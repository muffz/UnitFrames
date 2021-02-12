
-- oUF_Simple: templates/party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CreatePartyStyle
-----------------------------

if not L.C.heal or not L.C.heal.enabled then return end

local function CreateHealStyle(self)
  --config
  self.cfg = L.C.heal
  --settings
  self.settings = {}
  self.settings.template = "heal"
  self.settings.setupFrame = false
  self.settings.setupHeader = true
  self.settings.createDrag = false
  --style
  L.F.CreateStyle(self)
end
L.F.CreateHealStyle = CreateHealStyle