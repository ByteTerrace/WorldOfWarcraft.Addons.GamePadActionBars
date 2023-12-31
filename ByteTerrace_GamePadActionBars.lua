ByteTerraceWowApi = {
    Addons = {},
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
    Events = {},
    Frames = {
        ClearOverrideBindings = ClearOverrideBindings,
        CreateFrame = CreateFrame,
        RegisterAttributeDriver = RegisterAttributeDriver,
        SetOverrideBinding = SetOverrideBinding,
        SetOverrideBindingClick = SetOverrideBindingClick,
        UIParent = UIParent,
    },
    GamePad = C_GamePad,
    Player = {
        IsAwayFromKeyboard = IsChatAFK(),
        IsInCombat = InCombatLockdown(),
    },
    System = {},
    Timers = {},
}

local getDefaultSettings = function ()
    local settings = {
        Camera = {
            ConsoleVariables = {
                CameraKeepCharacterCentered = false,
                test_cameraDynamicPitch = 1.0,
                test_cameraDynamicPitchBaseFovPad = 0.875,
                test_cameraDynamicPitchBaseFovPadDownScale = 1.0,
                test_cameraHeadMovementStrength = 1.0,
                test_cameraHeadMovementMovingStrength = 1.0,
                test_cameraOverShoulder = 0.475,
                test_cameraTargetFocusInteractEnable = true,
                test_cameraTargetFocusInteractStrengthPitch = 0.75,
                test_cameraTargetFocusInteractStrengthYaw = 1.0,
            },
        },
        GamePad = {
            ActionBars = {
                AlphaWhenActive = 1.0,
                AlphaWhenPassive = 0.5,
                ButtonSize = 0,
                IsEnabled = true,
                OffsetX = 0,
                OffsetY = 0,
            },
            Buttons = {
                IconMap = {
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
                },
                PadShoulderLeft = {
                    States = {
                        [1] = { Binding = "TARGETNEARESTENEMY", },
                        [2] = { Binding = "TARGETNEARESTFRIEND", },
                        [3] = { Binding = "UNBOUND", },
                    }
                },
                PadShoulderRight = {
                    States = {
                        [1] = { Binding = "INTERACTMOUSEOVER", },
                        [2] = { Binding = "TOGGLEAUTORUN", },
                        [3] = { Binding = "FLIPCAMERAYAW", },
                    }
                },
                Select = {
                    Binding = "PADSOCIAL",
                    States = {
                        [1] = { Binding = "TOGGLEWORLDMAP", },
                        [2] = { Binding = "OPENALLBAGS", },
                        [3] = { Binding = "TOGGLECHARACTER0", },
                        [4] = { Binding = "TOGGLESOCIAL", },
                        [5] = { Binding = "TOGGLESPELLBOOK", },
                    }
                },
                Start = {
                    Binding = "PADFORWARD",
                    States = {
                        [1] = { Binding = "TOGGLEGAMEMENU", },
                        [2] = { Binding = "TOGGLEGAMEMENU", },
                        [3] = { Binding = "TOGGLEGAMEMENU", },
                        [4] = { Binding = "TOGGLEGAMEMENU", },
                        [5] = { Binding = "TOGGLEGAMEMENU", },
                    }
                },
            },
            ConsoleVariables = {
                GamePadAnalogMovement = true,
                GamePadCameraPitchSpeed = 1.5,
                GamePadCameraYawSpeed = 2.25,
                GamePadCursorAutoDisableJump = true,
                GamePadCursorAutoDisableSticks = "2",
                GamePadCursorAutoEnable = false,
                GamePadCursorCenteredEmulation = false,
                GamePadCursorCentering = false,
                GamePadCursorForTargeting = false,
                GamePadCursorLeftClick = "NONE",
                GamePadCursorOnLogin = true,
                GamePadCursorRightClick = "NONE",
                GamePadEmulateAlt = "NONE",
                GamePadEmulateCtrl = "NONE",
                GamePadEmulateShift = "NONE",
                GamePadEmulateTapWindowMs = 350,
                GamePadEnable = true,
                GamePadFaceMovementMaxAngle = 115.0,
                GamePadFaceMovementMaxAngleCombat = 115.0,
                GamePadFactionColor = false,
                GamePadOverlapMouseMs = 2000,
                GamePadRunThreshold = 0.65,
                GamePadStickAxisButtons = false,
                GamePadTankTurnSpeed = 0.0,
                GamePadTouchCursorEnable = false,
                GamePadTurnWithCamera = "2",
                GamePadVibrationStrength = 1.0,
                SoftTargetEnemy = "1",
                SoftTargetEnemyArc = "1",
                SoftTargetEnemyRange = 30.0,
                SoftTargetFriend = "1",
                SoftTargetFriendArc = "1",
                SoftTargetFriendRange = 10.0,
                SoftTargetForce = "0",
                SoftTargetInteract = "1",
                SoftTargetInteractArc = "1",
                SoftTargetInteractRange = 2.5,
            },
            VendorIdMap = {
                [1118] = "XboxSeriesX",          -- Official Xbox Series X Controller: Bluetooth/USBC
                [1356] = "DualSense",            -- Official PlayStation 5 DualSense Controller: Bluetooth/USBC
                [1406] = "NintendoSwitchPro",    -- Official Nintendo Switch Pro Controller: Bluetooth/USBC
            },
        },
    }

    if ByteTerraceWowApi.System:IsClassic() then
        settings.GamePad.ActionBars.ButtonSize = 40
        settings.GamePad.ActionBars.OffsetY = 200
    elseif ByteTerraceWowApi.System:IsMainline() then
        settings.GamePad.ActionBars.ButtonSize = 45
        settings.GamePad.ActionBars.OffsetY = 200
    end

    return settings
