if SERVER then
    AddCSLuaFile()
  end
  
  --CONCEPT: Players receive 2nd role, game switches between Day and Night roles throughout round
  
  MINIGAME.author = "Wasted"
  MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"
  
  MINIGAME.conVarData = {}
  
  if CLIENT then
    MINIGAME.lang = {
      name = {
        en = "Jekyll and Hyde"
      },
      desc = {
        en = ""
      }
    }
  end
  
  if SERVER then
    util.AddNetworkString("JekyllAndHyde_Start")
    local function GetNewRoles(plys)
      local verify_plys = plys
      local available_roles = roleselection.GetAllSelectableRolesList(#plys)
      table.Shuffle(available_roles)
      table.Shuffle(plys)
      -- for i = 1, #plys do
      --   local ply = plys[i]
      --   if #available_roles == 0 then
      --     if ply:GetTeam() == TEAM_INNOCENT then
      --       ply.night_role = ROLE_TRAITOR
      --     elseif ply:GetTeam() == TEAM_TRAITOR then
      --       ply.night_role = ROLE_INNOCENT
      --     end
      --   else
      --     local rnd = math.random(1, #available_roles)
      --     ply.nighttime_role = available_roles[rnd]
      --     table.remove(available_roles, rnd)
      --   end

      -- end
      for k, v in pairs(available_roles) do
        local rnd = math.random(1, #plys)
        local ply = plys[rnd]
        table.remove(plys, rnd)
        ply.nighttime_role = k
        ply.nighttime_team = roles.GetByIndex(k).team
      end
      local c = 0
      if #plys > 0 then
        for i = 1, #plys do
          local ply = plys[i]
          if ply:GetTeam() == TEAM_INNOCENT then
            ply.night_role = ROLE_TRAITOR
          elseif ply:GetTeam() == TEAM_TRAITOR and c <= 0 then
            ply.night_role = ROLE_DETECTIVE
          elseif ply:GetTeam() == TEAM_TRAITOR then
            ply.night_role = ROLE_INNOCENT
          elseif c <= 0 then
            ply.night_role = ROLE_DETECTIVE
          else
            ply.night_role = ROLE_INNOCENT
          end
          ply.nighttime_team = roles.GetByIndex(ply.nighttime_role).defaultTeam
        end
      end
      for i = 1, #plys do
        local ply = plys[i]
        if not ply.nighttime_role then
          ply.nighttime_role = ROLE_INNOCENT
        end
        if not ply.nighttime_team then
          ply.nighttime_team = TEAM_INNOCENT
        end
      end
    end

    local function GetNewRolePlayer(ply)
      local available_roles = roleselection.GetAllSelectableRolesList(1)
      table.Shuffle(available_roles)
      local roles = {}
      for k, v in pairs(available_roles) do
        roles[roles + 1] = k
      end
      local rnd = math.random(1, #roles)
      ply.nighttime_role = roles[rnd]
      ply.nighttime_team = roles.GetByIndex(ply.nighttime_role).defaultTeam
    end
  
local isNighttime = false

    function MINIGAME:OnActivation()
      isNighttime = false
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply = plys[i]
        ply.daytime_role = ply:GetSubRole()
        ply.daytime_team = ply:GetTeam()
        ply.nighttime_role = nil

      end
      GetNewRoles(plys)

      timer.Create("ttt2mg_hyde_minigame_timer", 60, 0, function()
        isNighttime = not isNighttime
        local plys = util.GetAlivePlayers()

        net.Start("JekyllAndHyde_Start")
        net.WriteBool(isNighttime)
        net.Broadcast()

        for i = 1, #plys do
          local ply = plys[i]
          if isNighttime then
            ply:SetRole(ply.nighttime_role, ply.nighttime_team)
          else
            ply:SetRole(ply.daytime_role, ply.daytime_team)
          end
        end
        SendFullStateUpdate()
      end)

      hook.Add("PlayerSpawn", "TTT2HydeMinigameSpawn", function(ply)
        if not ply:Alive() or ply:IsSpec() or not ply:IsActive() then return end

        if not ply.nighttime_role or not ply.daytime_role then
          GetNewRolePlayer(ply)
          ply.daytime_role = ply:GetSubRole()
          ply.daytime_team = ply:GetTeam()
          if isNighttime then
            ply:SetRole(ply.nighttime_role)
          else
            ply:SetRole(ply.daytime_role)
          end
        end
      end)

      hook.Add("TTT2UpdateTeam", "TTT2HydeMinigameUpdateTeam", function(ply, old, new)
        if isNighttime and ply.nighttime_team ~= new then
          ply.nighttime_team = new
        elseif not isNighttime and ply.daytime_team ~= new then
          ply.daytime_team = new
        end
      end)

      hook.Add("TTT2UpdateSubRole", "TTT2HydeMinigameUpdateSubRole", function(ply, old, new)
        if isNighttime and ply.nighttime_role ~= new then
          ply.nighttime_role = new
        elseif not isNighttime and ply.daytime_role ~= new then
          ply.daytime_role = new
        end
      end)
    end
  
    function MINIGAME:OnDeactivation()
  
    end
  
    function MINIGAME:IsSelectable()
      return false
    end

  elseif CLIENT then
    net.Receive("JekyllAndHyde_Start", function()
      local isNighttime = net.ReadBool()
      local msg = ""
      if isNighttime then
        msg = "The Sun sets; it is night"
      else
        msg = "The Sun rises; It is morning"
      end
      EPOP:AddMessage({
        text = msg
      })
    end)
  end
  