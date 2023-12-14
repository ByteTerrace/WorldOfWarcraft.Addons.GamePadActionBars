--[[ References:
    https://breezewiki.com/wowpedia/wiki/Events
    https://breezewiki.com/wowpedia/wiki/Global_functions
    https://breezewiki.com/wowpedia/wiki/UIHANDLER_OnGamePadButtonDown
    https://breezewiki.com/wowpedia/wiki/UIOBJECT_Button
    https://breezewiki.com/wowpedia/wiki/UIOBJECT_Frame
    https://breezewiki.com/wowpedia/wiki/UIOBJECT_Texture
    https://github.com/Gethe/wow-ui-textures

    /dump, /etrace, /fstack
]]

local GamePadActionBarsAddonName = "WowSandbox"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = 200
local GamePadActionBarsDefaultPassiveAlpha = 0.5

WowApi = {
    ActionBars = {
        SetPage = ChangeActionBarPage,
    },
    ConsoleVariables = C_CVar,
    Colors = {
        CreateColorFromBytes = CreateColorFromBytes,
    },
    Frames = {
        CreateFrame = CreateFrame,
    },
    GamePad = C_GamePad,
    Player = {
        IsAwayFromKeyboard = IsChatAFK,
        IsInCombat = InCombatLockdown,
    },
    UserInterface = {
        Parent = UIParent,
    },
    Timers = C_Timer,
}

local apiFrame = WowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", nil, "SecureHandlerBaseTemplate, SecureActionButtonTemplate")
local isPanicWarranted = function ()
    return WowApi.UserDefined.Player.IsAwayFromKeyboard
end
local onAddonLoaded = function (key)
    if GamePadActionBarsAddonName == key then
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateAlt", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateCtrl", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateShift", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateTapWindowMs", "0")
        WowApi.ConsoleVariables.SetCVar("GamePadEnable", "1")
        WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")
        WowApi.UserDefined.ActionBars:Initialize()
    end
end
local onFrameEvent = function (...) end
local onInputStateChanged = function (_, id, isDown)
    local isModifierInput = false

    if ((id == "PADLTRIGGER") or (id == "RCTRL")) then
        WowApi.UserDefined.Keyboard.IsControlKeyDown = isDown
        isModifierInput = true
    elseif ((id == "PADRTRIGGER") or (id == "RSHIFT")) then
        WowApi.UserDefined.Keyboard.IsShiftKeyDown = isDown
        isModifierInput = true
    end

    if (isModifierInput) then
        local isControlKeyDown = WowApi.UserDefined.Keyboard.IsControlKeyDown
        local isShiftKeyDown = WowApi.UserDefined.Keyboard.IsShiftKeyDown

        if (isControlKeyDown and isShiftKeyDown) then
            WowApi.UserDefined.ActionBars:Update("ActionButton")
        elseif (isControlKeyDown) then
            WowApi.UserDefined.ActionBars:Update("MultiBarBottomRightButton")
        elseif (isShiftKeyDown) then
            WowApi.UserDefined.ActionBars:Update("MultiBarBottomLeftButton")
        else
            WowApi.UserDefined.ActionBars:Update("ActionButton")
        end
    end
end
local onPlayerFlagsChanged = function ()
    WowApi.UserDefined.Player.IsAwayFromKeyboard = WowApi.Player.IsAwayFromKeyboard()
    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())
end
local onPlayerRegenDisabled = function ()
    WowApi.UserDefined.Player.IsInCombat = true
    WowApi.GamePad.SetVibration("High", 1.0)
    onPlayerFlagsChanged()
end
local onPlayerRegenEnabled = function ()
    WowApi.UserDefined.Player.IsInCombat = false
    WowApi.GamePad.SetVibration("Low", 0.5)
    onPlayerFlagsChanged()
end
local onPlayerStatusCheck = function ()
    if (isPanicWarranted()) then
        WowApi.UserDefined.GamePad:Panic(1.75, 13)
    end
end
local updateActionButton = function (button, isActiveButtonGroup)
    if (isActiveButtonGroup) then
        button:SetAlpha(GamePadActionBarsDefaultActiveAlpha)
        button.GamePadIconFrame:Show()
    else
        button:SetAlpha(GamePadActionBarsDefaultPassiveAlpha)
        button.GamePadIconFrame:Hide()
    end
