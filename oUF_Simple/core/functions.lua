
-- oUF_Simple: core/functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
--functions container
L.F = {}

local floor, unpack = floor, unpack

-----------------------------
-- Functions
-----------------------------

local hider = CreateFrame("Frame", "UIHider", UIParent)
hider:Hide()

local function WA_GetUnitAura(unit, spell, filter)
  for i = 1, 255 do
    local name, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, filter)
    if not name then return end
    if spell == spellId or spell == name then
      return UnitAura(unit, i, filter)
    end
  end
end

if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
  CompactRaidFrameManager:SetParent(UIHider)
  CompactUnitFrameProfiles:UnregisterAllEvents()
end

--NumberFormat
local function NumberFormat(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end
L.F.NumberFormat = NumberFormat

--CalcFrameSize
local function CalcFrameSize(numButtons,numCols,buttonWidth,buttonHeight,buttonMargin,framePadding)
  local numRows = ceil(numButtons/numCols)
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*buttonMargin + 2*framePadding
  return frameWidth, frameHeight
end

--SetPoint
local function SetPoint(self,relativeTo,point)
  --adjut the setpoint function to make it possible to reference a relativeTo object that is set on runtime and it not available on config init
  local a,b,c,d,e = unpack(point)
  if not b then
    self:SetPoint(a)
  elseif b and type(b) == "string" and not _G[b] then
    self:SetPoint(a,relativeTo,b,c,d)
  else
    self:SetPoint(a,b,c,d,e)
  end
end

--SetPoints
local function SetPoints(self,relativeTo,points)
  for i, point in next, points do
    SetPoint(self,relativeTo,point)
  end
end

--CreateBackdrop
local function CreateBackdrop(self,relativeTo)
  local backdrop = L.C.backdrop
  local bd = CreateFrame("Frame", nil, self, "BackdropTemplate")
  bd:SetFrameLevel(self:GetFrameLevel()-1 or 0)
  bd:SetPoint("TOPLEFT", relativeTo or self, "TOPLEFT", -backdrop.inset, backdrop.inset)
  bd:SetPoint("BOTTOMRIGHT", relativeTo or self, "BOTTOMRIGHT", backdrop.inset, -backdrop.inset)
  bd:SetBackdrop(backdrop)
  bd:SetBackdropColor(unpack(backdrop.bgColor))
  bd:SetBackdropBorderColor(unpack(backdrop.edgeColor))
  return bd
end
L.F.CreateBackdrop = CreateBackdrop

--CreateGlow
local function CreateGlow(self)
  f = CreateFrame("Frame", nil, self, "BackdropTemplate")
  f:SetPoint("BOTTOM",self,"TOP",0,4)
  f:SetSize(self:GetWidth()-2, 2)
  f:SetBackdrop({
    bgFile = L.C.textures.backdrop,
    edgeFile = L.C.textures.backdrop,
    edgeSize = 1,
    inset = 1,
    insets = {
      left = -1,
      right = -1,
      top = -1,
      bottom = -1,
    },
  })
  f:SetBackdropColor(0, 0, 0, .7)
  f:SetBackdropBorderColor(1, 1, 1, .7)
  f:Hide()

  return f
end
L.F.CreateGlow = CreateGlow

--CreateIcon
local function CreateIcon(self,layer,sublevel,size,point)
  local icon = self:CreateTexture(nil,layer,nil,sublevel)
  icon:SetSize(unpack(size))
  SetPoint(icon,self,point)
  return icon
end

local function ColorHealthbarOnThreat(self,unit)
  if self.colorThreat and self.colorThreatInvers and unit and UnitThreatSituation("player", unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threatInvers))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatInversBG))
  elseif self.colorThreat and unit and UnitThreatSituation(unit) == 3 then
    self:SetStatusBarColor(unpack(L.C.colors.healthbar.threat))
    self.bg:SetVertexColor(unpack(L.C.colors.healthbar.threatBG))
  end
end

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Health
-------------------------------------------------------------------------------------------------------------------------------------------------
local function Health_PostUpdate(health, unit, cur, max)
  local self = health:GetParent()
  local power = self.Power
  local r,g,b

  if UnitIsFriend("player", unit) then
    health:SetReverseFill(true)
    health:SetValue(max-cur)

    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
      health:SetValue(0)
    end
  else
    health:SetReverseFill(false)
    health:SetValue(cur)
  end

  if self.settings.template == "nameplate" then
    if UnitClassification(unit) == "minus" then
      self:SetHeight(4)
    else
      self:SetHeight(6)
    end
  end
end

local function Health_PostUpdateColor(element, unit, r, g, b)
  local self = element:GetParent()
  if(not unit or self.unit ~= unit) then return end

  local _,class = UnitClass(unit)
  local t,bg = {},{}

  if UnitIsFriend("player", unit) then
    t = {0.9,0.13,0.09}
    bg = {0,0,0}

    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
      bg = {0.57,0.57,0.57}
    end
  else
    -- debug
    -- if UnitName(unit) == "Thunderlord Trapper" and UnitGUID(unit.."target") == UnitGUID("player") then
    if UnitName(unit) == "Spiteful Shade" and UnitGUID(unit.."target") == UnitGUID("player") then
      t = {0.5,0.85,1,1}
    elseif L.C.importantMobs[UnitName(unit)] then
      t = {L.C.importantMobs[UnitName(unit)][1],L.C.importantMobs[UnitName(unit)][2],L.C.importantMobs[UnitName(unit)][3]}
    elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
      t = {0.57,0.57,0.57}
    elseif UnitIsPlayer(unit) then
      t = {RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b}
    else
      if not UnitAffectingCombat(unit) then
        t = {unpack(L.C.colors.reaction[UnitReaction(unit, "player") or 5])}
      else
        t = {0.72,0.11,0.11}
      end
    end
  end

  element:SetStatusBarColor(t[1],t[2],t[3],t[4] and t[4] or 1)
  element.bg:SetVertexColor(bg[1],bg[2],bg[3],bg[4] and bg[4] or 0.7)
end

local function CreateHealthBar(self)
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar, "MEDIUM", -8)
  
  if not self.cfg.powerbar or not self.cfg.powerbar.enabled then 
    s:SetAllPoints()
  else
    s:SetPoint("BOTTOM")
    s:SetPoint("LEFT")
    s:SetPoint("RIGHT")
    s:SetHeight(self:GetHeight()-self.cfg.powerbar.height-1)---self.cfg.powerbar.gap)
  end
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.backdrop)
  bg:SetVertexColor(0,0,0,0.7)
  bg:SetAllPoints()
  s.bg = bg

  s.colorThreat = true --UNIT_THREAT_LIST_UPDATE
  s.colorHealth = true
  s.colorDisconnected = true --UNIT_CONNECTION = true
  s.colorTapping = true --UNIT_FACTION = true
  s.PostUpdate = Health_PostUpdate
  s.PostUpdateColor = Health_PostUpdateColor

  -- self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Health_PostUpdateColor)
  -- table.insert(self.__elements, Health_PostUpdateColor)

  if self.cfg.healthbar.range then
    self.Range = {
      insideAlpha = 1,
      outsideAlpha = 0.3,
    }
  end
  return s
