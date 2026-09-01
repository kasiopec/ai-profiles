# 2. The Control Panel (Your Magic Commands)

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
[⬅️ Back to Home](./README.md)
