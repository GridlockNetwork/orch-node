[← Back to main documentation](README.md)

# Customization and Development Guide

## Components

### Orchestration Node
The main application that coordinates between clients and guardians. It manages client sessions, routes messages, and tracks guardian status.

Runs on port 5310.

### MongoDB
Database for storing orchestration node data. Handles client sessions, guardian info, and message history.

Runs on port 27017.

### NATS
Message broker for real-time communication between components. Routes messages between clients and guardians.

Runs on ports:
- 4222 (client connections)
- 8222 (monitoring)
- 6222 (cluster)

## Local Development Setup

Start MongoDB and NATS:
```sh
# Create network if it doesn't exist
docker network create gridlock-net

# Start MongoDB with auth
docker run -d --name mongodb \
  --network gridlock-net \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=gridlock_user \
  -e MONGO_INITDB_ROOT_PASSWORD=gridlock_dev_password \
  -v mongodb_data:/data/db \
  mongo:latest

# Start NATS with config
docker run -d --name nats \
  --network gridlock-net \
  -p 4222:4222 \
  -p 8222:8222 \
  -p 6222:6222 \
  -v $(pwd)/nats-server.conf:/etc/nats/nats-server.conf:ro \
  nats:latest --config /etc/nats/nats-server.conf
```

Setup and run the orchestration node:
```sh
npm install
cp example.env .env
npm run compile
npm run dev
```

## Customization

- MongoDB: Change auth credentials in docker run command
- NATS: Edit nats-server.conf for auth and cluster settings
- Ports: Modify port mappings in docker run commands
- Network: Use different network name by changing gridlock-net
