--[[
  Project Name: Client Sided Anti-Cheat
  Status: Finished, obsolete. Join Jupiter Development to suggest features and functions. 
  Developers:
              Jupiter Development:
                                  Styx -- Founder and Lead Developer.
                                  Lolegic -- Made the UI detection.
]]

--[[
  Comment Styles:
    --// This is for tips.
    -- This is for important information
    --! This is for arguements for a table
    --@ This is for describing purposes
]]

local switches = {} --// Use this for customizations.
switches.SpeedDetection = true
switches.JumpDetection = true
switches.InvisibleDetection = true -- Older invisible scripts teleport players to the void to be able to keep them invisible, you can easily detect this; however false positives prevented this from being useful. However, simple sanity checks can actually help this.
switches.TeleportDetection = true -- Can cause issue in games that teleport the player, possible need to disable.
switches.AccountAgeRestrictions = true -- prevents young Roblox accounts from joining.
switches.UIDetection = true -- Detects UI's in CoreGUI

local antiCheatMechanics = {} --// Customize for how you want the Anti-Cheat to work
antiCheatMechanics.StrikeSystem = true
antiCheatMechanics.NumberOfStrikes = 3
antiCheatMechanics.WarningSystem = true

local info = {} --// More important things needed to be customized.
info.AccountAgeRestriction = 10 --@ This is to prevent accounts under the minimum (10) days of age from joining the game.
info.Strikes = 0
info.WalkSpeedMaximum = 40
info.NormalWalkSpeed = 30
info.JumpPowerMaximum = 40
info.NormalJumpPower = 34

local excluded = {}
excluded.ExcludedPlayers = {} --! UserID, UserName -- System so the Owner/Admin/Developer/Mod can still do stuff without having issues. --@ Ex. Make sure its a table {"UserID", "Username"}
-- Likely more to be added.

local variables = {}
variables.GamePlayers = game:GetService("Players")
variables.LocalPlayer = game:GetService("Players").LocalPlayer
variables.Humanoid = game:GetService("Players").LocalPlayer.Character.Humanoid
variables.DeactivateScript = false

local usedFunctions = {}

usedFunctions.Kick = function(kickReason: string)
  variables.LocalPlayer:Kick(kickReason)
end

usedFunctions.IsExcluded = function()
  for _, excludedPlayer in ipairs(excluded.ExcludedPlayers) do
    if excludedPlayer.UserId == tostring(variables.LocalPlayer.UserId) and excludedPlayer.UserName == variables.LocalPlayer.Name then
      return true
    end
  end
  return false
end

usedFunctions.UpdateStrikes = function()
  info.Strikes = info.Strikes + 1
  game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Warning!",
    Text = "You've been caught cheating, stop it! You only have " .. antiCheatMechanics.NumberOfStrikes - info.Strikes .. " left.",
    Duration = 3
  }
)
  if info.Strikes == antiCheatMechanics.NumberOfStrikes then
    usedFunctions.Kick("You have been kicked due to several violations of the game rules.") -- This is how you would add your own ban system if you wanted.
  end
end

game.Loaded:Wait()

if usedFunctions.IsExcluded() then
  variables.DeactivateScript = true
  return
end

for i,v in ipairs(game:GetService("CoreGui")) do
  table.insert(info.CoreGuiInfo, i, v)
end

if switches.AccountAgeRestrictions then
  if variables.LocalPlayer.AccountAge >= info.AccountAgeRestriction then
    usedFunctions.Kick("You have been kicked because your Roblox account does not meet or exceed our account age limit.")
  end
end

variables.Humanoid:GetAttributeChangedSignal("WalkSpeed"):Connect(function()
  if variables.Humanoid.WalkSpeed > info.WalkSpeedMaximum and switches.SpeedDetection then
    usedFunctions.UpdateStrikes()
    variables.Humanoid.WalkSpeed = info.NormalWalkSpeed
  end
end)

variables.Humanoid:GetAttributeChangedSignal("JumpPower"):Connect(function()
  if variables.Humanoid.JumpPower > info.JumpPowerMaximum and switches.JumpDetection then
    usedFunctions.UpdateStrikes()
    variables.Humanoid.JumpPower = info.NormalJumpPower
  end
end)

variables.LocalPlayer.Character.HumanoidRootPart.AttributeChanged("CFrame"):Connect(function(oldXYZ: CFrame | CFrameValue) -- This I think is right if not next update this will be redone
  if switches.TeleportDetection then
    if oldXYZ.X > variables.LocalPlayer.Character.HumanoidRootPart.CFrame.X + 60 then
      usedFunctions.UpdateStrikes()
    end
  end
end)

while switches.InvisibleDetection do
  if variables.LocalPlayer.Character.HumanoidRootPart.CFrame.X >= 9999 and variables.LocalPlayer.Character.HumanoidRootPart.CFrame.Y > 9999 then
      task.wait(7)
      if variables.LocalPlayer.Character.HumanoidRootPart.CFrame.X >= 9999 and variables.LocalPlayer.Character.HumanoidRootPart.CFrame.Y > 9999 then
        usedFunctions.UpdateStrikes()
        variables.LocalPlayer.Character.Humanoid.Health = 0
      end
  end
end

while true do
  local coreGui = game:GetService("CoreGui")
  local table = {}
  local weakMetaTable = setmetatable({}, {__mode = "kv"})
  weakMetaTable[1] = coreGui
  weakMetaTable[2] = table
  coreGui = nil
  table = nil
    while weakMetaTable[2] do
      task.wait(0.15)
    end
    if weakMetaTable[1] then
      usedFunctions.UpdateStrikes()
    end
end

-- This is to keep track of what Ive done
--[[
  Account age verification: ✅
  IsExcluded: ✅
  Speed Detection: ✅
  Jump Detection: ✅
  Teleport Detection: ✅
  Invisible Detection: ✅
  UI Detection: ✅
  Strike System: ✅
]]
