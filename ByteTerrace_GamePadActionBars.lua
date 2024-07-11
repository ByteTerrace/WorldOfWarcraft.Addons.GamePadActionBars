--[[
    https://arks.itch.io/ps4-buttons
    https://juliocacko.itch.io/free-input-prompts
    https://robthefivenine.itch.io/flat-gamepad-icons
]]

local Events_OnAddonLoaded
local Events_OnGamePadActiveChanged
local Events_OnPlayerEnteringWorld
local Events_OnPlayerFlagsChanged
local Events_OnPlayerRegenDisabled
local Events_OnPlayerRegenEnabled
local GamePad_InitializeDriver
local GamePad_InitializeUserInterface
local GamePad_SetBindings
local Player_GetStatusIndicatorColor
local System_GetAddOnSettings
local System_GetDefaultAddOnSettings
local System_SetAddOnSettings
local System_InitializeConsoleVariables
local System_IsClassic
local System_IsMainline
local System_OnAddedLoaded

Events_OnAddonLoaded = function (addOnName, containsBindings)
    local handler = ByteTerraceWowApi.Addons.HandlerMap[addOnName]

    if (nil ~= handler) then
        handler()
    end
end
Events_OnGamePadActiveChanged = function ()
    local addonSettings = System_GetAddOnSettings()
    local gamePadButtons = addonSettings.GamePad.Buttons
    local gamePadType = "Generic"
    local iconTextureMap = ByteTerraceWowApi.GamePad.IconTextureMap
    local themeBasePath = ("Interface/AddOns/ByteTerrace_GamePadActionBars/Assets/Themes/juliocacko_alt")

    for deviceId in ipairs(C_GamePad:GetAllDeviceIDs()) do
        local _, rawState = pcall(C_GamePad.GetDeviceRawState, deviceId)

        if (nil ~= rawState) then
            local deviceType = addonSettings.GamePad.VendorIdMap[rawState.vendorID]

            if ("DualSense" == deviceType) then
                gamePadButtons.Select.Binding = "PADSOCIAL"
                gamePadType = "Sony PlayStation"
            elseif ("NintendoSwitchPro" == deviceType) then
                gamePadButtons.Select.Binding = "PADBACK"
                gamePadType = "Nintendo Switch"
            elseif ("XboxSeriesX" == deviceType) then
                gamePadButtons.Select.Binding = "PADBACK"
                gamePadType = "Microsoft Xbox"
            end
        end
    end

    iconTextureMap[0] = (themeBasePath .. "/Generic/dpad_up")
    iconTextureMap[1] = (themeBasePath .. "/Generic/dpad_right")
    iconTextureMap[2] = (themeBasePath .. "/Generic/dpad_down")
    iconTextureMap[3] = (themeBasePath .. "/Generic/dpad_left")
    iconTextureMap[4] = (themeBasePath .. "/" .. gamePadType .. "/l1")
    iconTextureMap[5] = (themeBasePath .. "/Generic/l3")
    iconTextureMap[6] = (themeBasePath .. "/" .. gamePadType .. "/bpad_up")
    iconTextureMap[7] = (themeBasePath .. "/" .. gamePadType .. "/bpad_left")
    iconTextureMap[8] = (themeBasePath .. "/" .. gamePadType .. "/bpad_down")
    iconTextureMap[9] = (themeBasePath .. "/" .. gamePadType .. "/bpad_right")
    iconTextureMap[10] = (themeBasePath .. "/" .. gamePadType .. "/r1")
    iconTextureMap[11] = (themeBasePath .. "/Generic/r3")

    for i = 0, 11 do
        local texture = iconTextureMap[i]

        _G[("ActionButton" .. (i + 1))].gamePadIcon.texture:SetTexture(texture)

        if (8 == i) then
            ByteTerraceWowApi.GamePad.JumpButton.gamePadIcon.texture:SetTexture(texture)
        end
    end

    GamePad_SetBindings()
