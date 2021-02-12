
-- oUF_SimpleConfig: player
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--[[local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent",function(self,event,name)
  self:UnregisterEvent(event)
  BuffFrame:UnregisterEvent("UNIT_AURA")
  local h = function(f) f.Show = f.Hide; f:Hide() end
  h(BuffFrame)
  h(TemporaryEnchantFrame)
end)]]

-----------------------------
-- Player Config
-----------------------------

L.C.player = {
  enabled = true,
  --size = {282,21},
  size = {314,24},
  point = {"TOP",UIParent,"CENTER",0,-264},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    debuffHighlight = true,
  },
  --powerbar
  powerbar = {
    enabled = true,
    height = 6,
    power = {
      enabled = true,
      point = {"TOP","BOTTOM",0,-3},
      size = 13,
      tag = "[oUF_Simple:power]",
      noshadow = true,
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  --[[castbar = {
    enabled = true,
    size = {386,6},
    point = {"TOP","BOTTOM",0,-49},
    backdrop = true,
    colorClass = true,
  },]]
  castbar = {
    enabled = true,
    size = {314,16},
    point = {"TOP","BOTTOM",13,-49},
    backdrop = true,
    colorClass = true,
    icon = {
      enabled = true,
      size = 16,
      point = {"BOTTOMRIGHT","BOTTOMLEFT",-6,0},
    },
  },
  --[[castbar = {
    enabled = true,
    size = {282,21},
    point = {"TOPRIGHT","BOTTOMRIGHT",0,-2},
    name = {
      enabled = true,
      align = "CENTER",
      noshadow = true,
      points = {
        {"LEFT",2,-0.5},
        {"RIGHT",0,-0.5},
      },
      size = 13,
    },
    icon = {
      enabled = true,
      size = 21,
      point = {"RIGHT","LEFT",0,0},
    },
  },]]
  --classbar
  gcdbar = {
    enabled = true,
    size = {314,6},
    point = {"BOTTOM","TOP",0,22},
  },
  classbar = {
    enabled = true,
    size = {314,6},
    point = {"BOTTOM","TOP",0,6},
  },
  --altpowerbar
  altpowerbar = {
    enabled = true,
    size = {314,6},
    point = {"TOP","BOTTOM",0,-87},
  },
  --addpowerbar (additional powerbar, like mana if a druid has rage display atm)
  addpowerbar = {
    enabled = true,
    size = {314,1},
    integrate = true,
    point = {"TOPRIGHT","TOPLEFT",-4,0},
    --orientation = "VERTICAL",
    colorPower = true,
  },
  debuffs = {
    enabled = true,
    point = {"TOPLEFT","BOTTOMLEFT",0,-6},
    num = 8,
    cols = 8,
    size = 34,
    spacing = 6,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DPWN",
    disableCooldown = true,
    --CustomFilter = CustomFilter,
  },
  --[[buffs = {
    enabled = true,
    --plebBuffs:SetPoint('TOP', UIParent, "TOP", 0, -39)
    --plebBuffs:SetPoint('RIGHT', Minimap, "Left", -20, 0)
    point = {"TOPRIGHT",Minimap,"TOPLEFT",-20,0},
    num = 30,
    cols = 10,
    size = 35,
    spacing = 6,
    initialAnchor = "TOPRIGHT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = true,
  },]]
}
