local GamePadActionBarsCustomPadNameSelect = "PADSOCIAL"
local GamePadActionBarsCustomPadNameStart = "PADFORWARD"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = 85
local GamePadActionBarsDefaultPassiveAlpha = 0.5
local GamePadActionBarsPadLshoulderState1Binding = "TARGETNEARESTENEMY"
local GamePadActionBarsPadLshoulderState2Binding = "TARGETNEARESTFRIEND"
local GamePadActionBarsPadLshoulderState3Binding = "TOGGLESHEATH"
local GamePadActionBarsPadRshoulderState1Binding = "INTERACTMOUSEOVER"
local GamePadActionBarsPadRshoulderState2Binding = "TOGGLEAUTORUN"
local GamePadActionBarsPadRshoulderState3Binding = "FLIPCAMERAYAW"
local GamePadActionBarsPadSelectState1Binding = "TOGGLEWORLDMAP"
local GamePadActionBarsPadSelectState2Binding = "TOGGLESOCIAL"
local GamePadActionBarsPadSelectState3Binding = "TOGGLECHARACTER0"
local GamePadActionBarsPadStartState1Binding = "TOGGLEGAMEMENU"
local GamePadActionBarsPadStartState2Binding = "TOGGLEGAMEMENU"
local GamePadActionBarsPadStartState3Binding = "TOGGLEGAMEMENU"
local GamePadVendorIdDualSense = 1356
local GamePadVendorIdNintendoSwitchPro = 1406
local GamePadVendorIdXboxSeriesX = 1118

WowApi = {
    Camera = {
        ResetView = ResetView,
        SaveView = SaveView,
        SetView = SetView,
        ZoomIn = CameraZoomIn,
        ZoomOut = CameraZoomOut,
    },
    ConsoleVariables = {},
    Colors = {
        CreateColorFromBytes = CreateColorFromBytes,
    },
    Frames = {
        ClearOverrideBindings = ClearOverrideBindings,
        CreateFrame = CreateFrame,
        RegisterAttributeDriver = RegisterAttributeDriver,
        SetOverrideBinding = SetOverrideBinding,
        SetOverrideBindingClick = SetOverrideBindingClick,
    },
    GamePad = C_GamePad,
    Player = {
        IsAwayFromKeyboard = IsChatAFK(),
        IsInCombat = InCombatLockdown(),
    },
    Timers = {},
    UserInterface = {
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
            SlidingActionBarTexture0,
            SlidingActionBarTexture1,
        },
        ModifiedFrames = {
            CastingBarFrame = CastingBarFrame,
            CharacterMicroButton = CharacterMicroButton,
            FramerateText = FramerateText,
            HelpMicroButton = HelpMicroButton,
            MainMenuBar = MainMenuBar,
            MainMenuBarBackpackButton = MainMenuBarBackpackButton,
            MainMenuBarPageNumber = MainMenuBarPageNumber,
            MainMenuExpBar = MainMenuExpBar,
            MainMenuMicroButton = MainMenuMicroButton,
            PetActionBarFrame = PetActionBarFrame,
            PetActionButton1 = PetActionButton1,
            QuestLogMicroButton = QuestLogMicroButton,
            ReputationWatchBar = ReputationWatchBar,
            SocialsMicroButton = SocialsMicroButton,
            SpellbookMicroButton = SpellbookMicroButton,
            TalentMicroButton = TalentMicroButton,
            WorldMapMicroButton = WorldMapMicroButton,
        },
        Parent = UIParent,
    },
}

