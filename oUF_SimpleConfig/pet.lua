
-- oUF_SimpleConfig: pet
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Pet Config
-----------------------------

L.C.pet = {
  enabled = true,
  --size = {66,24},
  size = {74,24},
  --point = {"RIGHT","oUF_SimpleTarget","LEFT",-20,0},
  point = {"RIGHT","oUF_SimpleTargetTarget","LEFT",-20,0},
  scale = 1*L.C.globalscale,
  --frameVisibility = "[@pet,noexists] hide; show",
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    frequentUpdates = false,
    name = {
      enabled = false,
      noshadow = true,
      points = {
        {"LEFT",1,0},
        {"RIGHT",-1,0},
      },
      size = 12,
      tag = "[name]",
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
  --altpowerbar (for vehicles)
  altpowerbar = {
    enabled = false,
    size = {130,5},
    point = {"BOTTOMLEFT","oUF_SimplePlayer","TOPLEFT",0,4},
    integrate = true,
  },
}
