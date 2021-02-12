
local A, L = ...
local oUF = L.oUF or oUF

local function Update(self, event, unit)
  if(self.unit ~= unit) then return end
  local ta = self.rAbsorbBar
  local allAbsorbs = UnitGetTotalAbsorbs(unit) or 0
  local maxHealth = UnitHealthMax(unit)
  if allAbsorbs > maxHealth then allAbsorbs = maxHealth end
  ta:SetMinMaxValues(0, maxHealth)
  ta:SetValue(allAbsorbs)

  if ta.bg then
    --print(allAbsorbs/maxHealth, ta:GetWidth()*(1-allAbsorbs/maxHealth))
    --ta:GetWidth()
    --ta.bg:SetTexCoord(1-allAbsorbs/maxHealth,1,0,1)
    ta.bg:SetPoint("TOP")
    ta.bg:SetPoint("RIGHT")
    ta.bg:SetPoint("BOTTOM")
    ta.bg:SetPoint("LEFT", ta:GetWidth()*(1-allAbsorbs/maxHealth), 0)
  end
end

local function Path(self, ...)
  return (self.rAbsorbBar.Override or Update) (self, ...)
end

local function ForceUpdate(element)
  return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
  local ta = self.rAbsorbBar
  if(ta) then
    ta.__owner = self
    ta.ForceUpdate = ForceUpdate
    self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:RegisterEvent('UNIT_MAXHEALTH', Path)
    return true
  end
end

local function Disable(self)
  local ta = self.rAbsorbBar
  if(ta) then
    self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
    self:UnregisterEvent('UNIT_MAXHEALTH', Path)
  end
end

oUF:AddElement('rAbsorbBar', Path, Enable, Disable)
