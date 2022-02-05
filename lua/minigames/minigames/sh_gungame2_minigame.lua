if SERVER then
    AddCSLuaFile()
  end
  
  --CONCEPT: Random gun, get a new one when out of ammo
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Gun Game 2"
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then
  
    local function ReplaceGun(ply)
        local weps = weapons.GetList()
        local gungame_weps = {}

        for i = 1, #weps do
            local wep = weps[i]
            if (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and wep.AutoSpawnable then
                gungame_weps[#gungame_weps + 1] = wep
            end
        end

        local ply_weps = ply:GetWeapons()
        for i = 1, #ply_weps do
            local wep = ply_weps[i]
            if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                ply:StripWeapon(wep:GetClass())
            end
        end

        local selection = gungame_weps[math.random(1, #gungame_weps)]
        local wep = ply:Give(selection.ClassName)
        wep.AllowDrop = false
        ply:SelectWeapon(wep)
    end
  
    function MINIGAME:OnActivation()
        local entities = ents.GetAll()
        for i = 1, #entities do
            local ent = entities[i]
            if (ent.Base == "weapon_tttbase" and 
                (ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_PISTOL)) 
                or (ent.Base == "base_ammo_ttt") 
            then
                ent:Remove()
            end
        end

        local plys = util.GetAlivePlayers()
        for i = 1, #plys do
            local ply = plys[i]
            ReplaceGun(ply)
        end

        hook.Add("Think", "TTT2MinigameGungame2Think", function()
            local plys = util.GetAlivePlayers()

            for i = 1, #plys do
                local ply = plys[i]
                local weps = ply:GetWeapons()
                local needsWeapon = true
                for j = 1, #weps do
                    local wep = weps[j]
                    if not (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) then continue end
                    needsWeapon = false

                    if wep:Clip1() <= 0 then
                        ReplaceGun(ply)
                        break
                    end
                if needsWeapon then ReplaceGun(ply) end
                end
            end
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("Think", "TTT2MinigameGungame2Think")
    end

    -- function MINIGAME:IsSelectable()
    --   return false
    -- end
  end
  