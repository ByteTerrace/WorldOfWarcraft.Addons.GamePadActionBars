local GamePadActionBarsAddonName = "GamePadActionBars"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = -80
local GamePadActionBarsDefaultPassiveAlpha = 0.5

WowApi = {
    ConsoleVariables = C_CVar,
    Colors = {
        CreateColorFromBytes = CreateColorFromBytes,
    },
    Frames = {
        CreateFrame = CreateFrame,
        SetOverrideBindingClick = SetOverrideBindingClick,
    },
    GamePad = C_GamePad,
    Player = {
        IsAwayFromKeyboard = IsChatAFK,
        IsInCombat = InCombatLockdown,
    },
    Timers = C_Timer,
    UserInterface = {
        MainMenuBar = {
            CharacterMicroButton = {
                Frame = ActionBarDownButton,
                IsHidden = false,
            },
            ActionBarDownButton = {
                Frame = ActionBarDownButton,
                IsHidden = true,
            },
            ActionBarUpButton = {
                Frame = ActionBarUpButton,
                IsHidden = true,
            },
            MainMenuBarLeftEndCap = {
                Frame = MainMenuBarLeftEndCap,
                IsHidden = true,
            },
            MainMenuBarPageNumber = {
                Frame = MainMenuBarPageNumber,
                IsHidden = false,
            },
            MainMenuBarPerformanceBarFrame = {
                Frame = MainMenuBarPerformanceBarFrame,
                IsHidden = true,
            },
            MainMenuBarRightEndCap = {
                Frame = MainMenuBarRightEndCap,
                IsHidden = true,
            },
            MainMenuBarTexture0 = {
                Frame = MainMenuBarTexture0,
                IsHidden = true,
            },
            MainMenuBarTexture1 = {
                Frame = MainMenuBarTexture1,
                IsHidden = true,
            },
            MainMenuBarTexture2 = {
                Frame = MainMenuBarTexture2,
                IsHidden = true,
            },
            MainMenuBarTexture3 = {
                Frame = MainMenuBarTexture3,
                IsHidden = true,
            },
            MainMenuExpBar = {
                Frame = MainMenuExpBar,
                IsHidden = true,
            },
        },
        Parent = UIParent,
    },
}

local gamePadActionBarsFrame = WowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", WowApi.UserInterface.Parent, "SecureActionButtonTemplate, SecureHandlerBaseTemplate")
local initializeUserInterface = function ()
    local gamePadButtonOffsetMap = {
        [0] = -120,
        [1] = -80,
        [2] = -120,
        [3] = -160,
        [4] = -160,
        [5] = -120,
    }

    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())

    for _, mainMenuBarItem in pairs(WowApi.UserInterface.MainMenuBar) do
        if (mainMenuBarItem.IsHidden) then
            mainMenuBarItem.Frame:SetParent(gamePadActionBarsFrame)
        end
    end

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", -80, GamePadActionBarsDefaultOffsetY - 35)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", 0, GamePadActionBarsDefaultOffsetY - 70)
    WowApi.UserInterface.MainMenuBar.MainMenuBarPageNumber.Frame:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", 0, GamePadActionBarsDefaultOffsetY)

    for i = 0, 35 do
        local actionBarName = "ActionButton"
        local alpha = GamePadActionBarsDefaultActiveAlpha
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isReflection = (5 < iMod12)
        local xOffset = GamePadActionBarsDefaultOffsetX
        local yOffset = GamePadActionBarsDefaultOffsetY

        if ((i > 11) and (i < 24)) then
            actionBarName = "MultiBarBottomLeftButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (isReflection and -40 or 40)
            yOffset = (yOffset - 80)
        elseif ((i > 23) and (i < 36)) then
            actionBarName = "MultiBarBottomRightButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (isReflection and 80 or -80)
            yOffset = (yOffset - 80)
        end

        xOffset = (xOffset + (gamePadButtonOffsetMap[iMod6] * (isReflection and -1 or 1)))
        yOffset = (((0 == iMod2) and 40 or 0) * (((0 == iMod6) or (4 == iMod6)) and 1 or -1) + yOffset)

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]
        local gamePadIconFrame = WowApi.Frames.CreateFrame("Frame", ((actionBarName .. "GamePadIconFrame" .. (iMod12 + 1))), actionButton)
        local gamePadIconTexture = gamePadIconFrame:CreateTexture(((actionBarName .. "GamePadIconTexture" .. (iMod12 + 1))), "OVERLAY")

        actionButton.GamePadIconFrame = gamePadIconFrame
        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconFrame:SetFrameLevel(actionButton:GetFrameLevel() + 1)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", xOffset, yOffset)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture("Interface/AddOns/GamePadActionBars/Assets/Icons/" .. iMod12 .. ".blp")
        gamePadIconFrame.Texture = gamePadIconTexture

        gamePadActionBarsFrame:SetFrameRef(actionButton:GetName(), actionButton)
        gamePadActionBarsFrame:SetFrameRef(gamePadIconFrame:GetName(), gamePadIconFrame)

        if (i > 11) then
            gamePadIconFrame:Hide()
        end
    end
