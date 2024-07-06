local Camera_InitializeConsoleVariables
local ConsoleVariables_Set
local Events_OnAddonLoaded
local Events_OnPlayerEnteringWorld
local Events_OnPlayerFlagsChanged
local Events_OnPlayerRegenDisabled
local Events_OnPlayerRegenEnabled
local GamePad_InitializeBindings
local GamePad_InitializeConsoleVariables
local GamePad_InitializeDriver
local GamePad_InitializeUserInterface

Camera_InitializeConsoleVariables = function ()
    -- EXPERIMENTAL: action camera configuration
    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

    for key, value in pairs(ByteTerrace_GamePadActionBars.Camera.ConsoleVariables) do
        ConsoleVariables_Set(key, value)
    end
end
ConsoleVariables_Set = function (key, value)
    local valueType = type(value)

    if ("boolean" == valueType) then
        value = (value and "1" or "0")
    elseif ("number" == valueType) then
        value = tostring(value)
    end

    C_CVar.SetCVar(key, value)
end
Events_OnAddonLoaded = function (addOnName)
    local handler = ByteTerraceWowApi.Addons.HandlerMap[addOnName]

    if (nil ~= handler) then
        handler()
    end
end
Events_OnPlayerEnteringWorld = function (isInitialLogin, isReloadingUi)
    if (isInitialLogin or isReloadingUi) then
        Camera_InitializeConsoleVariables()
        GamePad_InitializeConsoleVariables()

        if System_IsClassic() then
            _G["SHOW_MULTI_ACTIONBAR_1"] = nil
            _G["SHOW_MULTI_ACTIONBAR_2"] = nil
            _G["SHOW_MULTI_ACTIONBAR_3"] = nil
            _G["SHOW_MULTI_ACTIONBAR_4"] = nil

            MultiActionBar_Update()
        else -- TODO: Determine if there is a way to apply these settings ephemerally; as we do in classic.
            Settings.SetValue("PROXY_SHOW_ACTIONBAR_2", false)
            Settings.SetValue("PROXY_SHOW_ACTIONBAR_3", false)
            Settings.SetValue("PROXY_SHOW_ACTIONBAR_4", false)
            Settings.SetValue("PROXY_SHOW_ACTIONBAR_5", false)
        end
    end

    ResetView(5)
    SetView(5)
    CameraZoomOut(50.0)
    CameraZoomIn(1.25)
    SaveView(5)
    Events_OnPlayerFlagsChanged()
end
Events_OnPlayerFlagsChanged = function ()
    ByteTerraceWowApi.Player.IsAwayFromKeyboard = IsChatAFK()
    C_GamePad.SetLedColor(Player_GetStatusIndicatorColor(ByteTerraceWowApi.Player))
end
Events_OnPlayerRegenDisabled = function ()
    ByteTerraceWowApi.Player.IsInCombat = true
    C_GamePad.SetVibration("High", 1.0)
    Events_OnPlayerFlagsChanged()
end
Events_OnPlayerRegenEnabled = function ()
    ByteTerraceWowApi.Player.IsInCombat = false
    C_GamePad.SetVibration("Low", 0.5)
    Events_OnPlayerFlagsChanged()
