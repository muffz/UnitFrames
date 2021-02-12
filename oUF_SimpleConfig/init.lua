
-- oUF_SimpleConfig: init
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--config container
L.C = {}
--tags and events
L.C.tagMethods = {}
L.C.tagEvents = {}
--make the config global
oUF_SimpleConfig = L.C

SlashCmdList["TESTUF"] = function()
	for i = 1,4 do
		local f = _G["oUF_SimpleBoss"..i]
    	f:Show(); f.Hide = function() end f.unit = "player"
    end

    for i = 1,4 do
		local f = _G["oUF_SimplePartyHeaderUnitButton"..i]
    	f:Show(); f.Hide = function() end f.unit = "player"
    end
end
SLASH_TESTUF1 = "/testuf"
