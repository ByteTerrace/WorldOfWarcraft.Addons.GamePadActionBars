local GamePadNameDualSense = "DualSense Wireless Controller"
local GamePadNameXboxSeriesX = "Xbox Series X Controller"
local GamePadActionBarsAddonName = "GamePadActionBars"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = 100
local GamePadActionBarsDefaultPassiveAlpha = 0.5
local GamePadActionBarsPadLshoulderState1Binding = "TARGETNEARESTENEMY"
local GamePadActionBarsPadLshoulderState2Binding = "TARGETNEARESTFRIEND"
local GamePadActionBarsPadLshoulderState3Binding = "FLIPCAMERAYAW"
local GamePadActionBarsPadRshoulderState1Binding = "INTERACTMOUSEOVER"
local GamePadActionBarsPadRshoulderState2Binding = "TOGGLEAUTORUN"
local GamePadActionBarsPadRshoulderState3Binding = "TOGGLESHEATH"
local GamePadActionBarsPreferredControllerType = GamePadNameDualSense

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
    UserInterface = {
        Camera = {
            ZoomIn = CameraZoomIn,
            ZoomOut = CameraZoomOut,
        },
        HiddenFrames = {
            ActionBarDownButton,
            ActionBarUpButton,
            MainMenuBarLeftEndCap,
            MainMenuBarPerformanceBarFrame,
            MainMenuBarRightEndCap,
            MainMenuBarTexture0,
            MainMenuBarTexture1,
            MainMenuBarTexture2,
            MainMenuBarTexture3,
            MainMenuXPBarTexture0,
            MainMenuXPBarTexture1,
            MainMenuXPBarTexture2,
            MainMenuXPBarTexture3,
            ReputationWatchBar.StatusBar.WatchBarTexture0,
            ReputationWatchBar.StatusBar.WatchBarTexture1,
            ReputationWatchBar.StatusBar.WatchBarTexture2,
            ReputationWatchBar.StatusBar.WatchBarTexture3,
            ReputationWatchBar.StatusBar.XPBarTexture0,
            ReputationWatchBar.StatusBar.XPBarTexture1,
            ReputationWatchBar.StatusBar.XPBarTexture2,
            ReputationWatchBar.StatusBar.XPBarTexture3,
        },
        Parent = UIParent,
        ResetView = ResetView,
        SaveView = SaveView,
        SetView = SetView,
    },
}

local gamePadActionBarsFrame = WowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", WowApi.UserInterface.Parent, "SecureActionButtonTemplate, SecureHandlerBaseTemplate")
local initializeGamePadBindings = function ()
    local isDualSenseControllerConnected = false
    local isXboxControllerConnected = false

    for deviceId in ipairs(WowApi.GamePad:GetAllDeviceIDs()) do
        local _, rawState = pcall(WowApi.GamePad.GetDeviceRawState, deviceId)

        if nil ~= rawState then
            if GamePadNameDualSense == rawState.name then
                isDualSenseControllerConnected = true
            elseif GamePadNameXboxSeriesX == rawState.name then
                isXboxControllerConnected = true
            end
        end
    end

    if (isDualSenseControllerConnected and (GamePadActionBarsPreferredControllerType == GamePadNameDualSense)) then
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADBACK", "TOGGLEWORLDMAP")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSOCIAL", "TOGGLEQUESTLOG")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD6", "TOGGLEWORLDMAP")
    elseif (isXboxControllerConnected and (GamePadActionBarsPreferredControllerType == GamePadNameXboxSeriesX)) then
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADBACK", "TOGGLEWORLDMAP")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSYSTEM", "TOGGLEQUESTLOG")
    end

    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADFORWARD", "TOGGLEGAMEMENU")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDUP", "ACTIONBUTTON1")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDRIGHT", "ACTIONBUTTON2")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDDOWN", "ACTIONBUTTON3")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDLEFT", "ACTIONBUTTON4")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSHOULDER", GamePadActionBarsPadLshoulderState1Binding)
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSTICK", "ACTIONBUTTON6")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD4", "ACTIONBUTTON7")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD3", "ACTIONBUTTON8")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD1", "JUMP")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD2", "ACTIONBUTTON10")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADRSHOULDER", GamePadActionBarsPadRshoulderState1Binding)
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADRSTICK", "ACTIONBUTTON12")
    WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADLTRIGGER", gamePadActionBarsFrame:GetName(), "PADLTRIGGER")
    WowApi.Frames.SetOverrideBindingClick(gamePadActionBarsFrame, true, "PADRTRIGGER", gamePadActionBarsFrame:GetName(), "PADRTRIGGER")
