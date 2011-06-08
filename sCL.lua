local addon = ...
local me = UnitName"player"
local format = string.format
local strlower = strlower
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass

local classColors = {}
if IsAddOnLoaded("!ClassColors") and CUSTOM_CLASS_COLORS then
	for k, v in pairs(CUSTOM_CLASS_COLORS) do classColors[k] = ("%02x%02x%02x"):format(v.r*255, v.g*255, v.b*255) end
else
	for k, v in pairs(RAID_CLASS_COLORS) do	classColors[k] = ("%02x%02x%02x"):format(v.r*255, v.g*255, v.b*255) end
end

local function sTex(spellid)
	local name, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellid)
	if icon and name then
		return format("\124T%s:12\124t |cffffbb11%s|r",icon,name)
	elseif name then
		return format("|cffffbb11%s|r",name)
	else
		return ""
	end
end

local function cSpell(school)
	if school == 4 then -- fire
		return "|cffee5555"
	elseif school == 8 then -- nature
		return "|cff55bb55"
	elseif school == 16 then -- frost
		return "|cff5555ee"
	elseif school == 20 then -- frostfire
		return "|cffee55ee"
	elseif school == 32 then -- shadow
		return "|cff8800bb"
	elseif school == 64 then -- arcane
		return "|cff22dddd"
	else
		return ""
	end
end

local function cName(name)
	if name == nil then return "|cffff7831Nobody|r" end
	local _, class = UnitClass(name)
	if classColors[class] == nil then
		return format("|cffff7831%s|r",name)
	else
		return format("|cff%s%s|r",classColors[class],name)
	end
end

local function a(msg) ChatFrame3:AddMessage(msg) end

local f = CreateFrame("Frame",addon)
f:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
f:SetScript("OnEvent", function(_,_,_,event,_,_,source,_,_,dest,_,arg9,arg10,arg11,arg12,arg13,_,arg15,_,_,arg18)
	if source == me then -- source = me
		if event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "DAMAGE_SHIELD" or event == "RANGE_DAMAGE" then
			a(format("%s %s %s%s%d%s",sTex(arg9),cName(dest),(arg18 and "|cffffbb11*" or ""),cSpell(arg11),arg12,(arg18 and "|cffffbb11*" or ""))) return
		elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
			a(format("%s %s %s%s%d%s",sTex(arg9),cName(dest),(arg18 and "|cffffbb11*" or ""),"|cff55bb55+",arg12,(arg18 and "|cffffbb11*" or ""))) return
		elseif event == "SWING_DAMAGE" then
			a(format("|cffffbb11Melee|r %s %s%s%d%s",cName(dest),(arg15 and "|cffffbb11*" or ""),cSpell(arg11),arg9,(arg15 and "|cffffbb11*" or ""))) return
		elseif event == "SWING_MISSED" then
			a(format("|cffffbb11Melee|r %s %s",cName(dest),strlower(arg9))) return
		elseif event == "SPELL_MISSED" or event == "DAMAGE_SHIELD_MISSED" then
			a(format("%s %s %s",sTex(arg9),cName(dest),strlower(arg12))) return
		elseif event == "SPELL_INTERRUPT" then
			a(format("%s interrupt %s's %s",sTex(arg9),cName(dest),sTex(arg12))) return
		end
	elseif dest == me then -- target = me
		if event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "DAMAGE_SHIELD" or event == "RANGE_DAMAGE" then
			a(format("%s %s %s%s%d%s",cName(source),sTex(arg9),(arg18 and "|cffffbb11*" or ""),cSpell(arg11),arg12,(arg18 and "|cffffbb11*" or ""))) return
		elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
			if arg10 == "Vampiric Embrace" then return end
			a(format("%s %s %s%s%d%s",cName(source),sTex(arg9),(arg18 and "|cffffbb11*" or ""),"|cff55bb55+",arg12,(arg18 and "|cffffbb11*" or ""))) return
		elseif event == "SWING_DAMAGE" then
			a(format("%s |cffffbb11Melee|r %s%s%d%s",cName(source),(arg15 and "|cffffbb11*" or ""),cSpell(arg11),arg9,(arg15 and "|cffffbb11*" or ""))) return
		elseif event == "SWING_MISSED" then
			a(format("%s |cffffbb11Melee|r %s",cName(source),strlower(arg9))) return
		elseif event == "SPELL_MISSED" or event == "DAMAGE_SHIELD_MISSED" then
			a(format("%s %s %s",cName(source),sTex(arg9),strlower(arg12))) return
		elseif event == "ENVIRONMENTAL_DAMAGE" then
			a(format("|cffffbb11%s|r %s %d",strlower(arg9),cName(dest),arg10)) return
		end
	end
end)