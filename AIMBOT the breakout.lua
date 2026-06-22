local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local NOTIFICATION_CONFIG = {
    width = 320,
    bgColor = Color3.fromRGB(15, 15, 30),
    accentColor = Color3.fromRGB(150, 100, 255),
    textColor = Color3.fromRGB(200, 180, 255),
    successColor = Color3.fromRGB(100, 200, 100),
    errorColor = Color3.fromRGB(255, 100, 100),
    warningColor = Color3.fromRGB(255, 200, 80),
    infoColor = Color3.fromRGB(100, 150, 255),
    autoCloseDuration = 0
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NotificationSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(0, NOTIFICATION_CONFIG.width + 20, 1, 0)
notificationContainer.Position = UDim2.new(1, -NOTIFICATION_CONFIG.width - 40, 0, 0)
notificationContainer.BackgroundTransparency = 1
notificationContainer.BorderSizePixel = 0
notificationContainer.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = notificationContainer
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local notificationIndex = 0
local activeNotifications = {}

local function createNotification(config)
    config = config or {}
    local notifConfig = {
        title = config.title or "Thong bao",
        message = config.message or "Khong co noi dung",
        type = config.type or "info",
        duration = config.duration or NOTIFICATION_CONFIG.autoCloseDuration,
        icon = config.icon or "i"
    }
    notificationIndex = notificationIndex + 1
    local notifId = notificationIndex
    local typeColors = {
        success = NOTIFICATION_CONFIG.successColor,
        error = NOTIFICATION_CONFIG.errorColor,
        warning = NOTIFICATION_CONFIG.warningColor,
        info = NOTIFICATION_CONFIG.infoColor
    }
    local accentColor = typeColors[notifConfig.type] or NOTIFICATION_CONFIG.infoColor
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification_" .. notifId
    notifFrame.Size = UDim2.new(1, 0, 0, 100)
    notifFrame.BackgroundColor3 = NOTIFICATION_CONFIG.bgColor
    notifFrame.BorderSizePixel = 0
    notifFrame.LayoutOrder = notifId
    notifFrame.Parent = notificationContainer
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = accentColor
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 12, 0, 12)
    iconLabel.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
    iconLabel.BorderSizePixel = 0
    iconLabel.Text = notifConfig.icon
    iconLabel.TextSize = 20
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = notifFrame
    Instance.new("UICorner", iconLabel).CornerRadius = UDim.new(0, 8)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -75, 0, 20)
    titleLabel.Position = UDim2.new(0, 58, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = notifConfig.title
    titleLabel.TextColor3 = accentColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -75, 0, 32)
    messageLabel.Position = UDim2.new(0, 58, 0, 32)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = notifConfig.message
    messageLabel.TextColor3 = NOTIFICATION_CONFIG.textColor
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 11
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = notifFrame
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -32, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = notifFrame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
    local function closeNotification()
        TweenService:Create(notifFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 100)}):Play()
        task.wait(0.3)
        notifFrame:Destroy()
        table.remove(activeNotifications, #activeNotifications)
    end
    closeBtn.MouseButton1Click:Connect(closeNotification)
    notifFrame.Size = UDim2.new(0, 0, 0, 100)
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 100)}):Play()
    if notifConfig.duration and notifConfig.duration > 0 then
        task.delay(notifConfig.duration, function()
            if notifFrame.Parent then closeNotification() end
        end)
    end
    table.insert(activeNotifications, notifId)
    return notifId
end

local NotificationSystem = {
    success = function(title, message, duration)
        return createNotification({title = title or "Thanh cong", message = message or "Hoan thanh!", type = "success", icon = "✅", duration = duration})
    end,
    error = function(title, message, duration)
        return createNotification({title = title or "Loi", message = message or "Co loi xay ra!", type = "error", icon = "X", duration = duration})
    end,
    warning = function(title, message, duration)
        return createNotification({title = title or "Canh bao", message = message or "Chu y!", type = "warning", icon = "!", duration = duration})
    end,
    info = function(title, message, duration)
        return createNotification({title = title or "Thong tin", message = message or "Thong tin huu ich", type = "info", icon = "i", duration = duration})
    end
}

if game.PlaceId ~= 13156528982 then
    NotificationSystem.error("Sai Game", "day khong phai Game the breakout, script nay chi hoat dong tren the breakout\n\nThis is not Game The Breakout, this script only works on The Breakout.", 0)
    return