end
local onFrameEvent = function (...) end

function ByteTerraceWowApi.Camera:InitializeConsoleVariables()
    -- EXPERIMENTAL: action camera configuration
    ByteTerraceWowApi.Frames.UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

    for key, value in pairs(ByteTerrace_GamePadActionBars.Camera.ConsoleVariables) do
        ByteTerraceWowApi.ConsoleVariables:Set(key, value)
    end
end
function ByteTerraceWowApi.ConsoleVariables:Reset(key)
    C_CVar.SetCVar(key, C_CVar.GetCVarDefault(key))
end
function ByteTerraceWowApi.ConsoleVariables:Set(key, value)
    local valueType = type(value)

    if ("boolean" == valueType) then
        value = (value and "1" or "0")
    elseif ("number" == valueType) then
        value = tostring(value)
    end

    C_CVar.SetCVar(key, value)
end
function ByteTerraceWowApi.Events.OnAddonLoaded(addOnName)
    local handler = ByteTerraceWowApi.Addons.HandlerMap[addOnName]

    if (nil ~= handler) then
        handler()
    end
end
function ByteTerraceWowApi.Events.OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)
    if (isInitialLogin or isReloadingUi) then
        ByteTerraceWowApi.Camera:InitializeConsoleVariables()
        ByteTerraceWowApi.GamePad:InitializeConsoleVariables()
    end

    ByteTerraceWowApi.Camera.ResetView(5)
    ByteTerraceWowApi.Camera.SetView(5)
    ByteTerraceWowApi.Camera.ZoomOut(50.0)
    ByteTerraceWowApi.Camera.ZoomIn(1.25)
    ByteTerraceWowApi.Camera.SaveView(5)
    ByteTerraceWowApi.Events:OnPlayerFlagsChanged()
end
function ByteTerraceWowApi.Events.OnPlayerFlagsChanged()
    ByteTerraceWowApi.Player.IsAwayFromKeyboard = IsChatAFK()
    ByteTerraceWowApi.GamePad.SetLedColor(ByteTerraceWowApi.Player:GetStatusIndicatorColor())
end
function ByteTerraceWowApi.Events.OnPlayerRegenDisabled()
    ByteTerraceWowApi.Player.IsInCombat = true
    ByteTerraceWowApi.GamePad.SetVibration("High", 1.0)
    ByteTerraceWowApi.Events:OnPlayerFlagsChanged()
