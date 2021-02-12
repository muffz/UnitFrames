
-- oUF_SimpleConfig: global
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Global Config
-----------------------------

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"

L.C.globalscale = 1

--print("ouf_SimepleConfig:","UI scale",UIParent:GetScale(),"L.C.globalscale",L.C.globalscale)

--textures
L.C.textures = {
  statusbar = L.C.mediapath.."statusbar",  
  absorb = L.C.mediapath.."absorb",
  aura = L.C.mediapath.."square",
  split = L.C.mediapath.."split",
  backdrop = L.C.mediapath.."backdrop",--"Interface\\ChatFrame\\ChatFrameBackground",
  --gradient = L.C.mediapath.."gradient",--"Interface\\ChatFrame\\ChatFrameBackground",
}

--backdrop
L.C.backdrop = {
  bgFile = L.C.textures.backdrop,
  bgColor = {0,0,0,0},
  edgeFile = L.C.textures.backdrop,
  edgeColor = {0,0,0,0.7},
  edgeSize = 2,
  inset = 2,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },
}

--colors
L.C.colors = {}
L.C.colors.reaction = {
  [1] = {0.72,0.11,0.11},
  [2] = {0.72,0.11,0.11},
  [3] = {0.72,0.11,0.11},
  [4] = {1,0.84,0},
  [5] = {0.2,0.41,0.12},--{0.11,0.37,0.13},
  [6] = {0.2,0.41,0.12},--{0.11,0.37,0.13},
  [7] = {0.2,0.41,0.12},--{0.11,0.37,0.13},
  [8] = {0.2,0.41,0.12},--{0.11,0.37,0.13},
}
L.C.colors.reactionComplementary = {
  [1] = {0.11,0.72,0.72},
  [2] = {0.11,0.72,0.72},
  [3] = {0.11,0.72,0.72},
  [4] = {0,0.17,1},
  [5] = {0.37,0.11,0.35},
  [6] = {0.37,0.11,0.35},
  [7] = {0.37,0.11,0.35},
  [8] = {0.37,0.11,0.35},
}
L.C.colors.class = {
  ["DEATHKNIGHT"] = {r = 0.77, g = 0.12, b = 0.23},
  ["DEMONHUNTER"] = {r = 0.64, g = 0.19, b = 0.79},
  ["DRUID"] = {r = 1, g = 0.49, b = 0.04},
  ["HUNTER"] = {r = 0.67, g = 0.83, b = 0.45},
  ["MAGE"] = {r = 0.25, g = 0.78, b = 0.92},
  ["MONK"] = {r = 0, g = 1 , b = 0.59},
  ["PALADIN"] = {r = 0.96, g = 0.55, b = 0.73},
  ["PRIEST"] = {r = 1, g = 1, b = 1},
  ["ROGUE"] = {r = 1, g = 0.96, b = 0.41},
  --["SHAMAN"] = {r = 0, g = 0.44, b = 0.87},
  ["SHAMAN"] = {r = 0, g = 191/255, b = 165/255},
  ["WARLOCK"] = {r = 0.53, g = 0.53, b = 0.93},
  ["WARRIOR"] = {r = 0.78, g = 0.61, b = 0.43},
}
L.C.colors.classComplementary = {
  ["DEATHKNIGHT"] = {r = 0.12, g = 0.77, b = 0.66},
  ["DEMONHUNTER"] = {r = 0.34, g = 0.79, b = 0.19},
  ["DRUID"] = {r = 0.04, g = 0.55, b = 1},
  ["HUNTER"] = {r = 0.61, g = 0.45, b = 0.83},
  ["MAGE"] = {r = 0.92, g = 0.4, b = 0.25},
  ["MONK"] = {r = 1, g =  0, b = 0.42},
  ["PALADIN"] = {r = 0.55, g =  0.96, b = 0.78},
  ["PRIEST"] = {r = 1, g =  1, b = 1},
  --["PRIEST"] = {r = 0, g =  0, b = 0},
  ["ROGUE"] = {r = 0.41, g =  0.45, b = 1},
  ["SHAMAN"] = {r = 0.87, g =  0.44, b = 0},
  ["WARLOCK"] = {r = 0.93, g =  0.93, b = 0.53},
  ["WARRIOR"] = {r = 0.42, g =  0.6, b = 0.78},

}
--colors bgMultiplier
L.C.colors.bgMultiplier = 0
--colors castbar
L.C.colors.castbar = {
  default = {1,0.6,0},
  --defaultBG = {0,0,0,0.7},
  defaultBG = {0.0,0.0,0.0,0.7},
  --defaultBG = {0.15,0.2,0.22,0.7},
  shielded = {0.7,0.7,0.7},
  shieldedBG = {0.33,0.43,0.48,0.7},
  --shieldedBG = {0.15,0.2,0.22,0.7},
}
--colors healthbar
L.C.colors.healthbar = {
  --default = {0,1,0},
  --defaultBG = {0*L.C.colors.bgMultiplier,1*L.C.colors.bgMultiplier,0},
  threat = {1,0,0},
  threatBG = {1*L.C.colors.bgMultiplier,0,0},
  threatInvers = {0,1,0},
  threatInversBG = {0,1*L.C.colors.bgMultiplier,0},
  --absorb = {0.012,0.663,0.957,0.5},
  absorb = {0.502,0.847,1,0.7},
  --absorb = {0.6,0.9,1,0.7},
  --absorb = {0.57,0.57,0.57,0.7},
}
--fix way to dark mana color
L.C.colors.power = {
  mana = {0.1, 0.2, 1}
}

