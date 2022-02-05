if SERVER then
    AddCSLuaFile()
  end
  
  --CONCEPT: Game speed increases over the course of the round
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Acceleration!"
      },
      desc = {
        en = "GAS GAS GAS"
      }
    }
  end
  
  if SERVER then
  
  
    function MINIGAME:OnActivation()
        timer.Create("tt2mg_acceleration_timer", 1, 0, function()
            timescale = game.GetTimeScale()
            game.SetTimeScale(timescale + 0.004)
        end)
    end
  
    function MINIGAME:OnDeactivation()
        timer.Remove("tt2mg_acceleration_timer")
        game.SetTimeScale(1)
    end
  
    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
  end
  