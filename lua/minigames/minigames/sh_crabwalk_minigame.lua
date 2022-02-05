if SERVER then
    AddCSLuaFile()
  end
  
  --Concept: Player can only move side to side
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Crabby"
      },
      desc = {
        en = "Only move sideways"
      }
    }
  end
  
  if SERVER then
    function MINIGAME:OnActivation()
        hook.Add("StartCommand", "CrabbyMinigameControl", function(ply, ucmd)
            if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("StartCommand", "DPadMinigameControl") return end
            if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end

            ucmd:SetForwardMove(0)
            ucmd:SetUpMove(0)
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("StartCommand", "CrabbyMinigameControl")
    end
  
    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
  end
  