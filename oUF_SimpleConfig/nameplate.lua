
-- oUF_SimpleConfig: nameplate
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- NamePlateCallback
-----------------------------

local function NamePlateCallback(nameplate,event,unit)
  --print(...)
  if nameplate and nameplate.TargetIndicator then
    if UnitGUID("target") and UnitGUID(unit) == UnitGUID("target") then
      nameplate.TargetIndicator:Show()
    else
      nameplate.TargetIndicator:Hide()
    end
  end
end
L.C.NamePlateCallback = NamePlateCallback

-----------------------------
-- NamePlateCVars
-----------------------------

local cvars = {
  nameplateMotion           = 1,

  nameplateMinScale         = 1,
  nameplateMaxScale         = 1,
  nameplateMinScaleDistance = 0,
  nameplateMaxScaleDistance = 40,

  nameplateGlobalScale      = 1,
  NamePlateHorizontalScale  = 1,
  NamePlateVerticalScale    = 1,
  nameplateSelfScale        = 1,
  nameplateSelectedScale    = 1,
  nameplateLargerScale      = 1,
  nameplateShowFriendlyNPCs = 0,
  
  nameplateMinAlpha         = 1,--0.75,
  nameplateMaxAlpha         = 1,--0.75,
  nameplateMinAlphaDistance = 0,
  nameplateMaxAlphaDistance = 40,
  nameplateSelectedAlpha    = 1,
  nameplateOtherAtBase      = 0,

  --decrease nameplate spacing
  nameplateOverlapH = 0.7, -- 1.1
  nameplateOverlapV = 0.85, -- 0.8

  --force nameplates to stay on screen
  nameplateOtherTopInset = 0.08, -- -1
  nameplateOtherBottomInset = 0.1, -- -1

  --meh just to remember
  SpellQueueWindow = 100,
}

L.C.NamePlateCVars = cvars

-----------------------------
-- NamePlateConfig
-----------------------------

--custom filter for nameplate debuffs
local function CustomDebuffFilter(...)
  local element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3 = ...
  return (nameplateShowAll or button.isPlayer) 
    and spellID ~= 12486 --Mage: Blizzard
    and spellID ~= 205708 --Mage: Chilled
    and spellID ~= 2818 --Rogue: Deadly Poison
    and spellID ~= 3409 --Rogue: Crippling Poison
    and spellID ~= 256148 --Rogue: Iron Wire
    and spellID ~= 1330 --Rogue: Garrot Silence
    and spellID ~= 302565 --Conductive Ink

end

local function CustomBuffFilter(...)
  local element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3 = ...
  local _, class = UnitClass("player")
  --[[if class == "ROGUE" then 
    return isStealable and not debuffType == "" 
  end]]

  --return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
  return isStealable 
    -- RAID
    or spellID == 329636 --Stone Legion - Hardener Stone Form
    or spellID == 329808 --Stone Legion - Hardener Stone Form


    -- DUNGEON
    or spellID == 323149 --Mists - Embrace Darkness
    or spellID == 343470 --NW - Boneshatter Shield
end

--[[local function CustomAuraFilter(...)
  --icons, unit, icon, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, _, _, _, _, _, _, spellID = ...
  --return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
  return spellID == 277242  --Symbiote of G'huun
    or spellID == 276434 --Decaying Flesh (Uldir)
    or spellID == 285382 --Kelp Wrapping (isBossDebuff)
    --or spellID == 12654 --test
end]]
--[[local function CustomAuraFilter(...)
  local element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3 = ...
  if button.isDebuff then
    return nameplateShowAll or button.isPlayer
  else
    return isStealable 
    or spellID == 265091 --Gift of G'huun
    or spellID == 278567 --Soul Fetish
    or spellID == 267981 --Protective Aura
  end
end]]

L.C.nameplate = {
  enabled = true,
  --size = {138,5},
  size = {154 ,6},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*(768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")),
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
    name = {
      enabled = true,
      noshadow = true,
      points = {
        --{"BOTTOMLEFT",1.5,14.5},
        {"BOTTOMLEFT",1,11.5},
        --{"BOTTOMRIGHT",0.5,14.5},
        {"BOTTOMRIGHT",0,11.5 },
      },
      size = 13,
      align = "CENTER",
      tag = "[oUF_Simple:name]",
      --tag = "[oUF_Simple:healer][oUF_Simple:nameplatecolor][oUF_Simple:classification][name]|r",
    },
    health = {
      enabled = true,
      point = {"CENTER","CENTER",0,-0.5},
      size = 13,
      align = "CENTER",
      --font = L.C.mediapath.."PixelOperator-Bold.ttf",
      --outline = "MONOCHROMEOUTLINE",
      tag = "[oUF_Simple:execute]",
      noshadow = true,
    },
    debuffHighlight = true,
  },
  powerbar = {
    enabled = false,
    height = 1,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {154,18},
    point = {"TOPRIGHT","BOTTOMRIGHT",0,-1},
    name = {
      enabled = true,
      align = "CENTER",
      noshadow = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",0,0},
      },
      size = 11,
    },
    icon = {
      enabled = true,
      size = 16,
      point = {"RIGHT","LEFT",0,0},
    },
  },
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,23},
    num = 4,
    cols = 4,
    size = 34,
    spacing = 6,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    disableMouse = true,
    CustomFilter = CustomDebuffFilter,
    --PostCreateAura = PostCreateAura,
  },
  buffs = {
    enabled = true,
    point = {"RIGHT","LEFT",-12,0},
    num = 2,
    cols = 2,
    size = 34,
    spacing = 6,
    initialAnchor = "RIGHT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = true,
    disableMouse = true,
    showStealableBuffs = true,
    CustomFilter = CustomBuffFilter,
    --PostCreateAura = PostCreateAura,
  },
  --[[special
  auras = {
    enabled = true,
    point = {"BOTTOM","TOP",0,55},
    num = 1,
    cols = 1,
    size = 36,
    spacing = 6,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    disableMouse = true,
    CustomFilter = CustomAuraFilter,
    --PostCreateAura = PostCreateAura,
  },]]
  aurawatch = {
    size = 36,
    indicators = {
      DRUID = {
        --{164815, 'TOPRIGHT', {10, 10}, {0/255, 150/255, 136/255}}, --Lifebloom

      },
    },
  },
}