end
L.F.CreateHealthBar = CreateHealthBar
-------------------------------------------------------------------------------------------------------------------------------------------------
-- HealthPrediction
-------------------------------------------------------------------------------------------------------------------------------------------------
local function HealthPrediction_PostUpdate(self, unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
  local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
  local absorb = UnitGetTotalAbsorbs(unit) or 0

  self:SetMinMaxValues(0, maxHealth)
  self:SetValue(absorb)
end

local function HealthPrediction(self)
  local bars = { "myBar", "otherBar", "absorbBar", "healAbsorbBar" }
  -- local s = CreateFrame("Frame")
  local s = CreateFrame("StatusBar", nil, self.Health)
  s:SetFrameLevel(self.Health:GetFrameLevel())
  s:SetStatusBarTexture(L.C.textures.statusbar, "MEDIUM", -7)
  s:SetStatusBarColor(unpack(L.C.colors.healthbar.absorb))
  -- s:SetAllPoints()
  s:SetPoint("LEFT")
  s:SetPoint("RIGHT")
  s:SetPoint("BOTTOM")
  s:SetHeight(6)

  --[[for _, name in ipairs(bars) do
    local bar = CreateFrame("StatusBar", nil, self.Health)
    bar:SetFrameLevel(self.Health:GetFrameLevel())
    bar:SetStatusBarTexture(L.C.textures.statusbar, "MEDIUM", -7)
    bar:SetStatusBarColor(unpack(L.C.colors.healthbar.absorb))
    -- bar:SetAllPoints()
    bar:SetPoint('TOP')
    bar:SetPoint('BOTTOM')
    bar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "LEFT", 0, 0)
    s[name] = bar
  end--]]

  s.maxOverflow = 1
  s.PostUpdate = HealthPrediction_PostUpdate

  return s
end
L.F.HealthPrediction = HealthPrediction

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Power
-------------------------------------------------------------------------------------------------------------------------------------------------

--PostUpdatePower
local function PostUpdatePower(power, unit, cur, min, max)
  local self = power:GetParent()
  local health = self.Health
  local _, class = UnitClass(unit)
  --local powerType = UnitPowerType(unit)
    local cid = select(3,UnitClass(unit))
    local ptype = UnitPowerType(unit)
    local maxpp = UnitPowerMax(unit, ptype)

  --if unit == "target" then print(unit:find("boss%d"),UnitClassification(unit),cur,min,max,displayType) end
  --print(displayType,max)
  if not UnitIsPlayer(unit) then
    power:Show()
    health:SetHeight(self:GetHeight()-self.cfg.powerbar.height-1)
    power:SetStatusBarColor(RAID_CLASS_COLORS["MAGE"].r,RAID_CLASS_COLORS["MAGE"].g,RAID_CLASS_COLORS["MAGE"].b)
  elseif self.settings.template == "player" or self.settings.template == "pet" then
    power:Show()
    if self.settings.template == "player" and self.cfg.addpowerbar.integrate and self.AdditionalPower:IsShown() then
      health:SetHeight(self:GetHeight()-self.cfg.powerbar.height-3)
    else
      health:SetHeight(self:GetHeight()-self.cfg.powerbar.height-1)
    end
    local _, class = UnitClass("player")
    --power:SetStatusBarColor(L.C.colors.class[class].r,L.C.colors.class[class].g,L.C.colors.class[class].b)
    power:SetStatusBarColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b)

  --elseif not UnitIsPlayer(unit) and max > 0
  --or powerType == 0 and max == 100000 and not UnitIsDead(unit) and not UnitIsGhost(unit) and class ~= "MAGE" and class ~= "WARLOCK" then
  --or not UnitIsDead(unit) and not UnitIsGhost(unit) 
    --and (class == "DRUID" and UnitPowerMax(unit, 0) == 100000 
    --or (class == "PRIEST" or class == "MONK" or class == "SHAMAN") and UnitPowerMax(unit, powerType) == 100000) then
  --or class == "DRUID" and UnitPowerMax(unit, 0) == 100000
  --or UnitPowerMax(unit, powerType) == 100000 and not UnitIsDead(unit) and not UnitIsGhost(unit) and class ~= "MAGE" and class ~= "WARLOCK" and class ~= "DRUID" then
    --print(unit) unit is boss? 

  elseif UnitIsPlayer(unit) and ptype == 0 and maxpp >= 50000 and cid ~= 8 and cid ~= 9 and not UnitIsDead(unit) and not UnitIsGhost(unit) then


    power:Show()
    health:SetHeight(self:GetHeight()-self.cfg.powerbar.height-1)

    if UnitIsFriend("player", unit) then
      --if class then power:SetStatusBarColor(L.C.colors.class[class].r,L.C.colors.class[class].g,L.C.colors.class[class].b) else power:SetStatusBarColor(1,1,1) end
      --if class then power:SetStatusBarColor(L.C.colors.class[class].r,L.C.colors.class[class].g,L.C.colors.class[class].b) else power:SetStatusBarColor(1,1,1) end
      power:SetStatusBarColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b)
    else
      power:SetStatusBarColor(0,0.8,1)
    end
  else
    power:Hide()
    health:SetHeight(self:GetHeight())
  end
end



--UpdateThreat
local function UpdateThreat(self,event,unit)
  if event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT" then
    --do natting
  elseif self.unit ~= unit then
    return
  end
  self.Health:ForceUpdate()
end
L.F.UpdateThreat = UpdateThreat

--CreateText
local function CreateText(self,font,size,outline,align,noshadow)
  local text = self:CreateFontString(nil, "ARTWORK") --"BORDER", "OVERLAY"
  --text:SetFont(font or STANDARD_TEXT_FONT, size or 12, outline or "OUTLINE")
  text:SetFont(L.C.mediapath.."font.ttf", size or 12, outline or "OUTLINE")
  text:SetJustifyH(align or "LEFT")
  if not noshadow then
    text:SetShadowColor(0,0,0,0.6)
    text:SetShadowOffset(1,-1)
  end
  --fix some wierd bug
  text:SetText("Bugfix")
  text:SetMaxLines(1)
  text:SetHeight(text:GetStringHeight())
  return text
end
L.F.CreateText = CreateText

--AltPowerBarOverride
local function AltPowerBarPostUpdate(self, unit, cur, min, max)
  if UnitPowerBarID(unit) == 0 then return end
  local _, class = UnitClass(unit)
  self:SetStatusBarColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b)
  self.bg:SetVertexColor(0, 0, 0, 1)

  self:SetMinMaxValues(min, max)
  self:SetValue(cur)
end

--CreateAltPowerBar
local function CreateAltPowerBar(self)
  if not self.cfg.altpowerbar or not self.cfg.altpowerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(unpack(self.cfg.altpowerbar.size))
  s:SetOrientation(self.cfg.altpowerbar.orientation or "HORIZONTAL")
  SetPoint(s,self,self.cfg.altpowerbar.point)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.statusbar)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  CreateBackdrop(s)
  --attributes
  --s.colorClass = true
  s.PostUpdate = AltPowerBarPostUpdate
  --s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateAltPowerBar = CreateAltPowerBar



--[[local function ClassPowerPreUpdate(element, event)
  print(element, event)
  local _, _, classID = UnitClass("player")
  if classID ~= 4 then return end

  local max = UnitPowerMax("player", 4)
  local specID = GetSpecialization()
  local color = element.__owner.colors.power[powerType]
  local r, g, b = color[1], color[2], color[3]

  for index = 1, max do
    if classID == 4 and specID == 2 then
      local cp = WA_GetUnitAura("player", GetSpellInfo(193356))

      if cp and cur >= 4 then
        element[index]:SetStatusBarColor(1,0,0)
      elseif not cp and cur == 5 then
        element[index]:SetStatusBarColor(1,0,0)
      else
        element[index]:SetStatusBarColor(r,g,b)
      end
    end
  end
end]]

