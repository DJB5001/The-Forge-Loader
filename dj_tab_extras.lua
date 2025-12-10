-- dj_tab_extras.lua
-- Extra features: Auto Sell, Auto Use Potions

return function(Window, Rayfield, Utils)
   local ExtrasTab = Window:CreateTab("✨ Extras", nil)
   
   ---------------------------------------------------------------------
   -- 💰 AUTO SELL SYSTEM
   ---------------------------------------------------------------------
   ExtrasTab:CreateSection("💰 Auto Sell System")
   
   -- ALL ORES FROM THE FORGE - SORTED BY RARITY (49 total)
   local ALL_ORES = {
      -- 🟩 Common
      "Stone", "Sand Stone", "Copper", "Iron",
      
      -- 🟬 Uncommon
      "Cardboardite", "Tin", "Silver", "Gold", "Poopite",
      
      -- 🟪 Rare
      "Fichlillium", "Bananite", "Mushroomite", "Platinum", "Boneite", "Dark Boneite", "Slimite",
      
      -- 🟯 Epic
      "Cobalt", "Titanium", "Lapis Lazuli", "Volcanic Rock", "Quartz", "Amethyst", "Topaz", "Magmaite", "Lightite", "Demonite",
      
      -- 🟧 Legendary
      "Diamond", "Sapphire", "Cuprite", "Obsidian", "Emerald", "Ruby", "Rivalite", "Uranium", "Aite", "Mythril", "Eye Ore", "Fireite", "Darkryte",
      
      -- 🌈 Crystals
      "Magenta Crystal", "Arcane Crystal", "Crimson Crystal", "Green Crystal", "Orange Crystal", "Blue Crystal", "Rainbow Crystal"
   }
   
   -- Auto Sell State
   local autoSellEnabled = false
   local selectedOres = {}
   local sellAmount = 1
   local sellInterval = 5 -- minutes
   local lastSellTime = 0
   local autoSellConnection = nil
   
   -- Helper: Execute sell with ONLY SellConfirm
   local function executeSell()
      print("[AUTO SELL] === STARTING SELL PROCESS ===")
      
      if #selectedOres == 0 then
         warn("[AUTO SELL] No ores selected!")
         Rayfield:Notify({
            Title = "Auto Sell",
            Content = "No ores selected!",
            Duration = 3
         })
         return false
      end
      
      -- Build basket
      local basket = {}
      for _, ore in ipairs(selectedOres) do
         basket[ore] = sellAmount
      end
      
      print("[AUTO SELL] Selling:")
      for ore, amount in pairs(basket) do
         print("  -", ore, "x", amount)
      end
      
      -- ONLY SELL CONFIRM - No Open/Close
      print("[AUTO SELL] Executing SellConfirm...")
      local args = {
         "SellConfirm",
         {
            Basket = basket
         }
      }
      
      local success, result = pcall(function()
         return game:GetService("ReplicatedStorage")
            :WaitForChild("Shared")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("DialogueService")
            :WaitForChild("RF")
            :WaitForChild("RunCommand")
            :InvokeServer(unpack(args))
      end)
      
      if success then
         print("[AUTO SELL] ✅ Sell command sent")
      else
         warn("[AUTO SELL] ❌ Sell failed:", result)
      end
      
      print("[AUTO SELL] === SELL PROCESS COMPLETE ===")
      return success
   end
   
   -- Helper: Start auto sell loop
   local function startAutoSell()
      if autoSellConnection then return end
      
      autoSellConnection = game:GetService("RunService").Heartbeat:Connect(function()
         if not autoSellEnabled then return end
         
         local now = tick()
         local intervalSeconds = sellInterval * 60
         
         if now - lastSellTime >= intervalSeconds then
            print("[AUTO SELL] ⏰ Interval reached, executing sell...")
            local success = executeSell()
            if success then
               lastSellTime = now
               Rayfield:Notify({
                  Title = "Auto Sell",
                  Content = "Sold "..sellAmount.."x ores!",
                  Duration = 2
               })
            end
         end
      end)
      
      print("[AUTO SELL] 🔄 Started (interval:", sellInterval, "min)")
   end
   
   -- Helper: Stop auto sell
   local function stopAutoSell()
      if autoSellConnection then
         autoSellConnection:Disconnect()
         autoSellConnection = nil
      end
      print("[AUTO SELL] ⏸️ Stopped")
   end
   
   -- WARNING: IMPORTANT - PLACED ABOVE ORE SELECTION
   ExtrasTab:CreateParagraph({
      Title = "⚠️ IMPORTANT!",
      Content = "YOU NEED TO SELL SOMETHING ONCE YOURSELF TO MAKE THIS FEATURE WORK!\n\nGo to the shop NPC and manually sell 1 ore first, then this feature will work."
   })
   
   -- UI: Ore Selection (Multi-Select Dropdown)
   ExtrasTab:CreateDropdown({
      Name = "⛏️ Select Ores to Sell (49 Available)",
      Options = ALL_ORES,
      CurrentOption = {},
      MultipleOptions = true,
      Flag = "AutoSellOres",
      Callback = function(options)
         selectedOres = {}
         if type(options) == "table" then
            for _, ore in ipairs(options) do
               table.insert(selectedOres, ore)
            end
         elseif type(options) == "string" then
            table.insert(selectedOres, options)
         end
         
         local count = #selectedOres
         print("[AUTO SELL] Selected", count, "ore(s):", table.concat(selectedOres, ", "))
      end
   })
   
   -- UI: Sell Amount Input (User can type amount)
   ExtrasTab:CreateInput({
      Name = "📊 Sell Amount (Enter Number)",
      PlaceholderText = "1",
      RemoveTextAfterFocusLost = false,
      Flag = "AutoSellAmount",
      Callback = function(value)
         local amount = tonumber(value)
         if amount and amount > 0 then
            sellAmount = math.floor(amount)
            print("[AUTO SELL] Amount set to:", sellAmount)
         else
            warn("[AUTO SELL] Invalid amount:", value)
            Rayfield:Notify({
               Title = "Invalid Amount",
               Content = "Please enter a valid number!",
               Duration = 3
            })
         end
      end
   })
   
   -- UI: Sell Interval Slider (Minutes)
   ExtrasTab:CreateSlider({
      Name = "⏰ Auto Sell Interval (Minutes)",
      Range = {1, 60},
      Increment = 1,
      CurrentValue = 5,
      Flag = "AutoSellInterval",
      Callback = function(value)
         sellInterval = value
         print("[AUTO SELL] Interval set to:", sellInterval, "min")
      end
   })
   
   -- UI: Manual Sell Button
   ExtrasTab:CreateButton({
      Name = "💰 Sell Now (Manual)",
      Callback = function()
         print("[AUTO SELL] Manual sell button clicked")
         local success = executeSell()
         if success then
            Rayfield:Notify({
               Title = "Manual Sell",
               Content = "Sold "..sellAmount.."x ores!",
               Duration = 3
            })
         else
            Rayfield:Notify({
               Title = "Manual Sell",
               Content = "Sell failed! Check console (F9).",
               Duration = 3
            })
         end
      end
   })
   
   ExtrasTab:CreateSection("🔄 Auto Sell")
   
   -- UI: Auto Sell Toggle
   ExtrasTab:CreateToggle({
      Name = "🔄 Enable Auto Sell",
      CurrentValue = false,
      Flag = "AutoSellEnabled",
      Callback = function(value)
         autoSellEnabled = value
         
         if value then
            -- IMMEDIATELY execute sell when enabled
            print("[AUTO SELL] ⚡ Executing immediate sell on enable...")
            local success = executeSell()
            
            if success then
               Rayfield:Notify({
                  Title = "Auto Sell Enabled",
                  Content = "Sold "..sellAmount.."x ores! Next: "..sellInterval.." min",
                  Duration = 3
               })
            else
               Rayfield:Notify({
                  Title = "Auto Sell",
                  Content = "First sell failed! Check console (F9).",
                  Duration = 3
               })
            end
            
            -- Start auto sell loop
            startAutoSell()
            lastSellTime = tick() -- Reset timer after immediate sell
         else
            stopAutoSell()
            Rayfield:Notify({
               Title = "Auto Sell",
               Content = "Disabled",
               Duration = 2
            })
         end
      end
   })
   
   ---------------------------------------------------------------------
   -- 🧪 AUTO USE POTION SYSTEM
   ---------------------------------------------------------------------
   ExtrasTab:CreateSection("🧪 Auto Use Potion System")
   
   -- ALL POTIONS (excluding HealthPotion12 and PotionLVL2)
   local ALL_POTIONS = {
      "AttackDamagePotion1",
      "HealthPotion1",
      "HealthPotion2",
      "LuckPotion1",
      "MinerPotion1",
      "MovementSpeedPotion1"
   }
   
   -- Auto Potion State
   local autoPotionEnabled = false
   local selectedPotions = {}
   local potionInterval = 5 -- minutes
   local lastPotionTime = 0
   local autoPotionConnection = nil
   
   -- Helper: Use single potion
   local function usePotion(potionName)
      print("[AUTO POTION] Using:", potionName)
      
      local success, result = pcall(function()
         local args = {potionName}
         return game:GetService("ReplicatedStorage")
            :WaitForChild("Shared")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("ToolService")
            :WaitForChild("RF")
            :WaitForChild("ToolActivated")
            :InvokeServer(unpack(args))
      end)
      
      if success then
         print("[AUTO POTION] ✅", potionName, "used successfully")
         return true
      else
         warn("[AUTO POTION] ❌", potionName, "failed:", result)
         return false
      end
   end
   
   -- Helper: Execute potion usage with 10s delays
   local function executePotionUse()
      print("[AUTO POTION] === STARTING POTION USE ===")
      
      if #selectedPotions == 0 then
         warn("[AUTO POTION] No potions selected!")
         Rayfield:Notify({
            Title = "Auto Potion",
            Content = "No potions selected!",
            Duration = 3
         })
         return false
      end
      
      print("[AUTO POTION] Using", #selectedPotions, "potion(s):")
      for i, potion in ipairs(selectedPotions) do
         print("  ", i, "-", potion)
      end
      
      -- Use potions with 10s delay between each
      task.spawn(function()
         for i, potion in ipairs(selectedPotions) do
            local success = usePotion(potion)
            
            if success then
               Rayfield:Notify({
                  Title = "Auto Potion",
                  Content = "✅ Used: "..potion,
                  Duration = 2
               })
            else
               Rayfield:Notify({
                  Title = "Auto Potion",
                  Content = "❌ Failed: "..potion,
                  Duration = 3
               })
            end
            
            -- Wait 10 seconds before next potion (except for last one)
            if i < #selectedPotions then
               print("[AUTO POTION] ⏳ Waiting 10 seconds before next potion...")
               wait(10)
            end
         end
         
         print("[AUTO POTION] === POTION USE COMPLETE ===")
      end)
      
      return true
   end
   
   -- Helper: Start auto potion loop
   local function startAutoPotions()
      if autoPotionConnection then return end
      
      autoPotionConnection = game:GetService("RunService").Heartbeat:Connect(function()
         if not autoPotionEnabled then return end
         
         local now = tick()
         local intervalSeconds = potionInterval * 60
         
         if now - lastPotionTime >= intervalSeconds then
            print("[AUTO POTION] ⏰ Interval reached, using potions...")
            executePotionUse()
            lastPotionTime = now
         end
      end)
      
      print("[AUTO POTION] 🔄 Started (interval:", potionInterval, "min)")
   end
   
   -- Helper: Stop auto potion
   local function stopAutoPotions()
      if autoPotionConnection then
         autoPotionConnection:Disconnect()
         autoPotionConnection = nil
      end
      print("[AUTO POTION] ⏸️ Stopped")
   end
   
   -- UI: Potion Selection (Multi-Select Dropdown)
   ExtrasTab:CreateDropdown({
      Name = "🧪 Select Potions (Multi-Select)",
      Options = ALL_POTIONS,
      CurrentOption = {},
      MultipleOptions = true,
      Flag = "AutoUsePotions",
      Callback = function(options)
         selectedPotions = {}
         if type(options) == "table" then
            for _, potion in ipairs(options) do
               table.insert(selectedPotions, potion)
            end
         elseif type(options) == "string" then
            table.insert(selectedPotions, options)
         end
         
         local count = #selectedPotions
         print("[AUTO POTION] Selected", count, "potion(s):", table.concat(selectedPotions, ", "))
      end
   })
   
   -- UI: Potion Interval Slider (1-5 Minutes)
   ExtrasTab:CreateSlider({
      Name = "⏰ Auto Use Interval (Minutes)",
      Range = {1, 5},
      Increment = 1,
      CurrentValue = 5,
      Flag = "AutoPotionInterval",
      Callback = function(value)
         potionInterval = value
         print("[AUTO POTION] Interval set to:", potionInterval, "min")
      end
   })
   
   -- UI: Manual Use Button
   ExtrasTab:CreateButton({
      Name = "🧪 Use Potions Now (Manual)",
      Callback = function()
         print("[AUTO POTION] Manual use button clicked")
         executePotionUse()
      end
   })
   
   ExtrasTab:CreateSection("🔄 Auto Potion")
   
   -- UI: Auto Potion Toggle
   ExtrasTab:CreateToggle({
      Name = "🔄 Enable Auto Use Potions",
      CurrentValue = false,
      Flag = "AutoPotionEnabled",
      Callback = function(value)
         autoPotionEnabled = value
         
         if value then
            -- IMMEDIATELY use potions when enabled
            print("[AUTO POTION] ⚡ Using potions immediately on enable...")
            executePotionUse()
            
            Rayfield:Notify({
               Title = "Auto Potion Enabled",
               Content = "Using "..#selectedPotions.." potion(s)! Next: "..potionInterval.." min",
               Duration = 3
            })
            
            -- Start auto potion loop
            startAutoPotions()
            lastPotionTime = tick() -- Reset timer after immediate use
         else
            stopAutoPotions()
            Rayfield:Notify({
               Title = "Auto Potion",
               Content = "Disabled",
               Duration = 2
            })
         end
      end
   })
   
   print("[EXTRAS] Tab loaded with Auto Sell + Auto Potion systems")
end