# Gridlock Orchestration Node

The orchestration node (orch node) is a crucial component of the Gridlock Network. It acts as the heart of the network, facilitating communication between clients and guardians. The orch node enables complex interactions such as creating new wallets or signing transactions.

While the orchestration node ensures the smooth operation of the system, it is designed as a simple, secure component that maintains the privacy and security of the data without seeing any of the information being passed.

To understand how the full system works, see [System Overview](./SystemOverview.md).  
Related: [Guardian Node](https://github.com/GridlockNetwork/guardian-node) | [SDK](https://github.com/GridlockNetwork/gridlock-sdk) | [CLI](https://github.com/GridlockNetwork/gridlock-cli)

## Quick Start

Copy and paste these commands to start everything:

```sh
docker network create gridlock-net
cp example.env .env
docker compose -p gridlock-orch-stack up
```

This will start:

- The local network that connects all the containers
- The orchestration node (http://localhost:5310)
- The database (MongoDB)
- The peer-to-peer networking layer

For detailed configuration options, local development setup, and advanced customization, see [Customization and Development Guide](./customization_and_development.md).

## Join the Network

This code is yours to use — but it's even better when you're part of the official Gridlock network.

By running [guardian nodes](https://github.com/GridlockNetwork/guardian-node), you can earn rewards while helping secure the network.

Join the community: [gridlock.network/join](https://gridlock.network/join)
community