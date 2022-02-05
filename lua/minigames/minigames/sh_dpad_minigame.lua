if SERVER then
    AddCSLuaFile()
  end
  
  --Concept: Player can only move along orthagonals/diagonals
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Classic Controls"
      },
      desc = {
        en = "No Strafing Allowed!"
      }
    }
  end
  
  if SERVER then
    function MINIGAME:OnActivation()
        hook.Add("StartCommand", "DPadMinigameControl", function(ply, ucmd)
            if GetRoundState() ~= ROUND_ACTIVE then hook.Remove("StartCommand", "DPadMinigameControl") return end
            if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then return end

            ucmd:SetSideMove(0)
            ucmd:SetUpMove(0)
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("StartCommand", "DPadMinigameControl")
    end
  
    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
  end
  