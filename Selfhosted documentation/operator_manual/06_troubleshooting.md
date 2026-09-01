# 6. Troubleshooting & Emergencies

### Problem: "Disk Full" or "No Space Left on Device"
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

### Problem: "Permission Denied"
* **Diagnosis:** You try to edit a file or a container crashes saying it can't write to a folder.
* **Solution:** Reset permissions to the safe defaults.
  ```bash
  dp600
  ```

### Problem: "Everything is Broken / Weird Behavior"
* **Diagnosis:** Containers are stuck, or networking is glitching.
* **Solution (The "Turn it off and on again" for the whole server):**
  1.  Stop everything (🔴 Downtime):
      ```bash
      dcdown
      ```
  2.  Start everything fresh:
      ```bash
      dccall
      ```

---
[⬅️ Back to Home](./README.md)
