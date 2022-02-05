if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("C4Minigame_Alert")
  end
  
  --Concept: Randomly spawn C4
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "C4 Surprise!"
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then

    minigame_c4_list = {}

    function SpawnC4atPlayer(ply, delay)
        -- print("Spawning C4")
        local c4 = ents.Create("ttt_c4")
        c4:Initialize()
        c4:Arm(ply, delay)
        c4:Spawn()
        c4:SetPos(ply:GetPos())
        minigame_c4_list[#minigame_c4_list + 1] = c4
        net.Start("C4Minigame_Alert")
        net.Send(ply)
    end

    function RandomSpawnC4()
        -- print("Finding a random position")
        local pos = Vector(0,0,0)
        local delay = math.random(45,120)
        local plys = util.GetAlivePlayers()
        -- print("Finding a random player")
        local ply = plys[math.random(1,#plys)]
        SpawnC4atPOS(ply, delay)
    end

    function MINIGAME:OnActivation()
        -- print("C4 Minigame Activated")
        local delay = math.random(30,120) + CurTime()
        hook.Add("Think", "ThinkC4MinigameSpawn", function()
            if delay > CurTime() then return end
            if GetRoundState() ~= ROUND_ACTIVE then
                self:OnDeactivation()
            end
            RandomSpawnC4()
            delay = CurTime() + math.random(30,120)
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("Think", "ThinkC4MinigameSpawn")
        for i = 1, #minigame_c4_list do
            if not IsValid(minigame_c4_list[i]) then continue end
            minigame_c4_list[i]:Remove()
        end
        minigame_c4_list = {}
    end
  
    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
end
if CLIENT then
    net.Receive("C4Minigame_Alert", function()
        EPOP:AddMessage({
            text = "You've dropped C4!"
        })
    end)
end