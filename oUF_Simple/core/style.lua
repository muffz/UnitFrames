
-- oUF_Simple: core/style
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF or oUF

-----------------------------
-- Style
-----------------------------

--CreateStyle
local function CreateStyle(self)
  L.F.SetupFrame(self)
  L.F.SetupHeader(self)
  
  self.Backdrop = L.F.CreateBackdrop(self)

  self.Health = L.F.CreateHealthBar(self)
  self.Power = L.F.CreatePowerBar(self)
  --self.rAbsorbBar = L.F.CreateAbsorbBar(self)
  L.F.CreateNameText(self)
  L.F.CreateHealthText(self)
  
  L.F.CreatePowerText(self)
  self.Castbar = L.F.CreateCastBar(self)
  self.GCD = L.F.CreateGCDBar(self)
  if select(3, UnitClass("player")) == 6 then
    self.Runes = L.F.CreateRuneBar(self)
  else
    if select(3, UnitClass("player")) == 10 then
      self.Stagger = L.F.CreateStaggerBar(self)
    end
    self.ClassPower = L.F.CreateClassBar(self)
  end
  self.AlternativePower = L.F.CreateAltPowerBar(self)
  self.AdditionalPower = L.F.CreateAdditionalPowerBar(self)
  self.Debuffs = L.F.CreateDebuffs(self)
  self.Buffs = L.F.CreateBuffs(self)
  self.RaidTargetIndicator = L.F.CreateRaidMark(self)
  self.ReadyCheckIndicator = L.F.CreateReadyCheck(self)

  if self.settings.template == "nameplate" then
    self.TargetIndicator = L.F.CreateNameplateTargetIndicator(self)
    self.Glow = L.F.CreateGlow(self)
    self.Auras = L.F.CreateAuras(self)
  end

  --if self.settings.template == "heal" then
    self.AuraWatch = L.F.CreateAuraWatch(self)
  --end
end
L.F.CreateStyle = CreateStyle