# Home Server Operator's Manual

**Version:** 1.0  
**Author:** kasiopec

## System Information
- **OS:** Debian 12 (LXC Container on Proxmox)
- **Path:** `/home/kasiopec/docker`
- **User:** kasiopec (UID: 1000)

---

## 0. Fresh Install & Setup (Debian 12)
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

## 1. START HERE: The Operator’s Guide
### ⚠️ The Golden Rule
> **If a command is marked 🟡 YELLOW or 🔴 RED and you do not understand why you are running it, STOP.**
> Go read the **Standard Operating Procedure (SOP)** in Section 4 first.

### 🚦 The Traffic Light System
Throughout this guide, commands are marked by their danger level:
* 🟢 **Green (SAFE):** Information only. You can run these anytime. No data will be lost.
* 🟡 **Yellow (CAUTION):** Services will restart or pause. The family might yell "The internet is down!" briefly.
* 🔴 **Red (DANGER):** Destructive. Can delete files, passwords, or the entire server setup. **Think twice.**

### 🚑 Emergency Flowchart
* **Service (e.g., Plex) is broken?** → Go to **Section 4 (SOPs)**
* **Disk full / Error messages?** → Go to **Section 6 (Troubleshooting)**
* **Just curious how it works?** → Go to **Section 5 (Architecture)**
* **Scared to touch anything?** → Stay in **Section 2 (Control Panel)**

---

## 2. The Control Panel (Your Magic Commands)
These aliases are shortcuts designed to manage the server without typing long code.
* **Where to run them:** In the terminal (SSH).
* **Command Prefix:** Most start with `d` (Docker) or `dc` (Docker Compose).

### 🟢 Status & Monitoring (Safe to Run Anytime)
| Command | Safety | What it does | System Impact |
| :--- | :---: | :--- | :--- |
| **`dpss`** | 🟢 | **Show Status.** Lists all running containers in a nice table. | None. Just looks. |
| **`dclogs <name>`** | 🟢 | **Check Logs.** Shows the "diary" of a specific container (e.g., `dclogs plex`). Press `Ctrl+C` to exit. | None. |
| **`ddf`** | 🟢 | **Check Space.** Shows how much disk space Docker is using. | None. |
| **`dips`** | 🟢 | **Show IPs.** Lists the local IP addresses of all containers. | None. |

### 🟡 Standard Operations (Expect Brief Downtime)
| Command | Safety | What it does | System Impact |
| :--- | :---: | :--- | :--- |
| **`dcup`** | 🟡 | **Update & Start.** The "Make it happen" button. Pulls updates and restarts only changed services. | **Brief Interruption.** Services updating will restart. |
| **`dcrestart <name>`** | 🟡 | **Restart One.** Turns a specific container off and on again (e.g., `dcrestart plex`). | **Service Down.** That specific app stops for ~10s. |
| **`dcstop <name>`** | 🟡 | **Stop One.** Stops a container and leaves it off. | **Service Off.** Won't work until started. |
| **`dcpull`** | 🟡 | **Download Updates.** Downloads new software versions but does *not* apply them yet. | **Slow Internet.** Might slow down network briefly. |
| **`dprune`** | 🟡 | **Clean Up.** Removes unused data (old images, stopped containers) to save space. | **Safe.** Only deletes *unused* items. |

### 🔴 The Nuclear Codes (DANGER - DO NOT TOUCH)
| Command | Safety | What it does | Risk Factor |
| :--- | :---: | :--- | :--- |
| **`derase`** | 🔴 | **WIPE EVERYTHING.** Stops all containers and deletes **ALL** images and volumes. | **Catastrophic.** You will lose data if not backed up. |
| **`dp777`** | 🔴 | **Unlock Permissions.** Sets all config files to be editable by anyone (`chmod 777`). | **Security Risk.** Leaves secrets exposed. |
| **`dcdown`** | 🔴 | **Stop Stack.** Takes the entire home server offline. | **Total Blackout.** Nothing will work. |

---

## 3. The Map (Where Things Live)
We treat the file system like a video game save. It is located at `/home/kasiopec/docker`.

### 🗺️ The Directory Tree
```text
/home/kasiopec/docker
├── 📁 appdata/         <-- ❌ THE SAVE GAMES (Do Not Delete)
│   ├── plex/
│   ├── portainer/
│   └── ...
├── 📁 compose/         <-- 🛠️ THE BLUEPRINTS (How apps are built)
│   ├── docker-compose-plex.yml
│   └── ...
├── 📁 secrets/         <-- 🔒 THE KEYS (Passwords)
├── 📄 .env             <-- ⚠️ THE SETTINGS (IPs, User IDs - Don't touch)
└── 📄 docker-compose-main.yaml  <-- 🧠 THE BRAIN (Controls everything)
```