end
Events_OnPlayerEnteringWorld = function (isInitialLogin, isReloadingUi)
    if (isInitialLogin or isReloadingUi) then
        local addonSettings = System_GetAddOnSettings()

        UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

        System_InitializeConsoleVariables(addonSettings.Camera.ConsoleVariables)
        System_InitializeConsoleVariables(addonSettings.GamePad.ConsoleVariables)
    end

    ResetView(5)
    SetView(5)
    CameraZoomOut(50.0)
    CameraZoomIn(1.25)
    SaveView(5)
    Events_OnPlayerFlagsChanged()
end
Events_OnPlayerFlagsChanged = function (unitTarget)
    C_GamePad.SetLedColor(Player_GetStatusIndicatorColor(ByteTerraceWowApi.Colors, IsChatAFK(), ByteTerraceWowApi.Player.IsInCombat))
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

    if (ByteTerraceWowApi.Player.IsActiveGamePadChangePending) then
        GamePad_SetBindings()

        ByteTerraceWowApi.Player.IsActiveGamePadChangePending = false
    end
end
GamePad_InitializeDriver = function (jumpButton, parentFrame)
    parentFrame:EnableGamePadButton(true)
    parentFrame:RegisterForClicks("AnyDown", "AnyUp")
    parentFrame:SetAttribute("action", 1)
    parentFrame:SetAttribute("PADLTRIGGER", false)
    parentFrame:SetAttribute("PADRTRIGGER", false)
    parentFrame:SetAttribute("State1-ActionBarPage", 1)
    parentFrame:SetAttribute("State2-ActionBarPage", 6)
    parentFrame:SetAttribute("State3-ActionBarPage", 5)
    parentFrame:SetAttribute("State4-ActionBarPage", 4)
    parentFrame:SetAttribute("State5-ActionBarPage", 3)
    parentFrame:SetAttribute("type", "actionbar")
    parentFrame:SetAttribute("_onstate-actionbar", [[
        local actionButton5 = self:GetFrameRef("ActionButton5")
        local actionButton9 = self:GetFrameRef("ActionButton9")
        local actionButton11 = self:GetFrameRef("ActionButton11")
        local currentActionBarPage = self:GetAttribute("state-actionbar")
        local jumpButton = self:GetFrameRef("JumpButton")

        if (1 == currentActionBarPage) then
            actionButton5:Hide()
            actionButton9:Disable()
            actionButton9:Hide()
            actionButton11:Hide()
            jumpButton:Show()
        else
            actionButton9:Enable()
            actionButton9:Show()
            jumpButton:Hide()

            if (3 == currentActionBarPage) then
                actionButton5:Show()
                actionButton11:Show()
            elseif (4 == currentActionBarPage) then
                actionButton5:Show()
                actionButton11:Show()
            elseif (5 == currentActionBarPage) then
                actionButton5:Hide()
                actionButton11:Hide()
            elseif (6 == currentActionBarPage) then
                actionButton5:Hide()
                actionButton11:Hide()
            end
        end
    ]])
    parentFrame:SetFrameRef("ActionButton5", ActionButton5)
    parentFrame:SetFrameRef("ActionButton9", ActionButton9)
    parentFrame:SetFrameRef("ActionButton11", ActionButton11)
    parentFrame:SetFrameRef("JumpButton", jumpButton)
    parentFrame:WrapScript(parentFrame, "OnClick", [[
        local actionButton5 = self:GetFrameRef("ActionButton5")
        local actionButton9 = self:GetFrameRef("ActionButton9")
        local actionButton11 = self:GetFrameRef("ActionButton11")

        if (not down) then
            self:SetAttribute("action", self:GetAttribute("State1-ActionBarPage"))
            self:SetAttribute("PADLTRIGGER", false)
            self:SetAttribute("PADRTRIGGER", false)
            self:SetBinding(true, "PADLSHOULDER", self:GetAttribute("PadShoulderLeft-State1-Binding"))
            self:SetBinding(true, "PADRSHOULDER", self:GetAttribute("PadShoulderRight-State1-Binding"))
            self:SetBinding(true, self:GetAttribute("PadSelect-Binding"), self:GetAttribute("PadSelect-State1-Binding"))
            self:SetBinding(true, self:GetAttribute("PadStart-Binding"), self:GetAttribute("PadStart-State1-Binding"))
            self:SetBinding(true, "PAD1", "JUMP")
        else
            self:SetAttribute(button, true)
            self:SetBindingClick(true, "PAD1", actionButton9)

            if ("PADLTRIGGER" == button) then
                if self:GetAttribute("PADRTRIGGER") then
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
            elseif ("PADRTRIGGER" == button) then
                if self:GetAttribute("PADLTRIGGER") then
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
        end
    ]])

    if System_IsMainline() then
        parentFrame:SetAttribute("pressAndHoldAction", true)
        parentFrame:SetAttribute("typerelease", "actionbar")
    end
