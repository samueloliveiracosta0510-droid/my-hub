-- [[ BLOX FRUITS - ULTRA HUB v5 (FIXED AUTO FARM & FLY) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

if LocalPlayer.PlayerGui:FindFirstChild("UltraBloxFruitsHub") then
    LocalPlayer.PlayerGui.UltraBloxFruitsHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraBloxFruitsHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.Size = UDim2.new(0, 420, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Blox Fruits Hub - Fix Edition"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.BackgroundTransparency = 1
Scroll.Position = UDim2.new(0, 12, 0, 60)
Scroll.Size = UDim2.new(1, -24, 1, -70)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 320)
Scroll.ScrollBarThickness = 5

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

local function makeBtn(txt)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Font = Enum.Font.GothamSemibold
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.TextSize = 14
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local FarmBtn = makeBtn("Auto Farm Level")
local AttackBtn = makeBtn("Auto Attack (Click)")
local FlyBtn = makeBtn("Fly Lento Seguro")

local _Farm = false
local _Attack = false
local _Fly = false

-- Fly Variables Corrigidas
local speed = 35
local bv, bg

local function startFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.CFrame = root.CFrame
    bg.Parent = root
end

local function stopFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- Auto Attack
RunService.Stepped:Connect(function()
    if _Attack then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end)

-- Fly Lento Atualizado para Emulador
RunService.RenderStepped:Connect(function()
    if _Fly then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            if bv and bg then
                local cam = workspace.CurrentCamera
                local move = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                
                bv.Velocity = move * speed
                bg.CFrame = cam.CFrame
            end
        end
    end
end)

-- Auto Farm Corrigido (Busca em todo o workspace caso a pasta mude de nome)
task.spawn(function()
    while true do
        task.wait(0.3)
        if _Farm then
            pcall(function()
                local target = nil
                -- Procura tanto na pasta padrão quanto geral no workspace
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, mob in pairs(enemiesFolder:GetChildren()) do
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        local hrp = mob:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then
                            target = hrp
                            break
                        end
                    end
                end
                
                -- Se achou o mob e o player tiver vivo, teleporta em cima
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 3, 3)
                end
            end)
        end
    end
end)

-- Botões Click Events
FarmBtn.MouseButton1Click:Connect(function()
    _Farm = not _Farm
    FarmBtn.Text = "Auto Farm Level: " .. (_Farm and "ON" or "OFF")
    FarmBtn.TextColor3 = _Farm and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
end)

AttackBtn.MouseButton1Click:Connect(function()
    _Attack = not _Attack
    AttackBtn.Text = "Auto Attack (Click): " .. (_Attack and "ON" or "OFF")
    AttackBtn.TextColor3 = _Attack and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
end)

FlyBtn.MouseButton1Click:Connect(function()
    _Fly = not _Fly
    FlyBtn.Text = "Fly Lento Seguro: " .. (_Fly and "ON" or "OFF")
    FlyBtn.TextColor3 = _Fly and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
    if _Fly then startFly() else stopFly() end
end)
