[← Back to main documentation](README.md)

# Customization and Development Guide

This guide provides detailed instructions for customizing and developing the Gridlock Orchestration Node.

## Prerequisites

Setting up the orchestration node requires three essential components:

1. **Docker Network**: Required for local development and testing

   ```sh
   docker network create gridlock-net
   docker compose up
   ```

   Note: This is only needed if you're running other containers locally (Guardian Nodes, MongoDB, NATS). If you're connecting to internet-based MongoDB and NATS services, you don't need this network.

2. **MongoDB Database**: Required for data persistence

   - Follow the [MongoDB Setup Guide](MongoDBSetup.md) to get started

3. **NATS Messaging**: Required for communication between components
   - Follow the [NATS Setup Guide](NatsSetup.md) to get started

## Configuration

The application supports two configuration options:

1. Default config (baked into the image from example.env)
2. User config (overrides default)

We recommend storing your config file at the absolute path: `/Users/USERNAME/.gridlock-orch-node/.env` (replace `USERNAME` with your actual username).

To run with a custom configuration:

```sh
docker run --rm --name orch-node --network gridlock-net \
  -v /Users/USERNAME/.gridlock-orch-node/.env:/app/.env \
  -p 5310:5310 \
  gridlocknetwork/orch-node:latest
```

## Local Development Setup

To run the project locally, copy and run these commands:

```sh
npm install
npm run compile
npm run dev
```

## Customizing Docker Compose

The default docker-compose setup uses standard configurations. To customize:

1. Create a `docker-compose.override.yml` file
2. Add your custom configurations
3. Run `docker-compose up`

Example override file:

```yaml
version: '3.8'
services:
  orch-node:
    environment:
      - CUSTOM_ENV_VAR=value
    volumes:
      - ./custom-config:/app/config
  mongodb:
    environment:
      - MONGO_INITDB_ROOT_USERNAME=custom_user
      - MONGO_INITDB_ROOT_PASSWORD=custom_password
  nats:
    environment:
      - NATS_USER=custom_user
      - NATS_PASSWORD=custom_password
```

## Advanced Configuration

For more advanced configuration options, see:

- [MongoDB Configuration Guide](MongoDBSetup.md)
- [NATS Configuration Guide](NatsSetup.md)
- [System Overview](SystemOverview.md)
