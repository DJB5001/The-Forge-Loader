# 🔥 The Forge - Public Loader

[![Auto-Encode](https://github.com/DJB5001/The-Forge-Loader/actions/workflows/auto-encode.yml/badge.svg)](https://github.com/DJB5001/The-Forge-Loader/actions/workflows/auto-encode.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Discord](https://img.shields.io/badge/Discord-Join-7289DA?logo=discord&logoColor=white)](https://discord.gg/MTXnFfHXW9)

> **Public Loader Repository** für The Forge - Ein Roblox Script Hub mit automatischer Verschlüsselung via GitHub Actions

## 🚀 Quick Start

### In Roblox verwenden:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/DJB5001/The-Forge-Loader/main/loader.lua"))()
```

## 🎯 Features

- ✅ **Automatische Updates** via GitHub Actions Workflow
- 🔒 **Base64 Verschlüsselung** aller Scripts
- 📦 **13 Module** werden automatisch geladen
- ⏰ **Auto-Sync** alle 30 Minuten mit privatem Repository
- 🤖 **Zero-Config** - Alles läuft automatisch!

## 📚 Dokumentation

### Für Entwickler:
- 📝 [WORKFLOW_SETUP.md](WORKFLOW_SETUP.md) - GitHub Actions Workflow einrichten
- 📝 [SETUP_GUIDE.md](SETUP_GUIDE.md) - Allgemeine Setup-Anleitung
- 🔧 [upload_all_files.py](upload_all_files.py) - Manuelles Upload-Script

### Für User:
Führe einfach den Loader-Code in Roblox aus - fertig!

## ⚙️ Wie funktioniert's?

```
📦 The-Forge (privat)          GitHub Actions           🌍 The-Forge-Loader (public)
    │                               │                                │
    ├─ loader.lua       ─────────────► Encode          ────────────► encoded/loader.lua.b64
    ├─ main.lua         ─────────────► Encode          ────────────► encoded/main.lua.b64
    ├─ dj_utils.lua     ─────────────► Encode          ────────────► encoded/dj_utils.lua.b64
    └─ ...              ─────────────► Encode          ────────────► encoded/...
                                     │
                               Runs every 30min
                               or manually
```

### Workflow Status:

✅ Der Workflow läuft automatisch alle 30 Minuten  
🔄 Oder starte ihn manuell: [Actions Tab](https://github.com/DJB5001/The-Forge-Loader/actions)

## 💻 Repository Struktur

```
The-Forge-Loader/
├── .github/
│   └── workflows/
│       └── auto-encode.yml      # 🤖 Automatischer Encoder Workflow
├── encoded/                      # 🔒 Base64 encodierte Dateien
│   ├── loader.lua.b64
│   ├── main.lua.b64
│   ├── dj_utils.lua.b64
│   ├── ... (13 Dateien total)
│   └── index.txt              # Liste aller Dateien
├── loader.lua                    # 🚀 Haupt-Loader (public)
├── upload_all_files.py           # 🔧 Manuelles Upload Tool
├── WORKFLOW_SETUP.md             # 📝 Workflow Anleitung
├── SETUP_GUIDE.md                # 📝 Setup Anleitung
└── README.md                     # 📚 Diese Datei
```

## 🔄 Updates durchführen

### Automatisch (empfohlen):
1. Pushe Änderungen zu `The-Forge` (privates Repo)
2. Warte max. 30 Minuten
3. Workflow encodiert automatisch alle Dateien
4. Fertig! 🎉

### Manuell:
1. Gehe zu [Actions](https://github.com/DJB5001/The-Forge-Loader/actions)
2. Wähle "Auto-Encode Private Scripts"
3. Klicke "Run workflow"
4. Fertig! ⚡

## 🛠️ Für Entwickler

### Workflow einrichten:

1. **Token erstellen:**
   - [GitHub Settings → Tokens](https://github.com/settings/tokens)
   - `repo` Berechtigung wählen

2. **Secret hinzufügen:**
   - Repository → Settings → Secrets and variables → Actions
   - Name: `PRIVATE_REPO_TOKEN`
   - Value: Dein Token

3. **Workflow starten:**
   - Actions Tab → "Auto-Encode Private Scripts" → "Run workflow"

📝 Detaillierte Anleitung: [WORKFLOW_SETUP.md](WORKFLOW_SETUP.md)

### Manuelles Upload:

```bash
# Script herunterladen
wget https://raw.githubusercontent.com/DJB5001/The-Forge-Loader/main/upload_all_files.py

# Token einfügen (Zeile 13)
nano upload_all_files.py

# Ausführen
python3 upload_all_files.py
```

## 📊 Status

- ✅ 13/13 Module werden geladen
- ✅ Automatische Updates via GitHub Actions
- ✅ Base64 Verschlüsselung
- ✅ Workflow läuft alle 30 Minuten

## 📝 Module

1. **loader.lua** - Haupt-Loader mit Base64 Decoder
2. **main.lua** - Home Tab mit WalkSpeed & Anti-AFK
3. **dj_utils.lua** - Utility Funktionen
4. **dj_overlay.lua** - UI Overlay System
5. **dj_ui_base.lua** - UI Basis-Komponenten
6. **dj_ui_wrapper.lua** - UI Wrapper
7. **dj_tab_key.lua** - Key System Tab
8. **dj_tab_ingame.lua** - In-Game Features
9. **dj_tab_mining.lua** - Mining Tab
10. **dj_tab_monster.lua** - Monster Tab
11. **dj_tab_minigame.lua** - Minigame Tab
12. **dj_tab_extras.lua** - Extra Features
13. **dj_tab_misc.lua** - Verschiedenes

## 🔒 Sicherheit

- ✅ Source Code bleibt privat (The-Forge)
- ✅ Nur encodierte Versionen sind public
- ✅ GitHub Token als Secret gespeichert
- ✅ Workflow läuft in isolierter Umgebung

## 🎮 Unterstützte Spiele

- The Forge (Hauptspiel)
- Weitere Spiele in Entwicklung

## 💬 Support

- 👥 Discord: [discord.gg/MTXnFfHXW9](https://discord.gg/MTXnFfHXW9)
- 🐛 Issues: [GitHub Issues](https://github.com/DJB5001/The-Forge-Loader/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/DJB5001/The-Forge-Loader/discussions)

## 📝 License

MIT License - Siehe [LICENSE](LICENSE) für Details

## ⭐ Credits

- **Entwickler:** DJB5001
- **Discord:** [DJ HUB Community](https://discord.gg/MTXnFfHXW9)
- **UI Library:** Rayfield

---

**Made with ❤️ by DJB5001**

🔗 [The-Forge-Loader](https://github.com/DJB5001/The-Forge-Loader) | 💬 [Discord](https://discord.gg/MTXnFfHXW9)
