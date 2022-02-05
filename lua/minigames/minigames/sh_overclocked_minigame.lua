if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("OverclockedWeapon")
  end
  
  --CONCEPT: Shoting speed up
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Overclocked."
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then

	local function DisableWeaponSpeed(wep)
		if not IsValid(wep) or not wep.isOverclocked then return end

		wep.Primary.Delay = wep.OldDelay
		wep.OnDrop = wep.OldOnDrop

		net.Start("OverclockedWeapon")
		net.WriteBool(false)
		net.WriteEntity(wep)
		net.WriteFloat(wep.Primary.Delay)
		net.WriteFloat(wep.OldDelay)
		net.Send(wep.Owner)

		wep.OldOnDrop = nil
		wep.OldDelay = nil
		wep.isOverclocked = nil
	end

	local function ApplyWeaponSpeed(wep)
		if not IsValid(wep) or wep.isOverclocked
		or wep.Kind ~= WEAPON_HEAVY and wep.Kind ~= WEAPON_PISTOL then return end

		wep.OldDelay = wep.Primary.Delay
		wep.Primary.Delay = math.Round(0.25 * wep.Primary.Delay, 3)
		wep.OldOnDrop = wep.OnDrop
		wep.isOverclocked = true

		wep.OnDrop = function(slf, ...)
			DisableWeaponSpeed(slf)

			-- if IsValid(slf) and isfunction(slf.OnDrop) and isfunction(slf.OnDrop) then
			-- 	slf:OldOnDrop(...)
			-- end
		end

		net.Start("OverclockedWeapon")
		net.WriteBool(true)
		net.WriteEntity(wep)
		net.WriteFloat(wep.Primary.Delay)
		net.WriteFloat(wep.OldDelay)
		net.Send(wep.Owner)
	end

    local function shootingModifier(ply, old, new)
		if not IsValid(ply) then return end

        ApplyWeaponSpeed(new)

		if IsValid(old) then
			DisableWeaponSpeed(old)
		end
	end



    function MINIGAME:OnActivation()
        hook.Add("PlayerSwitchWeapon", "ShootingModifySpeed", shootingModifier)
    end
  
    function MINIGAME:OnDeactivation()
        hook.Remove("PlayerSwitchWeapon", "ShootingModifySpeed")
        local plys = player.GetAll()
        for i = 1, #plys do
            DisableWeaponSpeed(plys[i]:GetActiveWeapon())
        end
    end
  end
  
  if CLIENT then
    net.Receive("OverclockedWeapon", function()
		local apply = net.ReadBool()
		local wep = net.ReadEntity()

		if not IsValid(wep) then return end

		wep.Primary.Delay = net.ReadFloat()

		if apply then
			wep.OldOnDrop = wep.OnDrop
			wep.isOverclocked = true

			wep.OnDrop = function(slf, ...)
				if not IsValid(slf) then return end

				slf.Primary.Delay = net.ReadFloat()
				slf.OnDrop = slf.OldOnDrop
				slf.isOverclocked = false

				if isfunction(slf.OnDrop) then
					slf:OldOnDrop(...)
				end
			end
		else
			wep.OnDrop = wep.OldOnDrop
			wep.isOverclocked = nil
		end
	end)
  end