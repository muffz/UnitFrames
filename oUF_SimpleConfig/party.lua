
-- oUF_SimpleConfig: party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Party Config
-----------------------------

local function CustomFilter(...)
  --icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _, _, _, _, _, _, dispelType = ...
  local _, class = UnitClass("player")
  --print(class,dtype)
  return L.C.dispelFilter[class] and L.C.dispelFilter[class][dispelType]
end

L.C.party = {
  enabled = true,
  size = {154,24},
  --size = {120,24},
  --point = {"TOPLEFT",20,-20},
  point = {"BOTTOMLEFT","oUF_SimplePlayer","BOTTOMLEFT",-533,0},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
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
  setup = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = true,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "BOTTOM",
    xOffset = 0,
    yOffset = 6,
  },
}
