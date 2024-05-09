--[[
  Project Name: Client Sided Anti-Cheat
  Status: Work In Progress
  Developers:
              Jupiter Development:
                                  Styx -- Founder and Lead Developer
]]

--[[
  Comment Styles:
    --// This is for tips.
    -- This is for important information
    --! This is for arguements for a table
    --@ This is for describing purposes
]]

local switches = {} --// Use this for customizations.
switches.AntiJumpPowerModification = true
switches.AntiSpeedModification = true
switches.SpeedDetection = true
switches.JumpDetection = true
switches.InvisibleDetection = true -- Older invisible scripts teleport players to the void to be able to keep them invisible, you can easily detect this; however false positives prevented this from being useful. However, simple sanity checks can actually help this.
switches.FEBypasserDetection = true
switches.TeleportDetection = true -- Can cause issue in games that teleport the player, possible need to disable.
switches.AccountAgeRestrictions = true -- prevents young Roblox accounts from joining.

local antiCheatMechanics = {} --// Customize for how you want the Anti-Cheat to work
antiCheatMechanics.StrikeSystem = true
antiCheatMechanics.NumberOfStrikes = 3
antiCheatMechanics.WarningSystem = true

local info = {} --// More important things needed to be customized.
info.AccountAgeRestriction = 10 --@ This is to prevent accounts under the minimum (10) days of age from joining the game.
info.Strikes = 0
info.IsExcluded = nil

local excluded = {}
excluded.ExcludedPlayers = {} --! UserID, UserName -- System so the Owner/Admin/Developer/Mod can still do stuff without having issues.
excluded.IsExcluded = nil
-- Likely more to be added.

local variables = {}
variables.GamePlayers = game:GetService("Players")
variables.LocalPlayer = game:GetService("Players").LocalPlayer
variables.Humaniod = game:GetService("Players").LocalPlayer.Character.Humanoid

local usedFunctions = {}

usedFunctions.Kick = function(kickReason: string)
  variables.LocalPlayer:Kick(kickReason)
end

usedFunctions.UpdateStrikes = function()
  info.Strikes = info.Strikes + 1
  --@ Will be adding the warnings
  if info.Strikes == antiCheatMechanics.NumberOfStrikes then
    usedFunctions.Kick("You have been kicked due to several violations of the game rules.") -- This is how you would add your own ban system if you wanted.
  end
end

repeat task.wait(0.03) until game:IsLoaded()

if switches.AccountAgeRestrictions then
  if variables.LocalPlayer.AccountAge >= info.AccountAgeRestriction then
    usedFunctions.Kick("You have been kicked because your Roblox account does not meet or exceed our account age.")
  end
end