-----------------------------
-- ClassPower
-----------------------------

  local function ClassPowerPostUpdate(element, cur, max, hasMaxChanged, powerType)
    local ClassBar = element[1]:GetParent()
    if not max or cur == 0 then ClassBar:Hide() else ClassBar:Show() end

    local _, _, classID = UnitClass("player")
    if classID == 4 then
      local specID = GetSpecialization()
      local color = element.__owner.colors.power[powerType]
      local r, g, b = color[1], color[2], color[3]
      if specID == 2 and max and max >= 1 then
        for index = 1, max do
          local cp = WA_GetUnitAura("player", GetSpellInfo(193356))
          if cp and cur >= max-1 then
            element[index]:SetStatusBarColor(1,0,0)
          elseif not cp and cur == max then
            element[index]:SetStatusBarColor(1,0,0)
          else
            element[index]:SetStatusBarColor(r,g,b)
          end
        end
      end
    end

    if not hasMaxChanged then return end
    local width = (ClassBar:GetWidth()-1*(max-1))/max
    width = math.ceil(width)

    for index = 1, max do
      element[index]:ClearAllPoints()
      element[index]:SetWidth(width)

      if index == 1 then
        element[index]:SetPoint('LEFT', ClassBar, 'LEFT', 0, 0)
      elseif index == max then
        element[index]:SetPoint('LEFT', element[index-1], 'RIGHT', 1, 0)
        element[index]:SetPoint('RIGHT', ClassBar, 'RIGHT', 0, 0)
      else
        element[index]:SetPoint('LEFT', element[index-1], 'RIGHT', 1, 0)
      end
    end
  end
  L.F.ClassPowerPostUpdate = ClassPowerPostUpdate

  local function CreateClassBar(self)
    if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
    local s = {}
    --statusbar
    local ClassBar = CreateFrame("Frame", nil, self)
    ClassBar:SetSize(unpack(self.cfg.classbar.size))
    SetPoint(ClassBar,self,self.cfg.classbar.point)
    L.F.CreateBackdrop(ClassBar)
    --bg
    local bg = ClassBar:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(L.C.textures.backdrop)
    bg:SetVertexColor(0,0,0,0.7)
    bg:SetAllPoints()
    --points
    for index = 1, 10 do
      local Icon = CreateFrame("StatusBar", nil, ClassBar)
      Icon:SetStatusBarTexture(L.C.textures.statusbar)
      Icon:SetHeight(select(2,unpack(self.cfg.classbar.size)))

      s[index] = Icon
    end
    --hook
    --s.PreUpdate = ClassPowerPreUpdate
    s.PostUpdate = ClassPowerPostUpdate
    s.ClassPower = ClassPower

    return s
  end
  L.F.CreateClassBar = CreateClassBar

  local function CreateRuneBar(self)
    if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
    local s = {}
    --statusbar
    local ClassBar = CreateFrame("Frame", nil, self)
    ClassBar:SetSize(unpack(self.cfg.classbar.size))
    SetPoint(ClassBar,self,self.cfg.classbar.point)
    L.F.CreateBackdrop(ClassBar)
    --bg
    local bg = ClassBar:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(L.C.textures.backdrop)
    bg:SetVertexColor(0,0,0,1)
    bg:SetAllPoints()

    local width = (ClassBar:GetWidth()-5.1)/6
    
    --points
    for index = 1, 6 do
      local Icon = CreateFrame("StatusBar", nil, ClassBar)
      Icon:SetStatusBarTexture(L.C.textures.statusbar)
      Icon:SetHeight(select(2,unpack(self.cfg.classbar.size)))
      Icon:SetWidth(width)
      Icon:SetPoint('LEFT', ClassBar, 'LEFT', (index - 1) * (width + 1), 0)

      s[index] = Icon
    end

    s.colorSpec = true
    s.sortOrder = 'asc'
    --hook
    s.Runes = Runes

    return s
  end
  L.F.CreateRuneBar = CreateRuneBar

  local function StaggerPostUpdate(element,cur,max)
    if not max or cur == 0 then element:Hide() else element:Show() end
  end

  local function CreateStaggerBar(self)
    if not self.cfg.classbar or not self.cfg.classbar.enabled then return end
    local s = {}
    --statusbar
    local Stagger = CreateFrame("StatusBar", nil, self)
    Stagger:SetStatusBarTexture(L.C.textures.backdrop)
    Stagger:SetStatusBarColor(0,0,0,0)
    Stagger:SetSize(unpack(self.cfg.classbar.size))
    SetPoint(Stagger,self,self.cfg.classbar.point)
    L.F.CreateBackdrop(Stagger)
    --bg
    local bg = Stagger:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(L.C.textures.backdrop)
    bg:SetVertexColor(0,0,0,1)
    bg:SetAllPoints()

    --hook
    s = Stagger
    s.PostUpdate = StaggerPostUpdate
    
    return s
  end
  L.F.CreateStaggerBar = CreateStaggerBar

--CreatePowerBar
local function CreatePowerBar(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetSize(self:GetWidth(), self.cfg.powerbar.height)
  s:SetPoint("TOP")
  --s:SetStatusBarColor(0.9,0.8,0.5)
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.backdrop)
  bg:SetVertexColor(0,0,0,1)
  bg:SetAllPoints()
  bg.multiplier = 0
  s.bg = bg
  --sep
  s.sep = s:CreateTexture(nil, "BACKGROUND")
  s.sep:SetHeight(1)
  s.sep:SetPoint("TOPLEFT", s, "BOTTOMLEFT", 0, 0)
  s.sep:SetPoint("TOPRIGHT", s, "BOTTOMRIGHT", 0, 0)
  s.sep:SetTexture(L.C.textures.backdrop)
  s.sep:SetVertexColor(0,0,0,0.7)
  --attributes
  s.frequentUpdates = true
  --hooks
  s.PostUpdate = PostUpdatePower
  return s
end
L.F.CreatePowerBar = CreatePowerBar

--CreateAdditionalPowerBar
local function CreateAdditionalPowerBar(self)
  if not self.cfg.addpowerbar or not self.cfg.addpowerbar.enabled then return end
  --print(self.unit,self.settings.template,"CreateAdditionalPowerBar")
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetStatusBarColor(0,0.8,1)
  s:SetSize(unpack(self.cfg.addpowerbar.size))
  s:SetOrientation(self.cfg.addpowerbar.orientation or "HORIZONTAL")
  if self.cfg.addpowerbar.integrate then
    s:SetPoint("TOP",self.Power,"BOTTOM",0,-1)

    s.sep = s:CreateTexture(nil, "BACKGROUND")
    s.sep:SetHeight(1)
    s.sep:SetPoint("TOPLEFT", s, "BOTTOMLEFT", 0, 0)
    s.sep:SetPoint("TOPRIGHT", s, "BOTTOMRIGHT", 0, 0)
    s.sep:SetTexture(L.C.textures.backdrop)
    s.sep:SetVertexColor(0,0,0,0.7)  
  else
    SetPoint(s,self,self.cfg.addpowerbar.point)
  end
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND")
  bg:SetTexture(L.C.textures.backdrop)
  bg:SetVertexColor(0,0,0,0.7)
  bg:SetAllPoints()
  s.bg = bg
  --backdrop
  --CreateBackdrop(s)
  --attributes
  --s.colorPower = self.cfg.addpowerbar.colorPower
  --s.bg.multiplier = L.C.colors.bgMultiplier
  return s