end
GamePad_InitializeBindings = function (frame)
    local isDualSenseControllerConnected = false
    local isNintendoSwitchProControllerConnected = false
    local isXboxControllerConnected = false

    for deviceId in ipairs(C_GamePad:GetAllDeviceIDs()) do
        local _, rawState = pcall(C_GamePad.GetDeviceRawState, deviceId)

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

    SetOverrideBinding(frame, true, ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.Binding, ByteTerrace_GamePadActionBars.GamePad.Buttons.Select.States[1].Binding)
    SetOverrideBinding(frame, true, ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.Binding, ByteTerrace_GamePadActionBars.GamePad.Buttons.Start.States[1].Binding)
    SetOverrideBinding(frame, true, "PADDUP", "ACTIONBUTTON1")
    SetOverrideBinding(frame, true, "PADDRIGHT", "ACTIONBUTTON2")
    SetOverrideBinding(frame, true, "PADDDOWN", "ACTIONBUTTON3")
    SetOverrideBinding(frame, true, "PADDLEFT", "ACTIONBUTTON4")
    SetOverrideBinding(frame, true, "PADLSTICK", "ACTIONBUTTON6")
    SetOverrideBinding(frame, true, "PAD4", "ACTIONBUTTON7")
    SetOverrideBinding(frame, true, "PAD3", "ACTIONBUTTON8")
    SetOverrideBinding(frame, true, "PAD1", "JUMP")
    SetOverrideBinding(frame, true, "PAD2", "ACTIONBUTTON10")
    SetOverrideBinding(frame, true, "PADRSTICK", "ACTIONBUTTON12")
    SetOverrideBindingClick(frame, true, "PADLTRIGGER", frame:GetName(), "PADLTRIGGER")
    SetOverrideBindingClick(frame, true, "PADRTRIGGER", frame:GetName(), "PADRTRIGGER")
end
GamePad_InitializeConsoleVariables = function ()
    for key, value in pairs(ByteTerrace_GamePadActionBars.GamePad.ConsoleVariables) do
        ConsoleVariables_Set(key, value)
    end
