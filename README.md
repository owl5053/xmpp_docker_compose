# XMPP Server with Coturn (Docker Compose)

A complete, production-ready XMPP (Jabber) server setup with Prosody and Coturn TURN/STUN server, containerized with Docker Compose. Includes Converse.js web client integration and optional Nginx Proxy Manager for SSL management.

## 🚀 Features

- **Prosody 13.0** - Modern XMPP server
- **Coturn** - TURN/STUN server for audio/video calls
- **Converse.js** - Built-in web client with OMEMO encryption
- **HTTP File Upload** - Share files up to 100MB
- **MUC (Group Chat)** - Persistent chat rooms with history
- **Message Archive Management (MAM)** - Message history
- **REST API** - For bot integration
- **External Services** - Voice/video calls via TURN
- **Let's Encrypt ready** - Automatic SSL (via NPM or manual)

## 📋 Prerequisites

- Docker and Docker Compose
- Domain name pointed to your server
- Linux server with public IP
- Basic knowledge of command line and XMPP

## 🔥 Firewall / Router Ports

Make sure the following ports are open on your firewall/router and forwarded to your server:

| Service | Protocol | Port(s) | Description |
|---------|----------|---------|-------------|
| XMPP Client | TCP | 5222 | Client-to-server (C2S) connections |
| XMPP Server | TCP | 5269 | Server-to-server (S2S) federation |
| XMPP HTTP | TCP | 5280 | HTTP interface (BOSH/WebSocket) |
| XMPP HTTPS | TCP | 5281 | HTTPS interface (secure BOSH/WebSocket, file upload) |
| TURN | TCP/UDP | 3478 | TURN/STUN server (main port) |
| TURN TLS | TCP | 5349 | TURN over TLS (secure) |
| TURN Relay | UDP | 20000-20500 | Media relay ports for voice/video |

**Note**: If you're using Nginx Proxy Manager, also open ports 80 and 443 for SSL certificate issuance.

## Quick Start Guide

1. **Clone the project**
   ```bash
   git clone https://github.com/owl5053/xmpp_docker_compose.git
   cd xmpp-docker-compose
   ```

3. **Configure Domain**
   Replace "your_server.ru" with your actual domain in:
   ```text
   - docker-compose.yaml
   - config/prosody/prosody.cfg.lua
   - config/coturn/turnserver.conf
   - user.sh
   ```

5. **Generate Secrets**
   ```bash
   sh generate_a_new_secret.sh
   ```
   Update the generated secret in Prosody and Coturn config files.

6. Set up SSL certificates (Option A or B)

**Option A: Nginx Proxy Manager (Recommended)**

Use the provided `docker-compose.yaml` configuration:

```yaml
services:
  npm:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: xmpp-npm
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    volumes:
      - ./data/npm:/data
      - ./data/letsencrypt:/etc/letsencrypt
    networks:
      - npm-proxy

networks:
  npm-proxy:
    name: npm-proxy
    driver: bridge
```
Get SSL certificates through the NPM web interface (port 81).
Option B: Manual Let's Encrypt
Place certificates in: 
```text
 ../npm/data/letsencrypt/live/npm-11/
```
Or manually modify the certificate paths in your configuration files.

7. **Spin up Containers**
   ```bash
   docker compose up -d
   ```

8. **Create Admin User**
   ```bash
   sh user.sh -a
   ```

## User Management

Manage accounts easily with the user.sh script:
```bash
./user.sh -a           # Add new user
./user.sh -p <user>    # Change password
./user.sh -d <user>    # Delete user
./user.sh -l           # List all users
```
## Web Access

Once the stack is running, access the web chat via:
```text
https://YOUR_DOMAIN:5281
```

## Project Structure

- **config/** – Prosody and Coturn configuration files.
- **data/** – Database storage and SSL certificates.
- **docker-compose.yaml** – Main orchestration file.
- **user.sh** – Management utility script.

## Security Overview

- **Closed Registration:** Users can only be created by the admin.
- **Mandatory Encryption:** TLS is required for all connections.
- **Privacy:** EXIF metadata stripping is enabled for file uploads.


## 🤖 Ready-to-Use XMPP Bot

You can use my pre-built Docker image for a simple XMPP bot:

**Docker Hub:** [owl5053/xmpp_bot_slixmpp](https://hub.docker.com/r/owl5053/xmpp_bot_slixmpp)

Features:
- Send messages to users and MUC rooms
- REST API support
- Easy configuration via environment variables
- Based on Slixmpp library

## License
MIT
