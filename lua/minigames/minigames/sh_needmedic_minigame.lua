if SERVER then
    AddCSLuaFile()
  end
  
  --CONCEPT: Respawn as medics
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "I Need a Medic!"
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then
    function MINIGAME:OnActivation()
        
        hook.Add("TTT2PostPlayerDeath", "TTT2MinigameNeedMedicRespawn", function(ply, attacker, dmgInfo)
            if not IsValid(ply) then return end

            if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("TTT2PostPlayerDeath", "TTT2MinigameNeedMedicRespawn") return end

            if ply.has_respawned_need_medic or ply:IsReviving() then return end

            ply:Revive(
                12,
                function()
                    ply:SetRole(ROLE_MEDIC)
                    ply.has_respawned_need_medic = true
                    SendFullStateUpdate()
                end,
                nil,
                false
            )
        end)
    end
  
    function MINIGAME:OnDeactivation()
  
    end
  
    function MINIGAME:IsSelectable()
        if MEDIC then
            return true
        else
            return false
        end
    end
  end
  