end
GamePad_InitializeDriver = function (hiddenFrame, parentFrame)
    parentFrame:EnableGamePadButton(true)
    parentFrame:RegisterForClicks("AnyDown", "AnyUp")
    parentFrame:SetAttribute("action", 1)
    parentFrame:SetAttribute("IsEnabled", true)
    parentFrame:SetAttribute("PadTriggerLeft-IsDown", false)
    parentFrame:SetAttribute("PadTriggerRight-IsDown", false)
    parentFrame:SetAttribute("State1-ActionBarPage", 1)
    parentFrame:SetAttribute("State2-ActionBarPage", 6)
    parentFrame:SetAttribute("State3-ActionBarPage", 5)
    parentFrame:SetAttribute("State4-ActionBarPage", 4)
    parentFrame:SetAttribute("State5-ActionBarPage", 3)
    parentFrame:SetAttribute("type", "actionbar")
    parentFrame:SetFrameRef("ActionButton5", ActionButton5)
    parentFrame:SetFrameRef("ActionButton9", ActionButton9)
    parentFrame:SetFrameRef("ActionButton11", ActionButton11)
    parentFrame:SetFrameRef("HiddenFrame", hiddenFrame)
    parentFrame:SetFrameRef("ParentFrame", parentFrame)
    parentFrame:SetPoint("BOTTOM", ByteTerrace_GamePadActionBars.GamePad.ActionBars.OffsetX, ByteTerrace_GamePadActionBars.GamePad.ActionBars.OffsetY)
    parentFrame:WrapScript(parentFrame, "OnClick", [[
        if self:GetAttribute("IsEnabled") then
            local actionButton5 = self:GetFrameRef("ActionButton5")
            local actionButton9 = self:GetFrameRef("ActionButton9")
            local actionButton11 = self:GetFrameRef("ActionButton11")
            local hiddenFrame = self:GetFrameRef("HiddenFrame")
            local parentFrame = self:GetFrameRef("ParentFrame")

            if (down) then
                actionButton9:SetParent(parentFrame)
                self:SetBindingClick(true, "PAD1", actionButton9)

                if "PADLTRIGGER" == button then
                    self:SetAttribute("PadTriggerLeft-IsDown", true)

                    if self:GetAttribute("PadTriggerRight-IsDown") then
                        actionButton5:SetParent(parentFrame)
                        actionButton11:SetParent(parentFrame)
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
                        actionButton5:SetParent(parentFrame)
                        actionButton11:SetParent(parentFrame)
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
                actionButton5:SetParent(hiddenFrame)
                actionButton9:SetParent(hiddenFrame)
                actionButton11:SetParent(hiddenFrame)
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

    if System_IsMainline() then
        parentFrame:SetAttribute("pressAndHoldAction", true)
        parentFrame:SetAttribute("typerelease", "actionbar")
    end
end
GamePad_InitializeUserInterface = function (hiddenFrame, parentFrame)
    VERTICAL_MULTI_BAR_HEIGHT = 1 -- DIRTY HACK! Only tested in "Vanilla". See the function "MultiActionBar_Update" in "BlizzardInterfaceCode/Interface/FrameXML/MultiActionBars.lua" for more information.

    local buttonSize = ByteTerrace_GamePadActionBars.GamePad.ActionBars.ButtonSize
    local buttonSizeTimes2 = (buttonSize * 2)
    local buttonSizeTimes3 = (buttonSize * 3)
    local buttonSizeTimes4 = (buttonSize * 4)
    local xPadding = 60
    local yPadding = 0

    for i = 0, 60 do
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
        elseif ((i > 35) and (i < 48)) then
            actionBarName = "MultiBarLeftButton"
            alpha = ByteTerrace_GamePadActionBars.GamePad.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes2 * (isReflection and 1 or -1)))
            yOffset = (yOffset - buttonSize)
        elseif ((i > 47) and (i < 60)) then
            actionBarName = "MultiBarRightButton"
            alpha = ByteTerrace_GamePadActionBars.GamePad.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes3 * (isReflection and -1 or 1)))
            yOffset = yOffset
        end

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]
        local gamePadIconFrame = CreateFrame("Frame", ((actionBarName .. "GamePadIconFrame" .. (iMod12 + 1))), actionButton)
        local gamePadIconTexture = gamePadIconFrame:CreateTexture(((actionBarName .. "GamePadIconTexture" .. (iMod12 + 1))), "OVERLAY")
        local gamePadIconTextureOffsetX = (((iMod6 == 1) and 17.5 or ((iMod6 == 3) and -17.5 or 0)) * (isReflection and -1 or 1))
        local gamePadIconTextureOffsetY = ((iMod6 == 0) and 17.5 or ((iMod6 == 2) and -17.5 or 0))

        actionButton.GamePadIconFrame = gamePadIconFrame
        actionButton.HotKey:SetParent(hiddenFrame)
        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
        gamePadIconFrame:SetAllPoints(actionButton)
        gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
        gamePadIconTexture:SetPoint("CENTER", gamePadIconTextureOffsetX, gamePadIconTextureOffsetY)
        gamePadIconTexture:SetSize(24, 24)
        gamePadIconTexture:SetTexture(ByteTerrace_GamePadActionBars.GamePad.Buttons.IconMap[iMod12])
        gamePadIconFrame.Texture = gamePadIconTexture

        if ((i == 4) or (i == 8) or (i == 10)) then
            actionButton:SetParent(hiddenFrame)
        elseif (i > 11) then
            gamePadIconFrame:Hide()
        end
    end

    if System_IsClassic() then
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
        MainMenuXPBarTexture0:SetParent(hiddenFrame)
        MainMenuXPBarTexture3:SetParent(hiddenFrame)
        ReputationWatchBar:SetPoint("CENTER", (ReputationWatchBar:GetWidth() * 0.5), 0)
        ReputationWatchBar:SetWidth(ReputationWatchBar:GetWidth() * 0.5)
        ReputationWatchBar.StatusBar:SetPoint("CENTER", (ReputationWatchBar.StatusBar:GetWidth() * 0.5), 0)
        ReputationWatchBar.StatusBar:SetWidth(ReputationWatchBar.StatusBar:GetWidth() * 0.5)
        ReputationWatchBar.StatusBar.WatchBarTexture2:SetParent(hiddenFrame)
        ReputationWatchBar.StatusBar.WatchBarTexture3:SetParent(hiddenFrame)
        ReputationWatchBar.StatusBar.XPBarTexture2:SetParent(hiddenFrame)
        ReputationWatchBar.StatusBar.XPBarTexture3:SetParent(hiddenFrame)
    end

    hiddenFrame:Hide()