end
local userDefinedApi = {
    ActionBars = {
        ActionButton = {},
        MultiBarBottomLeftButton = {},
        MultiBarBottomRightButton = {},
        Settings = {
            OffsetMap = {
                [0] = -120,
                [1] = -80,
                [2] = -120,
                [3] = -160,
                [4] = -160,
                [5] = -120,
            },
            TextureMap = {
                [0] = "Interface/AddOns/WowSandbox/Assets/Icons/64/all_l_up.blp",
                [1] = "Interface/AddOns/WowSandbox/Assets/Icons/64/all_l_right.blp",
                [2] = "Interface/AddOns/WowSandbox/Assets/Icons/64/all_l_down.blp",
                [3] = "Interface/AddOns/WowSandbox/Assets/Icons/64/all_l_left.blp",
                [4] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_s_lb.blp",
                [5] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_s_lsb.blp",
                [6] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_r_y.blp",
                [7] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_r_x.blp",
                [8] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_r_a.blp",
                [9] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_r_b.blp",
                [10] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_s_rb.blp",
                [11] = "Interface/AddOns/WowSandbox/Assets/Icons/64/xbox_s_rsb.blp",
            },
        },
    },
    Colors = {
        IsAwayFromKeyboard = WowApi.Colors.CreateColorFromBytes(255, 255, 0, 255),
        IsInCombatFalse = WowApi.Colors.CreateColorFromBytes(0, 255, 0, 255),
        IsInCombatTrue = WowApi.Colors.CreateColorFromBytes(255, 0, 0, 255)
    },
    Events = {
        RegisterEvent = function (_, eventName) apiFrame:RegisterEvent(eventName) end,
        SetHandler = function (_, functor) onFrameEvent = functor end,
    },
    GamePad = {},
    Keyboard = {
        IsControlKeyDown = false,
        IsShiftKeyDown = false,
    },
    Player = {
        IsAwayFromKeyboard = WowApi.Player.IsAwayFromKeyboard(),
        IsInCombat = WowApi.Player.IsInCombat(),
    },
}
local userDefinedEventHandlerMap = {
    ADDON_LOADED = onAddonLoaded,
    CHAT_MSG_WHISPER = onPlayerStatusCheck,
    PLAYER_FLAGS_CHANGED = onPlayerFlagsChanged,
    PLAYER_REGEN_DISABLED = onPlayerRegenDisabled,
    PLAYER_REGEN_ENABLED = onPlayerRegenEnabled,
    READY_CHECK = onPlayerStatusCheck,
}

function userDefinedApi.ActionBars:Initialize()
    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())

    for i = 0, 35 do
        local actionBarName = "ActionButton"
        local alpha = GamePadActionBarsDefaultActiveAlpha
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isOther = (5 < iMod12)
        local xOffset = GamePadActionBarsDefaultOffsetX
        local yOffset = GamePadActionBarsDefaultOffsetY

        if ((i > 11) and (i < 24)) then
            actionBarName = "MultiBarBottomLeftButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (isOther and -40 or 40)
            yOffset = (yOffset - 80)
        elseif ((i > 23) and (i < 36)) then
            actionBarName = "MultiBarBottomRightButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (isOther and 80 or -80)
            yOffset = (yOffset - 80)
        end

        xOffset = (xOffset + (WowApi.UserDefined.ActionBars.Settings.OffsetMap[iMod6] * (isOther and -1 or 1)))
        yOffset = (((0 == iMod2) and 40 or 0) * (((0 == iMod6) or (4 == iMod6)) and 1 or -1) - yOffset)

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]
        local gamePadIconFrame = WowApi.Frames.CreateFrame("Frame", ((actionBarName .. "GamePadIcon" .. (iMod12 + 1))), actionButton)
        local gamePadIconTexture = gamePadIconFrame:CreateTexture(nil, "OVERLAY")

        actionButton.GamePadIconFrame = gamePadIconFrame
        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconFrame:SetFrameLevel(255)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", xOffset, yOffset)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture(WowApi.UserDefined.ActionBars.Settings.TextureMap[iMod12])
        gamePadIconFrame.Texture = gamePadIconTexture

        apiFrame:SetFrameRef(actionButton:GetName(), actionButton)
        apiFrame:SetFrameRef(gamePadIconFrame:GetName(), gamePadIconFrame)

        if (i > 11) then
            gamePadIconFrame:Hide()
        end
    end

    WowApi.UserDefined.ActionBars:Update("ActionButton")
