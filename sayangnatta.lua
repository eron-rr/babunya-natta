-- ==========================================
-- 🛠️ UNIVERSAL MULTI-TOOL HUB (WITH CLICK TP)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Tabel manajemen koneksi untuk fitur Clean Kill (Tombol X)
local ScriptConnections = {}
local function AddConnection(conn)
    table.insert(ScriptConnections, conn)
    return conn
end

-- Bersihkan UI lama jika dieksekusi ulang
if CoreGui:FindFirstChild("UniversalMultiToolHub") then
    CoreGui.UniversalMultiToolHub:Destroy()
end

-- ==========================================
-- 🎨 PEMBUATAN UI UTAMA (RED THEME)
-- ==========================================
local sg = Instance.new("ScreenGui")
sg.Name = "UniversalMultiToolHub"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

-- Frame Utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 420)
main.Position = UDim2.new(0.5, -140, 0.3, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

-- TopBar / Header
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 8)
topBarCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -75, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "UNIVERSAL MULTI-TOOL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Container Tombol Kanan Atas (- dan X)
local btnHolder = Instance.new("Frame")
btnHolder.Size = UDim2.new(0, 65, 1, 0)
btnHolder.Position = UDim2.new(1, -70, 0, 0)
btnHolder.BackgroundTransparency = 1
btnHolder.Parent = topBar

-- Tombol Minimize (-)
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeButton"
minBtn.Size = UDim2.new(0, 28, 0, 23)
minBtn.Position = UDim2.new(0, 0, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.Parent = btnHolder

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- Tombol Close / Kill Script (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 28, 0, 23)
closeBtn.Position = UDim2.new(0, 32, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 13
closeBtn.Parent = btnHolder

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Scroll Container untuk Menampung Semua Menu
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 580)
scroll.ScrollBarThickness = 4
scroll.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scroll
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

-- Helper Function untuk Membuat Tombol Toggle
local function createToggleButton(name, defaultText, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = defaultText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

-- Helper Function untuk Membuat Slider
local function createSlider(titleText, minVal, maxVal, defaultVal, order, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = order
    frame.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = titleText .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.SourceSansItalic
    label.TextSize = 13
    label.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    local initialPercent = (defaultVal - minVal) / (maxVal - minVal)
    sliderBtn.Position = UDim2.new(initialPercent, 0, 0.5, 0)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderBtn

    local dragging = false

    local function update()
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = sliderBar.AbsolutePosition.X
        local barSize = sliderBar.AbsoluteSize.X
        local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
        
        sliderBtn.Position = UDim2.new(percentage, 0, 0.5, 0)
        local val = minVal + (percentage * (maxVal - minVal))
        val = math.round(val * 10) / 10
        label.Text = titleText .. ": " .. tostring(val)
        callback(val)
    end

    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    AddConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    AddConnection(RunService.RenderStepped:Connect(function()
        if dragging then update() end
    end))
end

-- ==========================================
-- 🔄 MINIMIZE & TOGGLE KEYBIND ('K') & CLOSE
-- ==========================================
local function toggleUI()
    main.Visible = not main.Visible
end

minBtn.MouseButton1Click:Connect(toggleUI)

-- Keybind 'K' untuk menyembunyikan / menampilkan kembali UI
AddConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        toggleUI()
    end
end))

-- Deklarasi variabel pembantu untuk cleanup saat tombol X ditekan
local isFlyActive = false
local stopFlying

-- Tombol X untuk mematikan seluruh fungsi script & menghapus UI
closeBtn.MouseButton1Click:Connect(function()
    if isFlyActive and stopFlying then
        stopFlying()
    end
    for _, conn in ipairs(ScriptConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    sg:Destroy()
end)

-- ==========================================
-- 📐 EDGE RESIZING LOGIC
-- ==========================================
local BORDER_THICKNESS = 8
local MIN_SIZE = Vector2.new(220, 250)

local rightHandle = Instance.new("TextButton")
rightHandle.Name = "RightHandle"
rightHandle.Size = UDim2.new(0, BORDER_THICKNESS, 1, -35)
rightHandle.Position = UDim2.new(1, -BORDER_THICKNESS, 0, 35)
rightHandle.BackgroundTransparency = 1
rightHandle.Text = ""
rightHandle.ZIndex = 10
rightHandle.Parent = main

local bottomHandle = Instance.new("TextButton")
bottomHandle.Name = "BottomHandle"
bottomHandle.Size = UDim2.new(1, -BORDER_THICKNESS, 0, BORDER_THICKNESS)
bottomHandle.Position = UDim2.new(0, 0, 1, -BORDER_THICKNESS)
bottomHandle.BackgroundTransparency = 1
bottomHandle.Text = ""
bottomHandle.ZIndex = 10
bottomHandle.Parent = main

local cornerHandle = Instance.new("TextButton")
cornerHandle.Name = "CornerHandle"
cornerHandle.Size = UDim2.new(0, BORDER_THICKNESS * 2, 0, BORDER_THICKNESS * 2)
cornerHandle.Position = UDim2.new(1, -BORDER_THICKNESS * 2, 1, -BORDER_THICKNESS * 2)
cornerHandle.BackgroundTransparency = 1
cornerHandle.Text = ""
cornerHandle.ZIndex = 11
cornerHandle.Parent = main

local resizing = false
local currentMode = nil
local resizeStartMouse, resizeStartSize

local function attachResize(handle, mode)
    AddConnection(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            currentMode = mode
            resizeStartMouse = input.Position
            resizeStartSize = Vector2.new(main.AbsoluteSize.X, main.AbsoluteSize.Y)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    currentMode = nil
                end
            end)
        end
    end))
