local GamePadActionBarsAddonName = "GamePadActionBars"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = -80
local GamePadActionBarsDefaultPassiveAlpha = 0.5
local GamePadNameDualSense = "DualSense Wireless Controller"
local GamePadNameXboxSeriesX = "Xbox Series X Controller"

WowApi = {
    ConsoleVariables = C_CVar,
    Colors = {
        CreateColorFromBytes = CreateColorFromBytes,
    },
    Frames = {
        CreateFrame = CreateFrame,
        SetOverrideBinding = SetOverrideBinding,
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
            ActionBarDownButton = {
                Frame = ActionBarDownButton,
                IsHidden = true,
            },
            ActionBarUpButton = {
                Frame = ActionBarUpButton,
                IsHidden = true,
            },
            CharacterMicroButton = {
                Frame = CharacterMicroButton,
                IsHidden = false,
            },
            MainMenuBarBackpackButton = {
                Frame = MainMenuBarBackpackButton,
                IsHidden = false,
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
                IsHidden = false,
            },
            MainMenuXPBarTexture0 = {
                Frame = MainMenuXPBarTexture0,
                IsHidden = true,
            },
            MainMenuXPBarTexture1 = {
                Frame = MainMenuXPBarTexture1,
                IsHidden = true,
            },
            MainMenuXPBarTexture2 = {
                Frame = MainMenuXPBarTexture2,
                IsHidden = true,
            },
            MainMenuXPBarTexture3 = {
                Frame = MainMenuXPBarTexture3,
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

    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDUP", "ACTIONBUTTON1")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDRIGHT", "ACTIONBUTTON2")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDDOWN", "ACTIONBUTTON3")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDLEFT", "ACTIONBUTTON4")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSHOULDER", "TARGETSCANENEMY")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSTICK", "ACTIONBUTTON6")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD4", "ACTIONBUTTON7")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD3", "ACTIONBUTTON8")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD1", "JUMP")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD2", "ACTIONBUTTON10")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADRSHOULDER", "INTERACTTARGET")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADRSTICK", "ACTIONBUTTON12")
    WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADLTRIGGER", gamePadActionBarsFrame:GetName(), "PADLTRIGGER")
    WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADRTRIGGER", gamePadActionBarsFrame:GetName(), "PADRTRIGGER")
    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())
    WowApi.UserInterface.MainMenuBar.CharacterMicroButton.Frame:ClearAllPoints()
    WowApi.UserInterface.MainMenuBar.CharacterMicroButton.Frame:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", -80, (GamePadActionBarsDefaultOffsetY - 55))
    WowApi.UserInterface.MainMenuBar.MainMenuBarBackpackButton.Frame:ClearAllPoints()
    WowApi.UserInterface.MainMenuBar.MainMenuBarBackpackButton.Frame:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", 82.5, (GamePadActionBarsDefaultOffsetY - 105))
    WowApi.UserInterface.MainMenuBar.MainMenuBarPageNumber.Frame:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", 0, GamePadActionBarsDefaultOffsetY)
    WowApi.UserInterface.MainMenuBar.MainMenuExpBar.Frame:ClearAllPoints()
    WowApi.UserInterface.MainMenuBar.MainMenuExpBar.Frame:SetPoint("CENTER", WowApi.UserInterface.Parent, "CENTER", 0, (GamePadActionBarsDefaultOffsetY - 35))
    WowApi.UserInterface.MainMenuBar.MainMenuExpBar.Frame:SetWidth(180)

    for _, mainMenuBarItem in pairs(WowApi.UserInterface.MainMenuBar) do
        if (mainMenuBarItem.IsHidden) then
            mainMenuBarItem.Frame:SetParent(gamePadActionBarsFrame)
        end
    end

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

        if ((i == 4) or (i == 8) or (i == 10)) then
            actionButton:SetAlpha(0.0)
        elseif (i > 11) then
            gamePadIconFrame:Hide()
        end
    end
