
-- oUF_SimpleConfig: party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Party Config
-----------------------------

local SpellIDFilter = {
  [240559] = true, -- Grievous Wound
  -- Atal'Dazar
  [253239] = true, -- Dazar'ai Juggernaut - Merciless Assault
  [256846] = true, -- Dinomancer Kish'o - Deadeye Aim
  [257407] = true, -- Rezan - Pursuit
  
  -- Freehold
  [272402] = true, -- Cutwater Knife Juggler - Ricocheting Throw
  [257739] = true, -- Blacktooth Scrapper - Blind Rage
  [258338] = true, -- Captain Raoul - Blackout Barrel
  [256979] = true, -- Captain Eudora - Powder Shot
  
  -- Kings'Rest
  [270507] = true, --  Spectral Beastmaster - Poison Barrage
  [265773] = true, -- The Golden Serpent - Spit Gold
  [270506] = true, -- Spectral Beastmaster - Deadeye Shot
  
  -- Shrine of the Storm
  [264166] = true, -- Aqu'sirr - Undertow
  [268214] = true, -- Runecarver Sorn - Carve Flesh
  
  -- Siege of Boralus
  [257641] = true, -- Kul Tiran Marksman - Molten Slug
  [257036] = true, -- Dockhound Packmaster - Feral Charge
  [272662] = true, -- Irontide Raider - Iron Hook
  [256639] = true, -- Blacktar Bomber - Fire Bomb
  [272874] = true, -- Ashvane Commander - Trample
  [272581] = true, -- Bilge Rat Tempest - Water Spray
  [272528] = true, -- Ashvane Sniper - Shoot
  [272542] = true, -- Ashvane Sniper - Ricochet
  
  -- Temple of Sethraliss
  [268703] = true, -- Charged Dust Devil - Lightning Bolt
  [272670] = true, -- Sandswept Marksman - Shoot
  [267278] = true, -- Static-charged Dervish - Electrocute
  [272820] = true, -- Spark Channeler - Shock
  [274642] = true, -- Hoodoo Hexer - Lava Burst
  [268061] = true, -- Plague Doctor - Chain Lightning
  
  -- The Motherlode!!
  [268185] = true, -- Refreshment Vendor, Iced Spritzer
  [258674] = true, -- Off-Duty Laborer - Throw Wrench
  [276304] = true, -- Rowdy Reveler - Penny For Your Thoughts
  [263628] = true, -- Mechanized Peacekeeper - Charged Claw
  [263209] = true, -- Mine Rat - Throw Rock
  [268797] = true, -- Venture Co. Alchemist - Transmute: Enemy to Goo
  [263202] = true, -- Venture Co. Earthshaper - Rock Lance
  [262794] = true, -- Venture Co. Mastermind - Energy Lash
  [260669] = true, -- Rixxa Fluxflame - Propellant Blast
  
  -- The Underrot
  [265376] = true, -- Fanatical Headhunter - Barbed Spear
  [265084] = true, -- Devout Blood Priest - Blood Bolt
  [265625] = true, -- Befouled Spirit - Dark Omen
  [278961] = true, -- Diseased Lasher - Decaying Mind
  
  -- Tol Dagor
  [256039] = true, -- Overseer Korgus - Deadeye
  [185857] = true, -- Ashvane Spotter - Shoot
  
  -- Waycrest Manor
  [263891] = true, -- Heartsbane Vinetwister - Grasping Thorns
  [264510] = true, -- Crazed Marksman - Shoot
  [260699] = true, -- Coven Diviner - Soul Bolt
  [260551] = true, -- Soulbound Goliath - Soul Thorns
  [260741] = true, -- Heartsbane Triad - Jagged Nettles
  [268202] = true, -- Gorak Tul - Death Lens
}

local function CustomFilter(...)
  --icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
  local _,_, _, name, _, _, dispelType, _, _, _, _, _, spellID, _, isBossDebuff = ...
  local _, class = UnitClass("player")
  --print(class,dtype)
  --return L.C.dispelFilter[class] and L.C.dispelFilter[class][dtype]
  --print(name,spellID,SpellIDFilter[spellID])
  --if not SpellIDFilter[spellID] then return true else return false end
  --return isBossDebuff or (L.C.dispelFilter[class] and L.C.dispelFilter[class][dispelType]) or (caster and caster:match("(boss)%d?$") == "boss") or (nameplateShowAll and not casterIsPlayer)
   -- or not UnitPlayerControlled(caster)
    --or spellID == 265773
    --or spellID == 266231
  return isBossDebuff or (L.C.dispelFilter[class] and L.C.dispelFilter[class][dispelType]) or SpellIDFilter[spellID]
