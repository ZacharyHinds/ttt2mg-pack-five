if SERVER then
    AddCSLuaFile()
  end
  
  --CONCEPT: Players limited to sniper rifle
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Quickscope Round"
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then
  
  
    function MINIGAME:OnActivation()

        local ents = ents.GetAll()
        for i = 1, #ents do
            local ent = ents[i]
            if (ent.Base == "weapon_tttbase" and (ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_PISTOL)) or ent.Base == "base_ammo_ttt" then
                ent:Remove()
            end
        end

        local plys = player.GetAll()
        for i = 1, #plys do
            local ply = plys[i]
            weps = ply:GetWeapons()
            for j = 1, #weps do
                local wep = weps[j]
                if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                    ply:StripWeapon(wep:GetClass())
                end
            end
            local rifle = ply:Give("weapon_zm_rifle")
            rifle.AllowDrop = false
        end


        hook.Add("PlayerCanPickupWeapon", "MinigameQuickscopePickup", function(ply, wep)
            if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                return false
            end
        end)

        hook.Add("Think", "MinigameQuickscopeThinkAmmo", function()
            local plys = util.GetAlivePlayers()
            for i = 1, #plys do
                plys[i]:SetAmmo(100, "357")
            end
        end)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("PlayerCanPickupWeapon", "MinigameQuickscopePickup")
        hook.Remove("Think", "MinigameQuickscopeThinkAmmo")
        local plys = util.GetAlivePlayers()
        for i = 1, #plys do
            local ply = plys[i]
            local weps = ply:GetWeapons()
            for j = 1, #weps do
                local wep = weps[j]
                if wep:GetClass() == "weapon_zm_rifle" then
                    wep.AllowDrop = true
                end
            end
        end
    end
  
    function MINIGAME:IsSelectable()
      return false
    end
  end
  