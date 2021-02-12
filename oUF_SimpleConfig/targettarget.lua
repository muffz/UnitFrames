
-- oUF_SimpleConfig: targettarget
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- TargetTarget Config
-----------------------------

local function CustomFilter(...)
  --icons, unit, icon, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
  return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

L.C.targettarget = {
  enabled = true,
  --size = {102,21},
  size = {114,24},
  --point = {"LEFT","oUF_SimpleTarget","RIGHT",20,0},
  point = {"RIGHT","oUF_SimplePlayer","LEFT",-20,0},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    name = {
      enabled = true,
      noshadow = true,
      points = {
        {"LEFT",1,-1},
        {"RIGHT",0,-1},
      },
      size = 13,
      align = "LEFT",
      tag = "[oUF_Simple:color][oUF_Simple:classification][name]",
    },
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    height = 6,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"TOPRIGHT","BOTTOMRIGHT",0,-6},
    num = 3,
    cols = 3,
    size = 34,
    spacing = 6,
    initialAnchor = "TOPRIGHT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = true,
    CustomFilter = CustomFilter,
  },
}