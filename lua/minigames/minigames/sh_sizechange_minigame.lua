if SERVER then
    AddCSLuaFile()
  end
  
  --Concept: Occasionally spawn radio items at players and have them run random sounds
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Health = Size"
      },
      desc = {
        en = "Damage shrinks you!"
      }
    }
  end
  
  if SERVER then

    local function setSize(ply, scal)
        if ply:IsSpec() or not ply:Alive() then return end

        ply:SetStepSize(1 * scal, 1)
        ply:SetModelScale(1 * scal, 1)
        ply:SetViewOffset(Vector(0, 0, 64) * scal)
        ply:SetViewOffsetDucked(Vector(0, 0, 32) * scal)
        ply:ResetHull()
        local a, b = ply:GetHull()
        ply:SetHull(a * scal, b * scal)
        a, b = ply:GetHullDuck()
        ply:SetHullDuck(a * scal, b * scal)
        hook.Add("TTTPlayerSpeed", "ShrinkMinigameSpeed", function()
          return math.Clamp(ply:GetStepSize() / 9, 0.25, 1)
        end)
    end


    function MINIGAME:OnActivation()

        hook.Add("Think", "ShrinkMinigameThink", function()
            local plys = util.GetAlivePlayers()
            for i = 1, #plys do
                local ply = plys[i]
                shrinkScale = math.Clamp(ply:Health() / 100, 0.20, 1.2)
                if ply.shrinkScale ~= shrinkScale then
                    ply.shrinkScale = shrinkScale
                    setSize(ply, shrinkScale)
                end
            end
        end)
  
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("Think", "ShrinkMinigameThink")
        local plys = player.GetAll()
        for i =1, #plys do
            local ply = plys[i]
            setSize(ply, 1)
            ply.shrinkScale = nil
        end
    end
  
    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
  end
  