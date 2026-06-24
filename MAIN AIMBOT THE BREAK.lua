if game.PlaceId == 13156528982 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nhola1954-prog/the_breakou/refs/heads/main/AIMBOT%20the%20breakout.lua"))()
else
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    local SoundService = game:GetService("SoundService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local Camera = Workspace.CurrentCamera

    local ASSETS = {
        EYE   = "rbxassetid://136454727186459",
        MUSIC = "rbxassetid://112411720859687",
        ALARM = "rbxassetid://1474008656"
    }

    local COUNTDOWN_DURATION = 100
    local CHAT_WIDTH = 320
    local CHAT_HEIGHT = 120
    local ALERT_WIDTH = 350

    local bgMusic = Instance.new("Sound")
    bgMusic.SoundId = ASSETS.MUSIC
    bgMusic.Volume = 6
    bgMusic.Looped = true
    bgMusic.Parent = SoundService
    bgMusic:Play()

    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 200
    Lighting.FogColor = Color3.fromRGB(180, 180, 180)
    Lighting.Ambient = Color3.fromRGB(50, 50, 50)
    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    Lighting.ExposureCompensation = 0
    Lighting.GlobalShadows = true

    local ccEffect = Instance.new("ColorCorrectionEffect")
    ccEffect.TintColor = Color3.fromRGB(255, 255, 255)
    ccEffect.Contrast = 0
    ccEffect.Parent = Lighting

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Light") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj:Destroy()
        end
    end

    local sky = Instance.new("Sky")
    sky.Name = "RainbowSky"
    sky.Parent = Lighting
    RunService.RenderStepped:Connect(function()
        local c = Color3.fromHSV(tick() * 0.3 % 1, 1, 1)
        sky.SkyboxBk = c
        sky.SkyboxDn = c
        sky.SkyboxFt = c
        sky.SkyboxLf = c
        sky.SkyboxRt = c
        sky.SkyboxUp = c
        Lighting.FogColor = c
    end)

    local AlertGui = Instance.new("ScreenGui")
    AlertGui.Name = "ServerDownAlert"
    AlertGui.ResetOnSpawn = false
    AlertGui.Parent = PlayerGui

    local RedOverlay = Instance.new("Frame")
    RedOverlay.Size = UDim2.new(1, 0, 1, 0)
    RedOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    RedOverlay.BackgroundTransparency = 1
    RedOverlay.BorderSizePixel = 0
    RedOverlay.Parent = AlertGui

    local AlertPanel = Instance.new("Frame")
    AlertPanel.Size = UDim2.new(0, ALERT_WIDTH, 0, 240)
    AlertPanel.Position = UDim2.new(0.5, -ALERT_WIDTH/2, 0.05, 0)
    AlertPanel.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
    AlertPanel.BackgroundTransparency = 0.15
    AlertPanel.BorderSizePixel = 0
    AlertPanel.Active = true
    AlertPanel.Draggable = true
    AlertPanel.Parent = AlertGui
    Instance.new("UICorner", AlertPanel).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", AlertPanel).Color = Color3.fromRGB(255, 50, 50)
    AlertPanel.UIStroke.Thickness = 2
    AlertPanel.UIStroke.Transparency = 0.2

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    HeaderFrame.BackgroundTransparency = 0.15
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = AlertPanel
    Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 12)

    local WarningIcon = Instance.new("TextLabel")
    WarningIcon.Size = UDim2.new(0, 35, 0, 35)
    WarningIcon.Position = UDim2.new(0, 10, 0.5, -17)
    WarningIcon.BackgroundTransparency = 1
    WarningIcon.Text = "??"
    WarningIcon.TextSize = 24
    WarningIcon.Font = Enum.Font.GothamBold
    WarningIcon.Parent = HeaderFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 50, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "⚠️ undetect Error"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = HeaderFrame

    local CountdownLabel = Instance.new("TextLabel")
    CountdownLabel.Size = UDim2.new(1, -20, 0, 26)
    CountdownLabel.Position = UDim2.new(0, 10, 0, 45)
    CountdownLabel.BackgroundTransparency = 1
    CountdownLabel.Text = string.format("%.1fs", COUNTDOWN_DURATION)
    CountdownLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
    CountdownLabel.Font = Enum.Font.GothamBold
    CountdownLabel.TextSize = 22
    CountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    CountdownLabel.Parent = AlertPanel

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -20, 0, 10)
    BarBg.Position = UDim2.new(0, 10, 0, 75)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
    BarBg.BackgroundTransparency = 0.15
    BarBg.BorderSizePixel = 0
    BarBg.Parent = AlertPanel
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 5)

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    BarFill.BackgroundTransparency = 0.15
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 5)

    local PercentLabel = Instance.new("TextLabel")
    PercentLabel.Size = UDim2.new(1, -20, 0, 18)
    PercentLabel.Position = UDim2.new(0, 10, 0, 90)
    PercentLabel.BackgroundTransparency = 1
    PercentLabel.Text = "0%"
    PercentLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    PercentLabel.Font = Enum.Font.GothamBold
    PercentLabel.TextSize = 14
    PercentLabel.TextXAlignment = Enum.TextXAlignment.Center
    PercentLabel.Parent = AlertPanel

    local ConsoleFrame = Instance.new("Frame")
    ConsoleFrame.Size = UDim2.new(1, -20, 0, 90)
    ConsoleFrame.Position = UDim2.new(0, 10, 0, 115)
    ConsoleFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    ConsoleFrame.BackgroundTransparency = 0.5
    ConsoleFrame.BorderSizePixel = 0
    ConsoleFrame.Parent = AlertPanel
    Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 5)

    local ConsoleText = Instance.new("TextLabel")
    ConsoleText.Size = UDim2.new(1, -10, 1, -10)
    ConsoleText.Position = UDim2.new(0, 5, 0, 5)
    ConsoleText.BackgroundTransparency = 1
    ConsoleText.Text = ""
    ConsoleText.TextColor3 = Color3.fromRGB(100, 255, 100)
    ConsoleText.Font = Enum.Font.Code
    ConsoleText.TextSize = 10
    ConsoleText.TextXAlignment = Enum.TextXAlignment.Left
    ConsoleText.TextYAlignment = Enum.TextYAlignment.Top
    ConsoleText.Parent = ConsoleFrame

    local errorMessages = {
        "ERROR: workspace integrity failed",
        "ERROR: lighting service disconnected",
        "ERROR: script injection detected",
        "ERROR: map decompilation",
        "ERROR: model corruption",
        "ERROR: part missing reference",
        "ERROR: memory overflow",
        "ERROR: server shutdown initiated",
        "ERROR: character replication lost",
        "ERROR: physics engine crash",
        "ERROR: network disconnect",
        "ERROR: data loss detected",
        "ERROR: chunk failed to load",
        "ERROR: render pipeline broken",
        "ERROR: player data wiped",
        "ERROR: game logic loop dead",
        "ERROR: connection timeout"
    }

    spawn(function()
        while true do
            local lines = {}
            local lineCount = math.random(8, 12)
            for i = 1, lineCount do
                table.insert(lines, errorMessages[math.random(#errorMessages)])
            end
            ConsoleText.Text = table.concat(lines, "\n")
            wait(0.5)
        end
    end)

    local shakeIntensity = 0
    RunService.RenderStepped:Connect(function()
        if shakeIntensity > 0 then
            local shakeX = (math.random() - 0.5) * shakeIntensity * 0.2
            local shakeY = (math.random() - 0.5) * shakeIntensity * 0.2
            Camera.CFrame = Camera.CFrame * CFrame.new(shakeX, shakeY, 0)
        end
    end)

    local function updateProgress(percent, secondsLeft)
        percent = math.clamp(percent, 0, 100)
        BarFill.Size = UDim2.new(percent / 100, 0, 1, 0)
        PercentLabel.Text = math.floor(percent) .. "%"
        CountdownLabel.Text = string.format("%.1fs", secondsLeft)

        local darkness = percent / 100
        Lighting.Brightness = 1 - darkness * 0.8
        Lighting.Ambient = Color3.fromRGB(50 + 50 * darkness, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(60 + 67 * darkness, 0, 0)
        Lighting.ExposureCompensation = -darkness * 2
        ccEffect.TintColor = Color3.fromRGB(255, 255 - 175 * darkness, 255 - 175 * darkness)
        ccEffect.Contrast = 0.3 * darkness
        RedOverlay.BackgroundTransparency = 1 - darkness * 0.5
        shakeIntensity = (percent / 100) * 8
    end

    local ChatGui = Instance.new("ScreenGui")
    ChatGui.Name = "ChatMenu"
    ChatGui.ResetOnSpawn = false
    ChatGui.Parent = PlayerGui

    local chatPanel = Instance.new("Frame")
    chatPanel.Size = UDim2.new(0, 0, 0, 0)
    chatPanel.Position = UDim2.new(0.5, -CHAT_WIDTH/2, 0.6, -CHAT_HEIGHT/2)
    chatPanel.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    chatPanel.BackgroundTransparency = 0.5
    chatPanel.BorderSizePixel = 0
    chatPanel.Visible = false
    chatPanel.Parent = ChatGui
    Instance.new("UICorner", chatPanel).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", chatPanel).Color = Color3.fromRGB(150, 100, 255)
    chatPanel.UIStroke.Thickness = 2
    chatPanel.UIStroke.Transparency = 0.3

    local chatHeader = Instance.new("Frame")
    chatHeader.Size = UDim2.new(1, 0, 0, 38)
    chatHeader.BackgroundColor3 = Color3.fromRGB(40, 25, 70)
    chatHeader.BackgroundTransparency = 0.5
    chatHeader.BorderSizePixel = 0
    chatHeader.Parent = chatPanel
    Instance.new("UICorner", chatHeader).CornerRadius = UDim.new(0, 14)

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, -50, 1, 0)
    headerTitle.Position = UDim2.new(0, 12, 0, 0)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "💬 M.phi ( DEV )"
    headerTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextSize = 13
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = chatHeader

    local chatContent = Instance.new("Frame")
    chatContent.Size = UDim2.new(1, -16, 1, -70)
    chatContent.Position = UDim2.new(0, 8, 0, 42)
    chatContent.BackgroundTransparency = 1
    chatContent.Parent = chatPanel

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, 0, 1, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = ""
    messageLabel.TextColor3 = Color3.fromRGB(200, 180, 230)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 11
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = chatContent

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 32)
    buttonFrame.Position = UDim2.new(0, 0, 1, -32)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    buttonFrame.BackgroundTransparency = 0.5
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = chatPanel
    Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 8)

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 100, 0, 22)
    yesBtn.Position = UDim2.new(1, -215, 0.5, -11)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    yesBtn.BorderSizePixel = 0
    yesBtn.Text = "✓ OK tao thoát"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 10
    yesBtn.Parent = buttonFrame
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 4)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 100, 0, 22)
    noBtn.Position = UDim2.new(1, -110, 0.5, -11)
    noBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 150)
    noBtn.BorderSizePixel = 0
    noBtn.Text = "✗ T đéo thoát đấy"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 10
    noBtn.Parent = buttonFrame
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 4)

    local function typeMessage(text, speed)
        speed = speed or 0.03
        for i = 1, #text do
            messageLabel.Text = text:sub(1, i)
            wait(speed)
        end
    end

    local function openChatMenu()
        chatPanel.Visible = true
        chatPanel.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(chatPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, CHAT_WIDTH, 0, CHAT_HEIGHT)
        }):Play()
        typeMessage("ĐỒ NGU MÀY VÀO NHẦM GAME RỒI, GIỜ THOÁT NGAY CHO TAO", 0.03)
    end

    local function closeChatMenu()
        TweenService:Create(chatPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        wait(0.3)
        chatPanel.Visible = false
        messageLabel.Text = ""
    end

    local function spawnChaser()
        while not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) do
            wait(0.5)
        end

        local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
        local angle = math.random() * math.pi * 2
        local spawnOffset = Vector3.new(math.cos(angle) * 60, 0, math.sin(angle) * 60)
        local spawnPos = Vector3.new(rootPos.X + spawnOffset.X, rootPos.Y + 5, rootPos.Z + spawnOffset.Z)

        local monster = Instance.new("Part")
        monster.Name = "ChasingMonster"
        monster.Size = Vector3.new(1, 1, 1)
        monster.Transparency = 1
        monster.Anchored = true
        monster.CanCollide = false
        monster.CFrame = CFrame.new(spawnPos)
        monster.Parent = Workspace

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = monster
        billboard.Size = UDim2.new(0, 25, 0, 25)
        billboard.AlwaysOnTop = true
        billboard.Parent = monster

        local img = Instance.new("ImageLabel")
        img.Image = ASSETS.EYE
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.ImageTransparency = 0.2
        img.Parent = billboard

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 80, 80)
        light.Brightness = 10
        light.Range = 40
        light.Parent = monster

        local snd = Instance.new("Sound")
        snd.SoundId = ASSETS.ALARM
        snd.Volume = 2
        snd.Parent = monster
        snd:Play()

        RunService.Heartbeat:Connect(function()
            if not monster.Parent then return end
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

            local playerRoot = LocalPlayer.Character.HumanoidRootPart
            local distance = (monster.Position - playerRoot.Position).Magnitude
            if distance < 6 then
                LocalPlayer:Kick("Error")
                monster:Destroy()
                return
            end
            local direction = (playerRoot.Position - monster.Position).Unit
            monster.CFrame = CFrame.new(monster.Position + direction * 0.2)
        end)
    end

    yesBtn.MouseButton1Click:Connect(function()
        closeChatMenu()
        spawnChaser()
    end)
    noBtn.MouseButton1Click:Connect(closeChatMenu)

    spawn(function()
        wait(0.5)
        openChatMenu()
    end)

    local invisiblePlatform = Instance.new("Part")
    invisiblePlatform.Name = "InvisibleStand"
    invisiblePlatform.Size = Vector3.new(50, 2, 50)
    invisiblePlatform.Position = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)) or Vector3.new(0, 5, 0)
    invisiblePlatform.Anchored = true
    invisiblePlatform.CanCollide = true
    invisiblePlatform.Transparency = 1
    invisiblePlatform.Parent = Workspace

    local function createBillboardPart(parent, position, size, imageId, transparency, alwaysOnTop)
        local part = Instance.new("Part")
        part.Size = size
        part.Position = position
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Parent = parent

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = part
        billboard.Size = UDim2.new(size.X * 3, 0, size.Y * 3, 0)
        billboard.AlwaysOnTop = alwaysOnTop or false
        billboard.Parent = part

        local image = Instance.new("ImageLabel")
        image.Image = imageId
        image.Size = UDim2.new(1, 0, 1, 0)
        image.BackgroundTransparency = 1
        image.ImageTransparency = transparency or 0
        image.Parent = billboard

        return part, image
    end

    local eyeTriggered = false
    local brightDarkTriggered = false
    local meteorsTriggered = false

    local function spawnRandomEye()
        local eyeSize = Vector3.new(5, 5, 5)
        local offset = Vector3.new(math.random(-80, 80), math.random(2, 15), math.random(-80, 80))
        local pos = Camera.CFrame.Position + offset
        createBillboardPart(Workspace, pos, eyeSize, ASSETS.EYE, 0.4, false)
    end

    local function triggerEyes()
        if eyeTriggered then return end
        eyeTriggered = true
        local eyePos = Camera.CFrame.Position + Vector3.new(0, 50, -80)
        createBillboardPart(Workspace, eyePos, Vector3.new(30, 30, 30), ASSETS.EYE, 0.2, true)
        spawn(function()
            while true do
                for _ = 1, 3 do spawnRandomEye() end
                wait(1)
            end
        end)
    end

    local function triggerBrightDark()
        if brightDarkTriggered then return end
        brightDarkTriggered = true
        spawn(function()
            while true do
                Lighting.ClockTime = 12
                Lighting.Brightness = 2
                wait(0.3)
                Lighting.ClockTime = 0
                Lighting.Brightness = 0
                wait(0.3)
            end
        end)
    end

    local function createEyeMeteor(startPos, targetPos)
        local meteor = Instance.new("Part")
        meteor.Name = "EyeMeteor"
        meteor.Shape = Enum.PartType.Ball
        meteor.Size = Vector3.new(12, 12, 12)
        meteor.Color = Color3.fromRGB(255, 100, 50)
        meteor.Material = Enum.Material.Neon
        meteor.CanCollide = false
        meteor.Anchored = false
        meteor.CFrame = CFrame.new(startPos)
        meteor.Parent = Workspace

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 150, 0)
        light.Brightness = 8
        light.Range = 60
        light.Parent = meteor

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = meteor
        billboard.Size = UDim2.new(36, 0, 36, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = meteor

        local image = Instance.new("ImageLabel")
        image.Image = ASSETS.EYE
        image.Size = UDim2.new(1, 0, 1, 0)
        image.BackgroundTransparency = 1
        image.ImageTransparency = 0.3
        image.Parent = billboard

        return meteor
    end

    local function meteorFall(meteor, targetPos, duration)
        local startPos = meteor.Position
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / duration, 1)
            local ease = 1 - (1 - progress) ^ 3
            local newPos = startPos:Lerp(targetPos, ease)
            meteor.CFrame = CFrame.new(newPos) * CFrame.Angles(math.rad(progress * 720), math.rad(progress * 360), 0)
            if progress >= 1 then
                connection:Disconnect()
            end
        end)
    end

    local function createImpact(position)
        local explosion = Instance.new("Part")
        explosion.Name = "ImpactExplosion"
        explosion.Shape = Enum.PartType.Ball
        explosion.Size = Vector3.new(1, 1, 1)
        explosion.Color = Color3.fromRGB(255, 200, 100)
        explosion.Material = Enum.Material.Neon
        explosion.CanCollide = false
        explosion.Anchored = true
        explosion.CFrame = CFrame.new(position)
        explosion.Parent = Workspace

        TweenService:Create(explosion, TweenInfo.new(0.6), {Size = Vector3.new(40, 40, 40)}):Play()
        game:GetService("Debris"):AddItem(explosion, 0.7)
    end

    local function spawnEyeMeteor(targetPos)
        local spawnPos = targetPos + Vector3.new(0, 500, 0)
        local meteor = createEyeMeteor(spawnPos, targetPos)
        local distance = (spawnPos - targetPos).Magnitude
        local duration = distance / 150
        meteorFall(meteor, targetPos, duration)
        wait(duration)
        createImpact(targetPos)
        meteor:Destroy()
    end

    local function triggerMeteors()
        if meteorsTriggered then return end
        meteorsTriggered = true
        spawn(function()
            while true do
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    wait(1)
                    continue
                end
                local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
                for _ = 1, 3 do
                    local offset = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
                    spawn(function()
                        spawnEyeMeteor(rootPos + offset)
                    end)
                end
                wait(2.5)
            end
        end)
    end

    local function startFinale()
        local alarm = Instance.new("Sound")
        alarm.SoundId = ASSETS.ALARM
        alarm.Volume = 10
        alarm.Parent = SoundService
        alarm:Play()
        spawn(function()
            wait(3)
            LocalPlayer:Kick("Error")
        end)
    end

    local function clearTerrain(regionMin, regionMax)
        local terrain = Workspace.Terrain
        local material = Enum.Material.Air
        local region = Region3int16.new(Vector3int16.new(regionMin), Vector3int16.new(regionMax))
        terrain:FillRegion(region, 0, material)
    end

    local function startTerrainClearing()
        spawn(function()
            local terrain = Workspace.Terrain
            repeat wait() until terrain.MaxExtents.Max.X > terrain.MaxExtents.Min.X
            local minExtents = terrain.MaxExtents.Min
            local maxExtents = terrain.MaxExtents.Max
            local sizeX = maxExtents.X - minExtents.X
            local sizeZ = maxExtents.Z - minExtents.Z
            local stepX = math.ceil(sizeX / 20)
            local stepZ = math.ceil(sizeZ / 20)
            local startTime = tick()
            local endTime = startTime + COUNTDOWN_DURATION
            while tick() < endTime do
                local elapsed = tick() - startTime
                local fraction = math.clamp(elapsed / COUNTDOWN_DURATION, 0, 1)
                local colsToClear = math.floor(fraction * 20) + 1
                for i = 1, colsToClear do
                    for j = 1, 20 do
                        local cx = minExtents.X + (i - 1) * stepX
                        local cz = minExtents.Z + (j - 1) * stepZ
                        local regionMin = Vector3.new(cx, minExtents.Y, cz)
                        local regionMax = regionMin + Vector3.new(stepX, maxExtents.Y - minExtents.Y, stepZ)
                        pcall(clearTerrain, regionMin, regionMax)
                    end
                end
                wait(0.5)
            end
            pcall(clearTerrain, Vector3.new(minExtents.X, minExtents.Y, minExtents.Z), Vector3.new(maxExtents.X, maxExtents.Y, maxExtents.Z))
        end)
    end

    local allDeletableParts = {}

    local function getDeletableObjects()
        local objects = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj ~= Camera
                and obj ~= LocalPlayer.Character
                and not (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character))
                and obj ~= invisiblePlatform
                and not obj:IsA("Terrain") then
                table.insert(objects, obj)
            end
        end
        return objects
    end

    local function attachHugeFire(part)
        if not part:IsA("BasePart") then return end
        local fire = Instance.new("Fire")
        fire.Heat = 100
        fire.Size = 30
        fire.Parent = part
    end

    local function prepareAllPartsForDestruction()
        local objects = getDeletableObjects()
        allDeletableParts = objects
        spawn(function()
            for _, obj in ipairs(allDeletableParts) do
                if obj:IsA("BasePart") then
                    attachHugeFire(obj)
                    wait(0.01)
                end
            end
        end)
    end

    local function destroyAllPartsAtOnce()
        for _, obj in ipairs(allDeletableParts) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        allDeletableParts = {}
    end

    prepareAllPartsForDestruction()

    local startTime = tick()
    startTerrainClearing()

    spawn(function()
        while true do
            local elapsed = tick() - startTime
            local percent = math.clamp((elapsed / COUNTDOWN_DURATION) * 100, 0, 100)
            local secondsLeft = math.max(COUNTDOWN_DURATION - elapsed, 0)
            updateProgress(percent, secondsLeft)

            if not brightDarkTriggered and secondsLeft <= 60 then triggerBrightDark() end
            if not eyeTriggered and secondsLeft <= 60 then triggerEyes() end
            if not meteorsTriggered and secondsLeft <= 13 then triggerMeteors() end

            if percent >= 100 then
                destroyAllPartsAtOnce()
                startFinale()
                break
            end
            wait(0.05)
        end
    end)
end