end
GamePad_InitializeUserInterface = function (hiddenFrame, gamePadSettings, jumpButton, parentFrame)
    -- Update frame strata of multi-bar frames so that the gamepad icon has the highest z-index.
    MultiBarBottomLeft:SetFrameStrata("LOW")
    MultiBarBottomRight:SetFrameStrata("LOW")
    MultiBarLeft:SetFrameStrata("LOW")
    MultiBarRight:SetFrameStrata("LOW")

    parentFrame:SetPoint("BOTTOM", gamePadSettings.ActionBars.OffsetX, gamePadSettings.ActionBars.OffsetY)

    local buttonSize = gamePadSettings.ActionBars.ButtonSize
    local buttonSizeTimes2 = (buttonSize * 2)
    local buttonSizeTimes3 = (buttonSize * 3)
    local buttonSizeTimes4 = (buttonSize * 4)
    local xPadding = 60
    local yPadding = 0

    for i = 0, 59 do
        local actionBarName = "ActionButton"
        local alpha = gamePadSettings.ActionBars.AlphaWhenActive
        local iMod2 = (i % 2)
        local iMod6 = (i % 6)
        local iMod12 = (i % 12)
        local isReflection = (5 < iMod12)
        local xOffset = (((((1 == iMod6) or (3 == iMod6) or (4 == iMod6)) and ((1 == iMod6) and buttonSizeTimes2 or buttonSizeTimes4) or buttonSizeTimes3) + xPadding) * (isReflection and 1 or -1))
        local yOffset = (((1 == iMod2) and 0 or (buttonSize + yPadding)) * ((((0 == iMod6) or (4 == iMod6))) and 1 or -1))

        if ((i > 11) and (i < 24)) then
            actionBarName = "MultiBarBottomLeftButton"
            alpha = gamePadSettings.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes2 * (isReflection and 1 or -1)))
            yOffset = (yOffset - buttonSize)
        elseif ((i > 23) and (i < 36)) then
            actionBarName = "MultiBarBottomRightButton"
            alpha = gamePadSettings.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes3 * (isReflection and -1 or 1)))
            yOffset = yOffset
        elseif ((i > 35) and (i < 48)) then
            actionBarName = "MultiBarLeftButton"
            alpha = gamePadSettings.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSizeTimes2 * (isReflection and 1 or -1)))
            yOffset = (yOffset + buttonSizeTimes2)
        elseif ((i > 47) and (i < 60)) then
            actionBarName = "MultiBarRightButton"
            alpha = gamePadSettings.ActionBars.AlphaWhenPassive
            xOffset = (xOffset + (buttonSize * (isReflection and -1 or 1)))
            yOffset = (yOffset + buttonSizeTimes2)
        end

        local actionButton = _G[(actionBarName .. (iMod12 + 1))]

        actionButton:ClearAllPoints()
        actionButton:SetAlpha(alpha)
        actionButton:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)

        if (i < 12) then
            if (nil == actionButton.gamePadIcon) then
                local gamePadIcon = CreateFrame("Frame", (actionButton:GetName() .. "GamePadIcon"), actionButton)

                gamePadIcon:SetFrameLevel(actionButton:GetFrameLevel() + 1)
                gamePadIcon:SetPoint("CENTER", actionButton, "CENTER", 0, 0)
                gamePadIcon:SetScale(actionButton:GetScale())
                gamePadIcon:SetSize(actionButton:GetSize())

                actionButton.gamePadIcon = gamePadIcon
                gamePadIcon.texture = gamePadIcon:CreateTexture(nil, "OVERLAY")
            end

            local baseOffset = (buttonSize * 0.4375)
            local gamePadIconTexture = actionButton.gamePadIcon.texture
            local gamePadIconTextureOffsetX = (((1 == iMod6) and baseOffset or (((3 == iMod6) or (4 == iMod12) or (10 == iMod12)) and -baseOffset or 0)) * (isReflection and -1 or 1))
            local gamePadIconTextureOffsetY = (((0 == iMod6) or (4 == iMod12) or (10 == iMod12)) and baseOffset or ((2 == iMod6) and -baseOffset or 0))

            gamePadIconTexture:SetAlpha(0.85)
            gamePadIconTexture:SetPoint("CENTER", gamePadIconTextureOffsetX, gamePadIconTextureOffsetY)
            gamePadIconTexture:SetSize(24, 24)

            if ((5 < i) and (10 > i)) then
                gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
            end

            if ((4 == i) or (8 == i) or (10 == i)) then
                actionButton:Hide()
                actionButton:SetAttribute("statehidden", true);

                if (8 == i) then
                    if (nil == jumpButton.gamePadIcon) then
                        local gamePadIcon = CreateFrame("Frame", (jumpButton:GetName() .. "GamePadIcon"), jumpButton)

                        gamePadIcon:SetFrameLevel(jumpButton:GetFrameLevel() + 1)
                        gamePadIcon:SetPoint("CENTER", jumpButton, "CENTER", 0, 0)
                        gamePadIcon:SetScale(jumpButton:GetScale())
                        gamePadIcon:SetSize(jumpButton:GetSize())

                        jumpButton.gamePadIcon = gamePadIcon
                        gamePadIcon.texture = gamePadIcon:CreateTexture(nil, "OVERLAY")
                    end

                    gamePadIconTexture = jumpButton.gamePadIcon.texture

                    gamePadIconTexture:SetAlpha(0.85)
                    gamePadIconTexture:SetMask("Interface/Masks/CircleMaskScalable")
                    gamePadIconTexture:SetPoint("CENTER", gamePadIconTextureOffsetX, gamePadIconTextureOffsetY)
                    gamePadIconTexture:SetSize(24, 24)
                    jumpButton.icon:SetTexture("Interface/Icons/Ability_Rogue_FleetFooted")
                    jumpButton:SetAllPoints(actionButton)
                    jumpButton:SetScale(actionButton:GetScale())
                    jumpButton:SetSize(actionButton:GetSize())
                end
            end
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
GamePad_SetBindings = function()
    if (ByteTerraceWowApi.Player.IsInCombat) then
        ByteTerraceWowApi.Player.IsActiveGamePadChangePending = true

        return
    end

    local actionBarsFrame = ByteTerraceWowApi.GamePad.ActionBarsFrame
    local gamePadButtons = System_GetAddOnSettings().GamePad.Buttons

    actionBarsFrame:SetAttribute("PadSelect-Binding", gamePadButtons.Select.Binding)
    actionBarsFrame:SetAttribute("PadSelect-State1-Binding", gamePadButtons.Select.States[1].Binding)
    actionBarsFrame:SetAttribute("PadSelect-State2-Binding", gamePadButtons.Select.States[2].Binding)
    actionBarsFrame:SetAttribute("PadSelect-State3-Binding", gamePadButtons.Select.States[3].Binding)
    actionBarsFrame:SetAttribute("PadSelect-State4-Binding", gamePadButtons.Select.States[4].Binding)
    actionBarsFrame:SetAttribute("PadSelect-State5-Binding", gamePadButtons.Select.States[5].Binding)
    actionBarsFrame:SetAttribute("PadShoulderLeft-State1-Binding", gamePadButtons.PadShoulderLeft.States[1].Binding)
    actionBarsFrame:SetAttribute("PadShoulderLeft-State2-Binding", gamePadButtons.PadShoulderLeft.States[2].Binding)
    actionBarsFrame:SetAttribute("PadShoulderLeft-State3-Binding", gamePadButtons.PadShoulderLeft.States[3].Binding)
    actionBarsFrame:SetAttribute("PadShoulderRight-State1-Binding", gamePadButtons.PadShoulderRight.States[1].Binding)
    actionBarsFrame:SetAttribute("PadShoulderRight-State2-Binding", gamePadButtons.PadShoulderRight.States[2].Binding)
    actionBarsFrame:SetAttribute("PadShoulderRight-State3-Binding", gamePadButtons.PadShoulderRight.States[3].Binding)
    actionBarsFrame:SetAttribute("PadStart-Binding", gamePadButtons.Start.Binding)
    actionBarsFrame:SetAttribute("PadStart-State1-Binding", gamePadButtons.Start.States[1].Binding)
    actionBarsFrame:SetAttribute("PadStart-State2-Binding", gamePadButtons.Start.States[2].Binding)
    actionBarsFrame:SetAttribute("PadStart-State3-Binding", gamePadButtons.Start.States[3].Binding)
    actionBarsFrame:SetAttribute("PadStart-State4-Binding", gamePadButtons.Start.States[4].Binding)
    actionBarsFrame:SetAttribute("PadStart-State5-Binding", gamePadButtons.Start.States[5].Binding)

    SetOverrideBinding(actionBarsFrame, true, gamePadButtons.Select.Binding, gamePadButtons.Select.States[1].Binding)
    SetOverrideBinding(actionBarsFrame, true, gamePadButtons.Start.Binding, gamePadButtons.Start.States[1].Binding)
    SetOverrideBinding(actionBarsFrame, true, "PADDUP", "ACTIONBUTTON1")
    SetOverrideBinding(actionBarsFrame, true, "PADDRIGHT", "ACTIONBUTTON2")
    SetOverrideBinding(actionBarsFrame, true, "PADDDOWN", "ACTIONBUTTON3")
    SetOverrideBinding(actionBarsFrame, true, "PADDLEFT", "ACTIONBUTTON4")
    SetOverrideBinding(actionBarsFrame, true, "PADLSTICK", "ACTIONBUTTON6")
    SetOverrideBinding(actionBarsFrame, true, "PAD4", "ACTIONBUTTON7")
    SetOverrideBinding(actionBarsFrame, true, "PAD3", "ACTIONBUTTON8")
    SetOverrideBinding(actionBarsFrame, true, "PAD1", "JUMP")
    SetOverrideBinding(actionBarsFrame, true, "PAD2", "ACTIONBUTTON10")
    SetOverrideBinding(actionBarsFrame, true, "PADRSTICK", "ACTIONBUTTON12")
    SetOverrideBindingClick(actionBarsFrame, true, "PADLTRIGGER", actionBarsFrame:GetName(), "PADLTRIGGER")
    SetOverrideBindingClick(actionBarsFrame, true, "PADRTRIGGER", actionBarsFrame:GetName(), "PADRTRIGGER")

    --[[local isPadLTriggerDown = C_GamePad.GetDeviceMappedState().buttons[(C_GamePad.ButtonBindingToIndex("PADLTRIGGER") + 1)]
    local isPadRTriggerDown = C_GamePad.GetDeviceMappedState().buttons[(C_GamePad.ButtonBindingToIndex("PADRTRIGGER") + 1)]

    if (isPadLTriggerDown) then
        if (isPadRTriggerDown)  then
            ChangeActionBarPage(actionBarsFrame:GetAttribute("State4-ActionBarPage"))
        else
            ChangeActionBarPage(actionBarsFrame:GetAttribute("State2-ActionBarPage"))
        end
    elseif (isPadRTriggerDown)  then
        if (isPadLTriggerDown)  then
            ChangeActionBarPage(actionBarsFrame:GetAttribute("State5-ActionBarPage"))
        else
            ChangeActionBarPage(actionBarsFrame:GetAttribute("State3-ActionBarPage"))
        end
    else
        ChangeActionBarPage(actionBarsFrame:GetAttribute("State1-ActionBarPage"))
    end]]