end
function userDefinedApi.ActionBars:Update(activeActionBar)
    for _, value in pairs(WowApi.UserDefined.ActionBars["ActionButton"]) do
        updateActionButton(value, ("ActionButton" == activeActionBar))
    end

    for _, value in pairs(WowApi.UserDefined.ActionBars["MultiBarBottomLeftButton"]) do
        updateActionButton(value, ("MultiBarBottomLeftButton" == activeActionBar))
    end

    for _, value in pairs(WowApi.UserDefined.ActionBars["MultiBarBottomRightButton"]) do
        updateActionButton(value, ("MultiBarBottomRightButton" == activeActionBar))
    end
end
function userDefinedApi.GamePad:Panic(delayInSeconds, numberOfRings)
    for i = 1, numberOfRings do
        WowApi.Timers.After((i * delayInSeconds), function()
            local ledColor
            local vibrationIntensity
            local vibrationType

            if (0 == (i % 2)) then
                ledColor = WowApi.Colors.CreateColorFromBytes(128, 0, 128, 255)
                vibrationIntensity = 0.65
                vibrationType = "Low"
            else
                ledColor = WowApi.Colors.CreateColorFromBytes(255, 255, 0, 255)
                vibrationIntensity = 0.35
                vibrationType = "High"
            end

            WowApi.GamePad.SetLedColor(ledColor)
            WowApi.GamePad.SetVibration(vibrationType, vibrationIntensity)
        end)
    end
end
function userDefinedApi.Player:GetStatusIndicatorColor()
    return (self.IsInCombat and WowApi.UserDefined.Colors.IsInCombatTrue or (self.IsAwayFromKeyboard and WowApi.UserDefined.Colors.IsAwayFromKeyboard or WowApi.UserDefined.Colors.IsInCombatFalse))
end

apiFrame:HookScript("OnEvent", function(...) onFrameEvent(...) end)
userDefinedApi.Events:SetHandler(function (_, eventName, ...) userDefinedEventHandlerMap[eventName](...) end)

for eventName, _ in pairs(userDefinedEventHandlerMap) do
    userDefinedApi.Events:RegisterEvent(eventName)
end

WowApi.UserDefined = userDefinedApi

apiFrame:EnableGamePadButton(true)
apiFrame:RegisterForClicks("AnyDown", "AnyUp")
apiFrame:SetAttribute("action", 1)
apiFrame:SetAttribute("type", "actionbar")
apiFrame:WrapScript(apiFrame, "OnClick", [[
    local currentPageIndex = self:GetAttribute("action")

    for i = 1, 12 do
        local actionButton = self:GetFrameRef("ActionButton" .. i)
        local actionButtonGamePadIcon = self:GetFrameRef("ActionButtonGamePadIcon" .. i)
        local multiBarBottomLeftButton = self:GetFrameRef("MultiBarBottomLeftButton" .. i)
        local multiBarBottomLeftButtonGamePadIcon = self:GetFrameRef("MultiBarBottomLeftButtonGamePadIcon" .. i)
        local multiBarBottomRightButton = self:GetFrameRef("multiBarBottomRightButton" .. i)
        local multiBarBottomRightButtonGamePadIcon = self:GetFrameRef("multiBarBottomRightButtonGamePadIcon" .. i)

        if (down) then
            actionButton:SetAlpha(0.5)
            actionButtonGamePadIcon:Hide()

            if "PADLTRIGGER" == button then
                --self:SetAttribute("action", 2)
                multiBarBottomLeftButton:SetAlpha(1.0)
                multiBarBottomLeftButtonGamePadIcon:Show()
                multiBarBottomRightButton:SetAlpha(0.5)
            else
                --self:SetAttribute("action", 3)
                multiBarBottomLeftButton:SetAlpha(0.5)
                multiBarBottomRightButton:SetAlpha(1.0)
                multiBarBottomRightButtonGamePadIcon:Show()
            end
        else
            --self:SetAttribute("action", 1)
            actionButton:SetAlpha(1.0)
            actionButtonGamePadIcon:Show()
            multiBarBottomLeftButton:SetAlpha(0.5)
            multiBarBottomRightButton:SetAlpha(0.5)

            if "PADLTRIGGER" == button then
                multiBarBottomLeftButtonGamePadIcon:Hide()
            else
                multiBarBottomRightButtonGamePadIcon:Hide()
            end
        end
    end
]])
SetOverrideBindingClick(apiFrame, true, "PADLTRIGGER", "GamePadActionBarsFrame", "PADLTRIGGER")
SetOverrideBindingClick(apiFrame, true, "PADRTRIGGER", "GamePadActionBarsFrame", "PADRTRIGGER")
