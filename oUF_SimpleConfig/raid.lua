
-- oUF_SimpleConfig: raid
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Raid Config
-----------------------------

local function CustomFilter(...)
  --icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, dispelType = ...
  local _, class = UnitClass("player")
  --print(class,dtype)
  return L.C.dispelFilter[class] and L.C.dispelFilter[class][dispelType]
end

L.C.raid = {
  enabled = true,
  size = {102,21},
  points = { --list of 8 points, one for each raid group
    {"TOPLEFT",27,-147},
    {"TOP", "oUF_SimpleRaidHeader1", "BOTTOM", 0, -20},
    {"TOP", "oUF_SimpleRaidHeader2", "BOTTOM", 0, -20},
    {"TOP", "oUF_SimpleRaidHeader3", "BOTTOM", 0, -20},
    {"TOPLEFT", "oUF_SimpleRaidHeader1", "TOPRIGHT", 20, 0},
    {"TOP", "oUF_SimpleRaidHeader5", "BOTTOM", 0, -20},
    {"TOP", "oUF_SimpleRaidHeader6", "BOTTOM", 0, -20},
    {"TOP", "oUF_SimpleRaidHeader7", "BOTTOM", 0, -20},
  },
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = true,
    colorThreat = true,
    range = true,
    name = {
      enabled = true,
      noshadow = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 12,
      tag = "[oUF_Simple:leader][oUF_Simple:color][name][oUF_Simple:role]",
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
    readycheck = {
    enabled = true,
    size = {16,16},
    point = {"RIGHT","RIGHT",0,-3},
  },
  setup = {
    template = nil,
    visibility = "custom [group:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = false,
    showRaid = true,
    point = "TOP",
    xOffset = 0,
    yOffset = -5,
  },
    --debuffs
  debuffs = {
    enabled = true,
    point = {"LEFT","RIGHT",6,0},
    num = 1,
    cols = 1,
    size = 27,
    spacing = 6,
    initialAnchor = "LEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
    CustomFilter = CustomFilter,
  },
}