end
L.F.CreateAdditionalPowerBar = CreateAdditionalPowerBar

-----------------------------
-- GCD
-----------------------------

local function CreateGCDBar(self)
  if true then return end
  if not self.cfg.gcdbar or not self.cfg.gcdbar.enabled then return end
  local s = CreateFrame("StatusBar", nil, self)
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetStatusBarColor(1,1,1,0.7)
  s:SetSize(self:GetWidth(), 2)
  --s:SetPoint("TOP",0,100)
  SetPoint(s,self,self.cfg.gcdbar.point)
   
  s:Hide()

  local start,duration,enabled,modRate = GetSpellCooldown(61304)

  local timeElapsed = 0
  local function onUpdate(self, elapsed)
    timeElapsed = timeElapsed + elapsed
    if (timeElapsed > 0.2) then
      if start+duration-GetTime() > 0 then
        s:SetValue(start+duration-GetTime())
      else
        s:Hide()
        self:SetScript("OnUpdate", nil)
      end
    end
  end
  
  s:RegisterEvent("SPELL_UPDATE_COOLDOWN")
  s:SetScript("OnEvent", function(self, event)
    start, duration, enabled, modRate = GetSpellCooldown(61304)
    s:SetMinMaxValues(0,duration)
    if duration > 0 then
      s:SetScript("OnUpdate", onUpdate)
      s:Show()  
    end
  end)

  return s
end
L.F.CreateGCDBar = CreateGCDBar

-----------------------------
-- Castbar
-----------------------------

-- local castHolder = {}

local function Cast_CheckInterruptible(self, unit)
  if self.notInterruptible then
    self:SetStatusBarColor(unpack(L.C.colors.castbar.shielded))
  else
    self:SetStatusBarColor(unpack(L.C.colors.castbar.default))
  end
end

local LCG = LibStub("LibCustomGlow-1.0")

local function Cast_GlowHide(self)
  if self:GetParent().settings.template ~= "nameplate" then return end

  LCG.PixelGlow_Stop(self.glowFrame)
  self.glowStatus = nil
end

local function Cast_GlowShow(self, unit)
  -- there is a problem with target already changed when poststart is called
  if self:GetParent().settings.template ~= "nameplate" then return end

  if not self.hooked then
    self.glowStatus = nil
    self:HookScript("OnUpdate", function(_self, elapsed)
      if not (self.casting or self.channeling) then
        Cast_GlowHide(self)
      elseif UnitGUID(unit.."target") == UnitGUID("player") and not self.glowStatus then 
        LCG.PixelGlow_Start(self.glowFrame, {1,1,1,1}, 8, 0.25, 24, 2, 0, 0, false)
        self.glowStatus = true
      elseif UnitGUID(unit.."target") ~= UnitGUID("player") then --and not UnitIsPlayer(unit) then
        Cast_GlowHide(self)
      end
    end)
    self.hooked = true
  end

  -- this is the ONLY way to check the units cast target
  -- if UnitGUID(unit.."target") == UnitGUID("player") then 
  --   LCG.PixelGlow_Start(self.glow, {1,1,1,1}, 8, 0.25, _, 2, 0, 0, false)
  --   self._v.glow = true
  -- elseif not UnitGUID(unit.."target") and not self._v.glow and self then
  --   -- units have no targets on pull, so we need the recheck their targets with a minimal delay or event call
  --   -- local function yikes()
  --   --   Cast_GlowShow(self, unit)
  --   -- end
  --   -- C_Timer.After(0.01, yikes)
  -- end
end


local function Cast_GlowHidee(element)
  local self = element.__owner 
  if self.settings.template ~= "nameplate" then return end
  LCG.PixelGlow_Stop(self.glowFrame)
end

local function Cast_GlowShoww(element)
  local self = element.__owner 
  if self.settings.template ~= "nameplate" then return end

  element:HookScript("OnUpdate", function(_self, elapsed)
    if not element:IsShown() then 
      LCG.PixelGlow_Stop(element.glowFrame)
      return
    end
    if UnitGUID(self.unit.."target") == UnitGUID("player") and (element.casting or element.channeling) then 
      LCG.PixelGlow_Start(element.glowFrame, {1,1,1,1}, 8, 0.25, 24, 2, 0, 0, false)
    else
      LCG.PixelGlow_Stop(element.glowFrame)
    end

  end)
end



local function Cast_PostStart(self, unit)
  Cast_CheckInterruptible(self, unit)

  if L.C.importantCasts[self.spellID] then
    local r,g,b = L.C.importantCasts[self.spellID][1],L.C.importantCasts[self.spellID][2],L.C.importantCasts[self.spellID][3]
    self:SetStatusBarColor(r,g,b)
  end

  -- for i, castGUID in pairs(castHolder) do
  --   print(i,castGUID, self.castID==castGUID)
  -- end

  -- Cast_GlowShow(self, unit)
  
  --frame - target frame to set glowing;
  --color - {r,g,b,a}, color of lines and opacity, from 0 to 1. Defaul value is {0.95, 0.95, 0.32, 1}; 
  --N - number of lines. Defaul value is 8; 
  --frequency - frequency, set to negative to inverse direction of rotation. Default value is 0.25; 
  --length - length of lines. Default value depends on region size and number of lines; 
  --th - thickness of lines. Default value is 2; 
  --xOffset,yOffset - offset of glow relative to region border; 
  --border - set to true to create border under lines; 
  --key - key of glow, allows for multiple glows on one frame

  --LCG.PixelGlow_Start(self, {1,1,1,1}, 8, 0.25, _, 2, 0, 0, false)
end

local function Cast_PostInterruptible(self, unit)
  Cast_CheckInterruptible(self, unit)
end

local function Cast_Update(self, unit)
  return
  -- Cast_GlowHide(self)
end

local function Cast_PostStop(self, unit, spellID)
  -- if self:GetParent().settings.template ~= "nameplate" then Cast_GlowHide(self) end
  Cast_GlowHidee(self)
end


