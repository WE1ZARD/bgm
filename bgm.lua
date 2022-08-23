--[[
============================================================

    Origin: https://github.com/Fiurs-Hearth/BattleMusic
    Re-Code by Weizard
    note: fade in/out effect with wow bgm muted.

=============================================================
]]

local _G = _G or getfenv()
local inCombat

bgm = {}
bgm.songs = 3 -- your music number
bgm.solo = true

bgm.toggle = true

if not bgm.toggle then return end

local t = CreateFrame("frame")


local function trigger()
    math.randomseed(time())
    local timetick = 0
    local inInstance, instanceType = IsInInstance()

    if bgm.solo then if (not instanceType == "pvp" or GetNumPartyMembers() > 5 ) then return end end

    if event == "PLAYER_REGEN_DISABLED" then
        t:SetScript("OnUpdate",function()
            timetick = timetick+arg1
            if timetick > 0.1 then
                t:SetScript("OnUpdate",nil)
                SetCVar("MusicVolume",0.5)
                SoundOptionsFrame_Load()
               PlayMusic("Interface\\AddOns\\!bgm\\music\\"..tostring(math.random(1,bgm.songs))..".mp3") 
            end 
        end)
        inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
        StopMusic()
        t:SetScript("OnUpdate",function()
            timetick = timetick+arg1
            if timetick > 3.5 then
                t:SetScript("OnUpdate",nil)
                SetCVar("MusicVolume",0)
                SoundOptionsFrame_Load()
            end 
        end)
    else
        inCombat = false
        SetCVar("EnableMusic", 1)
        SoundOptionsFrame_Load()
        StopMusic()
    end
end

local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", trigger)
