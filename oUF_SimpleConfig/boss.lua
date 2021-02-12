
-- oUF_SimpleConfig: boss
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Boss Config
-----------------------------

local function CustomFilter(...)
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

L.C.boss = {
  enabled = true,
  size = {210,21},
  point = {"TOP","oUF_SimpleFocus","BOTTOM",0,461}, --point of first boss frame
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    frequentUpdates = true,
    name = {
      enabled = true,
      noshadow = true,
      points = {
        {"LEFT",1,0},
        {"RIGHT",-75,0},
      },
      size = 12,
      tag = "[oUF_Simple:color][oUF_Simple:classification][name]",
    },
    health = {
      enabled = true,
      noshadow = true,
      align = "RIGHT",
      point = {"RIGHT",0,0},
      size = 12,
      tag = "[oUF_Simple:color][oUF_Simple:health]",
    },
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    height = 5,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  castbar = {
    enabled = false,
    size = {183,16},
    point = {"TOP","BOTTOM",13,-49},
    backdrop = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",0,0},
      },
      font = STANDARD_TEXT_FONT,
      size = 12,
      outline = "OUTLINE",
      align = "CENTER",
      noshadow = true,
    },
    icon = {
      enabled = true,
      size = 16,
      point = {"BOTTOMRIGHT","BOTTOMLEFT",-6,0},
    },
  },
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,6},
    num = 6,
    cols = 6,
    size = 30,
    spacing = 6,
    initialAnchor = "BOTTOMLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    CustomFilter = CustomFilter,
  },
  setup = {
    point = "TOP",
    relativePoint = "BOTTOM", --relativeTo will be the boss frame preceding
    xOffset = 0,
    yOffset = -81,
  },
}