--CreateCastBar
local function CreateCastBar(self)
  if not self.cfg.castbar or not self.cfg.castbar.enabled then return end
  --statusbar
  local s = CreateFrame("StatusBar", nil, self)
  s.__owner = self
  s:SetStatusBarTexture(L.C.textures.statusbar)
  s:SetFrameStrata("MEDIUM")
  s:SetSize(unpack(self.cfg.castbar.size))
  s:SetOrientation("HORIZONTAL")
  SetPoint(s,self,self.cfg.castbar.point)
  if self.settings.template == "player" and self.cfg.castbar.colorClass then
    local _, class = UnitClass("player")
    s:SetStatusBarColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b)
    s.SetStatusBarColor = function() return end
  else
    s:SetStatusBarColor(unpack(L.C.colors.castbar.default))
  end
  --bg
  local bg = s:CreateTexture(nil, "BACKGROUND",nil,-8)
  bg:SetTexture(L.C.textures.statusbar)
  if self.settings.template == "nameplate" then
    bg:SetPoint("TOPLEFT", self, "BOTTOMLEFT",-2,-2)
    bg:SetPoint("BOTTOMRIGHT", 2, -2)
  else
    bg:SetPoint("TOPLEFT")
    bg:SetPoint("BOTTOMRIGHT")
  end
  bg:SetVertexColor(unpack(L.C.colors.castbar.defaultBG)) --bg multiplier
  s.bg = bg

  local glowFrame = CreateFrame("Frame", nil, self)
  glowFrame:SetPoint("TOPLEFT",-2,2)
  glowFrame:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT",2,-2)
  s.glowFrame = glowFrame
  --backdrop
  if self.cfg.castbar.backdrop then
    bg:SetVertexColor(0,0,0,1)
    CreateBackdrop(s)
  end
  --icon
  if self.cfg.castbar.icon and self.cfg.castbar.icon.enabled then
    --icon
    local i = s:CreateTexture(nil,"BACKGROUND",nil,-7)
    i:SetSize(self.cfg.castbar.icon.size/(1-1*2*0.12),self.cfg.castbar.icon.size)
    SetPoint(i,s,self.cfg.castbar.icon.point)
    i:SetTexCoord(0.08, 0.92, 0.19, 0.81)
    s.Icon = i
    --correct nameplate size, need to simplify later on
    if self.settings.template == "nameplate" then -- or self.settings.template == "player" then
      local x,y = s:GetSize(unpack(self.cfg.castbar.size))
      s:SetSize(x-self.cfg.castbar.icon.size/(1-1*2*0.12),y-2)
    end
    --backdrop (for the icon)
    if self.cfg.castbar.backdrop then
      local bd = CreateFrame("Frame", nil, s)
      bd:SetAllPoints(i)
      CreateBackdrop(bd)
    end
  end
  
  --shield
  --[[local shield = s:CreateTexture(nil,"BACKGROUND",nil,-8)
  shield.__owner = s
  s.Shield = shield--]]
  --use a trick here...we use the show/hide on the shield texture to recolor the castbar
  --hooksecurefunc(shield,"Show",SetCastBarColorShielded)
  --hooksecurefunc(s,"Hide",SetCastBarColorDefault)
  --text
  if self.cfg.castbar.name and self.cfg.castbar.name.enabled then
    local cfg = self.cfg.castbar.name
    local name = CreateText(s,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
    if cfg.points then
      SetPoints(name,s,cfg.points)
    else
      SetPoint(name,s,cfg.point)
    end
    s.Text = name
  end

  --if self.settings.template == "nameplate" then
    --[[s:HookScript("OnUpdate", function(_self, elapsed)
      print("§")
      if not self.settings.template == "nameplate" then return end
      if not _self:IsShown() then 
        LCG.PixelGlow_Stop(s.glowFrame)
        return
      end
      if UnitGUID(self.unit.."target") == UnitGUID("player") and (s.casting or s.channeling) then 
        LCG.PixelGlow_Start(s.glowFrame, {1,1,1,1}, 8, 0.25, 24, 2, 0, 0, false)
      else
        LCG.PixelGlow_Stop(s.glowFrame)
      end
    end)--]]
  --end

  s:HookScript("OnShow", Cast_GlowShoww)
  s:HookScript("OnHide", Cast_GlowHidee)
  -- hooksecurefunc(s,"Show",Cast_GlowShoww)
  -- hooksecurefunc(s,"Hide",Cast_GlowHidee)
  --hooksecurefunc(self,"Hide",Cast_GlowHidee)

  --Castbar:PostCastStart(self, unit)
  --Castbar:PostCastUpdate(self, unit)
  --Castbar:PostCastStop(self, unit, spellID)
  --Castbar:PostCastFail(self, unit, spellID)
  --Castbar:PostCastInterruptible(self, unit)
  s.PostCastUpdate = Cast_Update
  s.PostCastStop = Cast_PostStop
  s.PostCastInterruptible = Cast_PostInterruptible
  s.PostCastStart = Cast_PostStart
  s.PostChannelStart = Cast_PostStart
  return s
end
L.F.CreateCastBar = CreateCastBar

--combatlog event for targeted spells??!!
--check combat log and add guid to table i guess
--read table in postcaststart and trigger glow

-- not target output, either for spellcast events nor combatlog spellcaststart

-----------------------------
-- Tags
-----------------------------

local function CreateRaidMark(self)
  if not self.cfg.raidmark or not self.cfg.raidmark.enabled then return end
  return CreateIcon(self.Health,"OVERLAY",-8,self.cfg.raidmark.size,self.cfg.raidmark.point)
end
L.F.CreateRaidMark = CreateRaidMark

local function CreateReadyCheck(self)
  if not self.cfg.readycheck or not self.cfg.readycheck.enabled then return end
  return CreateIcon(self.Health,"OVERLAY",-8,self.cfg.readycheck.size,self.cfg.readycheck.point)
end
L.F.CreateReadyCheck = CreateReadyCheck

--CreateNameText
local function CreateNameText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.name or not self.cfg.healthbar.name.enabled then return end
  local cfg = self.cfg.healthbar.name
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreateNameText = CreateNameText

--CreateHealthText
local function CreateHealthText(self)
  if not self.cfg.healthbar or not self.cfg.healthbar.health or not self.cfg.healthbar.health.enabled then return end
  local cfg = self.cfg.healthbar.health
  local text = CreateText(self.rAbsorbBar or self.Health,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.rAbsorbBar or self.Health,cfg.points)
  else
    SetPoint(text,self.rAbsorbBar or self.Health,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreateHealthText = CreateHealthText

--CreatePowerText
local function CreatePowerText(self)
  if not self.cfg.powerbar or not self.cfg.powerbar.power or not self.cfg.powerbar.power.enabled then return end
  local cfg = self.cfg.powerbar.power
  local text = CreateText(self.Power,cfg.font,cfg.size,cfg.outline,cfg.align,cfg.noshadow)
  if cfg.points then
    SetPoints(text,self.Power,cfg.points)
  else
    SetPoint(text,self.Power,cfg.point)
  end
  self:Tag(text, cfg.tag)
end
L.F.CreatePowerText = CreatePowerText

--PositionAura
local function SetPosition(element, from, to)
  local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
  local sizey = (math.ceil(element.size-element.size*2*0.12) or 16) + (element['spacing-y'] or element.spacing or 0) --BIGDICK
  local anchor = element.initialAnchor or 'BOTTOMLEFT'
  local growthx = (element['growth-x'] == 'LEFT' and -1) or 1
  local growthy = (element['growth-y'] == 'DOWN' and -1) or 1
  local cols = math.floor(element:GetWidth() / sizex + 0.5)

  for i = from, to do
    local button = element[i]

    -- Bail out if the to range is out of scope.
    if(not button) then break end
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)

    button:ClearAllPoints()
    button:SetPoint(anchor, element, anchor, col * sizex * growthx, row * sizey * growthy)
  end
end

--PostCreateAura
local function PostCreateAura(element,button)
  local self = element.__owner
  
  local bg = button:CreateTexture(nil,"BACKGROUND",nil,-8)
  bg:SetTexture(L.C.textures.backdrop)
  bg:SetVertexColor(0,0,0,0.7)
  if self.settings.template == "heal" then
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1) 
  else
    bg:SetPoint("TOPLEFT", -2, 2)
    bg:SetPoint("BOTTOMRIGHT", 2, -2)
  end
  element.bg = bg

  local hl = button:CreateTexture(nil,"OVERLAY",nil,-8)
  hl:SetTexCoord(0,1,0.125,0.875)
  hl:SetTexture(L.C.mediapath.."ButtonHilight.tga")
  hl:SetVertexColor(0,0,0,0)
  hl:SetPoint("TOPLEFT", -1, 1)
  hl:SetPoint("BOTTOMRIGHT", 1, -1)
  element.hl = hl
 
  --math.ceil(size*0.62)
  local xoffset = 0.08
  local xarea = 1-xoffset*2 --x size = 0.84
  local yarea = xarea*0.62 --y size = 0.4725
  local yoffset = (1-yarea)/2 
  button.icon:SetTexCoord(xoffset, 1-xoffset, yoffset, 1-yoffset)

  button.count:SetFont(L.C.mediapath.."font.ttf", 13, "OUTLINE")
  button.count:SetShadowColor(0,0,0,0)
  button.count:SetShadowOffset(0,0)
  button.count:SetJustifyH("RIGHT")
  button.count:ClearAllPoints()
  button.count:SetPoint("TOPRIGHT", 2.5, 0.5)
  button:SetFrameStrata("LOW")

  local countFrame = button.count:GetParent()

  button.time = countFrame:CreateFontString(nil, "OVERLAY")
  button.time:SetFont(L.C.mediapath.."font.ttf", 13, "OUTLINE")
  button.time:SetShadowColor(0,0,0,0)
  button.time:SetShadowOffset(0,0)
  button.time:SetJustifyH("CENTER")
  button.time:SetPoint("BOTTOM", 0.5, -2.5)

  --button.overlay:

  button.stealable:SetPoint('TOPLEFT', -4, 4)
  button.stealable:SetPoint('BOTTOMRIGHT', 4, -4)

  if self.settings.template == "heal" then
    local glowBackdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
    glowBackdrop:SetPoint("TOPLEFT",0,0)
    glowBackdrop:SetPoint("BOTTOMRIGHT",0,0)
    glowBackdrop:SetBackdrop({
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 2,
    })
    glowBackdrop:SetBackdropBorderColor(0,0,0,0.7)
    glowBackdrop:Hide()
    button.glowBackdrop = glowBackdrop

    glow = CreateFrame("Frame", nil, glowBackdrop, "BackdropTemplate")
    glow:SetPoint("TOPLEFT",0,0)
    glow:SetPoint("BOTTOMRIGHT",0,0)
    glow:SetBackdrop({
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 1,
    })
    glow:SetBackdropBorderColor(1,1,1,0.7)
  else
    local glowBackdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
    glowBackdrop:SetPoint("TOPLEFT",-1,1)
    glowBackdrop:SetPoint("BOTTOMRIGHT",1,-1)
    glowBackdrop:SetBackdrop({
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 3,
    })
    glowBackdrop:SetBackdropBorderColor(0,0,0,0.7)
    glowBackdrop:Hide()
    button.glowBackdrop = glowBackdrop

    glow = CreateFrame("Frame", nil, glowBackdrop, "BackdropTemplate")
    glow:SetPoint("TOPLEFT",0,0)
    glow:SetPoint("BOTTOMRIGHT",0,0)
    glow:SetBackdrop({
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 2,
    })
    glow:SetBackdropBorderColor(1,0,0,0.7)
    button.glow = glow
  end
