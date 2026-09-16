-- Menggunakan CoreGui agar UI tidak hilang saat karakter mati/respawn
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Bersihkan UI lama jika mengeksekusi ulang skrip
if CoreGui:FindFirstChild("UniversalPromptBypass") then
    CoreGui.UniversalPromptBypass:Destroy()
end

-- ==========================================
-- 🎨 PEMBUATAN UI SIMPEL LATAR MERAH
-- ==========================================
local sg = Instance.new("ScreenGui")
sg.Name = "UniversalPromptBypass"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 150)
main.Position = UDim2.new(0.5, -130, 0.4, -75)
main.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Latar belakang MERAH
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true -- Bisa digeser sesuka hati di dalam game
main.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

-- Judul UI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "PROXIMITY BYPASS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = main

-- Tombol Toggle Aktif/Nonaktif
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 220, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -110, 0, 40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Default HIJAU (Aktif)
toggleBtn.Text = "STATUS: AKTIF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleBtn

-- Teks Durasi Slider
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(1, 0, 0, 25)
valueLabel.Position = UDim2.new(0, 0, 0, 85)
valueLabel.BackgroundTransparency = 1
valueLabel.Text = "Durasi: 0.0 Detik"
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.Font = Enum.Font.SourceSansItalic
valueLabel.TextSize = 14
valueLabel.Parent = main

-- Bar Slider
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 200, 0, 6)
sliderBar.Position = UDim2.new(0.5, -100, 0, 120)
sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = main

-- Tombol Geser Slider
local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 16, 0, 16)
sliderBtn.Position = UDim2.new(0, 0, 0.5, 0) -- Mulai dari paling kiri (0 detik)
sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
sliderBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
sliderBtn.Text = ""
sliderBtn.BorderSizePixel = 0
sliderBtn.Parent = sliderBar

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = sliderBtn

-- ==========================================
-- ⚙️ LOGIKA SLIDER & BYPASS
-- ==========================================
local isBypassActive = true
local sliderValue = 0.0 -- Rentang awal diset ke 0 detik
local dragging = false

-- Logika klik tombol aktif/nonaktif
toggleBtn.MouseButton1Click:Connect(function()
    isBypassActive = not isBypassActive
    if isBypassActive then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        toggleBtn.Text = "STATUS: AKTIF"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        toggleBtn.Text = "STATUS: NONAKTIF"
    end
end)

-- Pembaruan Slider (Mengatur dari 0.0 sampai 5.0 detik)
local function updateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local barPos = sliderBar.AbsolutePosition.X
    local barSize = sliderBar.AbsoluteSize.X
    
    local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
    sliderBtn.Position = UDim2.new(percentage, 0, 0.5, 0)
    
    -- Mengunci rentang waktu dari 0 ke 5 detik
    local minTime = 0.0
    local maxTime = 5.0
    local calculatedTime = minTime + (percentage * (maxTime - minTime))
    sliderValue = math.round(calculatedTime * 10) / 10 -- Membulatkan 1 angka di belakang koma
    
    valueLabel.Text = string.format("Durasi: %.1f Detik", sliderValue)
end

sliderBtn.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        updateSlider()
    end
end)

-- Fungsi Utama menggunakan logika kode kamu yang sudah terbukti WORK
local function setupPromptBypass(prom)
    if prom:IsA("ProximityPrompt") then
        prom.PromptButtonHoldBegan:Connect(function()
            -- Cek saklar UI (apakah STATUS: AKTIF)
            if not isBypassActive then return end
            
            -- Cek durasi asli prompt seperti di skrip kamu
            if prom.HoldDuration <= 0 then return end
            
            -- Menahan jeda jika slider di atas 0 detik
            if sliderValue > 0 then
                task.wait(sliderValue)
            end
            
            -- Menjalankan fungsi bawaan executor milikmu
            fireproximityprompt(prom, 0)
        end)
    end
end

-- Terapkan ke semua ProximityPrompt yang sudah ada di Map saat ini
for _, prom in next, workspace:GetDescendants() do
    setupPromptBypass(prom)
end

-- Terapkan ke ProximityPrompt baru yang baru muncul/termuat (Anti-Spam/Respawn)
workspace.DescendantAdded:Connect(function(class)
    setupPromptBypass(class)
end)