end

attachResize(rightHandle, "Right")
attachResize(bottomHandle, "Bottom")
attachResize(cornerHandle, "Corner")

AddConnection(UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStartMouse
        local newWidth = resizeStartSize.X
        local newHeight = resizeStartSize.Y

        if currentMode == "Right" or currentMode == "Corner" then
            newWidth = math.max(MIN_SIZE.X, resizeStartSize.X + delta.X)
        end
        if currentMode == "Bottom" or currentMode == "Corner" then
            newHeight = math.max(MIN_SIZE.Y, resizeStartSize.Y + delta.Y)
        end

        main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end))

-- ==========================================
-- 1️⃣ PROXIMITY PROMPT BYPASS
-- ==========================================
local isBypassActive = true
local proxDelay = 0.0

local proxBtn = createToggleButton("ProxBtn", "PROXIMITY BYPASS: AKTIF", 1)
proxBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

proxBtn.MouseButton1Click:Connect(function()
    isBypassActive = not isBypassActive
    proxBtn.BackgroundColor3 = isBypassActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    proxBtn.Text = "PROXIMITY BYPASS: " .. (isBypassActive and "AKTIF" or "NONAKTIF")
end)

createSlider("Durasi Delay", 0.0, 5.0, 0.0, 2, function(val)
    proxDelay = val
end)

local function setupPromptBypass(prom)
    if prom:IsA("ProximityPrompt") then
        AddConnection(prom.PromptButtonHoldBegan:Connect(function()
            if not isBypassActive then return end
            if prom.HoldDuration <= 0 then return end
            if proxDelay > 0 then task.wait(proxDelay) end
            fireproximityprompt(prom, 0)
        end))
    end
end

for _, prom in next, workspace:GetDescendants() do setupPromptBypass(prom) end
AddConnection(workspace.DescendantAdded:Connect(setupPromptBypass))

-- ==========================================
-- 2️⃣ ZOOM UNLOCK
-- ==========================================
local isZoomActive = false
local zoomBtn = createToggleButton("ZoomBtn", "MAX ZOOM: NONAKTIF", 3)

zoomBtn.MouseButton1Click:Connect(function()
    isZoomActive = not isZoomActive
    zoomBtn.BackgroundColor3 = isZoomActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    zoomBtn.Text = "MAX ZOOM: " .. (isZoomActive and "AKTIF" or "NONAKTIF")
    
    if isZoomActive then
        LocalPlayer.CameraMaxZoomDistance = 99999
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    else
        LocalPlayer.CameraMaxZoomDistance = 128
    end
end)

-- ==========================================
-- 3️⃣ GOD MODE
-- ==========================================
local isGodActive = false
local godBtn = createToggleButton("GodBtn", "GOD MODE: NONAKTIF", 4)
local godHumanoid = nil
local godRenderConn = nil

local function updateGodMode()
    if not godHumanoid then return end
    if isGodActive then
        godHumanoid.BreakJointsOnDeath = false
        godHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        godHumanoid.Health = 100

        if not godRenderConn then
            godRenderConn = AddConnection(RunService.RenderStepped:Connect(function()
                if godHumanoid and godHumanoid.Parent and godHumanoid.Health < 100 then
                    godHumanoid.Health = 100
                end
            end))
        end
    else
        godHumanoid.BreakJointsOnDeath = true
        godHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        if godRenderConn then
            godRenderConn:Disconnect()
            godRenderConn = nil
        end
    end
end

local function setupGodCharacter(char)
    godHumanoid = char:WaitForChild("Humanoid", 5)
    if not godHumanoid then return end
    updateGodMode()

    AddConnection(godHumanoid.Died:Connect(function()
        if isGodActive then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local newHumanoid = Instance.new("Humanoid")
            newHumanoid.Parent = char
            godHumanoid:Destroy()
            godHumanoid = newHumanoid
            setupGodCharacter(char)
            if hrp then char:MoveTo(hrp.Position) end
        end
    end))
end

AddConnection(LocalPlayer.CharacterAdded:Connect(setupGodCharacter))
if LocalPlayer.Character then setupGodCharacter(LocalPlayer.Character) end

godBtn.MouseButton1Click:Connect(function()
    isGodActive = not isGodActive
    godBtn.BackgroundColor3 = isGodActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    godBtn.Text = "GOD MODE: " .. (isGodActive and "AKTIF" or "NONAKTIF")
    updateGodMode()
end)

-- ==========================================
-- 4️⃣ FLY HACK
-- ==========================================
local flySpeed = 100
local flyGyro, flyVel
local flyBtn = createToggleButton("FlyBtn", "FLY: NONAKTIF", 5)

