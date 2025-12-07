#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
The Forge - Complete Automated Encoder & Uploader
Lädt ALLE 13 Dateien aus The-Forge, encodiert sie und lädt sie hoch
"""

import base64
import requests
import time

# GitHub Configuration
GITHUB_TOKEN = "DEIN_TOKEN_HIER"  # 🔑 Füge deinen Token ein!
REPO_OWNER = "DJB5001"
SOURCE_REPO = "The-Forge"  # Private repo
TARGET_REPO = "The-Forge-Loader"  # Public repo
BRANCH = "main"

# Alle 13 Dateien
FILES_TO_ENCODE = [
    "loader.lua",
    "main.lua",
    "dj_utils.lua",
    "dj_overlay.lua",
    "dj_ui_base.lua",
    "dj_ui_wrapper.lua",
    "dj_tab_key.lua",
    "dj_tab_ingame.lua",
    "dj_tab_mining.lua",
    "dj_tab_monster.lua",
    "dj_tab_minigame.lua",
    "dj_tab_extras.lua",
    "dj_tab_misc.lua"
]

headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

def get_file_from_repo(filename):
    """Download file from The-Forge (private)"""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{SOURCE_REPO}/contents/{filename}"
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        content = base64.b64decode(data['content']).decode('utf-8')
        return content
    else:
        print(f"  ❌ Error {response.status_code}: {filename}")
        return None

def upload_encoded_file(filename, encoded_content):
    """Upload encoded file to The-Forge-Loader (public)"""
    target_path = f"encoded/{filename}.b64"
    url = f"https://api.github.com/repos/{REPO_OWNER}/{TARGET_REPO}/contents/{target_path}"
    
    # Prüfe ob Datei existiert (für Update)
    response = requests.get(url, headers=headers)
    sha = None
    if response.status_code == 200:
        sha = response.json().get('sha')
    
    # Upload/Update
    data = {
        "message": f"Update encoded {filename}",
        "content": encoded_content,
        "branch": BRANCH
    }
    
    if sha:
        data["sha"] = sha
    
    response = requests.put(url, json=data, headers=headers)
    
    if response.status_code in [200, 201]:
        return True
    else:
        print(f"  ❌ Upload failed: {response.status_code}")
        try:
            print(f"  {response.json().get('message', 'Unknown error')}")
        except:
            pass
        return False

def main():
    print("="*70)
    print("🔥" * 10 + " THE FORGE - COMPLETE UPLOADER " + "🔥" * 10)
    print("="*70)
    print()
    
    if GITHUB_TOKEN == "DEIN_TOKEN_HIER":
        print("❌ FEHLER: Bitte füge deinen GitHub Token ein!")
        print("ℹ️ Zeile 13: GITHUB_TOKEN = \"dein_token_hier\"")
        print()
        return
    
    print(f"📝 Quelle: {SOURCE_REPO} (privat)")
    print(f"🎯 Ziel: {TARGET_REPO} (public)")
    print(f"📚 Dateien: {len(FILES_TO_ENCODE)}")
    print()
    print("="*70)
    print()
    
    success_count = 0
    failed_count = 0
    
    for i, filename in enumerate(FILES_TO_ENCODE, 1):
        print(f"[{i:2d}/{len(FILES_TO_ENCODE)}] 🔄 {filename}")
        
        # 1. Download
        content = get_file_from_repo(filename)
        if not content:
            print(f"      ⚠️  Skipped (not found)\n")
            failed_count += 1
            continue
        
        print(f"      ✅ Downloaded: {len(content):,} bytes")
        
        # 2. Encode
        encoded = base64.b64encode(content.encode('utf-8')).decode('utf-8')
        print(f"      🔒 Encoded: {len(encoded):,} bytes (base64)")
        
        # 3. Upload
        if upload_encoded_file(filename, encoded):
            print(f"      ✅ Uploaded: encoded/{filename}.b64")
            success_count += 1
        else:
            failed_count += 1
        
        print()
        time.sleep(0.5)  # Rate limiting
    
    print("="*70)
    print(f"✅ Erfolgreich: {success_count}/{len(FILES_TO_ENCODE)}")
    if failed_count > 0:
        print(f"❌ Fehlgeschlagen: {failed_count}/{len(FILES_TO_ENCODE)}")
    print("="*70)
    print()
    
    if success_count == len(FILES_TO_ENCODE):
        print("🎉 PERFEKT! Alle Dateien wurden encodiert und hochgeladen!")
        print()
        print("🚀 Dein Loader ist jetzt einsatzbereit:")
        print(f"   https://raw.githubusercontent.com/{REPO_OWNER}/{TARGET_REPO}/{BRANCH}/loader.lua")
        print()
        print("🎮 Verwendung in Roblox:")
        print(f'   loadstring(game:HttpGet("https://raw.githubusercontent.com/{REPO_OWNER}/{TARGET_REPO}/{BRANCH}/loader.lua"))()')
        print()
    
    print("⚠️  WICHTIG: Lösche JETZT deinen GitHub Token!")
    print("   → https://github.com/settings/tokens")
    print("   → Finde deinen Token und klicke 'Delete'")
    print()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n❌ Abgebrochen durch Benutzer")
    except Exception as e:
        print(f"\n❌ FEHLER: {e}")
