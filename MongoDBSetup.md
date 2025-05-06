# MongoDB Setup Guide

[← Back to custom development guide](customization_and_development.md)

## Quick Start

The MongoDB database is automatically configured and started when you run `docker compose up`. The configuration is managed through environment variables in your `.env` file.

## Configuration

1. Copy the example environment file if you haven't already:
   ```sh
   cp example.env .env
   ```

2. The following MongoDB-related variables should be set in your `.env` file:
   ```
   MONGO_USERNAME=your_username
   MONGO_PASSWORD=your_password
   MONGODB_URL=mongodb://${MONGO_USERNAME}:${MONGO_PASSWORD}@mongodb:27017/gridlock?authSource=admin
   ```

## Connection Details

- **Host**: localhost (or mongodb when using Docker)
- **Port**: 27017
- **Database**: gridlock
- **Auth Source**: admin

## Manual Setup (Optional)

If you need to run MongoDB outside of Docker:

1. Install MongoDB locally
2. Start the MongoDB service
3. Create a user with appropriate permissions:
   ```javascript
   use admin
   db.createUser({
     user: "your_username",
     pwd: "your_password",
     roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
   })
   ```

## Troubleshooting

If you encounter connection issues:

1. Verify MongoDB is running:
   ```sh
   docker compose ps
   ```

2. Check the logs:
   ```sh
   docker compose logs mongodb
   ```

3. Ensure your `.env` file contains the correct credentials

4. Verify network connectivity:
   ```sh
   docker network inspect gridlock-net
   ```