end
local onAddonLoaded = function (key)
    if GamePadActionBarsAddonName == key then
        local gamePadCursorLeftClick = "NONE"

        for deviceId in ipairs(WowApi.GamePad:GetAllDeviceIDs()) do
            local _, rawState = pcall(WowApi.GamePad.GetDeviceRawState, deviceId)

            if nil ~= rawState then
                if GamePadNameDualSense == rawState.name then
                    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADBACK", "TOGGLEWORLDMAP")
                    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSOCIAL", "TOGGLEGAMEMENU")
                end
            end
        end

        WowApi.ConsoleVariables.SetCVar("GamePadAnalogMovement", "1")                     --
        WowApi.ConsoleVariables.SetCVar("GamePadCameraPitchSpeed", 1.5)                   --
        WowApi.ConsoleVariables.SetCVar("GamePadCameraYawSpeed", 2.25)                    --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableJump", "0")              -- 0 = never, 1 (default) = always
        WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableSticks", "1")            -- 0 = never, 1 = on movement, 2 (default) = on cursor or movement
        WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoEnable", "0")                   -- 0 = never, 1 (default) = always
        WowApi.ConsoleVariables.SetCVar("GamePadCursorCenteredEmulation", "0")            --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorCentering", "0")                    --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorForTargeting", "1")                 --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorLeftClick", gamePadCursorLeftClick) --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorOnLogin", "1")                      --
        WowApi.ConsoleVariables.SetCVar("GamePadCursorRightClick", "NONE")                --
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateAlt", "NONE")                      --
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateEsc'", "NONE")                     --
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateCtrl", "NONE")                     --
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateShift", "NONE")                    --
        WowApi.ConsoleVariables.SetCVar("GamePadEmulateTapWindowMs", "0")                 --
        WowApi.ConsoleVariables.SetCVar("GamePadEnable", "1")                             --
        WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngle", "105")             -- 0 (default) = always, 180 = never
        WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngleCombat", "105")       -- 0 = always, 180 (default) = never
        WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")                       --
        WowApi.ConsoleVariables.SetCVar("GamePadOverlapMouseMs", "2000")                  --
        WowApi.ConsoleVariables.SetCVar("GamePadRunThreshold", "0.65")                    --
        WowApi.ConsoleVariables.SetCVar("GamePadStickAxisButtons", "0")                   --
        WowApi.ConsoleVariables.SetCVar("GamePadTankTurnSpeed", "0")                      --
        WowApi.ConsoleVariables.SetCVar("GamePadTouchCursorEnable", "1")                  --
        WowApi.ConsoleVariables.SetCVar("GamePadTurnWithCamera", "2")                     -- 0 = never, 1 = while in combat, 2 = always
        WowApi.ConsoleVariables.SetCVar("GamePadVibrationStrength", "1")                  --
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
    local actionButton5 = self:GetFrameRef("ActionButton5")
    local actionButton9 = self:GetFrameRef("ActionButton9")
    local actionButton11 = self:GetFrameRef("ActionButton11")

    if (down) then
        actionButton9:SetAlpha(1.0)
        actionButton9:Show()
        self:SetBindingClick(true, "PAD1", actionButton9)

        if "PADLTRIGGER" == button then
            self:SetAttribute("PADLTRIGGER", true)

            if self:GetAttribute("PADRTRIGGER") then
                actionButton5:SetAlpha(1.0)
                actionButton5:Show()
                actionButton11:SetAlpha(1.0)
                actionButton11:Show()
                self:SetAttribute("action", 4)
                self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
            else
                self:SetAttribute("action", 2)
                self:SetBinding(true, "PADLSHOULDER", "TARGETNEARESTFRIEND")
                self:SetBinding(true, "PADRSHOULDER", "TOGGLEAUTORUN")
            end
        else
            actionButton5:SetAlpha(1.0)
            actionButton5:Show()
            actionButton11:SetAlpha(1.0)
            actionButton11:Show()
            self:SetAttribute("PADRTRIGGER", true)
            self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
            self:SetBindingClick(true, "PADRSHOULDER", actionButton11)

            if self:GetAttribute("PADLTRIGGER") then
                self:SetAttribute("action", 5)
            else
                self:SetAttribute("action", 3)
            end
        end
    else
        actionButton5:SetAlpha(0.0)
        actionButton9:SetAlpha(0.0)
        actionButton11:SetAlpha(0.0)
        actionButton11:SetBinding(true, "PADRSHOULDER", "INTERACTTARGET")
        self:SetAttribute("action", 1)
        self:SetAttribute("PADLTRIGGER", false)
        self:SetAttribute("PADRTRIGGER", false)
        self:SetBinding(true, "PADLSHOULDER", "TARGETSCANENEMY")
        self:SetBinding(true, "PAD1", "JUMP")
    end
]])

WowApi.UserDefined = userDefinedApi