end
L.F.PostCreateAura = PostCreateAura

--CreateAuraTimer
local function GetFormattedTime(s)
  if s < 60 then
    return floor(s), s - floor(s)
  elseif s < 3600 then
    return format("%dm", floor(s/60)), s % 60
  elseif s < 86400 then
    return format("%dh", floor(s/3600)), s % 3600
  else
    return format("%dd", floor(s/86400)), s % 86400
  end 
end

local function CreateAuraTimer(button, elapsed)
  if button.nextUpdate > 0 then
    button.nextUpdate = button.nextUpdate - elapsed
  else
    local remain = button.expiration - GetTime()

    if button.duration and remain < 0.3* button.duration then
      --print(remain,button.maxDuration)
      button.glowBackdrop:Show()
    else
      button.glowBackdrop:Hide()
    end

    if remain > 0 then
      local time, nextUpdate = GetFormattedTime(remain)
      button.time:SetText(time)
      button.nextUpdate = nextUpdate
    else
      button.duration = nil
      button.expiration = nil
      button.glowBackdrop:Hide()

      button.time:Hide()
      button:SetScript("OnUpdate", nil)
    end
  end
end

local function AuraGetSpellID(array, icon)
  for idx,_ in pairs(array) do
    --print(idx, GetSpellTexture(idx), button.icon:GetTexture())
    if icon:GetTexture() == GetSpellTexture(idx) then return true end
  end
  return false
end

--PostUpdateIcon
local function PostUpdateIcon(element, unit, button, index, position, duration, expiration, debuffType, isStealable)
  local self = element.__owner
  local size = button:GetSize()
  local height = math.ceil(size*0.62)
  if height%2 > 0 then height = height + 1 end
  button:SetSize(size, height)
  button.size = {size, height}
  --button.maxDuration = nil

  --print(button.spellID)
  --button:SetSize(size, math.ceil(size*9/16))
  --print(button.icon:GetTexture())
  --button.spellID = select(10, UnitAura(unit, index))
  --print(button.spellID)
  --local name, _, _, _, duration, expiration, _, _, _, spellID = UnitAura(unit, index)
--pandemicDebuffs   L.C.importantMobs[UnitName(unit)]
    --if button.icon = GetSpellTexture:L.C.importantMobs[UnitName(unit)]
    --[[if unit == "target" then
    print(button,index,duration)
    end]]

  --change to one update cycle for all buffs?!
  if button:IsShown() and duration and duration > 0 then
    button.expiration = expiration
    --if not button.maxDuration and button.isPlayer and AuraGetSpellID(L.C.pandemicDebuffs, button.icon) then button.maxDuration = duration end
    if button.isPlayer and AuraGetSpellID(L.C.pandemicDebuffs, button.icon) then
      button.duration = duration
    else
      button.duration = nil
    end

    button.time:Show()
    button.nextUpdate = 0
    button:SetScript("OnUpdate", CreateAuraTimer)
  else
    button.duration = nil
    button.expiration = nil
    button.glowBackdrop:Hide()

    button.time:Hide()
    button:SetScript("OnUpdate", nil)
  end

  if button:IsShown() and button.isPlayer and AuraGetSpellID(L.C.desaturateAuras, button.icon) then
    button:SetAlpha(0.3)
    button.icon:SetDesaturated(true)
  else
    button:SetAlpha(1)
    button.icon:SetDesaturated(false)
  end

  if button.glow then
    if button.overlay:IsShown() then -- debuffType then --and UnitIsFriend("player", unit) then
      --local color = self.colors.debuff[debuffType] or self.colors.debuff.none
      local r,g,b = button.overlay:GetVertexColor()
      --element.glow:SetBackdropBorderColor(color[1], color[2], color[3],0.7)
      button.glow:SetBackdropBorderColor(r, g, b,0.7)
      button.glowBackdrop:Show()
    else
      button.glowBackdrop:Hide()
    end
  end
end

--CreateSpecial
local function CreateAuras(self)
  if not self.cfg.auras or not self.cfg.auras.enabled then return end
  local cfg = self.cfg.auras
  local frame = CreateFrame("Frame", nil, self)
  frame.__owner = self
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.disableMouse = cfg.disableMouse
  frame.showStealableBuffs = cfg.showStealableBuffs
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAura
  frame.PostUpdateIcon = cfg.PostUpdateIcon or PostUpdateIcon
  frame.SetPosition = cfg.SetPosition or SetPosition
  --frame.PostUpdateIcon = PostUpdateBuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(0,1,0,0.2)
  return frame
