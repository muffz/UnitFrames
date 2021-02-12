
-- oUF_Simple: core/spawn
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF or oUF

-----------------------------
-- oUF Tags
-----------------------------

--add player regen to the unitless event tags
oUF.Tags.SharedEvents["PLAYER_REGEN_DISABLED"] = true
oUF.Tags.SharedEvents["PLAYER_REGEN_ENABLED"] = true

--tag method: oUF_Simple:health
oUF.Tags.Methods["oUF_Simple:health"] = function(unit)
  if not UnitIsConnected(unit) then
    return "|cff999999Offline|r"
  end
  if(UnitIsDead(unit) or UnitIsGhost(unit)) then
    return "|cff999999Dead|r"
  end
  local hpmin, hpmax = UnitHealth(unit), UnitHealthMax(unit)
  local hpper = 0
  if hpmax > 0 then hpper = floor(hpmin/hpmax*100) end
  return L.F.NumberFormat(hpmin).." | "..hpper.."%"
end
--tag event: oUF_Simple:health
oUF.Tags.Events["oUF_Simple:health"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"

--tag method: oUF_Simple:health
oUF.Tags.Methods["oUF_Simple:power"] = function(unit)
  if UnitPower(unit) and UnitPower(unit) == 0 then return "" end --hopefully fix a bug with soulshape
  local powerType = UnitPowerType(unit)
  if powerType == 0 then
    return floor(UnitPower(unit)/UnitPowerMax(unit)*100)
  else
    return UnitPower(unit)
  end
end
--tag event: oUF_Simple:health
oUF.Tags.Events["oUF_Simple:power"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"

--tag method: oUF_Simple:color
oUF.Tags.Methods["oUF_Simple:color"] = function(unit)
  local r,g,b

  if UnitIsFriend("player", unit) then
    if UnitIsPlayer(unit) then
      local _, class = UnitClass(unit)
      if class then
        r,g,b = RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b
      else
        r,g,b = 1,1,1
      end
    else
      r,g,b = unpack(L.C.colors.reaction[UnitReaction(unit, "player") or 5])
    end
  else
    r,g,b = 1,1,1
  end
  return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end
--tag event: oUF_Simple:color
oUF.Tags.Events["oUF_Simple:color"] = "UNIT_TARGET UNIT_THREAT_SITUATION_UPDATE"

--tag method: oUF_Simple:nameplatecolor
oUF.Tags.Methods["oUF_Simple:nameplatecolor"] = function(unit)
  local r,g,b

  if UnitIsPlayer(unit) then
    local _, class = UnitClass(unit)
    r,g,b = RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b
  else
    r,g,b = unpack(L.C.colors.reaction[UnitReaction(unit, "player") or 5])
  end
  return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end
--tag event: oUF_Simple:nameplatecolor
oUF.Tags.Events["oUF_Simple:nameplatecolor"] = "UNIT_TARGET UNIT_THREAT_SITUATION_UPDATE"

--tag method: oUF_Simple:classification
oUF.Tags.Methods["oUF_Simple:classification"] = function(unit)
  local c = UnitClassification(unit)
  if(c == 'rare') then
    return 'r '
  elseif(c == 'rareelite') then
    return 'r+ '
  elseif(c == 'elite') then
    return '+ '
  elseif(c == 'worldboss') then
    return 'b '
  elseif(c == 'minus') then
    return '- '
  end
end
--tag event: oUF_Simple:classification
oUF.Tags.Events["oUF_Simple:classification"] = "UNIT_CLASSIFICATION_CHANGED"

--tag method: oUF_Simple:classification
oUF.Tags.Methods["oUF_Simple:name"] = function(unit)
  --healer
  local t = ''
  local cid = select(3,UnitClass(unit))
  local ptype = UnitPowerType(unit)
  local maxpp = UnitPowerMax(unit, ptype)

  if UnitIsPlayer(unit) and ptype == 0 and maxpp >= 50000 and cid ~= 8 and cid ~= 9 then
    t = '|TInterface\\LFGFrame\\LFGRole:13.5:13.5:0:0:64:16:48:64:0:16|t '
  end

  --classification
  local c = UnitClassification(unit)
  if(c == 'rare') then
    c = 'r '
  elseif(c == 'rareelite') then
    c = 'r+ '
  elseif(c == 'elite') then
    c = '+ '
  elseif(c == 'worldboss') then
    c = 'b '
  elseif(c == 'minus') then
    c = '- '
  else
    c = ''
  end

  --name
  local n = UnitName(unit)

  if c == '- ' then
    c = ''
    n = ''
  end

  --coloring
  local r,g,b
  if L.C.importantMobs[UnitName(unit)] then
    r,g,b = L.C.importantMobs[UnitName(unit)][1],L.C.importantMobs[UnitName(unit)][2],L.C.importantMobs[UnitName(unit)][3]
  elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
    r,g,b = 0.57,0.57,0.57
  elseif UnitIsPlayer(unit) then
    local _, class = UnitClass(unit)
    r,g,b = RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b
  else
    if not UnitAffectingCombat(unit) then
      r,g,b = unpack(L.C.colors.reaction[UnitReaction(unit, "player") or 5]) 
    else
      r,g,b = 0.72,0.11,0.11
    end
  end

  
  --local e = '|TInterface\\Icons\\ability_warlock_backdraft:0|t '
  --local e = '|TInterface\\petbattles\\battlebar-abilitybadge-weak-small:14:14|t '
  --[[local e = ' '
  local uc = select(3,UnitClass("player"))
  local s,_,_,_,k = select(6,GetTalentInfo(1,3,GetActiveSpecGroup()))
  if uc == 8 and s == 269644 and k and UnitHealth(unit)/UnitHealthMax(unit) < .3 and not UnitIsFriend("player", unit) then
    n = '!!!'
    --e = '|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14|t'
  else
    n = UnitName(unit)
    --e = ''
  end]]

  return string.format('%s|cff%02x%02x%02x%s%s|r',t,r*255,g*255,b*255,c,n)
end
--tag event: oUF_Simple:classification
oUF.Tags.Events["oUF_Simple:name"] = "UNIT_NAME_UPDATE UNIT_CLASSIFICATION_CHANGED UNIT_FACTION" -- UNIT_HEALTH UNIT_MAXHEALTH"

--tag method: oUF_Simple:execute indicator
oUF.Tags.Methods["oUF_Simple:execute"] = function(unit)
  local uc = select(3,UnitClass("player"))
  if uc ~= 8 then return '' end
  local s,_,_,_,k = select(6,GetTalentInfo(1,3,GetActiveSpecGroup()))
  if s ~= 269644 and not k then return '' end
  if UnitHealth(unit)/UnitHealthMax(unit) < 0.3 and not UnitIsFriend("player", unit) then
    return '!!!'
  else
    return ''
  end
end
--tag event: oUF_Simple:role
oUF.Tags.Events["oUF_Simple:execute"] = "UNIT_HEALTH UNIT_MAXHEALTH"

--tag method: oUF_Simple:role
oUF.Tags.Methods["oUF_Simple:healer"] = function(unit)
  local _, class = UnitClass(unit)
  local powerType = UnitPowerType(unit)
  local maxpower = UnitPowerMax(unit, powerType)

  if UnitIsPlayer(unit) and powerType == 0 and maxpower == 100000 and class ~= "MAGE" and class ~= "WARLOCK" then
    return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:48:64:0:16|t"
  end
end
--tag event: oUF_Simple:role
oUF.Tags.Events["oUF_Simple:healer"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"

--tag method: oUF_Simple:role
oUF.Tags.Methods["oUF_Simple:role"] = function(unit)
  local role = UnitGroupRolesAssigned(unit)
  if role == "TANK" then
    return "|TInterface\\LFGFrame\\LFGRole:14:14:0.5:0.5:64:16:32:48:0:16|t"
  --elseif role == "HEALER" then
    --return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:48:64:0:16|t"
  --elseif role == "DAMAGER" then
    --return "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:16:32:0:16|t"
  end
end
--tag event: oUF_Simple:role
oUF.Tags.Events["oUF_Simple:role"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

--tag method: oUF_Simple:leader
oUF.Tags.Methods["oUF_Simple:leader"] = function(unit)
  if UnitIsGroupLeader(unit) then
    return "|TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t"
  end
end
--tag event: oUF_Simple:leader
oUF.Tags.Events["oUF_Simple:leader"] = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

--load tags from the config
if L.C.tagMethods and type(L.C.tagMethods) == "table" and
   L.C.tagEvents  and type(L.C.tagEvents) == "table" then
  for key, value in next, L.C.tagMethods do
    if L.C.tagMethods[key] and L.C.tagEvents[key] then
      oUF.Tags.Methods[key] = L.C.tagMethods[key]
      oUF.Tags.Events[key] = L.C.tagEvents[key]
    end
  end
end