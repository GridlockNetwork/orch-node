import express, { Express } from 'express';
import helmet from 'helmet';
import xss from 'xss-clean';
import ExpressMongoSanitize from 'express-mongo-sanitize';
import compression from 'compression';
import cors from 'cors';
import passport from 'passport';
import httpStatus from 'http-status';
import config from './config/config';
import { morgan } from './modules/logger';
import { jwtStrategy } from './modules/auth';
import { authLimiter } from './modules/utils';
import { ApiError, errorConverter, errorHandler } from './modules/errors';
import routes from './routes/v1';
import mongoose from 'mongoose';
import { natsClient } from './modules/nats/nats.instance';
import { logger } from './modules/logger';

const app: Express = express();

if (config.env !== 'test') {
  app.use(morgan.successHandler);
  app.use(morgan.errorHandler);
}

// set security HTTP headers
app.use(helmet());

// enable cors
app.use(cors());
app.options('*', cors());

// parse json request body
app.use(express.json());

// parse urlencoded request body
app.use(express.urlencoded({ extended: true }));

// sanitize request data
app.use(xss());
app.use(ExpressMongoSanitize());

// gzip compression
app.use(compression());

// jwt authentication
app.use(passport.initialize());
passport.use('jwt', jwtStrategy);

// limit repeated failed requests to auth endpoints
if (config.env === 'production') {
  app.use('/v1/auth', authLimiter);
}

// health check endpoint
app.get('/health', async (_req, res) => {
  const mongoStatus = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';

  let natsStatus = 'disconnected';
  if (natsClient) {
    try {
      const testTopic = `health.check.${Date.now()}`;
      const sub = natsClient.subscribe(testTopic, {
        max: 1,
        timeout: 200,
      });

      await natsClient.publish(testTopic);

      for await (const msg of sub) {
        if (msg) {
          natsStatus = 'connected';
          break;
        }
      }

      await sub.unsubscribe();
    } catch (error) {
      natsStatus = 'disconnected';
    }
  }

  const overallStatus = mongoStatus === 'connected' && natsStatus === 'connected' ? 'ok' : 'down';

  res.status(httpStatus.OK).json({
    status: overallStatus,
    services: {
      mongodb: mongoStatus,
      nats: natsStatus,
    },
  });
});

// v1 api routes
app.use('/v1', routes);

// send back a 404 error for any unknown api request
app.use((_req, _res, next) => {
  next(new ApiError(httpStatus.NOT_FOUND, 'Not found'));
});

// convert error to ApiError, if needed
app.use(errorConverter);

// handle error
app.use(errorHandler);

export default app;