end
L.F.CreateAuras = CreateAuras

--CreateBuffs
local function CreateBuffs(self)
  if not self.cfg.buffs or not self.cfg.buffs.enabled then return end
  local cfg = self.cfg.buffs
  local frame = CreateFrame("Frame", nil, self)
  frame.__owner = self
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.disableMouse = cfg.disableMouse
  frame.showStealableBuffs = cfg.showStealableBuffs
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAura
  frame.PostUpdateIcon = cfg.PostUpdateIcon or PostUpdateIcon
  frame.SetPosition = cfg.SetPosition or SetPosition
  --frame.PostUpdateIcon = PostUpdateBuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(0,1,0,0.2)
  return frame
end
L.F.CreateBuffs = CreateBuffs

--CreateDebuffs
local function CreateDebuffs(self)
  if not self.cfg.debuffs or not self.cfg.debuffs.enabled then return end
  local cfg = self.cfg.debuffs
  local frame = CreateFrame("Frame", nil, self)
  frame.__owner = self
  SetPoint(frame,self,cfg.point)
  frame.num = cfg.num
  frame.size = cfg.size
  frame.spacing = cfg.spacing
  frame.initialAnchor = cfg.initialAnchor
  frame["growth-x"] = cfg.growthX
  frame["growth-y"] = cfg.growthY
  frame.disableCooldown = cfg.disableCooldown
  frame.disableMouse = cfg.disableMouse
  frame.filter = cfg.filter
  frame.CustomFilter = cfg.CustomFilter
  frame.PostCreateIcon = cfg.PostCreateAura or PostCreateAura
  frame.PostUpdateIcon = cfg.PostUpdateIcon or PostUpdateIcon
  frame.SetPosition = cfg.SetPosition or SetPosition
  --frame.PostUpdateIcon = PostUpdateDebuff
  frame:SetSize(CalcFrameSize(cfg.num,cfg.cols,cfg.size,cfg.size,cfg.spacing,0))
  --local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
  --t:SetAllPoints()
  --t:SetColorTexture(1,0,0,0.2)
  return frame
end
L.F.CreateDebuffs = CreateDebuffs

--CreateNamePlateTargetIndicator
local function CreateNameplateTargetIndicator(self)
  --if not (self or self.unit) then return end
   --[[local LinesFrame = CreateFrame("Frame", nil, f)
  local line = LinesFrame:CreateLine(nil, "OVERLAY", 7)
  --local line = LinesFrame:CreateTexture(nil, "OVERLAY", 7)

  line:SetThickness(2)
  line:SetColorTexture(1,0,0)
  line:SetStartPoint("CENTER", UIParent)
  line:SetEndPoint("BOTTOM", f)
  --line:SetPoint("CENTER", f)
  --line:SetPoint("CENTER", UIParent)
  line:Show()]]

  local frame = CreateFrame("Frame", nil, self.Health)
  frame:SetFrameLevel(self:GetFrameLevel())
  local height = self:GetHeight()

  local function CreateTop(f)
    f = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    f:SetSize(4, 2)
    f:SetBackdrop({
        bgFile = L.C.textures.backdrop,
        edgeFile = L.C.textures.backdrop,
        edgeSize = 1,
        inset = 1,
    insets = {
        left = -1,
        right = -1,
        top = -1,
        bottom = -1,
    },
    })
    f:SetBackdropColor(0, 0, 0, .7)
    f:SetBackdropBorderColor(1, 1, 1, 1)

    return f
  end

  local function CreateCenter(f)
    f = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    f:SetSize(2, height+10)
    f:SetBackdrop({
        bgFile = L.C.textures.backdrop,
        edgeFile = L.C.textures.backdrop,
        edgeSize = 1,
        inset = 1,
    insets = {
        left = -1,
        right = -1,
        top = 1,
        bottom = 1,
    },
    })
    f:SetBackdropColor(0, 0, 0, .7)
    f:SetBackdropBorderColor(1, 1, 1, 1)

    return f
  end

  local function CreateBottom(f)
    f = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    f:SetSize(4, 2)
    f:SetBackdrop({
        bgFile = L.C.textures.backdrop,
        edgeFile = L.C.textures.backdrop,
        edgeSize = 1,
        inset = 1,
    insets = {
        left = -1,
        right = -1,
        top = -1,
        bottom = -1,
    },
    })
    f:SetBackdropColor(0, 0, 0, .7)
    f:SetBackdropBorderColor(1, 1, 1, 1)

    return f
  end

  local function CreateCrossHorizontal(f)
    f = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    f:SetSize(UIParent:GetWidth(), 2)
    f:SetBackdrop({
        bgFile = L.C.textures.backdrop,
        edgeFile = L.C.textures.backdrop,
        edgeSize = 1,
        inset = -2,
    })
    f:SetBackdropColor(0, 0, 0, .7)
    f:SetBackdropBorderColor(1, 1, 1, 0)

    return f
  end

  local lc = CreateCenter(lc)
  lc:SetPoint("RIGHT", self, "LEFT", -5, 0)
  
  local lt = CreateTop(lt)
  lt:SetPoint("BOTTOMLEFT", lc, "TOPLEFT", 0, 0)

  local lb = CreateBottom(lt)
  lb:SetPoint("TOPLEFT", lc, "BOTTOMLEFT", 0, 0)


  local rc = CreateCenter(rc)
  rc:SetPoint("LEFT", self, "RIGHT", 5, 0)
  
  local rt = CreateTop(rt)
  rt:SetPoint("BOTTOMRIGHT", rc, "TOPRIGHT", 0, 0)

  local rb = CreateBottom(rt)
  rb:SetPoint("TOPRIGHT", rc, "BOTTOMRIGHT", 0, 0)

  --local cl = CreateCrossHorizontal(cl)
  --cl:SetPoint("LEFT", self, "RIGHT", 11, 0)
 
  local function onEvent(this, event)
    if UnitGUID("target") and UnitGUID(self.unit) == UnitGUID("target") then
      frame:Show()
    else
      frame:Hide()
    end
  end

  frame:Hide()

  local function rangeIndicator()
    --[[
    {range, itemid}
    {0, 1}, -- 0
    {5, 37727}, -- Ruby Acorn 
    {6, 63427}, -- Worgsaw 
    {7, 61323}, -- Ruby Seeds
    {8, 34368}, -- Attuned Crystal Cores 
    {10, 32321}, -- Sparrowhawk Net 
    {15, 33069}, -- Sturdy Rope
    {20, 10645}, -- Gnomish Death Ray
    {25, 24268}, -- Netherweave Net
    {30, 835}, -- Large Rope Net
    {35, 24269}, -- Heavy Netherweave Net
    {38, 140786}, -- Ley Spider Eggs
    {40, 28767}, -- The Decapitator
    {45, 23836}, -- Goblin Rocket Launcher
    {50, 116139}, -- Haunting Memento 
    {60, 32825}, -- Soul Cannon 
    {70, 41265}, -- Eyesore Blaster 
    {80, 35278}, -- Reinforced Net 
    {90, 133925}, -- Fel Lash
    {100, 33119}, -- Malister's Frost Wand
    ]]
    --[[local cid = select(3,UnitClass("player"))
    local id = 0
    if cid == 1 or cid == 4 or cid == 12 then
      id = 34368
    elseif cid == 3 or cid == 8 or cid == 9 then
      id = 28767 
    end

    local r = IsItemInRange(id, "target")
    if r == true then
      cr:SetBackdropColor(1, 1, 1, .3)
      cl:SetBackdropColor(1, 1, 1, .3)
      ct:SetBackdropColor(1, 1, 1, .3)
      cb:SetBackdropColor(1, 1, 1, .3)

      cr.t:SetVertexColor(1, 1, 1, .3)
      cl.t:SetVertexColor(1, 1, 1, .3)
      ct.t:SetVertexColor(1, 1, 1, .3)
      cb.t:SetVertexColor(1, 1, 1, .3)
    else
      cr:SetBackdropColor(1, 0, 0, .45)
      cl:SetBackdropColor(1, 0, 0, .45)
      ct:SetBackdropColor(1, 0, 0, .45)
      cb:SetBackdropColor(1, 0, 0, .45)

      cr.t:SetVertexColor(1, 0, 0, .45)
      cl.t:SetVertexColor(1, 0, 0, .45)
      ct.t:SetVertexColor(1, 0, 0, .45)
      cb.t:SetVertexColor(1, 0, 0, .45)
    end
    --print(r)
    --print(frame:IsShown())
    if frame:IsShown() then 
      C_Timer.After(0.1, rangeIndicator) 
    end]]
  end
  --rangeIndicator()
 
  local function onEvent(this, event)
    if event == "SPELL_UPDATE_USABLE" then print("F") end
    if UnitGUID("target") and UnitGUID(self.unit) == UnitGUID("target") then
      rangeIndicator()
      --self.bd:SetBackdropColor(1,1,1)
      --self.bd:SetBackdropBorderColor(1,1,1)
      frame:Show()
    else
      frame:Hide()
    end
  end

  frame:Hide()

  frame:RegisterEvent("UNIT_TARGETABLE_CHANGED")
  frame:RegisterEvent("PLAYER_TARGET_CHANGED")
  frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
  frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
  --frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
  --frame:RegisterEvent("UNIT_COMBAT")
  --frame:RegisterEvent("ADDON_LOADED")

  frame:SetScript("OnEvent", onEvent)
  return frame
