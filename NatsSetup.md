# NATS Setup Guide

[← Back to custom development guide](customization_and_development.md)

## Quick Start

The NATS server is automatically configured and started when you run `docker compose up`. The configuration is managed through the `nats-server.conf` file in the root directory.

## Configuration

1. The NATS server configuration is defined in `nats-server.conf`:
   ```conf
   port: 4222
   http_port: 8222
   cluster {
     port: 6222
   }

   # Authentication configuration
   authorization {
     users = [
       {
         user: "gridlock_nats_user"
         password: "gridlock_dev_password"
         permissions: {
           publish: ">"
           subscribe: ">"
         }
       }
     ]
   }
   ```

2. Update the following variables in your `.env` file to match the NATS configuration:
   ```
   NATS_NETWORK=nats://nats-main:4222
   NATS_USER=gridlock_nats_user
   NATS_PASSWORD=gridlock_dev_password
   ```

## Connection Details

- **Host**: localhost (or nats-main when using Docker)
- **Port**: 4222 (client connections)
- **HTTP Port**: 8222 (monitoring)
- **Cluster Port**: 6222

## Testing Connection

Open two terminal windows and run:

Terminal 1 (Subscribe):
```sh
nats sub test.subject --server nats://gridlock_nats_user:gridlock_dev_password@localhost:4222
```

Terminal 2 (Publish):
```sh
nats pub test.subject "Hello NATS" --server nats://gridlock_nats_user:gridlock_dev_password@localhost:4222
```

You should see the message appear in Terminal 1.

## Troubleshooting

If you encounter connection issues:

1. Check the logs:
   ```sh
   docker logs nats-main
   ```

2. Ensure your `.env` file contains the correct NATS credentials
