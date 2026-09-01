# 5. The Architecture (Technical Deep Dive)

> **ℹ️ Note for Non-Tech Users:** You can skip this section. It explains *why* the server is built this way.

### The "Include" Strategy
Instead of one massive file with 1000 lines, we use a modular approach.
* **`docker-compose-main.yaml`**: This is the master list. It barely contains any code; it just tells Docker: *\"Go look in the `compose/` folder and run these files.\"*
* **`compose/*.yml`**: Each service has its own file. This prevents one typo in Plex from breaking Portainer.

### The Immune System (Socket Proxy)
You will see `tcp://socket-proxy:2375` in many files.
* **Problem:** Giving apps access to Docker is dangerous. If an app gets hacked, the hacker owns the server.
* **Solution:** We use **Socket Proxy**. It sits in the middle and only allows \"Safe\" commands (like \"List containers\") but blocks \"Dangerous\" commands (like \"Start new container\").

### Networking
* **`socket_proxy` Network:** `192.168.91.0/24` - Isolated network for internal communication.
* **`nginx_proxy` Network:** `192.168.90.0/24` - Exposed to the reverse proxy for web access.

---
[⬅️ Back to Home](./README.md)