end
L.F.CreateNameplateTargetIndicator = CreateNameplateTargetIndicator


local function CreateAuraWatch(self)
  if not self.cfg.aurawatch then return end

  local auras = {}
  local spellIDs = self.cfg.aurawatch.indicators
  local class = select(2, UnitClass("player"))

  auras.onlyShowPresent = true
  auras.presentAlpha = 1
  auras.strictMatching = true

  auras.PostCreateIcon = function(self, icon, sid)
    if icon.cd then
      icon.cd:SetPoint("TOPLEFT", 1, -1)
      icon.cd:SetPoint("BOTTOMRIGHT", -1, 1)
      icon.cd:SetReverse(true)
    end

    if icon.count then
      icon.count:Hide()
    end
  end
  
  local buffs = {}

  if (spellIDs['ALL']) then
    for key, value in pairs(spellIDs['ALL']) do
      tinsert(buffs, value)
    end
  end

  if (spellIDs[class]) then
    for key, value in pairs(spellIDs[class]) do
      tinsert(buffs, value)
    end
  end

  -- Set any other AuraWatch settings
  auras.icons = {}
  for i, sid in pairs(buffs) do
    local icon = CreateFrame("Frame", nil, self)   
    icon.spellID = sid[1]
    icon:SetSize(self.cfg.aurawatch.size,math.ceil(self.cfg.aurawatch.size-self.cfg.aurawatch.size*2*0.12))
    
    icon:SetPoint(sid[2], self, sid[2], unpack(sid[3]))

    --icon.strictMatching = sid[5]
    --icon.hideCooldown = sid[6]
    --icon.hideCount = sid[7]

    -- Exception to place PW:S above Weakened Soul
    if (icon.spellID == 17) then
      icon:SetFrameLevel(icon:GetFrameLevel() + 1)
    end

    -- Indicator icon
    local tex = icon:CreateTexture(nil, "OVERLAY")
    tex:SetPoint("TOPLEFT", 1, -1)
    tex:SetPoint("BOTTOMRIGHT", -1, 1)
    tex:SetTexture(L.C.textures.statusbar)
    tex:SetVertexColor(unpack(sid[4]))
    icon.icon = tex

    local bg = icon:CreateTexture(nil,"BACKGROUND",nil,-1)
    bg:SetTexture(L.C.textures.backdrop)
    bg:SetVertexColor(0,0,0,1)
    bg:SetPoint("TOPLEFT")
    bg:SetPoint("BOTTOMRIGHT")
    --F.CreateBD(icon, 0)
    auras.icons[sid] = icon
    -- Set any other AuraWatch icon settings
  end

  return auras
end
L.F.CreateAuraWatch = CreateAuraWatch

--DumpShit
local function GetPlayerRole()
  local class = select(2, UnitClass("player"))
  local spec = GetSpecialization()
  if (class == 'PRIEST' and (spec == 1 or spec == 2)) or (class == 'SHAMAN' and spec == 3) or (class == 'PALADIN' and spec == 1) or (class == 'DRUID' and spec == 4) or (class == 'MONK' and spec == 2) then
    return "HEALER"
  elseif (class == 'MONK' and spec == 1) or (class == 'PALADIN' and spec == 2) or (class == 'DRUID' and spec == 3) or (class == 'WARRIOR' and spec == 3) or (class == 'DEATHKNIGHT' and spec == 1) then
    return "TANK"
  else
    return "DAMAGE"
  end
end

local f = CreateFrame("Frame")
local function onEvent(self, event, ...)
  if InCombatLockdown() then
    f:RegisterEvent("PLAYER_REGEN_ENABLED")
    return
  elseif (event and event == "PLAYER_REGEN_ENABLED") then
    f:UnregisterEvent("PLAYER_REGEN_ENABLED")
  end
  
  if GetPlayerRole() == "HEALER" then
    if _G["oUF_PartyHeader"] then
      RegisterAttributeDriver(_G["oUF_PartyHeader"],'state-visibility',"hide")
    end

    if _G["oUF_HealHeader"] then
      RegisterAttributeDriver(_G["oUF_HealHeader"],'state-visibility',L.C.heal.setup.visibility)
    end
  else
    if _G["oUF_PartyHeader"] then
      RegisterAttributeDriver(_G["oUF_PartyHeader"],'state-visibility',L.C.party.setup.visibility)
    end

    if _G["oUF_HealHeader"] then
      RegisterAttributeDriver(_G["oUF_HealHeader"],'state-visibility',"hide")
    end
  end
end

f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", onEvent)

--SetupHeader
local function SetupHeader(self)
  if not self.settings.setupHeader then return end
  self:RegisterForClicks("AnyDown")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
end
L.F.SetupHeader = SetupHeader

--SetupFrame
local function SetupFrame(self)
  if not self.settings.setupFrame then return end
  self:SetSize(unpack(self.cfg.size))
  SetPoint(self,nil,self.cfg.point)
  self:SetScale(self.cfg.scale)
  --print(self:GetName(),self:GetScale(),self:GetEffectiveScale(),self:GetWidth(),self:GetHeight(),self:GetPoint())
end
L.F.SetupFrame = SetupFrame
