# 3. The Map (Where Things Live)

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
[⬅️ Back to Home](./README.md)
