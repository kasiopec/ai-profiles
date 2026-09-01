# 7. Backup & Recovery

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

---
[⬅️ Back to Home](./README.md)