local hookFrameVisibility = function (widget)
    -- EXPERIMENTAL: d-pad menu interaction
    if C_Widget.IsFrameWidget(widget) then
        local activeIndex = 1
        local descendants = {}
        local frameVisibilityHandler = WowApi.Frames.CreateFrame("Button", (widget:GetName() .. "VisibilityHandler"), widget, "SecureActionButtonTemplate, SecureHandlerBaseTemplate")
        local nextDescendantAction = function (frame)
            if ((frame ~= frameVisibilityHandler) and frame:HasScript("OnClick") and frame:IsObjectType("Button") and frame:IsVisible()) then
                descendants[(#descendants + 1)] = frame
            end
        end
        local onClick = function (_, button)
            activeIndex = (activeIndex - 1)

            if ("PADDUP" == button) then
                activeIndex = (activeIndex - 1)
            elseif ("PADDDOWN" == button) then
                activeIndex = (activeIndex + 1)
            end

            activeIndex = ((activeIndex % #descendants) + 1)

            WowApi.GamePad.CursorFrame.Texture:ClearAllPoints()
            WowApi.GamePad.CursorFrame.Texture:SetParent(descendants[activeIndex])
            WowApi.GamePad.CursorFrame.Texture:SetPoint("RIGHT", 0, 0)
            WowApi.GamePad.CursorFrame:SetAttribute("clickbutton", descendants[activeIndex])
        end
        local onMouseDown = function () ExecuteFrameScript(descendants[activeIndex], "OnMouseDown") end
        local onMouseUp = function () ExecuteFrameScript(descendants[activeIndex], "OnMouseUp") end
        local onNextFrameTimer = WowApi.Timers:CreateTimer(0, function (self)
            if not (InCombatLockdown()) then
                for key, _ in pairs(descendants) do descendants[key] = nil end

                activeIndex = 1

                WowApi.Frames.ClearOverrideBindings(self)
                WowApi.Frames:EnumerateDescendants(self:GetParent(), nextDescendantAction)
                WowApi.Frames.SetOverrideBindingClick(self, true, "PAD1", WowApi.GamePad.CursorFrame:GetName(), "LeftButton")
                WowApi.Frames.SetOverrideBindingClick(self, true, "PADDUP", self:GetName(), "PADDUP")
                WowApi.Frames.SetOverrideBindingClick(self, true, "PADDRIGHT", self:GetName(), "PADDRIGHT")
                WowApi.Frames.SetOverrideBindingClick(self, true, "PADDDOWN", self:GetName(), "PADDDOWN")
                WowApi.Frames.SetOverrideBindingClick(self, true, "PADDLEFT", self:GetName(), "PADDLEFT")
                WowApi.GamePad.CursorFrame.Texture:ClearAllPoints()
                WowApi.GamePad.CursorFrame.Texture:SetParent(descendants[activeIndex])
                WowApi.GamePad.CursorFrame.Texture:SetPoint("RIGHT", 0, 0)
                WowApi.GamePad.CursorFrame:SetAttribute("clickbutton", descendants[activeIndex])
                WowApi.GamePad.CursorFrame:SetScript("OnMouseDown", onMouseDown)
                WowApi.GamePad.CursorFrame:SetScript("OnMouseUp", onMouseUp)
            end
        end)
        local onShow = function (self) WowApi.Timers:StartTimer(onNextFrameTimer, self) end

        frameVisibilityHandler:SetScript("OnClick", onClick)
        frameVisibilityHandler:SetScript("OnShow", onShow)
        frameVisibilityHandler:WrapScript(frameVisibilityHandler, "OnHide", "self:ClearBindings()")
    end
end
local initializeCameraVariables = function ()
    -- EXPERIMENTAL: action camera configuration
    WowApi.UserInterface.Parent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
    WowApi.ConsoleVariables:Set("CameraKeepCharacterCentered", false)
    WowApi.ConsoleVariables:Set("test_cameraDynamicPitch", 1.0)
    WowApi.ConsoleVariables:Set("test_cameraDynamicPitchBaseFovPad", 0.875)
    WowApi.ConsoleVariables:Set("test_cameraDynamicPitchBaseFovPadDownScale", 1.0)
    WowApi.ConsoleVariables:Set("test_cameraHeadMovementStrength", 1.0)
    WowApi.ConsoleVariables:Set("test_cameraHeadMovementMovingStrength", 1.0)
    WowApi.ConsoleVariables:Set("test_cameraOverShoulder", 0.475)
    WowApi.ConsoleVariables:Set("test_cameraTargetFocusInteractEnable", true)
    WowApi.ConsoleVariables:Set("test_cameraTargetFocusInteractStrengthPitch", 0.75)
    WowApi.ConsoleVariables:Set("test_cameraTargetFocusInteractStrengthYaw", 1.0)
end
local initializeGamePadVariables = function ()
    WowApi.ConsoleVariables:Set("GamePadAnalogMovement", true)
    WowApi.ConsoleVariables:Set("GamePadCameraPitchSpeed", 1.5)
    WowApi.ConsoleVariables:Set("GamePadCameraYawSpeed", 2.25)
    WowApi.ConsoleVariables:Set("GamePadCursorAutoDisableJump", true)
    WowApi.ConsoleVariables:Set("GamePadCursorAutoDisableSticks", "2")
    WowApi.ConsoleVariables:Set("GamePadCursorAutoEnable", false)
    WowApi.ConsoleVariables:Set("GamePadCursorCenteredEmulation", false)
    WowApi.ConsoleVariables:Set("GamePadCursorCentering", false)
    WowApi.ConsoleVariables:Set("GamePadCursorForTargeting", false)
    WowApi.ConsoleVariables:Set("GamePadCursorLeftClick", "NONE")
    WowApi.ConsoleVariables:Set("GamePadCursorOnLogin", true)
    WowApi.ConsoleVariables:Set("GamePadCursorRightClick", "NONE")
    WowApi.ConsoleVariables:Set("GamePadEmulateAlt", "NONE")
    WowApi.ConsoleVariables:Set("GamePadEmulateCtrl", "NONE")
    WowApi.ConsoleVariables:Set("GamePadEmulateShift", "NONE")
    WowApi.ConsoleVariables:Set("GamePadEmulateTapWindowMs", 350)
    WowApi.ConsoleVariables:Set("GamePadEnable", true)
    WowApi.ConsoleVariables:Set("GamePadFaceMovementMaxAngle", 115.0)
    WowApi.ConsoleVariables:Set("GamePadFaceMovementMaxAngleCombat", 115.0)
    WowApi.ConsoleVariables:Set("GamePadFactionColor", false)
    WowApi.ConsoleVariables:Set("GamePadOverlapMouseMs", 2000)
    WowApi.ConsoleVariables:Set("GamePadRunThreshold", 0.65)
    WowApi.ConsoleVariables:Set("GamePadStickAxisButtons", false)
    WowApi.ConsoleVariables:Set("GamePadTankTurnSpeed", 0.0)
    WowApi.ConsoleVariables:Set("GamePadTouchCursorEnable", false)
    WowApi.ConsoleVariables:Set("GamePadTurnWithCamera", "2")
    WowApi.ConsoleVariables:Set("GamePadVibrationStrength", 1.0)
    WowApi.ConsoleVariables:Set("SoftTargetEnemy", "1")
    WowApi.ConsoleVariables:Set("SoftTargetEnemyArc", "1")
    WowApi.ConsoleVariables:Set("SoftTargetEnemyRange", 30.0)
    WowApi.ConsoleVariables:Set("SoftTargetFriend", "1")
    WowApi.ConsoleVariables:Set("SoftTargetFriendArc", "1")
    WowApi.ConsoleVariables:Set("SoftTargetFriendRange", 10.0)
    WowApi.ConsoleVariables:Set("SoftTargetForce", "0")
    WowApi.ConsoleVariables:Set("SoftTargetInteract", "1")
    WowApi.ConsoleVariables:Set("SoftTargetInteractArc", "1")
    WowApi.ConsoleVariables:Set("SoftTargetInteractRange", 2.5)
end
local onAddonLoaded = function (key)
    local handler = WowApi.Addons.HandlerMap[key]

    if (nil ~= handler) then
        handler()
    end
end
local onAddonLoaded_Blizzard_TalentUI = function()
    hookFrameVisibility(_G["PlayerTalentFrame"])
end
local onAddonLoaded_ByteTerrace_GamePadActionBars = function()
    local gamePadActionBarsFrame = WowApi.GamePad.ActionBarsFrame
    local gamePadCursorFrame = WowApi.GamePad.CursorFrame

    WowApi.GamePad:InitializeBindings(gamePadActionBarsFrame)
    WowApi.GamePad:InitializeCursor(gamePadCursorFrame)
    WowApi.GamePad:InitializeDriver(gamePadActionBarsFrame)
    WowApi.GamePad:InitializeUserInterface(gamePadActionBarsFrame)
end
local onFrameEvent = function (...) end
local onPlayerEnteringWorld = function (isInitialLogin)
    if isInitialLogin then
        initializeCameraVariables()
        initializeGamePadVariables()
    end

    WowApi.Camera.ResetView(5)
    WowApi.Camera.SetView(5)
    WowApi.Camera.ZoomOut(50.0)
    WowApi.Camera.ZoomIn(1.25)
    WowApi.Camera.SaveView(5)
    WowApi.GamePad.SetLedColor(WowApi.Player:GetStatusIndicatorColor())
end
local onPlayerFlagsChanged = function ()
    WowApi.Player.IsAwayFromKeyboard = IsChatAFK()
    WowApi.GamePad.SetLedColor(WowApi.Player:GetStatusIndicatorColor())
end
local onPlayerInteractionManagerShow = function() end
local onPlayerRegenDisabled = function ()
    WowApi.Player.IsInCombat = true
    WowApi.GamePad.SetVibration("High", 1.0)
    onPlayerFlagsChanged()
end
local onPlayerRegenEnabled = function ()
    WowApi.Player.IsInCombat = false
    WowApi.GamePad.SetVibration("Low", 0.5)
    onPlayerFlagsChanged()
end

WowApi.Addons = {
    HandlerMap = {
        Blizzard_TalentUI = onAddonLoaded_Blizzard_TalentUI,
        ByteTerrace_GamePadActionBars = onAddonLoaded_ByteTerrace_GamePadActionBars,
    },
}
WowApi.Colors.IsAwayFromKeyboard = WowApi.Colors.CreateColorFromBytes(255, 255, 0, 255)
WowApi.Colors.IsInCombat = WowApi.Colors.CreateColorFromBytes(255, 0, 0, 255)
WowApi.Colors.IsNeutral = WowApi.Colors.CreateColorFromBytes(0, 255, 0, 255)
WowApi.Events = {
    HandlerMap = {
        ADDON_LOADED = onAddonLoaded,
        PLAYER_ENTERING_WORLD = onPlayerEnteringWorld,
        PLAYER_FLAGS_CHANGED = onPlayerFlagsChanged,
        PLAYER_INTERACTION_MANAGER_FRAME_SHOW = onPlayerInteractionManagerShow,
        PLAYER_REGEN_DISABLED = onPlayerRegenDisabled,
        PLAYER_REGEN_ENABLED = onPlayerRegenEnabled,
    },
    RegisterEvent = function (_, eventName) WowApi.GamePad.ActionBarsFrame:RegisterEvent(eventName) end,
    SetHandler = function (_, functor) onFrameEvent = functor end,
}
WowApi.GamePad.ActionBarsFrame = WowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", WowApi.UserInterface.Parent, "SecureActionButtonTemplate, SecureHandlerStateTemplate")
WowApi.GamePad.ButtonIconMap = {
    [0] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_dpad_up.blp",
    [1] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_dpad_right.blp",
    [2] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_dpad_down.blp",
    [3] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_dpad_left.blp",
    [4] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_trigger_button_left_1.blp",
    [5] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_stick_button_left.blp",
    [6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_unknown.blp",
    [7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_unknown.blp",
    [8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_unknown.blp",
    [9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_unknown.blp",
    [10] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_trigger_button_right_1.blp",
    [11] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/generic_stick_button_right.blp",
}
WowApi.GamePad.CursorFrame = WowApi.Frames.CreateFrame("Button", "GamePadCursorFrame", WowApi.UserInterface.Parent, "SecureActionButtonTemplate, SecureHandlerBaseTemplate")

function WowApi.ConsoleVariables:Reset(key)
    C_CVar.SetCVar(key, C_CVar.GetCVarDefault(key))
end
function WowApi.ConsoleVariables:Set(key, value)
    local valueType = type(value)

    if ("boolean" == valueType) then
        value = (value and "1" or "0")
    elseif ("number" == valueType) then
        value = tostring(value)
    end

    C_CVar.SetCVar(key, value)
end
function WowApi.Frames:EnumerateDescendants(parent, action)
    for i = 1, select("#", parent:GetChildren()) do
        local child = select(i, parent:GetChildren())

        action(child)

        self:EnumerateDescendants(child, action)
    end
end
function WowApi.GamePad:InitializeBindings(frame)
    local isDualSenseControllerConnected = false
    local isNintendoSwitchProControllerConnected = false
    local isXboxControllerConnected = false

    for deviceId in ipairs(self:GetAllDeviceIDs()) do
        local _, rawState = pcall(self.GetDeviceRawState, deviceId)

        if (nil ~= rawState) then
            if (GamePadVendorIdDualSense == rawState.vendorID) then
                --[[ Validated for:
                    - Official PlayStation 5 DualSense Controller: Bluetooth/USBC
                ]]
                isDualSenseControllerConnected = true
            elseif (GamePadVendorIdNintendoSwitchPro == rawState.vendorID) then
                --[[ Validated for:
                    - Official Nintendo Switch Pro Controller: Bluetooth/USBC
                ]]
                isNintendoSwitchProControllerConnected = true
            elseif (GamePadVendorIdXboxSeriesX == rawState.vendorID) then
                --[[ Validated for:
                    - Official Xbox Series X Controller: Bluetooth/USBC
                ]]
                isXboxControllerConnected = true
            end
        end
    end

    if isDualSenseControllerConnected then
        GamePadActionBarsCustomPadNameSelect = "PADSOCIAL"
        GamePadActionBarsCustomPadNameStart = "PADFORWARD"
        WowApi.GamePad.ButtonIconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_triangle.blp"
        WowApi.GamePad.ButtonIconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_square.blp"
        WowApi.GamePad.ButtonIconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_cross.blp"
        WowApi.GamePad.ButtonIconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_circle.blp"
    elseif isNintendoSwitchProControllerConnected then
        GamePadActionBarsCustomPadNameSelect = "PADBACK"
        GamePadActionBarsCustomPadNameStart = "PADFORWARD"
        WowApi.GamePad.ButtonIconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_x.blp"
        WowApi.GamePad.ButtonIconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_y.blp"
        WowApi.GamePad.ButtonIconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_b.blp"
        WowApi.GamePad.ButtonIconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_a.blp"
    elseif isXboxControllerConnected then
        GamePadActionBarsCustomPadNameSelect = "PADBACK"
        GamePadActionBarsCustomPadNameStart = "PADFORWARD"
        WowApi.GamePad.ButtonIconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_y.blp"
        WowApi.GamePad.ButtonIconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_x.blp"
        WowApi.GamePad.ButtonIconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_a.blp"
        WowApi.GamePad.ButtonIconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_b.blp"
    end

    frame:SetAttribute("CustomPadName-Select", GamePadActionBarsCustomPadNameSelect)
    frame:SetAttribute("CustomPadName-Start", GamePadActionBarsCustomPadNameStart)
    frame:SetAttribute("PadSelectBinding-State1", GamePadActionBarsPadSelectState1Binding)
    frame:SetAttribute("PadSelectBinding-State2", GamePadActionBarsPadSelectState2Binding)
    frame:SetAttribute("PadSelectBinding-State3", GamePadActionBarsPadSelectState3Binding)
    frame:SetAttribute("PadShoulderLeftBinding-State1", GamePadActionBarsPadLshoulderState1Binding)
    frame:SetAttribute("PadShoulderLeftBinding-State2", GamePadActionBarsPadLshoulderState2Binding)
    frame:SetAttribute("PadShoulderLeftBinding-State3", GamePadActionBarsPadLshoulderState3Binding)
    frame:SetAttribute("PadShoulderRightBinding-State1", GamePadActionBarsPadRshoulderState1Binding)
    frame:SetAttribute("PadShoulderRightBinding-State2", GamePadActionBarsPadRshoulderState2Binding)
    frame:SetAttribute("PadShoulderRightBinding-State3", GamePadActionBarsPadRshoulderState3Binding)
    frame:SetAttribute("PadStartBinding-State1", GamePadActionBarsPadStartState1Binding)
    frame:SetAttribute("PadStartBinding-State2", GamePadActionBarsPadStartState2Binding)
    frame:SetAttribute("PadStartBinding-State3", GamePadActionBarsPadStartState3Binding)

    WowApi.Frames.SetOverrideBinding(frame, true, GamePadActionBarsCustomPadNameSelect, GamePadActionBarsPadSelectState1Binding)
    WowApi.Frames.SetOverrideBinding(frame, true, GamePadActionBarsCustomPadNameStart, GamePadActionBarsPadStartState1Binding)
    WowApi.Frames.SetOverrideBinding(frame, true, "PADDUP", "ACTIONBUTTON1")
    WowApi.Frames.SetOverrideBinding(frame, true, "PADDRIGHT", "ACTIONBUTTON2")
    WowApi.Frames.SetOverrideBinding(frame, true, "PADDDOWN", "ACTIONBUTTON3")
    WowApi.Frames.SetOverrideBinding(frame, true, "PADDLEFT", "ACTIONBUTTON4")
    WowApi.Frames.SetOverrideBinding(frame, true, "PADLSHOULDER", GamePadActionBarsPadLshoulderState1Binding)
    WowApi.Frames.SetOverrideBinding(frame, true, "PADLSTICK", "ACTIONBUTTON6")
    WowApi.Frames.SetOverrideBinding(frame, true, "PAD4", "ACTIONBUTTON7")
    WowApi.Frames.SetOverrideBinding(frame, true, "PAD3", "ACTIONBUTTON8")
    WowApi.Frames.SetOverrideBinding(frame, true, "PAD1", "JUMP")
    WowApi.Frames.SetOverrideBinding(frame, true, "PAD2", "ACTIONBUTTON10")
    WowApi.Frames.SetOverrideBinding(frame, true, "PADRSHOULDER", GamePadActionBarsPadRshoulderState1Binding)
    WowApi.Frames.SetOverrideBinding(frame, true, "PADRSTICK", "ACTIONBUTTON12")
    WowApi.Frames.SetOverrideBindingClick(frame, true, "PADLTRIGGER", frame:GetName(), "PADLTRIGGER")
    WowApi.Frames.SetOverrideBindingClick(frame, true, "PADRTRIGGER", frame:GetName(), "PADRTRIGGER")
end
function WowApi.GamePad:InitializeCursor(frame)
    for frameName, _ in pairs(UIPanelWindows) do
        hookFrameVisibility(_G[frameName])
    end

    local cursorTexture = frame:CreateTexture()

    cursorTexture:SetAllPoints(WowApi.GamePad.ActionBarsFrame)
    cursorTexture:SetSize(24, 24)
    cursorTexture:SetTexture("Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/8.blp", "OVERLAY")
    frame:ClearAllPoints()
    frame:SetAttribute("type", "click")
    frame:SetPoint("CENTER", 0, 0)
    frame.Texture = cursorTexture
end
function WowApi.GamePad:InitializeDriver(frame)
    frame:EnableGamePadButton(true)
    frame:RegisterForClicks("AnyDown", "AnyUp")
    frame:SetAttribute("action", 1)
    frame:SetAttribute("IsEnabled", true)
    frame:SetAttribute("PadTriggerLeft-IsDown", false)
    frame:SetAttribute("PadTriggerRight-IsDown", false)
    frame:SetAttribute("State1-ActionBarPage", 1)
    frame:SetAttribute("State2-ActionBarPage", 6)
    frame:SetAttribute("State3-ActionBarPage", 5)
    frame:SetAttribute("State4-ActionBarPage", 4)
    frame:SetAttribute("State5-ActionBarPage", 3)
    frame:SetAttribute("type", "actionbar")
    frame:WrapScript(frame, "OnClick", [[
        if self:GetAttribute("IsEnabled") then
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
                        self:SetAttribute("action", self:GetAttribute("State4-ActionBarPage"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("State2-ActionBarPage"))
                        self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State2"))
                        self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State2"))
                        self:SetBinding(true, self:GetAttribute("CustomPadName-Select"), self:GetAttribute("PadSelectBinding-State2"))
                        self:SetBinding(true, self:GetAttribute("CustomPadName-Start"), self:GetAttribute("PadStartBinding-State2"))
                    end
                else
                    self:SetAttribute("PadTriggerRight-IsDown", true)

                    if self:GetAttribute("PadTriggerLeft-IsDown") then
                        actionButton5:SetAlpha(1.0)
                        actionButton5:Show()
                        actionButton11:SetAlpha(1.0)
                        actionButton11:Show()
                        self:SetAttribute("action", self:GetAttribute("State5-ActionBarPage"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("State3-ActionBarPage"))
                        self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State3"))
                        self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State3"))
                        self:SetBinding(true, self:GetAttribute("CustomPadName-Select"), self:GetAttribute("PadSelectBinding-State3"))
                        self:SetBinding(true, self:GetAttribute("CustomPadName-Start"), self:GetAttribute("PadStartBinding-State3"))
                    end
                end
            else
                actionButton5:SetAlpha(0.0)
                actionButton9:SetAlpha(0.0)
                actionButton11:SetAlpha(0.0)
                self:SetAttribute("action", self:GetAttribute("State1-ActionBarPage"))
                self:SetAttribute("PadTriggerLeft-IsDown", false)
                self:SetAttribute("PadTriggerRight-IsDown", false)
                self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeftBinding-State1"))
                self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRightBinding-State1"))
                self:SetBinding(true, self:GetAttribute("CustomPadName-Select"), self:GetAttribute("PadSelectBinding-State1"))
                self:SetBinding(true, self:GetAttribute("CustomPadName-Start"), self:GetAttribute("PadStartBinding-State1"))
                self:SetBinding(true, "PAD1", "JUMP")
            end
        end
    ]])
end
function WowApi.GamePad:InitializeUserInterface(frame)
    -- base frames
    local castingBarFrame = WowApi.UserInterface.ModifiedFrames.CastingBarFrame
    local characterMicroButton = WowApi.UserInterface.ModifiedFrames.CharacterMicroButton
    local mainMenuBar = WowApi.UserInterface.ModifiedFrames.MainMenuBar
    local mainMenuBarBackpackButton = WowApi.UserInterface.ModifiedFrames.MainMenuBarBackpackButton
    local mainMenuBarPageNumber = WowApi.UserInterface.ModifiedFrames.MainMenuBarPageNumber
    local mainMenuExpBar = WowApi.UserInterface.ModifiedFrames.MainMenuExpBar
    local petActionButton1 = WowApi.UserInterface.ModifiedFrames.PetActionButton1
    local reputationWatchBar = WowApi.UserInterface.ModifiedFrames.ReputationWatchBar

    -- owner frames
    local bagButtonOwnerFrame = CreateFrame("Frame", "BagButtonOwnerFrame", mainMenuBar)
    local castingBarOwnerFrame = CreateFrame("Frame", "CastingBarOwnerFrame", mainMenuBar)
    local microButtonOwnerFrame = CreateFrame("Frame", "MicroButtonOwnerFrame", mainMenuBar)
    local petActionButtonOwnerFrame = CreateFrame("Frame", "PetActionButtonOwnerFrame", mainMenuBar)

    -- reorganize user interface
    bagButtonOwnerFrame:SetPoint("CENTER", 0, -30)
    bagButtonOwnerFrame:SetScale(0.50)
    bagButtonOwnerFrame:SetSize(20, 20)
    bagButtonOwnerFrame:Show()
    castingBarOwnerFrame:SetPoint("CENTER", 0, 75)
    castingBarOwnerFrame:SetScale(0.50)
    castingBarOwnerFrame:SetSize(20, 20)
    castingBarOwnerFrame:Show()
    mainMenuBarBackpackButton:SetParent(bagButtonOwnerFrame)
    microButtonOwnerFrame:SetPoint("CENTER", 0, -40)
    microButtonOwnerFrame:SetScale(0.85)
    microButtonOwnerFrame:SetSize(20, 20)
    microButtonOwnerFrame:Show()
    petActionButtonOwnerFrame:SetPoint("CENTER", 0, 20)
    petActionButtonOwnerFrame:SetScale(0.75)
    petActionButtonOwnerFrame:SetSize(20, 20)
    petActionButtonOwnerFrame:Show()

    for i = 0, 3 do
        _G[("CharacterBag" .. i .. "Slot")]:SetParent(bagButtonOwnerFrame)
    end

    castingBarFrame:SetParent(castingBarOwnerFrame)
    characterMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.HelpMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.MainMenuMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.PetActionBarFrame:SetParent(petActionButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.QuestLogMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.SocialsMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.SpellbookMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.TalentMicroButton:SetParent(microButtonOwnerFrame)
    WowApi.UserInterface.ModifiedFrames.WorldMapMicroButton:SetParent(microButtonOwnerFrame)

    castingBarFrame:ClearAllPoints()
    castingBarFrame:SetPoint("CENTER", 0, 0)
    castingBarFrame.SetPoint = function(...) end
    characterMicroButton:ClearAllPoints()
    characterMicroButton:SetPoint("CENTER", -(characterMicroButton:GetWidth() * 3.175), 0)
    mainMenuBar:ClearAllPoints()
    mainMenuBar:SetPoint("BOTTOM", GamePadActionBarsDefaultOffsetX, GamePadActionBarsDefaultOffsetY)
    mainMenuBar:SetSize(20, 20)
    mainMenuBarBackpackButton:ClearAllPoints()
    mainMenuBarBackpackButton:SetPoint("CENTER", (mainMenuBarBackpackButton:GetWidth() * 2.25), 0)
    mainMenuBarPageNumber:SetPoint("CENTER", 0, 80)
    mainMenuExpBar:SetParent(mainMenuBar)
    mainMenuExpBar:ClearAllPoints()
    mainMenuExpBar:SetPoint("CENTER", mainMenuBar, 0, 5)
    mainMenuExpBar:SetWidth(110)
    petActionButton1:ClearAllPoints()
    petActionButton1:SetPoint("CENTER", petActionButtonOwnerFrame, "CENTER", -(petActionButton1:GetWidth() * 5.71), -120)
    reputationWatchBar:ClearAllPoints()
    reputationWatchBar:SetWidth(mainMenuExpBar:GetWidth())
    reputationWatchBar.StatusBar:ClearAllPoints()
    reputationWatchBar.StatusBar:SetPoint("TOP", mainMenuExpBar, 0, reputationWatchBar.StatusBar:GetHeight())
    reputationWatchBar.StatusBar:SetWidth(reputationWatchBar:GetWidth())

    for _, hiddenFrame in pairs(WowApi.UserInterface.HiddenFrames) do
        hiddenFrame:SetParent(frame)
    end

    for i = 0, 35 do
        local actionBarName = "ActionButton"
        local alpha = GamePadActionBarsDefaultActiveAlpha
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isReflection = (5 < iMod12)
        local xOffset = ((((1 == iMod6) or (3 == iMod6) or (4 == iMod6)) and ((1 == iMod6) and 80 or 160) or 120) * (isReflection and 1 or -1))
        local yOffset = (((1 == iMod2) and 0 or 40) * ((((0 == iMod6) or (4 == iMod6))) and 1 or -1))

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
        actionButton:SetPoint("CENTER", mainMenuBar, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconFrame:SetFrameLevel(actionButton:GetFrameLevel() + 1)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", 0, 0)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture(WowApi.GamePad.ButtonIconMap[iMod12])
        gamePadIconFrame.Texture = gamePadIconTexture

        if ((i == 4) or (i == 8) or (i == 10)) then
            actionButton:SetAlpha(0.0)
        elseif (i > 11) then
            gamePadIconFrame:Hide()
        end

        frame:SetFrameRef(actionButton:GetName(), actionButton)
    end
end
function WowApi.Player:GetStatusIndicatorColor()
    return (self.IsInCombat and WowApi.Colors.IsInCombat or (self.IsAwayFromKeyboard and WowApi.Colors.IsAwayFromKeyboard or WowApi.Colors.IsNeutral))
end
function WowApi.Timers:CreateTimer(delay, action, isRepeating, cancellationToken)
    local timer = {}

    timer.callback = function()
        if ((nil == timer.cancellationToken) or not(timer.cancellationToken.IsCancellationRequested)) then
            timer.func(timer.arguments)
        end

        if (timer.isRepeating and ((nil == timer.cancellationToken) or not(timer.cancellationToken.IsCancellationRequested))) then
            C_Timer.After(timer.delay, timer.callback)
        end
    end
    timer.cancellationToken = ((nil ~= cancellationToken) and cancellationToken or self:NewCancellationToken())
    timer.delay = delay
    timer.func = ((nil ~= action) and action or function (...) end)
    timer.isRepeating = isRepeating

    return timer
end
function WowApi.Timers:NewCancellationToken()
    return { IsCancellationRequested = false, }
end
function WowApi.Timers:StartTimer(timer, ...)
    timer.arguments = ...

    C_Timer.After(timer.delay, timer.callback)
end

WowApi.Events:SetHandler(function (_, eventName, ...) WowApi.Events.HandlerMap[eventName](...) end)
WowApi.GamePad.ActionBarsFrame:Hide()
WowApi.GamePad.ActionBarsFrame:HookScript("OnEvent", function(...) onFrameEvent(...) end)

for eventName, _ in pairs(WowApi.Events.HandlerMap) do
    WowApi.Events:RegisterEvent(eventName)
end
