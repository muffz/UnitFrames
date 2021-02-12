
-- oUF_SimpleConfig: focus
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Focus Config
-----------------------------

local function CustomFilter(...)
  --icons, unit, icon, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
  return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

L.C.focus = {
  enabled = true,
  size = {210,21},--{174,23},--{138,23},
  point = {"LEFT","oUF_SimpleTarget","RIGHT",20,0},
  scale = 1*L.C.globalscale,
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
    enabled = true,
    size = {183,16},
    --size = {256,16},
    point = {"TOP","BOTTOM",13,-49},
    --point = {"TOP","oUF_SimplePlayer","BOTTOM",13,-49-46},
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
  buffs = {
    enabled = true,
    point = {"TOPLEFT","BOTTOMLEFT",0,-6},
    num = 6,
    cols = 6,
    size = 30,
    spacing = 6,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
    showStealableBuffs = true,
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
}
