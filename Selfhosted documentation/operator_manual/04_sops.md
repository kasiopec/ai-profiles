# 4. Standard Operating Procedures (SOPs)

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
[⬅️ Back to Home](./README.md)
