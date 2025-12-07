# ⚙️ GitHub Actions Workflow Setup

## 🎯 Was macht der Workflow?

Der GitHub Actions Workflow **automatisiert** das Encoding:
- ✅ Lädt automatisch ALLE Dateien aus **The-Forge** (privat)
- 🔒 Encodiert sie in Base64
- 📤 Lädt sie nach **The-Forge-Loader** (public) hoch
- ⏰ Läuft **alle 30 Minuten** automatisch
- 🔄 Kann auch **manuell** gestartet werden

## 🔑 Schritt 1: GitHub Token erstellen

### Token mit den richtigen Berechtigungen:

1. Gehe zu: [github.com/settings/tokens](https://github.com/settings/tokens)
2. Klicke **"Generate new token"** → **"Generate new token (classic)"**
3. Gib einen Namen ein: `The-Forge-Loader-Workflow`
4. Setze Ablaufdatum: **"No expiration"** (empfohlen für Workflows)
5. Wähle folgende Berechtigungen:
   - ✅ **`repo`** (Full control of private repositories)
     - Damit kann der Workflow aus The-Forge lesen
6. Klicke **"Generate token"**
7. **KOPIERE DEN TOKEN SOFORT!** (wird nur einmal angezeigt)

## 🔐 Schritt 2: Token als Secret hinzufügen

1. Gehe zu deinem Repository: [The-Forge-Loader](https://github.com/DJB5001/The-Forge-Loader)
2. Klicke auf **"Settings"** (oben rechts)
3. Klicke links auf **"Secrets and variables"** → **"Actions"**
4. Klicke **"New repository secret"**
5. Name: `PRIVATE_REPO_TOKEN`
6. Value: *Füge deinen kopierten Token ein*
7. Klicke **"Add secret"**

## 🚀 Schritt 3: Workflow starten

### Option A: Manuell starten

1. Gehe zu: [Actions Tab](https://github.com/DJB5001/The-Forge-Loader/actions)
2. Klicke auf **"Auto-Encode Private Scripts"**
3. Klicke **"Run workflow"** → **"Run workflow"**
4. Warte ~1-2 Minuten
5. Der Workflow encodiert alle 13 Dateien!

### Option B: Automatisch (läuft alle 30 Min)

Der Workflow läuft automatisch **alle 30 Minuten**.

⏰ Nächster Lauf: Automatisch in max. 30 Minuten

## ✅ Schritt 4: Verifizieren

Nach dem ersten Workflow-Lauf:

1. Gehe zu: [encoded/ Ordner](https://github.com/DJB5001/The-Forge-Loader/tree/main/encoded)
2. Du solltest sehen:
   - ✅ `loader.lua.b64`
   - ✅ `main.lua.b64`
   - ✅ `dj_utils.lua.b64`
   - ✅ ... alle 13 Dateien als `.b64`
   - ✅ `index.txt` (Liste aller Dateien)

## 🎮 Verwendung in Roblox

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/DJB5001/The-Forge-Loader/main/loader.lua"))()
```

## 🔄 Updates durchführen

### Automatisch (empfohlen):
1. Pushe Änderungen zu **The-Forge** (privates Repo)
2. Warte max. 30 Minuten
3. Der Workflow updated automatisch alle Dateien!

### Manuell:
1. Pushe Änderungen zu **The-Forge**
2. Gehe zu [Actions](https://github.com/DJB5001/The-Forge-Loader/actions)
3. **"Run workflow"** → Sofortiges Update!

## 📊 Workflow Status prüfen

1. [Actions Tab](https://github.com/DJB5001/The-Forge-Loader/actions)
2. Sieh alle Workflow-Läufe
3. Klicke auf einen Lauf für Details
4. Grünes Häkchen = ✅ Erfolgreich
5. Rotes X = ❌ Fehler (siehe Logs)

## 🐛 Troubleshooting

### ❌ "Error: Resource not accessible by integration"
**Problem:** Token fehlt oder falsche Berechtigung
**Lösung:**
- Überprüfe ob Secret `PRIVATE_REPO_TOKEN` existiert
- Token muss `repo` Berechtigung haben

### ❌ "Failed to fetch XXX.lua"
**Problem:** Datei existiert nicht in The-Forge
**Lösung:**
- Überprüfe ob die Datei in The-Forge existiert
- Dateiname muss exakt übereinstimmen

### ❌ Workflow läuft nicht automatisch
**Problem:** Repository muss aktiv sein
**Lösung:**
- Pushe einen Commit (z.B. README aktualisieren)
- Oder starte Workflow manuell

## 🔒 Sicherheit

✅ **Sicher:**
- Token ist als Secret gespeichert (nicht sichtbar)
- Nur der Workflow hat Zugriff
- Token kann jederzeit widerrufen werden

⚠️ **Wichtig:**
- Teile NIEMALS deinen Token!
- Secret bleibt in GitHub (wird nicht im Code angezeigt)

## 📝 Workflow anpassen

Datei: `.github/workflows/auto-encode.yml`

### Zeitplan ändern:
```yaml
schedule:
  - cron: '*/15 * * * *'  # Alle 15 Minuten
  - cron: '0 * * * *'     # Jede Stunde
  - cron: '0 0 * * *'     # Täglich um Mitternacht
```

### Dateien hinzufügen:
```yaml
FILES=(
  "loader.lua"
  "main.lua"
  "deine_neue_datei.lua"  # Hier hinzufügen
)
```

## 🎉 Fertig!

Jetzt hast du ein **vollautomatisches System**:
1. ✍️ Du editierst Dateien in The-Forge (privat)
2. 🤖 GitHub Actions encodiert automatisch
3. 📤 Encoded Dateien werden hochgeladen
4. 🎮 Roblox lädt die neueste Version!

---

**Support:** [Discord](https://discord.gg/MTXnFfHXW9)