end
local initializeUserInterface = function ()
    local characterMicroButtonWidth = ((CharacterMicroButton:GetWidth() * 2.625))

    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("CENTER", WowApi.UserInterface.Parent, "BOTTOM", GamePadActionBarsDefaultOffsetX, GamePadActionBarsDefaultOffsetY)
    MainMenuBar:SetSize(32, 32)
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("CENTER", -characterMicroButtonWidth, -10)
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("CENTER", CharacterMicroButton, "CENTER", (MainMenuBarBackpackButton:GetWidth() * 4.39393939393939), -50)
    MainMenuBarPageNumber:SetPoint("CENTER", 0, 50)
    MainMenuExpBar:SetWidth(characterMicroButtonWidth * 2)
    ReputationWatchBar:SetWidth(characterMicroButtonWidth * 2)
    ReputationWatchBar.StatusBar:SetWidth(ReputationWatchBar:GetWidth())
    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())

    for _, frame in pairs(WowApi.UserInterface.HiddenFrames) do
        frame:SetParent(gamePadActionBarsFrame)
    end

    for i = 0, 35 do
        local actionBarName = "ActionButton"
        local alpha = GamePadActionBarsDefaultActiveAlpha
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isReflection = (5 < iMod12)
        local xOffset = ((((1 == iMod6) or (3 == iMod6) or (4 == iMod6)) and ((1 == iMod6) and 80 or 160) or 120) * (isReflection and 1 or -1))
        local yOffset = (50 + ((1 == iMod2) and 0 or 40) * ((((0 == iMod6) or (4 == iMod6))) and 1 or -1))

        if ((i > 11) and (i < 24)) then
            actionBarName = "MultiBarBottomLeftButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (xOffset + (40 * (isReflection and -1 or 1)))
            yOffset = (yOffset + 80)
        elseif ((i > 23) and (i < 36)) then
            actionBarName = "MultiBarBottomRightButton"
            alpha = GamePadActionBarsDefaultPassiveAlpha
            xOffset = (xOffset + (80 * (isReflection and 1 or -1)))
            yOffset = (yOffset + 80)
        end

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]
        local gamePadIconFrame = WowApi.Frames.CreateFrame("Frame", ((actionBarName .. "GamePadIconFrame" .. (iMod12 + 1))), actionButton)
        local gamePadIconTexture = gamePadIconFrame:CreateTexture(((actionBarName .. "GamePadIconTexture" .. (iMod12 + 1))), "OVERLAY")

        actionButton.GamePadIconFrame = gamePadIconFrame
        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", MainMenuBar, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconFrame:SetFrameLevel(actionButton:GetFrameLevel() + 1)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", 0, 0)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture("Interface/AddOns/GamePadActionBars/Assets/Icons/" .. iMod12 .. ".blp")
        gamePadIconFrame.Texture = gamePadIconTexture

        if ((i == 4) or (i == 8) or (i == 10)) then
            actionButton:SetAlpha(0.0)
        elseif (i > 11) then
            gamePadIconFrame:Hide()
        end

        gamePadActionBarsFrame:SetFrameRef(actionButton:GetName(), actionButton)
    end
end
local onAddonLoaded = function (key)
    if GamePadActionBarsAddonName == key then
        initializeGamePadBindings()
        initializeUserInterface()
    end
end
local onFrameEvent = function (...) end
local onPlayerEnteringWorld = function()
    WowApi.ConsoleVariables.SetCVar("CameraKeepCharacterCentered", "0")            --
    WowApi.ConsoleVariables.SetCVar("GamePadAnalogMovement", "1")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraPitchSpeed", "1.5")              --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraYawSpeed", "2.25")               --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableJump", "1")           --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableSticks", "1")         -- 0 = never, 1 = on movement, 2 = on cursor or movement
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoEnable", "0")                --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorCenteredEmulation", "0")         --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorCentering", "0")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorForTargeting", "0")              --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorLeftClick", "NONE")              --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorOnLogin", "1")                   --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorRightClick", "NONE")             --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateAlt", "NONE")                   --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateEsc'", "NONE")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateCtrl", "NONE")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateShift", "NONE")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateTapWindowMs", "350")            --
    WowApi.ConsoleVariables.SetCVar("GamePadEnable", "1")                          --
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngle", "105")          -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngleCombat", "105")    -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")                    --
    WowApi.ConsoleVariables.SetCVar("GamePadOverlapMouseMs", "2000")               --
    WowApi.ConsoleVariables.SetCVar("GamePadRunThreshold", "0.65")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadStickAxisButtons", "0")                --
    WowApi.ConsoleVariables.SetCVar("GamePadTankTurnSpeed", "0.0")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadTouchCursorEnable", "1")               --
    WowApi.ConsoleVariables.SetCVar("GamePadTurnWithCamera", "2")                  -- 0 = never, 1 = while in combat, 2 = always
    WowApi.ConsoleVariables.SetCVar("GamePadVibrationStrength", "1")               --
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemy", "1")                        -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemyArc", "1")                     -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemyRange", "30.0")                --
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriend", "1")                       -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriendArc", "1")                    -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriendRange", "10.0")               --
    WowApi.ConsoleVariables.SetCVar("SoftTargetForce", "0")                        -- 0 = never, 1 = enemies, 2 = friends
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteract", "1")                     -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteractArc", "1")                  -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteractRange", "2.5")              --

    -- EXPERIMENTAL: action camera configuration
    WowApi.UserInterface.Parent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitch", "1")
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitchBaseFovPad", "0.65")             -- min is 0.4, max is 1.0
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitchBaseFovPadDownScale", "0.25")    -- min is 0.25, max is 1.0
    WowApi.ConsoleVariables.SetCVar("test_cameraHeadMovementStrength", "1")
    WowApi.ConsoleVariables.SetCVar("test_cameraHeadMovementMovingStrength", "1.0")
    WowApi.ConsoleVariables.SetCVar("test_cameraOverShoulder", "0.475")                       -- min is ???, max is ???
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractEnable", "1")
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractStrengthPitch", "0.75")   -- min is ???, max is ???
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractStrengthYaw", "1.0")      -- min is ???, max is ???
    WowApi.UserInterface.ResetView(5)
    WowApi.UserInterface.SetView(5)
    WowApi.UserInterface.Camera.ZoomOut(50.0)
    WowApi.UserInterface.Camera.ZoomIn(2.5)
    WowApi.UserInterface.SaveView(5)
