if SERVER then
  AddCSLuaFile()
end

--Concept:

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {}
  -- ttt2_minigame_sensitivity_scale = {
  --   slider = true,
  --   min = 1,
  --   max = 2,
  --   decimal = 2,
  --   desc = "ttt2_minigame_sensitivity_scale (Def. 1.0)"
  -- }

if CLIENT then
  MINIGAME.lang = {
    name = {
      en = "Twitch Shooter"
    },
    desc = {
      en = "Sensitivity way up!"
    }
  }
end

local ttt2_minigame_sensitivity_scale = CreateConVar("ttt2_minigame_sensitivity_scale", "1.0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Sensitivity scale for Twitch Minigame") 
if SERVER then
  util.AddNetworkString("twitchMinigame_enabled")
  util.AddNetworkString("twitchMinigame_update")


  function MINIGAME:OnActivation()
    net.Start("twitchMinigame_enabled")
    net.WriteBool(true)
    net.Broadcast()
  end

  function MINIGAME:OnDeactivation()
    net.Start("twitchMinigame_enabled")
    net.WriteBool(false)
    net.Broadcast()
  end
end

if CLIENT then
  function MINIGAME:OnActivation()
    -- local delay = CurTime() + 5
    hook.Add("CreateMove", "TwitchMinigameMouse", function(cmd)
      local ply = LocalPlayer()
      if not ply.twitchMinigame_enabled then return end
      if not ply:Alive() or not ply:IsPlayer() then return end

      local scalar = 2

      local mouseY = cmd:GetMouseY()
      if mouseY > 0 then
        mouseY = mouseY ^ scalar
      else
        mouseY = mouseY ^ scalar * -1
      end

      mouseY = mouseY / 2

      local mouseX = cmd:GetMouseX()
      if mouseX > 0 then
        mouseX = mouseX ^ scalar
      else
        mouseX = mouseX ^ scalar * -1
      end

      mouseX = mouseX / 2

      local view = cmd:GetViewAngles()

      local angles = Angle(view.p + mouseY / 30, view.y - mouseX / 30, 0)
      angles.p = math.Clamp(angles.p, -89, 89)

      cmd:SetViewAngles(angles)
      -- ply:SetEyeAngles(angles)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("CreateMove", "TwitchMinigameMouse")
  end

  net.Receive("twitchMinigame_enabled", function()
    if net.ReadBool() then
      LocalPlayer().twitchMinigame_enabled = true
    else
      LocalPlayer().twitchMinigame_enabled = nil
    end
  end)
end
