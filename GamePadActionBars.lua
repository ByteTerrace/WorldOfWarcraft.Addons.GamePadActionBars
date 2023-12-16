local GamePadNameDualSense = "DualSense Wireless Controller"
local GamePadNameXboxSeriesX = "Xbox Series X Controller"
local GamePadActionBarsAddonName = "GamePadActionBars"
local GamePadActionBarsDefaultActiveAlpha = 1.0
local GamePadActionBarsDefaultOffsetX = 0
local GamePadActionBarsDefaultOffsetY = 100
local GamePadActionBarsDefaultPassiveAlpha = 0.5
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
        GetScreenHeight = GetScreenHeight,
        GetScreenWidth = GetScreenWidth,
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

    if (isDualSenseControllerConnected and (not(isXboxControllerConnected) or (GamePadActionBarsPreferredControllerType == GamePadNameDualSense))) then
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADBACK", "TOGGLEWORLDMAP")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSOCIAL", "TOGGLEGAMEMENU")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSYSTEM", "JUMP") -- TODO: Decide what action to bind with.
    elseif (isXboxControllerConnected and (not(isDualSenseControllerConnected) or (GamePadActionBarsPreferredControllerType == GamePadNameXboxSeriesX))) then
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADBACK", "TOGGLEGAMEMENU")
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSOCIAL", "JUMP") -- TODO: Figure out why the button press event doesn't actually fire.
        WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADSYSTEM", "TOGGLEWORLDMAP")
    end

    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADFORWARD", "TOGGLEQUESTLOG")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDUP", "ACTIONBUTTON1")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDRIGHT", "ACTIONBUTTON2")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDDOWN", "ACTIONBUTTON3")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADDLEFT", "ACTIONBUTTON4")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSHOULDER", "TARGETNEARESTENEMY")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADLSTICK", "ACTIONBUTTON6")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD4", "ACTIONBUTTON7")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD3", "ACTIONBUTTON8")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD1", "JUMP")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PAD2", "ACTIONBUTTON10")
    WowApi.Frames.SetOverrideBinding(gamePadActionBarsFrame, true, "PADRSHOULDER", "INTERACTMOUSEOVER")
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
    WowApi.ConsoleVariables.SetCVar("GamePadAnalogMovement", "1")                     --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraPitchSpeed", "1.5")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadCameraYawSpeed", "2.25")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableJump", "1")              -- 0 = never, 1 = always
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoDisableSticks", "1")            -- 0 = never, 1 = on movement, 2 = on cursor or movement
    WowApi.ConsoleVariables.SetCVar("GamePadCursorAutoEnable", "0")                   -- 0 = never, 1 = always
    WowApi.ConsoleVariables.SetCVar("GamePadCursorCenteredEmulation", "0")            --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorCentering", "0")                    --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorForTargeting", "0")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorLeftClick", "NONE")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorOnLogin", "1")                      --
    WowApi.ConsoleVariables.SetCVar("GamePadCursorRightClick", "NONE")                --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateAlt", "NONE")                      --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateEsc'", "NONE")                     --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateCtrl", "NONE")                     --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateShift", "NONE")                    --
    WowApi.ConsoleVariables.SetCVar("GamePadEmulateTapWindowMs", "0")                 --
    WowApi.ConsoleVariables.SetCVar("GamePadEnable", "1")                             --
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngle", "105")             -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFaceMovementMaxAngleCombat", "105")       -- 0 = always, 180 = never
    WowApi.ConsoleVariables.SetCVar("GamePadFactionColor", "0")                       --
    WowApi.ConsoleVariables.SetCVar("GamePadOverlapMouseMs", "2000")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadRunThreshold", "0.65")                    --
    WowApi.ConsoleVariables.SetCVar("GamePadStickAxisButtons", "0")                   --
    WowApi.ConsoleVariables.SetCVar("GamePadTankTurnSpeed", "0")                      --
    WowApi.ConsoleVariables.SetCVar("GamePadTouchCursorEnable", "1")                  --
    WowApi.ConsoleVariables.SetCVar("GamePadTurnWithCamera", "2")                     -- 0 = never, 1 = while in combat, 2 = always
    WowApi.ConsoleVariables.SetCVar("GamePadVibrationStrength", "1")                  --
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemy", "1")                           -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemyArc", "1")                        -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetEnemyRange", "30.0")                   --
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriend", "1")                          -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriendArc", "1")                       -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetFriendRange", "10.0")                  --
    WowApi.ConsoleVariables.SetCVar("SoftTargetForce", "0")                           -- 0 = never, 1 = enemies, 2 = friends
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteract", "1")                        -- 0 = never, 1 = gamepad, 2 = keyboard, 3 = always
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteractArc", "1")                     -- 0 = never, 1 = within arc, 2 = anywhere
    WowApi.ConsoleVariables.SetCVar("SoftTargetInteractRange", "2.5")                 --
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
            self:SetAttribute("PADRTRIGGER", true)

            if self:GetAttribute("PADLTRIGGER") then
                actionButton5:SetAlpha(1.0)
                actionButton5:Show()
                actionButton11:SetAlpha(1.0)
                actionButton11:Show()
                self:SetAttribute("action", 5)
                self:SetBindingClick(true, "PADLSHOULDER", actionButton5)
                self:SetBindingClick(true, "PADRSHOULDER", actionButton11)
            else
                self:SetAttribute("action", 3)
                self:SetBinding(true, "PADLSHOULDER", "FLIPCAMERAYAW")
                self:SetBinding(true, "PADRSHOULDER", "TOGGLESHEATH")
            end
        end
    else
        actionButton5:SetAlpha(0.0)
        actionButton9:SetAlpha(0.0)
        actionButton11:SetAlpha(0.0)
        actionButton11:SetBinding(true, "PADRSHOULDER", "INTERACTMOUSEOVER")
        self:SetAttribute("action", 1)
        self:SetAttribute("PADLTRIGGER", false)
        self:SetAttribute("PADRTRIGGER", false)
        self:SetBinding(true, "PADLSHOULDER", "TARGETNEARESTENEMY")
        self:SetBinding(true, "PAD1", "JUMP")
    end
]])

WowApi.UserDefined = userDefinedApi