end

local config = {
    aimbot = false,
    aimPart = "Head",
    fov = 130,
    smooth = 0.02,
    maxDistance = 500,
    minDistance = 5,
    cacheInterval = 0.08,
    unlockDistance = 800,
    wallCheck = true,
    prediction = true,
    predictionBase = 0.45,
    predictionMin = 0.12,
    predictionRange = 25,
    snapAim = true,
    pauseOnMouse = true,
    pauseDuration = 0.4,
    keyToggle = Enum.KeyCode.E,
    espEnabled = false,
    espMode = "Box",
    espColorName = "Green",
    espRainbow = false,
    espOutline = true,
    espShowName = true,
    espShowDistance = true,
    distMin = 100, distMax = 1000,
    predBaseMin = 0, predBaseMax = 0.6,
    predBaseStep = 0.01,
    pauseDurMin = 0.1, pauseDurMax = 2.0,
    pauseDurStep = 0.1
}

local function startScript()
    local COLORS = {
        Red = Color3.fromRGB(255, 50, 50),
        Green = Color3.fromRGB(50, 255, 50),
        Blue = Color3.fromRGB(50, 150, 255),
        White = Color3.fromRGB(255, 255, 255),
        Yellow = Color3.fromRGB(255, 255, 0),
        Orange = Color3.fromRGB(255, 150, 0),
        Purple = Color3.fromRGB(150, 50, 255)
    }

    local function getESPColor()
        if config.espRainbow then return Color3.fromHSV((tick() * 1.2) % 1, 1, 1) end
        return COLORS[config.espColorName] or COLORS.Green
    end

    local function roundToStep(value, step)
        if step >= 1 then return math.floor(value + 0.5) end
        local decimals = math.ceil(-math.log10(step))
        return math.floor(value * (10 ^ decimals) + 0.5) / (10 ^ decimals)
    end

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "AimbotGUI"
    MainGui.ResetOnSpawn = false
    MainGui.Parent = PlayerGui

    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 40)
    ToggleButton.Position = UDim2.new(0.02, 0, 0.5, -20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BackgroundTransparency = 0.4
    ToggleButton.Image = "rbxassetid://7072707341"
    ToggleButton.ImageColor3 = Color3.fromRGB(220, 220, 220)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = MainGui
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 260, 0, 620)
    MainFrame.Position = UDim2.new(0.15, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(100, 70, 200)
    MainFrame.UIStroke.Thickness = 1.5

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(35, 25, 70)
    header.BorderSizePixel = 0
    header.Parent = MainFrame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -20, 1, 0)
    headerTitle.Position = UDim2.new(0, 12, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "The breakout Aimbot (Cre: M.phi, Copyright)"
    headerTitle.TextColor3 = Color3.fromRGB(180, 160, 230)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 13
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -32, 0.5, -12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -12, 1, -50)
    scrollFrame.Position = UDim2.new(0, 6, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 2
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 200)
    scrollFrame.Parent = MainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollFrame
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function addLabel(text)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 24)
        item.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -8, 1, 0)
        lbl.Position = UDim2.new(0, 4, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(160, 140, 210)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = item
        item.Parent = scrollFrame
    end

    local function addNote(text)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 36)
        item.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -8, 1, 0)
        lbl.Position = UDim2.new(0, 2, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(50, 255, 50)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = item
        item.Parent = scrollFrame
    end

    local function addToggle(configKey, labelText, default)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundTransparency = 1
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -8, 1, 0)
        bg.Position = UDim2.new(0, 4, 0, 0)
        bg.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        bg.Parent = item
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -50, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 180, 240)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = bg
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 0, 18)
        btn.Position = UDim2.new(1, -44, 0.5, -9)
        btn.BackgroundColor3 = default and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(70, 70, 90)
        btn.BorderSizePixel = 0
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.Parent = bg
        btn.MouseButton1Click:Connect(function()
            config[configKey] = not config[configKey]
            local newState = config[configKey]
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = newState and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(70, 70, 90)}):Play()
            btn.Text = newState and "ON" or "OFF"
            if configKey == "aimbot" and not newState then lockedTarget = nil end
        end)
        item.Parent = scrollFrame
    end

    local function addSlider(configKey, labelText, minVal, maxVal, defaultVal, step)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 44)
        item.BackgroundTransparency = 1
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -8, 1, 0)
        bg.Position = UDim2.new(0, 4, 0, 0)
        bg.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        bg.Parent = item
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -16, 0, 14)
        lbl.Position = UDim2.new(0, 8, 0, 3)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText .. ": " .. tostring(defaultVal)
        lbl.TextColor3 = Color3.fromRGB(200, 180, 240)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = bg
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -16, 0, 5)
        sliderBg.Position = UDim2.new(0, 8, 1, -16)
        sliderBg.BackgroundColor3 = Color3.fromRGB(22, 18, 35)
        sliderBg.BorderSizePixel = 0
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 3)
        sliderBg.Parent = bg
        local initFraction = (defaultVal - minVal) / (maxVal - minVal)
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(initFraction, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
        sliderFill.BorderSizePixel = 0
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)
        sliderFill.Parent = sliderBg
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0, 10, 0, 10)
        handle.Position = UDim2.new(initFraction, -5, 0.5, -5)
        handle.BackgroundColor3 = Color3.fromRGB(100, 70, 200)
        handle.BorderSizePixel = 0
        handle.Text = ""
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
        handle.Parent = sliderBg
        local dragging = false
        local function setValue(newValue)
            newValue = math.clamp(roundToStep(newValue, step), minVal, maxVal)
            config[configKey] = newValue
            lbl.Text = labelText .. ": " .. tostring(newValue)
            local fraction = (newValue - minVal) / (maxVal - minVal)
            TweenService:Create(sliderFill, TweenInfo.new(0.05), {Size = UDim2.new(fraction, 0, 1, 0)}):Play()
            handle.Position = UDim2.new(fraction, -5, 0.5, -5)
        end
        local function updateFromMouse(inputPosX)
            local bgAbsPos = sliderBg.AbsolutePosition.X
            local bgWidth = sliderBg.AbsoluteSize.X
            local fraction = math.clamp((inputPosX - bgAbsPos) / bgWidth, 0, 1)
            local rawValue = minVal + fraction * (maxVal - minVal)
            setValue(rawValue)
        end
        handle.MouseButton1Down:Connect(function()
            dragging = true
            local connection = UserInputService.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    updateFromMouse(UserInputService:GetMouseLocation().X)
                end
            end)
            local endConnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    connection:Disconnect()
                    endConnection:Disconnect()
                end
            end)
        end)
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                updateFromMouse(UserInputService:GetMouseLocation().X)
                dragging = true
                local connection = UserInputService.InputChanged:Connect(function(input)
                    if not dragging then return end
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        updateFromMouse(UserInputService:GetMouseLocation().X)
                    end
                end)
                local endConnection = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        connection:Disconnect()
                        endConnection:Disconnect()
                    end
                end)
            end
        end)
        item.Parent = scrollFrame
    end

    local function addSpacer()
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 4)
        item.BackgroundTransparency = 1
        item.Parent = scrollFrame
    end

    local function addSelector(configKey, labelText, options, default)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundTransparency = 1
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -8, 1, 0)
        bg.Position = UDim2.new(0, 4, 0, 0)
        bg.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        bg.Parent = item
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 180, 240)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = bg
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 75, 0, 18)
        btn.Position = UDim2.new(1, -79, 0.5, -9)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.Parent = bg
        local currentIndex = table.find(options, default) or 1
        btn.MouseButton1Click:Connect(function()
            currentIndex = (currentIndex % #options) + 1
            local newVal = options[currentIndex]
            if configKey == "espMode" then
                for _, drawings in pairs(espDrawings) do
                    for _, d in pairs(drawings) do d:Remove() end
                end
                espDrawings = {}
                lastEspMode = newVal
            end
            config[configKey] = newVal
            btn.Text = newVal
        end)
        item.Parent = scrollFrame
    end

    addNote("day la script t tao vui, co bi loi gi thi bao ranh fix\nI created this script for fun, please report any errors so I can be fixed.")
    addLabel("AIMBOT")
    addToggle("aimbot", "Aimbot (E)", config.aimbot)
    addToggle("snapAim", "Snap Aim", config.snapAim)
    addSlider("maxDistance", "Range", config.distMin, config.distMax, config.maxDistance, 10)
    addToggle("wallCheck", "Wall Check", config.wallCheck)
    addNote("du doan Huong di cang cao thi aim kem cung dung thap qua")
    addToggle("prediction", "Prediction", config.prediction)
    addSlider("predictionBase", "Pred. Amount", config.predBaseMin, config.predBaseMax, config.predictionBase, config.predBaseStep)
    addSpacer()
    addLabel("PAUSE")
    addNote("khi xoay camera se dung aim bot ( Demo )\nRotating the camera will stop the aim bot ( Demo )")
    addToggle("pauseOnMouse", "Pause On Move", config.pauseOnMouse)
    addSlider("pauseDuration", "Duration (s)", config.pauseDurMin, config.pauseDurMax, config.pauseDuration, config.pauseDurStep)
    addSpacer()
    addLabel("ESP")
    addToggle("espEnabled", "ESP", config.espEnabled)
    addSelector("espMode", "Mode", {"Box", "Line", "Highlight"}, config.espMode)
    addSelector("espColorName", "Color", {"Red", "Green", "Blue", "White", "Yellow", "Orange", "Purple"}, config.espColorName)
    addToggle("espRainbow", "Rainbow", config.espRainbow)
    addToggle("espOutline", "Outline", config.espOutline)
    addToggle("espShowName", "Name", config.espShowName)
    addToggle("espShowDistance", "Distance", config.espShowDistance)

    ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    closeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

    local zombieCache = {}
    local lastCacheTime = 0
    local lockedTarget = nil
    local lockedDist = math.huge
    local lockTime = 0
    local pauseAimUntil = 0
    local espDrawings = {}
    local lastEspMode = config.espMode

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if not config.pauseOnMouse then return end
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            pauseAimUntil = tick() + config.pauseDuration
        elseif input.UserInputType == Enum.UserInputType.Touch and input.DeltaPosition.Magnitude > 2 then
            pauseAimUntil = tick() + config.pauseDuration
        end
    end)

    local function isZombie(model)
        if not model:IsA("Model") or model == LocalPlayer.Character then return false end
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local head = model:FindFirstChild("Head")
        if not humanoid or not head or humanoid.Health <= 0 then return false end
        local team = model:FindFirstChild("Team")
        if team then
            local localTeam = LocalPlayer.Team
            if localTeam and team.Name == localTeam.Name then return false end
            return true
        else
            local name = model.Name:lower()
            local zombieNames = {"classic", "fast", "strong", "boss", "zombie", "infected", "walker", "undead", "dead", "ghoul", "monster", "creature", "zom", "zomb"}
            for _, pattern in ipairs(zombieNames) do
                if name:find(pattern) then return true end
            end
            return false
        end
    end

    local function updateZombieCache()
        local now = tick()
        if now - lastCacheTime < config.cacheInterval then return zombieCache end
        lastCacheTime = now
        local newCache = {}
        local folder = Workspace:FindFirstChild("Zombies") or Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("NPCs")
        if folder then
            for _, model in ipairs(folder:GetChildren()) do
                if isZombie(model) then table.insert(newCache, model) end
            end
        end
        if #newCache == 0 then
            for _, model in ipairs(Workspace:GetDescendants()) do
                if isZombie(model) then table.insert(newCache, model) end
            end
        end
        zombieCache = newCache
        return zombieCache
    end

    local function isVisible(targetPart)
        if not config.wallCheck then return true end
        local camPos = Camera.CFrame.Position
        local targetPos = targetPart.Position
        local direction = (targetPos - camPos).Unit
        local distance = (targetPos - camPos).Magnitude
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        local rayResult = Workspace:Raycast(camPos, direction * distance, rayParams)
        if rayResult then return rayResult.Instance:IsDescendantOf(targetPart.Parent) end
        return true
    end

    local function getPredictedPosition(zombie)
        local head = zombie:FindFirstChild(config.aimPart)
        if not head then return nil end
        if not config.prediction then return head.Position end
        local velocity = head.Velocity
        if velocity.Magnitude < 0.01 then
            local rootPart = zombie:FindFirstChild("HumanoidRootPart")
            if rootPart then velocity = rootPart.Velocity end
        end
        local flatVelocity = Vector3.new(velocity.X, 0, velocity.Z)
        local distToTarget = (head.Position - Camera.CFrame.Position).Magnitude
        local predAmount = config.predictionBase
        if distToTarget < config.predictionRange then
            predAmount = config.predictionMin + (config.predictionBase - config.predictionMin) * (distToTarget / config.predictionRange)
        end
        return head.Position + flatVelocity * predAmount
    end

    local function getClosestZombieInFOV(ignoreTarget)
        local zombies = updateZombieCache()
        local closest = nil
        local minDist = config.fov
        local camPos = Camera.CFrame.Position
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for _, zombie in ipairs(zombies) do
            local head = zombie:FindFirstChild(config.aimPart)
            if not head then continue end
            local distToCam = (head.Position - camPos).Magnitude
            if distToCam > config.maxDistance then continue end
            if distToCam < config.minDistance then continue end
            if not isVisible(head) then continue end
            local predictedPos = getPredictedPosition(zombie)
            if not predictedPos then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if ignoreTarget and zombie == ignoreTarget then
                elseif dist < minDist then
                    minDist = dist
                    closest = zombie
                end
            end
        end
        return closest, minDist
    end

    local function isTargetValid(target)
        if not target or not target.Parent then return false end
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end
        local head = target:FindFirstChild(config.aimPart)
        if not head then return false end
        local camPos = Camera.CFrame.Position
        local distToCam = (head.Position - camPos).Magnitude
        if distToCam > config.unlockDistance then return false end
        if distToCam < config.minDistance then return false end
        if not isVisible(head) then return false end
        local predictedPos = getPredictedPosition(target)
        local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos or head.Position)
        if not onScreen then
            if tick() - lockTime > 0.5 then return false end
            return true
        end
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
        return dist <= config.fov * 2.0
    end

    local function unlockTarget()
        lockedTarget = nil
        lockedDist = math.huge
        lockTime = 0
    end

    local function createESPForZombie(zombie)
        local mode = config.espMode
        local drawings = {}
        if (mode == "Box" or mode == "Highlight") and config.espOutline then
            local outline = Drawing.new("Square")
            outline.Filled = false
            outline.Thickness = 4
            outline.Color = Color3.new(0, 0, 0)
            outline.Transparency = 0.5
            outline.Visible = false
            drawings["Outline"] = outline
        end
        if mode == "Box" then
            local box = Drawing.new("Square")
            box.Filled = false
            box.Thickness = 1
            box.Visible = false
            drawings["Box"] = box
        end
        if mode == "Line" then
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Visible = false
            drawings["Line"] = line
        end
        if mode == "Highlight" then
            local highlight = Drawing.new("Square")
            highlight.Filled = true
            highlight.Transparency = 0.7
            highlight.Visible = false
            drawings["Highlight"] = highlight
        end
        if config.espShowName then
            local nameText = Drawing.new("Text")
            nameText.Text = zombie.Name
            nameText.Size = 16
            nameText.Color = Color3.new(1, 1, 1)
            nameText.Center = true
            nameText.Outline = true
            nameText.OutlineColor = Color3.new(0, 0, 0)
            nameText.Visible = false
            drawings["NameText"] = nameText
        end
        if config.espShowDistance then
            local distText = Drawing.new("Text")
            distText.Text = "0m"
            distText.Size = 14
            distText.Color = Color3.new(1, 1, 1)
            distText.Center = true
            distText.Outline = true
            distText.OutlineColor = Color3.new(0, 0, 0)
            distText.Visible = false
            drawings["DistText"] = distText
        end
        return drawings
    end

    local function updateESPForZombie(zombie, drawings)
        local head = zombie:FindFirstChild("Head")
        local root = zombie:FindFirstChild("HumanoidRootPart")
        if not head or not root then
            for _, d in pairs(drawings) do d.Visible = false end
            return
        end
        local rootScreen, onScreen = Camera:WorldToViewportPoint(root.Position)
        local headScreen, _ = Camera:WorldToViewportPoint(head.Position)
        if not onScreen or not config.espEnabled then
            for _, d in pairs(drawings) do d.Visible = false end
            return
        end
        local color = getESPColor()
        local height = (head.Position - root.Position).Magnitude * 1.8
        local width = height * 0.6
        local scale = 1 / (root.Position - Camera.CFrame.Position).Magnitude * 400
        local pixelHeight = math.clamp(height * scale, 20, 200)
        local pixelWidth = math.clamp(width * scale, 15, 150)
        local topLeft = Vector2.new(headScreen.X - pixelWidth/2, headScreen.Y)
        local middleBottom = Vector2.new(headScreen.X, headScreen.Y + pixelHeight)
        if drawings["Outline"] then
            local outline = drawings["Outline"]
            outline.Position = topLeft - Vector2.new(1, 1)
            outline.Size = Vector2.new(pixelWidth + 2, pixelHeight + 2)
            outline.Visible = config.espOutline
        end
        if drawings["Box"] then
            local box = drawings["Box"]
            box.Position = topLeft
            box.Size = Vector2.new(pixelWidth, pixelHeight)
            box.Color = color
            box.Visible = true
        end
        if drawings["Line"] then
            local line = drawings["Line"]
            line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            line.To = middleBottom
            line.Color = color
            line.Visible = true
        end
        if drawings["Highlight"] then
            local highlight = drawings["Highlight"]
            highlight.Position = topLeft
            highlight.Size = Vector2.new(pixelWidth, pixelHeight)
            highlight.Color = color
            highlight.Visible = true
        end
        local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
        if drawings["NameText"] then
            local nt = drawings["NameText"]
            nt.Text = zombie.Name
            nt.Position = Vector2.new(headScreen.X, topLeft.Y - 18)
            nt.Visible = config.espShowName
        end
        if drawings["DistText"] then
            local dt = drawings["DistText"]
            dt.Text = dist .. "m"
            dt.Position = Vector2.new(headScreen.X, topLeft.Y + pixelHeight + 2)
            dt.Visible = config.espShowDistance
        end
    end

    local function cleanESP()
        local cacheSet = {}
        for _, z in ipairs(zombieCache) do cacheSet[z] = true end
        for zombie, drawings in pairs(espDrawings) do
            if not cacheSet[zombie] then
                for _, d in pairs(drawings) do d:Remove() end
                espDrawings[zombie] = nil
            end
        end
        if not config.espEnabled then
            for _, drawings in pairs(espDrawings) do
                for _, d in pairs(drawings) do d.Visible = false end
            end
        end
    end

    local function refreshESP()
        if lastEspMode ~= config.espMode then
            for _, drawings in pairs(espDrawings) do
                for _, d in pairs(drawings) do d:Remove() end
            end
            espDrawings = {}
            lastEspMode = config.espMode
        end
        for _, zombie in ipairs(zombieCache) do
            if not espDrawings[zombie] then
                espDrawings[zombie] = createESPForZombie(zombie)
            end
            updateESPForZombie(zombie, espDrawings[zombie])
        end
    end

    RunService:BindToRenderStep("AimbotCamera", Enum.RenderPriority.Camera.Value + 1, function()
        updateZombieCache()
        cleanESP()
        refreshESP()

        if not config.aimbot then
            if lockedTarget then unlockTarget() end
            return
        end

        if tick() < pauseAimUntil then return end

        if lockedTarget and not isTargetValid(lockedTarget) then
            unlockTarget()
        end

        if lockedTarget then
            local newTarget, newDist = getClosestZombieInFOV(lockedTarget)
            if newTarget and newDist < lockedDist * 0.8 and lockedDist > config.fov * 0.5 then
                lockedTarget = newTarget
                lockedDist = newDist
                lockTime = tick()
            end
        else
            local newTarget, newDist = getClosestZombieInFOV(nil)
            if newTarget then
                lockedTarget = newTarget
                lockedDist = newDist
                lockTime = tick()
            end
        end

        if lockedTarget then
            local predictedPos = getPredictedPosition(lockedTarget)
            if predictedPos then
                if config.snapAim then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                else
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predictedPos), config.smooth)
                end
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    end)

    script.Destroying:Connect(function()
        RunService:UnbindFromRenderStep("AimbotCamera")
        for _, drawings in pairs(espDrawings) do
            for _, d in pairs(drawings) do d:Remove() end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == config.keyToggle then
            config.aimbot = not config.aimbot
            if not config.aimbot then unlockTarget() end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        Camera = Workspace.CurrentCamera
        lastCacheTime = 0
        unlockTarget()
    end)

    NotificationSystem.success("Script chay thanh cong", "script chay thanh cong, cam on da su dung\n\nThe script ran successfully, thank for using my script.", 0)
end

local success, err = pcall(startScript)
if not success then
    NotificationSystem.warning("Loi", "Script bi loi khi khoi chay co the do game Da update hoac loi vat thong bao cho Admin de fix\n\nScript errors upon launch maybe due to game updates or minor bugs. Please contact the Admin for fixing.", 0)
end
