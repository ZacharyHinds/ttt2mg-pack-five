if SERVER then
    AddCSLuaFile()
  end
  
  --Concept: Players get second life as Elderly Role
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Retirement Home"
      },
      desc = {
        en = "All you damn whippersnappers get off my lawn!"
      }
    }
  end
  
  if SERVER then
    function MINIGAME:OnActivation()
        hook.Add("TTT2PostPlayerDeath", "TTT2MinigameRetirementRespawn", function(ply, attacker, dmgInfo)
            if not IsValid(ply) then return end

            if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("TTT2PostPlayerDeath", "TTT2MinigameRetirementRespawn") return end

            if ply.has_respawned_retirement or ply:IsReviving() then return end

            ply:Revive(
                12,
                function()
                    ply:SetRole(ROLE_ELDERLY)
                    ply.has_respawned_retirement = true
                    SendFullStateUpdate()
                end,
                nil,
                false
            )
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("TTT2PostPlayerDeath", "TTT2MinigameRetirementRespawn")
        local plys = player.GetAll()
        for i = 1, #plys do
            local ply = plys[i]
            ply.has_respawned_retirement = nil
        end
    end
  
    function MINIGAME:IsSelectable()
      if ELDERLY then
        return true
      else
        return false
      end
    end
  end
  