### 📂 Folder Explanation
| Folder/File | Metaphor | What happens if you delete it? | Safe to Edit? |
| :--- | :--- | :--- | :--- |
| **`appdata/`** | **Save Games** | 🔴 **Catastrophic.** You lose your Plex watch history, website data, and custom configs. | ❌ NO (Unless you know exactly which file). |
| **`compose/`** | **Blueprints** | 🟡 **Annoying.** The service won't start, but we can re-download the file. Data is safe. | ✅ YES (To change settings). |
| **`.env`** | **Global Settings** | 🔴 **System Crash.** Nothing will start because it won't know the IPs or User IDs. | ⚠️ CAUTION. |
| **`secrets/`** | **Vault** | 🔴 **Access Denied.** Services won't be able to log in. | ⚠️ CAUTION. |

---

## 4. Standard Operating Procedures (SOPs)
### SOP-01: Access the Server (SSH)
* **Goal:** Open the terminal to run commands.
* **Command:** Open your terminal app (CMD, PowerShell, or Terminal) and type:
  ```bash
  ssh kasiopec@192.168.1.201
  ```
* **Success:** You see the command prompt.

### SOP-02: Restart a Frozen Service
* **Goal:** Fix a specific app (e.g., Plex) that is acting up.
* **Command:**
  ```bash
  dcrestart plex
  ```
  *(Replace `plex` with the actual container name. Use `dpss` to find names).*
* **Success:** The command finishes and the service is reachable again.

### SOP-03: Update Everything
* **Goal:** Update all apps to the latest version.
* **Steps:**
  1.  Download updates (Safe):
      ```bash
      dcpull
      ```
  2.  Apply updates (Brief downtime):
      ```bash
      dcup
      ```
  3.  Clean up old files:
      ```bash
      dprune
      ```

### SOP-04: Edit a Config File (Safe Mode)
* **Goal:** Change a setting in a `docker-compose` file or `.env` file without permission errors.
* **Steps:**
  1.  **Unlock** the files (🔴 DANGER - Do not leave like this):
      ```bash
      dp777
      ```
  2.  **Edit** the file using `nano` or your SFTP editor.
  3.  **Lock** the files immediately after saving:
      ```bash
      dp600
      ```
* **Abort Condition:** If you forget step 3, your secrets are readable by anyone on the system.

---

## 5. The Architecture (Technical Deep Dive)
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

## 6. Troubleshooting & Emergencies
### Problem: \"Disk Full\" or \"No Space Left on Device\"
* **Diagnosis:** Run `ddf` to check space.
* **Solution:**
  1.  Run the standard cleaner:
      ```bash
      dprune
      ```
  2.  If that fails, run the aggressive image cleaner (removes all unused images):
      ```bash
      ddelimages
      ```

### Problem: \"Permission Denied\"
* **Diagnosis:** You try to edit a file or a container crashes saying it can't write to a folder.
* **Solution:** Reset permissions to the safe defaults.
  ```bash
  dp600
  ```

### Problem: \"Everything is Broken / Weird Behavior\"
* **Diagnosis:** Containers are stuck, or networking is glitching.
* **Solution (The \"Turn it off and on again\" for the whole server):**
  1.  Stop everything (🔴 Downtime):
      ```bash
      dcdown
      ```
  2.  Start everything fresh:
      ```bash
      dccall
      ```

---

## 7. Backup & Recovery
**Context:** This server runs inside a Proxmox LXC container.

### How to Backup
We rely on **Proxmox Snapshots** and **Proxmox Backups**.
1.  Log into the Proxmox Web UI.
2.  Select the Container (`1xx`).
3.  Click **Backup** → **Backup Now**.

### How to Restore
1.  Log into Proxmox.
2.  Select the Container.
3.  Click **Backup**.
4.  Select the latest file and click **Restore**.

### ⚠️ Important Note on Media
* **What IS backed up:** All config files, `appdata`, and settings located in `/home/kasiopec/docker`.
* **What is NOT backed up:** The media files in `/media/dashdd` (Movies/TV). These are likely mounted from a separate drive. If the LXC breaks, your movies are safe on the disk, but the *connection* to them needs the LXC running.
