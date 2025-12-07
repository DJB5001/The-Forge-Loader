#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
The Forge Encoder & Uploader
Encodes all Lua files from The-Forge (private repo) to Base64
and uploads them to The-Forge-Loader (public repo)
"""

import base64
import os
import requests
from datetime import datetime

# GitHub Configuration
GITHUB_TOKEN = "YOUR_GITHUB_TOKEN_HERE"  # 🔑 Replace with your token!
REPO_OWNER = "DJB5001"
SOURCE_REPO = "The-Forge"  # Private repo
TARGET_REPO = "The-Forge-Loader"  # Public repo
BRANCH = "main"

# Files to encode from The-Forge
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

class GitHubAPI:
    def __init__(self, token, owner):
        self.token = token
        self.owner = owner
        self.headers = {
            "Authorization": f"token {token}",
            "Accept": "application/vnd.github.v3+json"
        }
    
    def get_file(self, repo, path, branch="main"):
        """Download file from GitHub"""
        url = f"https://api.github.com/repos/{self.owner}/{repo}/contents/{path}?ref={branch}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            data = response.json()
            content = base64.b64decode(data['content']).decode('utf-8')
            sha = data['sha']
            return content, sha
        else:
            print(f"❌ Failed to get {path}: {response.status_code}")
            return None, None
    
    def create_or_update_file(self, repo, path, content, message, sha=None):
        """Create or update file on GitHub"""
        url = f"https://api.github.com/repos/{self.owner}/{repo}/contents/{path}"
        
        # Base64 encode content
        encoded_content = base64.b64encode(content.encode('utf-8')).decode('utf-8')
        
        data = {
            "message": message,
            "content": encoded_content,
            "branch": BRANCH
        }
        
        if sha:
            data["sha"] = sha
        
        response = requests.put(url, json=data, headers=self.headers)
        
        if response.status_code in [200, 201]:
            return True
        else:
            print(f"❌ Failed to upload {path}: {response.status_code}")
            print(response.json())
            return False

def main():
    print("="*60)
    print("🔥 THE FORGE ENCODER & UPLOADER 🔥")
    print("="*60)
    print()
    
    if GITHUB_TOKEN == "YOUR_GITHUB_TOKEN_HERE":
        print("❌ ERROR: Please set your GitHub token in the script!")
        print("ℹ️ Create one at: https://github.com/settings/tokens")
        print("ℹ️ Required scopes: 'repo' (full control of private repositories)")
        return
    
    api = GitHubAPI(GITHUB_TOKEN, REPO_OWNER)
    
    print(f"📝 Source: {SOURCE_REPO} (private)")
    print(f"🎯 Target: {TARGET_REPO} (public)")
    print(f"📚 Files: {len(FILES_TO_ENCODE)}")
    print()
    
    success_count = 0
    failed_count = 0
    
    for filename in FILES_TO_ENCODE:
        print(f"🔄 Processing: {filename}...")
        
        # 1. Download from private repo
        content, _ = api.get_file(SOURCE_REPO, filename, BRANCH)
        if not content:
            print(f"  ⚠️ Skipped {filename} (not found)")
            failed_count += 1
            continue
        
        print(f"  ✅ Downloaded: {len(content)} bytes")
        
        # 2. Encode to Base64
        encoded = base64.b64encode(content.encode('utf-8')).decode('utf-8')
        print(f"  🔒 Encoded: {len(encoded)} bytes (base64)")
        
        # 3. Upload to public repo in /encoded/ folder
        target_path = f"encoded/{filename}.b64"
        
        # Check if file exists (to get SHA for update)
        existing_content, existing_sha = api.get_file(TARGET_REPO, target_path, BRANCH)
        
        if api.create_or_update_file(
            TARGET_REPO,
            target_path,
            encoded,
            f"Update encoded {filename}",
            existing_sha
        ):
            print(f"  ✅ Uploaded to: {target_path}")
            success_count += 1
        else:
            print(f"  ❌ Upload failed!")
            failed_count += 1
        
        print()
    
    print("="*60)
    print(f"✅ Success: {success_count}/{len(FILES_TO_ENCODE)}")
    if failed_count > 0:
        print(f"❌ Failed: {failed_count}/{len(FILES_TO_ENCODE)}")
    print("="*60)
    print()
    print("🚀 Loader URL:")
    print(f"https://raw.githubusercontent.com/{REPO_OWNER}/{TARGET_REPO}/{BRANCH}/loader.lua")
    print()
    print("🎮 Usage in Roblox:")
    print(f'loadstring(game:HttpGet("https://raw.githubusercontent.com/{REPO_OWNER}/{TARGET_REPO}/{BRANCH}/loader.lua"))()')

if __name__ == "__main__":
    main()