createSlider("Kecepatan Terbang", 10, 500, 100, 6, function(val)
    flySpeed = val
end)

local function startFlying()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyGyro = Instance.new("BodyGyro", hrp)
    flyGyro.P = 9e4
    flyGyro.maxTorque = Vector3.new(9e4, 9e4, 9e4)
    flyGyro.CFrame = workspace.CurrentCamera.CFrame

    flyVel = Instance.new("BodyVelocity", hrp)
    flyVel.maxForce = Vector3.new(9e4, 9e4, 9e4)
    flyVel.velocity = Vector3.new(0, 0, 0)

    RunService:BindToRenderStep("MultiToolFlyStep", Enum.RenderPriority.Character.Value, function()
        if not isFlyActive then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end

        flyGyro.CFrame = cam.CFrame
        flyVel.velocity = (moveDir.Magnitude > 0 and moveDir.Unit or Vector3.new()) * flySpeed
    end)
end

stopFlying = function()
    if flyGyro then flyGyro:Destroy() end
    if flyVel then flyVel:Destroy() end
    RunService:UnbindFromRenderStep("MultiToolFlyStep")
end

flyBtn.MouseButton1Click:Connect(function()
    isFlyActive = not isFlyActive
    flyBtn.BackgroundColor3 = isFlyActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    flyBtn.Text = "FLY: " .. (isFlyActive and "AKTIF" or "NONAKTIF")
    
    if isFlyActive then
        startFlying()
    else
        stopFlying()
    end
end)

-- ==========================================
-- 5️⃣ FOLLOW PLAYER (TP BEHIND)
-- ==========================================
local followFrame = Instance.new("Frame")
followFrame.Size = UDim2.new(1, -10, 0, 70)
followFrame.BackgroundTransparency = 1
followFrame.LayoutOrder = 7
followFrame.Parent = scroll

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, 0, 0, 30)
targetInput.Position = UDim2.new(0, 0, 0, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetInput.PlaceholderText = "Ketik Nama Player..."
targetInput.Text = ""
targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
targetInput.Font = Enum.Font.SourceSans
targetInput.TextSize = 14
targetInput.Parent = followFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = targetInput

local followBtn = Instance.new("TextButton")
followBtn.Size = UDim2.new(1, 0, 0, 32)
followBtn.Position = UDim2.new(0, 0, 0, 35)
followBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
followBtn.Text = "FOLLOW PLAYER: NONAKTIF"
followBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
followBtn.Font = Enum.Font.SourceSansBold
followBtn.TextSize = 14
followBtn.Parent = followFrame

local followCorner = Instance.new("UICorner")
followCorner.CornerRadius = UDim.new(0, 5)
followCorner.Parent = followBtn

local isFollowActive = false
local targetPlayer = nil

local function getPlayerByPartialName(name)
    name = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(name) or p.DisplayName:lower():find(name)) then
            return p
        end
    end
    return nil
end

followBtn.MouseButton1Click:Connect(function()
    isFollowActive = not isFollowActive
    if isFollowActive then
        targetPlayer = getPlayerByPartialName(targetInput.Text)
        if targetPlayer then
            followBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            followBtn.Text = "FOLLOWING: " .. targetPlayer.DisplayName
        else
            isFollowActive = false
            followBtn.Text = "PLAYER TIDAK DITEMUKAN"
            task.wait(1.5)
            followBtn.Text = "FOLLOW PLAYER: NONAKTIF"
        end
    else
        followBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        followBtn.Text = "FOLLOW PLAYER: NONAKTIF"
    end
end)

AddConnection(RunService.RenderStepped:Connect(function()
    if isFollowActive and targetPlayer and targetPlayer.Character then
        local myChar = LocalPlayer.Character
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myChar and targetHRP then
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 4)
            end
        end
    end
end))

-- ==========================================
-- 6️⃣ CLICK TELEPORT
-- ==========================================
local isClickTpActive = false
local clickTpBtn = createToggleButton("ClickTpBtn", "CLICK TELEPORT: NONAKTIF", 8)

clickTpBtn.MouseButton1Click:Connect(function()
    isClickTpActive = not isClickTpActive
    clickTpBtn.BackgroundColor3 = isClickTpActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    clickTpBtn.Text = "CLICK TELEPORT: " .. (isClickTpActive and "AKTIF" or "NONAKTIF")
end)

local function makeTpMarker(pos)
    local marker = Instance.new("Part")
    marker.Anchored = true
    marker.CanCollide = false
    marker.Size = Vector3.new(1, 0.2, 1)
    marker.Color = Color3.fromRGB(0, 255, 0)
    marker.Material = Enum.Material.Neon
    marker.CFrame = CFrame.new(pos)
    marker.Transparency = 0.3
    marker.Parent = workspace
    Debris:AddItem(marker, 0.4)
end

AddConnection(Mouse.Button1Down:Connect(function()
    if not isClickTpActive then return end
    local target = Mouse.Hit
    if not target then return end
    
    local pos = target.Position
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Offset +3 studs ke atas agar karakter tidak terperangkap di tanah
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    makeTpMarker(pos)
end))