end
Player_GetStatusIndicatorColor = function (player)
    return (player.IsInCombat and ByteTerraceWowApi.Colors.IsInCombat or (player.IsAwayFromKeyboard and ByteTerraceWowApi.Colors.IsAwayFromKeyboard or ByteTerraceWowApi.Colors.IsNeutral))
end
System_GetDefaultSettings = function ()
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
                ButtonSize = 45,
                IsEnabled = true,
                OffsetX = 0,
                OffsetY = 220,
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

    if System_IsClassic() then
        settings.GamePad.ActionBars.ButtonSize = 40
    end

    return settings
end
System_IsClassic = function ()
    return (WOW_PROJECT_CLASSIC == WOW_PROJECT_ID)
end
System_IsMainline = function ()
    return (WOW_PROJECT_MAINLINE == WOW_PROJECT_ID)
end

ByteTerraceWowApi = {
    Addons = {
        HandlerMap = {
            ByteTerrace_GamePadActionBars = function()
                local addonSettings = _G["ByteTerrace_GamePadActionBars"]
                local hiddenFrame = CreateFrame("Frame", "GamePadHiddenFrame", UIParent, "SecureHandlerStateTemplate")

                if (nil == addonSettings) then
                    addonSettings = System_GetDefaultSettings()
                    _G["ByteTerrace_GamePadActionBars"] = addonSettings
                end

                local gamePadActionBarsFrame = ByteTerraceWowApi.GamePad.ActionBarsFrame

                GamePad_InitializeBindings(gamePadActionBarsFrame)
                GamePad_InitializeDriver(hiddenFrame, gamePadActionBarsFrame)

                if addonSettings.GamePad.ActionBars.IsEnabled then
                    GamePad_InitializeUserInterface(hiddenFrame, gamePadActionBarsFrame)
                end
            end,
        },
    },
    Colors = {
        IsAwayFromKeyboard = CreateColorFromBytes(255, 255, 0, 255),
        IsInCombat = CreateColorFromBytes(255, 0, 0, 255),
        IsNeutral = CreateColorFromBytes(0, 255, 0, 255),
    },
    Events = {
        HandlerMap = {
            ADDON_LOADED = Events_OnAddonLoaded,
            PLAYER_ENTERING_WORLD = Events_OnPlayerEnteringWorld,
            PLAYER_FLAGS_CHANGED = Events_OnPlayerFlagsChanged,
            PLAYER_REGEN_DISABLED = Events_OnPlayerRegenDisabled,
            PLAYER_REGEN_ENABLED = Events_OnPlayerRegenEnabled,
        },
        SetHandler = function(func)
            ByteTerraceWowApi.GamePad.EventHandler = func
        end,
    },
    GamePad = {
        ActionBarsFrame = CreateFrame("Button", "GamePadActionBarsFrame", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate"),
        EventFrame = CreateFrame("Frame", "GamePadEventFrame", UIParent, "SecureHandlerBaseTemplate"),
        EventHandler = function(...) end,
    },
    Player = {
        IsAwayFromKeyboard = IsChatAFK(),
        IsInCombat = InCombatLockdown(),
    },
}

ByteTerraceWowApi.Events.SetHandler(function (_, eventName, ...) ByteTerraceWowApi.Events.HandlerMap[eventName](...) end)
ByteTerraceWowApi.GamePad.EventFrame:HookScript("OnEvent", function(...) ByteTerraceWowApi.GamePad.EventHandler(...) end)

for eventName, _ in pairs(ByteTerraceWowApi.Events.HandlerMap) do ByteTerraceWowApi.GamePad.EventFrame:RegisterEvent(eventName) end