end
local onPlayerFlagsChanged = function ()
    WowApi.UserDefined.Player.IsAwayFromKeyboard = WowApi.Player.IsAwayFromKeyboard()
    WowApi.GamePad.SetLedColor(WowApi.UserDefined.Player:GetStatusIndicatorColor())
end
local onPlayerInteractionManagerShow = function() end
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
    PLAYER_ENTERING_WORLD = onPlayerEnteringWorld,
    PLAYER_FLAGS_CHANGED = onPlayerFlagsChanged,
    PLAYER_INTERACTION_MANAGER_FRAME_SHOW = onPlayerInteractionManagerShow,
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
gamePadActionBarsFrame:SetAttribute("ActionBarPage-State1", 1)
gamePadActionBarsFrame:SetAttribute("ActionBarPage-State2", 2)
gamePadActionBarsFrame:SetAttribute("ActionBarPage-State3", 3)
gamePadActionBarsFrame:SetAttribute("ActionBarPage-State4", 4)
gamePadActionBarsFrame:SetAttribute("ActionBarPage-State5", 5)
gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State1", GamePadActionBarsPadLshoulderState1Binding)
gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State2", GamePadActionBarsPadLshoulderState2Binding)
gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State3", GamePadActionBarsPadLshoulderState3Binding)
gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State1", GamePadActionBarsPadRshoulderState1Binding)
gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State2", GamePadActionBarsPadRshoulderState2Binding)
gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State3", GamePadActionBarsPadRshoulderState3Binding)
gamePadActionBarsFrame:SetAttribute("PadTriggerLeft-IsDown", false)
gamePadActionBarsFrame:SetAttribute("PadTriggerRight-IsDown", false)
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
            self:SetAttribute("PadTriggerLeft-IsDown", true)

            if self:GetAttribute("PadTriggerRight-IsDown") then
                actionButton5:SetAlpha(1.0)
                actionButton5:Show()
                actionButton11:SetAlpha(1.0)
                actionButton11:Show()
                self:SetAttribute("action", self:GetAttribute("ActionBarPage-State4"))
                self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
            else
                self:SetAttribute("action", self:GetAttribute("ActionBarPage-State2"))
                self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State2"))
                self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State2"))
            end
        else
            self:SetAttribute("PadTriggerRight-IsDown", true)

            if self:GetAttribute("PadTriggerLeft-IsDown") then
                actionButton5:SetAlpha(1.0)
                actionButton5:Show()
                actionButton11:SetAlpha(1.0)
                actionButton11:Show()
                self:SetAttribute("action", self:GetAttribute("ActionBarPage-State5"))
                self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
            else
                self:SetAttribute("action", self:GetAttribute("ActionBarPage-State3"))
                self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State3"))
                self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State3"))
            end
        end
    else
        actionButton5:SetAlpha(0.0)
        actionButton9:SetAlpha(0.0)
        actionButton11:SetAlpha(0.0)
        self:SetAttribute("action", self:GetAttribute("ActionBarPage-State1"))
        self:SetAttribute("PadTriggerLeft-IsDown", false)
        self:SetAttribute("PadTriggerRight-IsDown", false)
        self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State1"))
        self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State1"))
        self:SetBinding(true, "PAD1", "JUMP")
    end
]])

WowApi.UserDefined = userDefinedApi