L.C.dispelFilter = {
  PRIEST = { Magic = true, Disease = true, },
  SHAMAN = { Magic = true, Curse = true, },
  PALADIN = { Magic = true, Poison = true, Disease = true, },
  MONK = { Magic = true, Poison = true, Disease = true, },
  MAGE = { Curse = true, },
  DRUID = { Magic = true, Curse = true, Poison = true, },
}

L.C.importantCasts = {
  --[157534] = {0.67, 0, 1}, --TEST
  [334664] = {0.67, 0, 1}, --DoS: Frightened Cries
  [320462] = {0.67, 0, 1}, --NW: Necrotic Bolt
  [322493] = {0.67, 0, 1}, --NW: Frostbolt Volley
  [322493] = {0.67, 0, 1}, --NW: Frostbolt Volley
  --ToP
  [330868] = {0.67, 0, 1}, --Necrotic Volley
  [241969] = {0.67, 0, 1}, --Withering Discharge


  [253544] = {0.67, 0, 1}, --AD: Bwonsamdi's Mantle
  [253562] = {0.67, 0, 1}, --AD: Wildfire
  [253583] = {0.67, 0, 1}, --AD: Fiery Enchant
  [274569] = {0.67, 0, 1}, --SoB: Revitalizing Mist
  [269972] = {0.67, 0, 1}, --KR: Shadow Bolt Volley
}

L.C.importantMobs = {
  ["Irontide Enforcer"] = {0.78, 0.61, 0.43},
  ["Iron-Willed Enforcer"] = {0.78, 0.61, 0.43},
  
  ["Explosives"] = {0.67, 0, 1},

  ["Dutiful Attendant"] = {0.67, 0, 1},
  ["Begrudging Waiter"] = {0.5 , 0.85, 1},

  ["Shade of Bargast"] = {0.5 , 0.85, 1}, --Shades of Barghast
  -- ["Spiteful Shade"] = {0.5 , 0.85, 1}, --SL
  ["Soul Infuser"] = {0.5 , 0.85, 1}, --Sun King
  


  --["Training Dummy"] = {0.5 , 0.85, 1},
}

L.C.pandemicDebuffs = {
  [1943] = true, --Rupture
  [703] = true, --Garotte
}

L.C.desaturateAuras = {
  --[2818] = true, --Deadly Poison
  --[3409] = true, --Crippling Poison

}

--  https://www.twitch.tv/videos/569835196?t=2h9m15s