end

L.C.heal = {
  enabled = true,
  size = {71,52},
  --point = {"TOPLEFT",20,-20},
  point = {"BOTTOMLEFT","oUF_SimpleTarget","TOPLEFT",102,112},
  scale = 1*L.C.globalscale,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    range = true,
    name = {
      align = "CENTER",
      enabled = true,
      noshadow = true,
      points = {
        {"LEFT",2.5,0},
        {"RIGHT",-2,0},
      },
      size = 12,
      tag = "[oUF_Simple:leader][oUF_Simple:color][name][oUF_Simple:role]",
    },
  },
  --powerbar
  powerbar = {
    enabled = false,
    height = 5,
  },
  --raidmark 
  readycheck = {
    enabled = true,
    size = {16,16},
    point = {"RIGHT","RIGHT",0,-3},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"BOTTOMRIGHT","BOTTOMRIGHT",-3,3},
    num = 3,
    cols = 3,
    size = 22,
    spacing = 1,
    initialAnchor = "BOTTOMRIGHT",
    growthX = "LEFT",
    growthY = "DOWN",
    disableCooldown = true,
    disableMouse = true,
    CustomFilter = CustomFilter,
  },
  aurawatch = {
    size = 14,
    indicators = {
      PRIEST = {
        {6788, 'TOPLEFT', {2, -2}, {150/255, 0, 0}, true}, -- Weakened Soul
        {17, 'TOPLEFT', {2, -2}, {230/255, 170/255, 125/255}}, -- Power Word: Shield
        {139, 'TOPLEFT', {15, -2}, {0, 170/255, 0}}, -- Renew
        {152118, 'TOPLEFT', {15, -2}, {240/255, 240/255, 140/255}}, -- Clarity of Will
      },
      MONK = {
        {115175, 'TOPLEFT', {0, 0}, {76/255, 175/255, 80/255}}, -- Soothing Mist
        {119611, 'TOPRIGHT', {0, 0}, {76/255, 175/255, 80/255}}, -- Renewing Mist
        {124682, 'TOP', {0.5, 0}, {205/255, 220/255, 57/255}}, -- Enveloping Mist
      },
      PALADIN = {
        {53563, 'TOPLEFT', {2, -2}, {46/255, 97/255, 149/255}}, -- Beacon of Light
        {156910, 'TOPLEFT', {2, -2}, {126/255, 45/255, 90/255}}, -- Beavon of Faith
        {1022, 'TOPLEFT', {15, -2}, {158/255, 158/255, 158/255}}, -- Hand of Protection
        {6940, 'TOPLEFT', {15, -2}, {139/255, 16/255, 16/255}}, -- Hand of Sacrifice
        {1044, 'TOPLEFT', {15, -2}, {239/255, 108/255, 41/255}}, -- Hand of Freedom
        {287280, 'BOTTOMLEFT', {2, 2}, {239/255, 108/255, 41/255}}, -- Hand of Freedom
      },
      DRUID = {
        {33763, 'TOPLEFT', {0, 0}, {0/255, 150/255, 136/255}}, --Lifebloom
        {774, 'TOPRIGHT', {-13, 0}, {103/255, 58/255, 183/255}}, --Rejuvenation
        {155777, 'TOPRIGHT', {0, -13}, {233/255, 30/255, 99/255}}, --Germination
        {8936, 'TOPRIGHT', {0, 0}, {76/255, 175/255, 80/255}}, --Regrowth
        --{48438, 'TOPRIGHT', {0, -11}, {205/255, 220/255, 57/255}}, --Wild Growth
      },
      ALL = {
      },
    },
  },
  setup = {
    template = nil,
    visibility = "custom [nogroup:raid] show; hide",
    --visibility = "show",
    showPlayer = true,
    showSolo = true,
    showParty = true,
    showRaid = false,
    point = "BOTTOM",
    xOffset = 0,
    yOffset = 6,
  },
}