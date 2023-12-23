local GamePadActionBarsAddonName = "GamePadActionBars"
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
    ConsoleVariables = C_CVar,
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
        ResetView = ResetView,
        SaveView = SaveView,
        SetView = SetView,
    },
}

local gamePadActionBarsFrame = WowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", WowApi.UserInterface.Parent, "SecureActionButtonTemplate, SecureHandlerStateTemplate")
local gamePadCursorFrame = WowApi.Frames.CreateFrame("Frame", "GamePadCursorFrame", WowApi.UserInterface.Parent, "SecureHandlerBaseTemplate")

local initializeCameraVariables = function ()
    -- EXPERIMENTAL: action camera configuration
    WowApi.UserInterface.Parent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
    WowApi.ConsoleVariables.SetCVar("CameraKeepCharacterCentered", "0")                       --
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitch", "1")                           --
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitchBaseFovPad", "0.875")             -- min is 0.4, max is 1.0
    WowApi.ConsoleVariables.SetCVar("test_cameraDynamicPitchBaseFovPadDownScale", "1.0")      -- min is 0.25, max is 1.0
    WowApi.ConsoleVariables.SetCVar("test_cameraHeadMovementStrength", "1")                   --
    WowApi.ConsoleVariables.SetCVar("test_cameraHeadMovementMovingStrength", "1.0")           --
    WowApi.ConsoleVariables.SetCVar("test_cameraOverShoulder", "0.475")                       -- min is ???, max is ???
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractEnable", "1")
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractStrengthPitch", "0.75")    -- min is ???, max is ???
    WowApi.ConsoleVariables.SetCVar("test_cameraTargetFocusInteractStrengthYaw", "1.0")       -- min is ???, max is ???
    WowApi.UserInterface.ResetView(5)
    WowApi.UserInterface.SetView(5)
    WowApi.UserInterface.Camera.ZoomOut(50.0)
    WowApi.UserInterface.Camera.ZoomIn(1.25)
    WowApi.UserInterface.SaveView(5)
