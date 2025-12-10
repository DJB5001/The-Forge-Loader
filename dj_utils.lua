-- dj_utils.lua
local Utils = {}

-- Expose
_G.DJ_Utils = Utils

function Utils.notify(title, content, duration)
    if _G.Rayfield then
        _G.Rayfield:Notify({
            Title = tostring(title),
            Content = tostring(content),
            Duration = tonumber(duration) or 3
        })
    end
end

function Utils.checkVersion(expectedVersion)
    local currentVersion = _G.DJ_VERSION or "1.0.0"
    return currentVersion == expectedVersion
end

---------------------------------------------------------------------
-- 🤖 ANTI-AFK SYSTEM (Multi-Method)
---------------------------------------------------------------------
local AntiAFK = {
    enabled = false,
    connections = {},
    lastAction = 0,
    virtualUser = nil
}

function AntiAFK:start()
    if self.enabled then return end
    self.enabled = true
    print("[🤖 ANTI-AFK] Starting...")
    
    -- Method 1: VirtualUser (Most reliable)
    pcall(function()
        self.virtualUser = game:GetService("VirtualUser")
        self.connections.idled = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            self.virtualUser:CaptureController()
            self.virtualUser:ClickButton2(Vector2.new())
            self.lastAction = tick()
            print("[🤖 ANTI-AFK] Prevented idle kick (VirtualUser)")
        end)
    end)
    
    -- Method 2: Random small movements (every 5 minutes)
    self.connections.movement = game:GetService("RunService").Heartbeat:Connect(function()
        if tick() - self.lastAction >= 300 then -- 5 minutes
            pcall(function()
                local char = game:GetService("Players").LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    -- Tiny random movement (0.01 studs)
                    hrp.CFrame = hrp.CFrame + Vector3.new(
                        math.random(-10, 10) / 1000,
                        0,
                        math.random(-10, 10) / 1000
                    )
                end
            end)
            self.lastAction = tick()
            print("[🤖 ANTI-AFK] Micro-movement executed")
        end
    end)
    
    -- Method 3: Mouse movement simulation (every 10 minutes)
    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        self.connections.mouse = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() - self.lastAction >= 600 then -- 10 minutes
                pcall(function()
                    VirtualInputManager:SendMouseMoveEvent(
                        math.random(0, 100),
                        math.random(0, 100),
                        game
                    )
                end)
            end
        end)
    end)
    
    -- Method 4: Prevent sleep mode
    pcall(function()
        game:GetService("GuiService"):SetGameplayPausedNotificationEnabled(false)
    end)
    
    print("[🤖 ANTI-AFK] ✅ Active (Multi-Method)")
end

function AntiAFK:stop()
    if not self.enabled then return end
    self.enabled = false
    
    for name, connection in pairs(self.connections) do
        pcall(function() connection:Disconnect() end)
        print("[🤖 ANTI-AFK] Disconnected:", name)
    end
    self.connections = {}
    
    print("[🤖 ANTI-AFK] ⏸️ Stopped")
end

function AntiAFK:isActive()
    return self.enabled
end

-- Expose Anti-AFK
Utils.AntiAFK = AntiAFK
_G.DJ_AntiAFK = AntiAFK

return Utils