end
Player_GetStatusIndicatorColor = function (colors, isAwayFromKeyboard, isInCombat)
    return (isInCombat and colors.IsInCombat or (isAwayFromKeyboard and colors.IsAwayFromKeyboard or colors.IsNeutral))
end
System_GetAddOnSettings = function ()
    return _G["ByteTerrace_GamePadActionBars"]
end
System_GetDefaultAddOnSettings = function ()
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
                AlphaWhenPassive = 0.65,
                ButtonSize = 45,
                OffsetX = 0,
                OffsetY = 220,
            },
            Buttons = {
                PadShoulderLeft = {
                    States = {
                        [1] = { Binding = "TARGETNEARESTENEMY", },
                        [2] = { Binding = "TARGETNEARESTFRIEND", },
                        [3] = { Binding = "UNBOUND", },
                    },
                },
                PadShoulderRight = {
                    States = {
                        [1] = { Binding = "INTERACTMOUSEOVER", },
                        [2] = { Binding = "TOGGLEAUTORUN", },
                        [3] = { Binding = "FLIPCAMERAYAW", },
                    },
                },
                Select = {
                    Binding = "PADSOCIAL",
                    States = {
                        [1] = { Binding = "TOGGLEWORLDMAP", },
                        [2] = { Binding = "OPENALLBAGS", },
                        [3] = { Binding = "TOGGLECHARACTER0", },
                        [4] = { Binding = "TOGGLESOCIAL", },
                        [5] = { Binding = "TOGGLESPELLBOOK", },
                    },
                },
                Start = {
                    Binding = "PADFORWARD",
                    States = {
                        [1] = { Binding = "TOGGLEGAMEMENU", },
                        [2] = { Binding = "TOGGLEGAMEMENU", },
                        [3] = { Binding = "TOGGLEGAMEMENU", },
                        [4] = { Binding = "TOGGLEGAMEMENU", },
                        [5] = { Binding = "TOGGLEGAMEMENU", },
                    },
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
System_SetAddOnSettings = function (settings)
    _G["ByteTerrace_GamePadActionBars"] = settings
end
System_InitializeConsoleVariables = function (variables)
    for key, value in pairs(variables) do
        local valueType = type(value)

        if ("boolean" == valueType) then
            value = (value and "1" or "0")
        elseif ("number" == valueType) then
            value = tostring(value)
        end

        C_CVar.SetCVar(key, value)
    end
end
System_IsClassic = function ()
    return (_G["WOW_PROJECT_CLASSIC"] == _G["WOW_PROJECT_ID"])
end
System_IsMainline = function ()
    return (_G["WOW_PROJECT_MAINLINE"] == _G["WOW_PROJECT_ID"])
end
System_OnAddedLoaded = function ()
    local hiddenFrame = ByteTerraceWowApi.GamePad.HiddenFrame
    local jumpButton = ByteTerraceWowApi.GamePad.JumpButton
    local parentFrame = ByteTerraceWowApi.GamePad.ActionBarsFrame
    local settings = System_GetAddOnSettings()

    if (nil == settings) then
        settings = System_GetDefaultAddOnSettings()

        System_SetAddOnSettings(settings)
    end

    GamePad_InitializeDriver(jumpButton, parentFrame)
    GamePad_InitializeUserInterface(hiddenFrame, settings.GamePad, jumpButton, parentFrame)
    Events_OnGamePadActiveChanged()
end

ByteTerraceWowApi = {
    Addons = {
        HandlerMap = {
            ByteTerrace_GamePadActionBars = System_OnAddedLoaded,
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
            --GAME_PAD_ACTIVE_CHANGED = Events_OnGamePadActiveChanged,
            PLAYER_ENTERING_WORLD = Events_OnPlayerEnteringWorld,
            PLAYER_FLAGS_CHANGED = Events_OnPlayerFlagsChanged,
            PLAYER_REGEN_DISABLED = Events_OnPlayerRegenDisabled,
            PLAYER_REGEN_ENABLED = Events_OnPlayerRegenEnabled,
        },
        SetHandler = function (func) ByteTerraceWowApi.GamePad.EventHandler = func end,
    },
    GamePad = {
        ActionBarsFrame = CreateFrame("Button", "GamePadActionBarsFrame", UIParent, "SecureActionButtonTemplate, SecureHandlerStateTemplate"),
        EventFrame = CreateFrame("Frame", "GamePadEventFrame", UIParent, "SecureHandlerBaseTemplate"),
        EventHandler = function (...) end,
        HiddenFrame = CreateFrame("Frame", "GamePadHiddenFrame", UIParent, "SecureHandlerStateTemplate"),
        IconTextureMap = {},
        JumpButton = CreateFrame("Button", "GamePadJumpButton", UIParent, "ActionButtonTemplate, SecureActionButtonTemplate"),
    },
    Player = {
        IsActiveGamePadChangePending = false,
        IsInCombat = InCombatLockdown(),
    }
}

ByteTerraceWowApi.Events.SetHandler(function (_, eventName, ...) ByteTerraceWowApi.Events.HandlerMap[eventName](...) end)
ByteTerraceWowApi.GamePad.EventFrame:HookScript("OnEvent", function (...) ByteTerraceWowApi.GamePad.EventHandler(...) end)

for eventName, _ in pairs(ByteTerraceWowApi.Events.HandlerMap) do ByteTerraceWowApi.GamePad.EventFrame:RegisterEvent(eventName) end

hooksecurefunc("ActionButton_UpdateHotkeys", function(self, actionButtonType)
    local gamePadIcon = self.gamePadIcon
    local hotKey = self.HotKey

    if ((nil ~= gamePadIcon) and (nil ~= hotKey)) then
        local _, _, _, offsetX, offsetY = gamePadIcon.texture:GetPoint()

        if ((0 == offsetX) and (0 == offsetY)) then
            offsetY = (System_GetAddOnSettings().GamePad.ActionBars.ButtonSize * 0.4375)
        end

        hotKey:ClearAllPoints()
        hotKey:Hide()
        hotKey:SetDrawLayer("OVERLAY")
        hotKey:SetJustifyH("CENTER")
        hotKey:SetJustifyV("MIDDLE")
        hotKey:SetParent(gamePadIcon)
        hotKey:SetPoint("CENTER", ((offsetX * 0.3) + 0.5), (offsetY * 0.3))
        hotKey:SetScale(1.25)
        hotKey:SetText(_G["RANGE_INDICATOR"])
    end
end)
hooksecurefunc("AscendStop", function () ByteTerraceWowApi.GamePad.JumpButton:SetButtonState("NORMAL") end)
hooksecurefunc("JumpOrAscendStart", function () ByteTerraceWowApi.GamePad.JumpButton:SetButtonState("PUSHED") end)
RegisterAttributeDriver(ByteTerraceWowApi.GamePad.ActionBarsFrame, "state-actionbar", "[bar:1] 1;[bar:3] 3;[bar:4] 4;[bar:5] 5;[bar:6] 6;")