end
local initializeGamePadBindings = function ()
    local isDualSenseControllerConnected = false
    local isNintendoSwitchProControllerConnected = false
    local isXboxControllerConnected = false

    for deviceId in ipairs(WowApi.GamePad:GetAllDeviceIDs()) do
        local _, rawState = pcall(WowApi.GamePad.GetDeviceRawState, deviceId)

        if (nil ~= rawState) then
            if (GamePadVendorIdDualSense == rawState.vendorID) then
                --[[ Validated for:
                        - Official PlayStation 5 DualSense Controller: Bluetooth/USBC
                ]]
                isDualSenseControllerConnected = true
            elseif (GamePadVendorIdNintendoSwitchPro == rawState.vendorID) then
                --[[ Validated for:
                        - Nintendo Switch Pro Controller: Bluetooth/USBC
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
    elseif isNintendoSwitchProControllerConnected then
        GamePadActionBarsCustomPadNameSelect = "PADBACK"
        GamePadActionBarsCustomPadNameStart = "PADFORWARD"
    elseif isXboxControllerConnected then
        GamePadActionBarsCustomPadNameSelect = "PADBACK"
        GamePadActionBarsCustomPadNameStart = "PADFORWARD"
    end

    gamePadActionBarsFrame:SetAttribute("CustomPadName-Select", GamePadActionBarsCustomPadNameSelect)
    gamePadActionBarsFrame:SetAttribute("CustomPadName-Start", GamePadActionBarsCustomPadNameStart)
    gamePadActionBarsFrame:SetAttribute("PadSelectBinding-State1", GamePadActionBarsPadSelectState1Binding)
    gamePadActionBarsFrame:SetAttribute("PadSelectBinding-State2", GamePadActionBarsPadSelectState2Binding)
    gamePadActionBarsFrame:SetAttribute("PadSelectBinding-State3", GamePadActionBarsPadSelectState3Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State1", GamePadActionBarsPadLshoulderState1Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State2", GamePadActionBarsPadLshoulderState2Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderLeftBinding-State3", GamePadActionBarsPadLshoulderState3Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State1", GamePadActionBarsPadRshoulderState1Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State2", GamePadActionBarsPadRshoulderState2Binding)
    gamePadActionBarsFrame:SetAttribute("PadShoulderRightBinding-State3", GamePadActionBarsPadRshoulderState3Binding)
    gamePadActionBarsFrame:SetAttribute("PadStartBinding-State1", GamePadActionBarsPadStartState1Binding)
    gamePadActionBarsFrame:SetAttribute("PadStartBinding-State2", GamePadActionBarsPadStartState2Binding)
    gamePadActionBarsFrame:SetAttribute("PadStartBinding-State3", GamePadActionBarsPadStartState3Binding)

    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, GamePadActionBarsCustomPadNameSelect, GamePadActionBarsPadSelectState1Binding)
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, GamePadActionBarsCustomPadNameStart, GamePadActionBarsPadStartState1Binding)
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
local initializeGamePadCursor = function ()
    local gamePadCursorFrameTexture = gamePadCursorFrame:CreateTexture()
    local hookedFrames = {
        CharacterFrame,
        FriendsFrame,
        GameMenuFrame,
        HelpFrame,
        QuestLogFrame,
        SpellBookFrame,
        WorldMapFrame,
    }

    gamePadCursorFrame:ClearAllPoints()
    gamePadCursorFrame:Hide()
    gamePadCursorFrame:SetPoint("CENTER", 0, 0)
    gamePadCursorFrame:SetSize(16, 16)
    gamePadCursorFrameTexture:SetAllPoints(gamePadCursorFrame)
    gamePadCursorFrameTexture:SetTexture("Interface/AddOns/GamePadActionBars/Assets/Icons/8.blp", "OVERLAY")

    for _, frame in pairs(hookedFrames) do
        local cancellationToken = WowApi.Timers:NewCancellationToken()
        local visibilityHandler = WowApi.Frames.CreateFrame("Frame", (frame:GetName() .. "VisibilityHandler"), frame, "SecureHandlerShowHideTemplate")

        visibilityHandler:SetScript("OnShow", function (self)
            if not(WowApi.Player.IsInCombat) then
                local descendants = WowApi.Frames:GetDescendants(self:GetParent())

                for _, v in pairs(descendants) do
                    print(v:GetName())
                end
            end
        end)
    end
end
local initializeGamePadDriver = function ()
    gamePadActionBarsFrame:EnableGamePadButton(true)
    gamePadActionBarsFrame:RegisterForClicks("AnyDown", "AnyUp")
    gamePadActionBarsFrame:SetAttribute("action", 1)
    gamePadActionBarsFrame:SetAttribute("ActionBarPage-State1", 1)
    gamePadActionBarsFrame:SetAttribute("ActionBarPage-State2", 2)
    gamePadActionBarsFrame:SetAttribute("ActionBarPage-State3", 3)
    gamePadActionBarsFrame:SetAttribute("ActionBarPage-State4", 4)
    gamePadActionBarsFrame:SetAttribute("ActionBarPage-State5", 5)
    gamePadActionBarsFrame:SetAttribute("IsEnabled", true)
    gamePadActionBarsFrame:SetAttribute("PadTriggerLeft-IsDown", false)
    gamePadActionBarsFrame:SetAttribute("PadTriggerRight-IsDown", false)
    gamePadActionBarsFrame:SetAttribute("type", "actionbar")
    gamePadActionBarsFrame:SetAttribute("_onstate-iscursordragging", [[
        self:SetAttribute("IsEnabled", not(newstate))
    ]])
    gamePadActionBarsFrame:WrapScript(gamePadActionBarsFrame, "OnClick", [[
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
                        self:SetAttribute("action", self:GetAttribute("ActionBarPage-State4"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("ActionBarPage-State2"))
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
                        self:SetAttribute("action", self:GetAttribute("ActionBarPage-State5"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("ActionBarPage-State3"))
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
                self:SetAttribute("action", self:GetAttribute("ActionBarPage-State1"))
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

    WowApi.Frames.RegisterAttributeDriver(gamePadActionBarsFrame, 'state-iscursordragging', '[cursor] true; nil')
end
local initializeGamePadVariables = function ()
    WowApi.ConsoleVariables.SetCVar("GamePadAnalogMovement", "1")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraPitchSpeed", "1.5")              --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraYawSpeed", "2.25")               --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableJump", "1")           --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableSticks", "2")         -- 0 = never, 1 = on movement, 2 = on cursor or movement
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
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngle", "115")          -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngleCombat", "115")    -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")                    --
    WowApi.ConsoleVariables.SetCVar("GamePadOverlapMouseMs", "2000")               --
    WowApi.ConsoleVariables.SetCVar("GamePadRunThreshold", "0.65")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadStickAxisButtons", "0")                --
    WowApi.ConsoleVariables.SetCVar("GamePadTankTurnSpeed", "0.0")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadTouchCursorEnable", "0")               --
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
end
local initializeUserInterface = function ()
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
    if (GamePadActionBarsAddonName == key) then
        initializeGamePadBindings()
        initializeGamePadCursor()
        initializeGamePadDriver()
        initializeUserInterface()
    end
end
local onFrameEvent = function (...) end
local onPlayerEnteringWorld = function ()
    initializeCameraVariables()
    initializeGamePadVariables()
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

WowApi.Colors.IsAwayFromKeyboard = WowApi.Colors.CreateColorFromBytes(255, 255, 0, 255)
WowApi.Colors.IsInCombat = WowApi.Colors.CreateColorFromBytes(0, 255, 0, 255)
WowApi.Colors.IsNeutral = WowApi.Colors.CreateColorFromBytes(255, 0, 0, 255)
WowApi.Events = {
    HandlerMap = {
        ADDON_LOADED = onAddonLoaded,
        PLAYER_ENTERING_WORLD = onPlayerEnteringWorld,
        PLAYER_FLAGS_CHANGED = onPlayerFlagsChanged,
        PLAYER_INTERACTION_MANAGER_FRAME_SHOW = onPlayerInteractionManagerShow,
        PLAYER_REGEN_DISABLED = onPlayerRegenDisabled,
        PLAYER_REGEN_ENABLED = onPlayerRegenEnabled,
    },
    RegisterEvent = function (_, eventName) gamePadActionBarsFrame:RegisterEvent(eventName) end,
    SetHandler = function (_, functor) onFrameEvent = functor end,
}

function WowApi.Frames:GetDescendants(parent)
    local children = { parent:GetChildren(), }
    local descendants = {}

    if (0 < #children) then
        local index = 0
        local stack = { children, }

        while (0 < #stack) do
            children = table.remove(stack, #stack)

            for _, child in ipairs(children) do
                children = { child:GetChildren(), }
                descendants[index] = child
                index = (index + 1)

                if (0 < #children) then
                    stack[(#stack + 1)] = children
                end
            end
        end
    end

    return descendants
end
function WowApi.Player:GetStatusIndicatorColor()
    return (self.IsInCombat and WowApi.Colors.IsNeutral or (self.IsAwayFromKeyboard and WowApi.Colors.IsAwayFromKeyboard or WowApi.Colors.IsInCombat))
end
function WowApi.Timers:After(delay, action, cancellationToken)
    C_Timer.After(delay, function() if ((nil == cancellationToken) or not(cancellationToken.IsCancellationRequested)) then action() end end)
end
function WowApi.Timers:Debounce(delay, action, cancellationToken)
    local ct = ((nil ~= cancellationToken) and cancellationToken or WowApi.Timers:NewCancellationToken())

    return function ()
        ct.IsCancellationRequested = true
        ct = WowApi.Timers:NewCancellationToken()

        WowApi.Timers:After(delay, action, ct)
    end
end
function WowApi.Timers:NewCancellationToken()
    return { IsCancellationRequested = false, }
end
function WowApi.Timers:RepeatAction(delay, action, cancellationToken)
    WowApi.Timers:After(delay, function() action(); WowApi.Timers:RepeatAction(delay, action, cancellationToken) end, cancellationToken)
end
function WowApi.Timers:RepeatActionUntil(delay, action, predicate, cancellationToken)
    WowApi.Timers:RepeatAction(
        delay,
        function()
            if ((predicate == nil) or predicate()) then
                action()
            else
                cancellationToken.IsCancellationRequested = true
            end
        end,
        cancellationToken
    )
end

gamePadActionBarsFrame:Hide()
gamePadActionBarsFrame:HookScript("OnEvent", function(...) onFrameEvent(...) end)

WowApi.Events:SetHandler(function (_, eventName, ...) WowApi.Events.HandlerMap[eventName](...) end)

for eventName, _ in pairs(WowApi.Events.HandlerMap) do
    WowApi.Events:RegisterEvent(eventName)
end
