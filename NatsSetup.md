# NATS Setup Guide

[← Back to custom development guide](customization_and_development.md)

Quick setup guide for NATS messaging system for the Gridlock storage layer.

## Prerequisites

- Docker installed on your system

## Quick Start

### Step 1: Create NATS Configuration

Copy and paste this command to create the NATS configuration file:

```bash
mkdir -p ~/.gridlock-orch-node && cat > ~/.gridlock-orch-node/nats-server.conf << 'EOL'
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
EOL
```

### Step 2: Start NATS Server

Copy and paste this command to start the NATS server:

```bash
docker run -d --name nats-main --network gridlock-net \
  -p 4222:4222 -p 6222:6222 -p 8222:8222 \
  -v ~/.gridlock-orch-node/nats-server.conf:/etc/nats/nats-server.conf \
  nats:latest -c /etc/nats/nats-server.conf
```

### Step 3: Test Connection

Open two terminal windows and run these commands:

Terminal 1 (Subscribe):

```bash
nats sub test.subject --server nats://gridlock_nats_user:gridlock_dev_password@localhost:4222
```

Terminal 2 (Publish):

```bash
nats pub test.subject "Testing NATS connection" --server nats://gridlock_nats_user:gridlock_dev_password@localhost:4222
```

You should see the message appear in Terminal 1.

## Troubleshooting

If you need to restart NATS:

```bash
docker stop nats-main
docker rm nats-main
```

Then run Step 2 again.

## Security Note

The default credentials are:

- Username: `gridlock_nats_user`
- Password: `gridlock_dev_password`

Change these in production!

## Custom Configuration (Optional)

If you need additional NATS settings, you can modify the `nats-server.conf` file. The configuration above includes:

- Basic server settings (ports)
- Authentication with the default user (gridlock_nats_user) and password (gridlock_dev_password)
- Permissions to publish and subscribe to all subjects

## Security Considerations

- Always use strong passwords in production
- Consider using TLS for secure connections
- Implement proper access controls based on your needs
- Regularly rotate credentials
- Keep NATS updated to the latest stable version
