# 0. Fresh Install & Setup (Debian 12)

This section is for setting up a brand-new LXC container before deploying the Docker stack.

### 🛠️ Step 1: Update & Dependencies
Prepare the system and install necessary packages for HTTPS repository access.
```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release -y
```

### 🔑 Step 2: Add Docker’s GPG Key
Download and store the official GPG key.
```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

### 📦 Step 3: Add Repository
Register the official Docker repository.
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 🚀 Step 4: Install Docker & Compose
Install the Docker Engine and the Docker Compose plugin.
```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

### ✅ Step 5: Post-Install Setup
1. **Verify Installation:**
   ```bash
   sudo docker run hello-world
   docker compose version
   ```
2. **Manage as Non-Root User:**
   ```bash
   sudo groupadd docker
   sudo usermod -aG docker $USER
   ```
   *Note: Log out and back in for changes to take effect.*

---
[⬅️ Back to Home](./README.md)