end
local onAddonLoaded = function (key)
    if GamePadActionBarsAddonName == key then
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateAlt", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateCtrl", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateShift", "NONE")
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateTapWindowMs", "0")
        WowApi.ConsoleVariables.SetCVar("GamePadEnable", "1")
        WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")
        initializeUserInterface()
    end
end
local onFrameEvent = function (...) end
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
local userDefinedApi = {
    Colors = {
        IsAwayFromKeyboard = WowApi.Colors.CreateColorFromBytes(255, 255, 0, 255),
        IsInCombatFalse = WowApi.Colors.CreateColorFromBytes(0, 255, 0, 255),
        IsInCombatTrue = WowApi.Colors.CreateColorFromBytes(255, 0, 0, 255)
    },
    Events = {
        RegisterEvent = function (_, eventName) gamePadActionBarsFrame:RegisterEvent(eventName) end,
        SetHandler = function (_, functor) onFrameEvent = functor end,
    },
    Player = {
        IsAwayFromKeyboard = WowApi.Player.IsAwayFromKeyboard(),
        IsInCombat = WowApi.Player.IsInCombat(),
    },
}
local userDefinedEventHandlerMap = {
    ADDON_LOADED = onAddonLoaded,
    PLAYER_FLAGS_CHANGED = onPlayerFlagsChanged,
    PLAYER_REGEN_DISABLED = onPlayerRegenDisabled,
    PLAYER_REGEN_ENABLED = onPlayerRegenEnabled,
}

function userDefinedApi.Player:GetStatusIndicatorColor()
    return (self.IsInCombat and WowApi.UserDefined.Colors.IsInCombatTrue or (self.IsAwayFromKeyboard and WowApi.UserDefined.Colors.IsAwayFromKeyboard or WowApi.UserDefined.Colors.IsInCombatFalse))
end

gamePadActionBarsFrame:Hide()
gamePadActionBarsFrame:HookScript("OnEvent", function(...) onFrameEvent(...) end)
userDefinedApi.Events:SetHandler(function (_, eventName, ...) userDefinedEventHandlerMap[eventName](...) end)

for eventName, _ in pairs(userDefinedEventHandlerMap) do
    userDefinedApi.Events:RegisterEvent(eventName)
end

gamePadActionBarsFrame:EnableGamePadButton(true)
gamePadActionBarsFrame:RegisterForClicks("AnyDown", "AnyUp")
gamePadActionBarsFrame:SetAttribute("action", 1)
gamePadActionBarsFrame:SetAttribute("PADLTRIGGER", false)
gamePadActionBarsFrame:SetAttribute("PADRTRIGGER", false)
gamePadActionBarsFrame:SetAttribute("type", "actionbar")
gamePadActionBarsFrame:WrapScript(gamePadActionBarsFrame, "OnClick", [[
    if (down) then
        if "PADLTRIGGER" == button then
            self:SetAttribute("PADLTRIGGER", true)

            if self:GetAttribute("PADRTRIGGER") then
                self:SetAttribute("action", 4)
            else
                self:SetAttribute("action", 2)
            end
        else
            self:SetAttribute("PADRTRIGGER", true)

            if self:GetAttribute("PADLTRIGGER") then
                self:SetAttribute("action", 5)
            else
                self:SetAttribute("action", 3)
            end
        end
    else
        self:SetAttribute("action", 1)
        self:SetAttribute("PADLTRIGGER", false)
        self:SetAttribute("PADRTRIGGER", false)
    end
]])

WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADLTRIGGER", "GamePadActionBarsFrame", "PADLTRIGGER")
WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADRTRIGGER", "GamePadActionBarsFrame", "PADRTRIGGER")
WowApi.UserDefined = userDefinedApi