end
function ByteTerraceWowApi.Events.OnPlayerRegenEnabled()
    ByteTerraceWowApi.Player.IsInCombat = false
    ByteTerraceWowApi.GamePad.SetVibration("Low", 0.5)
    ByteTerraceWowApi.Events:OnPlayerFlagsChanged()
end
function ByteTerraceWowApi.Events:RegisterEvent(eventName)
    ByteTerraceWowApi.GamePad.EventFrame:RegisterEvent(eventName)
end
function ByteTerraceWowApi.Events:SetHandler(func)
    onFrameEvent = func
end
function ByteTerraceWowApi.GamePad:InitializeBindings(frame)
    local isDualSenseControllerConnected = false
    local isNintendoSwitchProControllerConnected = false
    local isXboxControllerConnected = false

    for deviceId in ipairs(self:GetAllDeviceIDs()) do
        local _, rawState = pcall(self.GetDeviceRawState, deviceId)

        if (nil ~= rawState) then
            local deviceType = ByteTerrace_GamePadActionBars.GamePad.VendorIdMap[rawState.vendorID]

            if ("DualSense" == deviceType) then
                isDualSenseControllerConnected = true
            elseif ("NintendoSwitchPro" == deviceType) then
                isNintendoSwitchProControllerConnected = true
            elseif ("XboxSeriesX" == deviceType) then
                isXboxControllerConnected = true
            end
        end
    end

    if isDualSenseControllerConnected then
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_triangle.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_square.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_cross.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/playstation_circle.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding = "PADSOCIAL"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding = "PADFORWARD"
    elseif isNintendoSwitchProControllerConnected then
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_x.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_y.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_b.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_a.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding = "PADBACK"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding = "PADFORWARD"
    elseif isXboxControllerConnected then
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[6] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_y.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[7] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_x.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[8] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_a.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[9] = "Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Icons/xbox_b.blp"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding = "PADBACK"
        ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding = "PADFORWARD"
    end

    frame:SetAttribute("PadSelect-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding)
    frame:SetAttribute("PadSelect-State1-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[1].Binding)
    frame:SetAttribute("PadSelect-State2-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[2].Binding)
    frame:SetAttribute("PadSelect-State3-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[3].Binding)
    frame:SetAttribute("PadSelect-State4-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[4].Binding)
    frame:SetAttribute("PadSelect-State5-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[5].Binding)
    frame:SetAttribute("PadShoulderLeft-State1-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderLeft.States[1].Binding)
    frame:SetAttribute("PadShoulderLeft-State2-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderLeft.States[2].Binding)
    frame:SetAttribute("PadShoulderLeft-State3-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderLeft.States[3].Binding)
    frame:SetAttribute("PadShoulderRight-State1-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderRight.States[1].Binding)
    frame:SetAttribute("PadShoulderRight-State2-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderRight.States[2].Binding)
    frame:SetAttribute("PadShoulderRight-State3-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.PadShoulderRight.States[3].Binding)
    frame:SetAttribute("PadStart-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding)
    frame:SetAttribute("PadStart-State1-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[1].Binding)
    frame:SetAttribute("PadStart-State2-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[2].Binding)
    frame:SetAttribute("PadStart-State3-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[3].Binding)
    frame:SetAttribute("PadStart-State4-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[4].Binding)
    frame:SetAttribute("PadStart-State5-Binding", ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[5].Binding)

    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding, ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[1].Binding)
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding, ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[1].Binding)
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADDUP", "ACTIONBUTTON1")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADDRIGHT", "ACTIONBUTTON2")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADDDOWN", "ACTIONBUTTON3")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADDLEFT", "ACTIONBUTTON4")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADLSTICK", "ACTIONBUTTON6")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PAD4", "ACTIONBUTTON7")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PAD3", "ACTIONBUTTON8")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PAD1", "JUMP")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PAD2", "ACTIONBUTTON10")
    ByteTerraceWowApi.Frames.SetOverrideBinding(frame, true, "PADRSTICK", "ACTIONBUTTON12")
    ByteTerraceWowApi.Frames.SetOverrideBindingClick(frame, true, "PADLTRIGGER", frame:GetName(), "PADLTRIGGER")
    ByteTerraceWowApi.Frames.SetOverrideBindingClick(frame, true, "PADRTRIGGER", frame:GetName(), "PADRTRIGGER")
end
function ByteTerraceWowApi.GamePad:InitializeConsoleVariables()
    for key, value in pairs(ByteTerrace_GamePadActionBars.GamePad.ConsoleVariables) do
        ByteTerraceWowApi.ConsoleVariables:Set(key, value)
    end
end
function ByteTerraceWowApi.GamePad:InitializeDriver(frame)
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
    frame:SetFrameRef("ActionButton5", ActionButton5)
    frame:SetFrameRef("ActionButton9", ActionButton9)
    frame:SetFrameRef("ActionButton11", ActionButton11)
    frame:SetPoint("BOTTOM", ByteTerrace_GamePadActionBars.GamePad.ActionBars.OffsetX, ByteTerrace_GamePadActionBars.GamePad.ActionBars.OffsetY)
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
                        self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State4-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State4-Binding"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("State2-ActionBarPage"))
                        self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeft-State2-Binding"))
                        self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRight-State2-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State2-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State2-Binding"))
                    end
                else
                    self:SetAttribute("PadTriggerRight-IsDown", true)

                    if self:GetAttribute("PadTriggerLeft-IsDown") then
                        actionButton5:SetAlpha(1.0)
                        actionButton5:Show()
                        actionButton11:SetAlpha(1.0)
                        actionButton11:Show()
                        self:SetAttribute("action", self:GetAttribute("State5-ActionBarPage"))
                        self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State5-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State5-Binding"))
                        self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                        self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
                    else
                        self:SetAttribute("action", self:GetAttribute("State3-ActionBarPage"))
                        self:ClearBinding("PADLSHOULDER")
                        self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRight-State3-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State3-Binding"))
                        self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State3-Binding"))
                    end
                end
            else
                actionButton5:SetAlpha(0.0)
                actionButton9:SetAlpha(0.0)
                actionButton11:SetAlpha(0.0)
                self:SetAttribute("action", self:GetAttribute("State1-ActionBarPage"))
                self:SetAttribute("PadTriggerLeft-IsDown", false)
                self:SetAttribute("PadTriggerRight-IsDown", false)
                self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeft-State1-Binding"))
                self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRight-State1-Binding"))
                self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State1-Binding"))
                self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State1-Binding"))
                self:SetBinding(true, "PAD1", "JUMP")
            end
        end
    ]])

    if ByteTerraceWowApi.System:IsMainline() then
        frame:SetAttribute("pressAndHoldAction", true)
        frame:SetAttribute("typerelease", "actionbar")
    end
end
function ByteTerraceWowApi.GamePad:InitializeUserInterface(frame)
    local buttonSize = ByteTerrace_GamePadActionBars.GamePad.ActionBars.ButtonSize
    local buttonSizeTimes2 = (buttonSize * 2)
    local buttonSizeTimes3 = (buttonSize * 3)
    local buttonSizeTimes4 = (buttonSize * 4)
    local xPadding = 10
    local yPadding = 0

    for i = 0, 35 do
        local actionBarName = "ActionButton"
        local alpha = ByteTerrace_GamePadActionBars.GamePad.ActionBars.AlphaWhenActive
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isReflection = (5 < iMod12)
        local xOffset = (((((1 == iMod6) or (3 == iMod6) or (4 == iMod6)) and ((1 == iMod6) and buttonSizeTimes2 or buttonSizeTimes4) or buttonSizeTimes3) + xPadding) * (isReflection and 1 or -1))
        local yOffset = (((1 == iMod2) and 0 or (buttonSize + yPadding)) * ((((0 == iMod6) or (4 == iMod6))) and 1 or -1))

        if ((i > 11) and (i < 24)) then
            actionBarName = "MultiBarBottomLeftButton"
            alpha = ByteTerrace_GamePadActionBars.GamePad.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSize * (isReflection and -1 or 1)))
            yOffset = (yOffset + buttonSizeTimes2)
        elseif ((i > 23) and (i < 36)) then
            actionBarName = "MultiBarBottomRightButton"
            alpha = ByteTerrace_GamePadActionBars.GamePad.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes2 * (isReflection and 1 or -1)))
            yOffset = (yOffset + buttonSizeTimes2)
        end

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]
        local gamePadIconFrame = ByteTerraceWowApi.Frames.CreateFrame("Frame", ((actionBarName .. "GamePadIconFrame" .. (iMod12 + 1))), actionButton)
        local gamePadIconTexture = gamePadIconFrame:CreateTexture(((actionBarName .. "GamePadIconTexture" .. (iMod12 + 1))), "OVERLAY")
        local gamePadIconTextureOffsetX = (((iMod6 == 1) and 17.5 or ((iMod6 == 3) and -17.5 or 0)) * (isReflection and -1 or 1))
        local gamePadIconTextureOffsetY = ((iMod6 == 0) and 17.5 or ((iMod6 == 2) and -17.5 or 0))

        actionButton.GamePadIconFrame = gamePadIconFrame
        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", frame, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconFrame:SetFrameLevel(actionButton:GetFrameLevel() + 1)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", gamePadIconTextureOffsetX, gamePadIconTextureOffsetY)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture(ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[iMod12])
        gamePadIconFrame.Texture = gamePadIconTexture

        if ((i == 4) or (i == 8) or (i == 10)) then
            actionButton:SetAlpha(0.0)
        elseif (i > 11) then
            gamePadIconFrame:Hide()
        end
    end

    if ByteTerraceWowApi.System:IsClassic() then
        ActionBarDownButton:SetPoint("LEFT", MainMenuBarTexture2, "LEFT", -(ActionBarDownButton:GetWidth() * 0.225), -(ActionBarDownButton:GetHeight() * 0.325))
        ActionBarUpButton:SetPoint("LEFT", MainMenuBarTexture2, "LEFT", -(ActionBarUpButton:GetWidth() * 0.225), (ActionBarUpButton:GetHeight() * 0.265))
        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint("CENTER", MainMenuBarTexture2, "CENTER", -(CharacterMicroButton:GetWidth() * 2.575), 9)
        MainMenuBar:SetWidth(MainMenuBar:GetWidth() * 0.5)
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarPageNumber:SetPoint("LEFT", MainMenuBarTexture2, "LEFT", (MainMenuBar:GetWidth() * 0.0515), -0.5)
        MainMenuBarRightEndCap:Hide()
        MainMenuBarTexture0:Hide()
        MainMenuBarTexture1:Hide()
        MainMenuBarTexture2:SetPoint("CENTER", -(MainMenuBarTexture2:GetWidth() * 0.5), 0)
        MainMenuBarTexture3:SetPoint("CENTER", (MainMenuBarTexture3:GetWidth() * 0.5), 0)
        MainMenuExpBar:SetPoint("CENTER", (MainMenuExpBar:GetWidth() * 0.5), 0)
        MainMenuExpBar:SetWidth(MainMenuExpBar:GetWidth() * 0.5)
        MainMenuXPBarTexture0:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        MainMenuXPBarTexture3:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        ReputationWatchBar:SetPoint("CENTER", (ReputationWatchBar:GetWidth() * 0.5), 0)
        ReputationWatchBar:SetWidth(ReputationWatchBar:GetWidth() * 0.5)
        ReputationWatchBar.StatusBar:SetPoint("CENTER", (ReputationWatchBar.StatusBar:GetWidth() * 0.5), 0)
        ReputationWatchBar.StatusBar:SetWidth(ReputationWatchBar.StatusBar:GetWidth() * 0.5)
        ReputationWatchBar.StatusBar.WatchBarTexture2:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        ReputationWatchBar.StatusBar.WatchBarTexture3:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        ReputationWatchBar.StatusBar.XPBarTexture2:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        ReputationWatchBar.StatusBar.XPBarTexture3:SetParent(ByteTerraceWowApi.GamePad.HiddenFrame)
        ByteTerraceWowApi.GamePad.HiddenFrame:Hide()
    end
end
function ByteTerraceWowApi.Player:GetStatusIndicatorColor()
    return (self.IsInCombat and ByteTerraceWowApi.Colors.IsInCombat or (self.IsAwayFromKeyboard and ByteTerraceWowApi.Colors.IsAwayFromKeyboard or ByteTerraceWowApi.Colors.IsNeutral))
end
function ByteTerraceWowApi.System:IsClassic()
    return (WOW_PROJECT_CLASSIC == WOW_PROJECT_ID)
end
function ByteTerraceWowApi.System:IsMainline()
    return (WOW_PROJECT_MAINLINE == WOW_PROJECT_ID)
end

ByteTerraceWowApi.Addons.HandlerMap = {
    ByteTerrace_GamePadActionBars = function()
        if (nil == ByteTerrace_GamePadActionBars) then
            ByteTerrace_GamePadActionBars = getDefaultSettings()
        end

        local gamePadActionBarsFrame = ByteTerraceWowApi.GamePad.ActionBarsFrame

        ByteTerraceWowApi.GamePad:InitializeBindings(gamePadActionBarsFrame)
        ByteTerraceWowApi.GamePad:InitializeDriver(gamePadActionBarsFrame)

        if ByteTerrace_GamePadActionBars.GamePad.ActionBars.IsEnabled then
            ByteTerraceWowApi.GamePad:InitializeUserInterface(gamePadActionBarsFrame)
        end
    end,
}
ByteTerraceWowApi.Colors.IsAwayFromKeyboard = ByteTerraceWowApi.Colors.CreateColorFromBytes(255, 255, 0, 255)
ByteTerraceWowApi.Colors.IsInCombat = ByteTerraceWowApi.Colors.CreateColorFromBytes(255, 0, 0, 255)
ByteTerraceWowApi.Colors.IsNeutral = ByteTerraceWowApi.Colors.CreateColorFromBytes(0, 255, 0, 255)
ByteTerraceWowApi.Events.HandlerMap = {
    ADDON_LOADED = ByteTerraceWowApi.Events.OnAddonLoaded,
    PLAYER_ENTERING_WORLD = ByteTerraceWowApi.Events.OnPlayerEnteringWorld,
    PLAYER_FLAGS_CHANGED = ByteTerraceWowApi.Events.OnPlayerFlagsChanged,
    PLAYER_REGEN_DISABLED = ByteTerraceWowApi.Events.OnPlayerRegenDisabled,
    PLAYER_REGEN_ENABLED = ByteTerraceWowApi.Events.OnPlayerRegenEnabled,
}
ByteTerraceWowApi.Events:SetHandler(function (_, eventName, ...) ByteTerraceWowApi.Events.HandlerMap[eventName](...) end)
ByteTerraceWowApi.GamePad.ActionBarsFrame = ByteTerraceWowApi.Frames.CreateFrame("Button", "GamePadActionBarsFrame", ByteTerraceWowApi.Frames.UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate")
ByteTerraceWowApi.GamePad.EventFrame = ByteTerraceWowApi.Frames.CreateFrame("Frame", "GamePadEventFrame", ByteTerraceWowApi.Frames.UIParent, "SecureHandlerBaseTemplate")
ByteTerraceWowApi.GamePad.EventFrame:HookScript("OnEvent", function(...) onFrameEvent(...) end)
ByteTerraceWowApi.GamePad.HiddenFrame = ByteTerraceWowApi.Frames.CreateFrame("Frame", "GamePadHiddenFrame", ByteTerraceWowApi.Frames.UIParent, "SecureHandlerStateTemplate")

for eventName, _ in pairs(ByteTerraceWowApi.Events.HandlerMap) do
    ByteTerraceWowApi.Events:RegisterEvent(eventName)
end
