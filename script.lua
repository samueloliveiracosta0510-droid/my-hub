-- [[ BLOX FRUITS - ULTRA HUB v4 (COM AUTO FARM INTELIGENTE) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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
Title.Text = "⚡ Blox Fruits Hub - Auto Farm Pro"
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

local FarmBtn = makeBtn("Auto Farm Level (Pro)")
local AttackBtn = makeBtn("Auto Attack (Click)")
local FlyBtn = makeBtn("Fly Lento Seguro")

local _Farm = false
local _Attack = false
local _Fly = false

-- Fly Variables
local speed = 30
local bv, bg, char, root, hum

local function startFly()
    char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = root
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = root.CFrame
    bg.Parent = root
end

local function stopFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if hum then hum.PlatformStand = false end
end

-- Auto Attack Otimizado
RunService.Stepped:Connect(function()
    if _Attack then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end)

-- Fly Lento Estável
RunService.RenderStepped:Connect(function()
    if _Fly and root and hum and bg and bv then
        hum.PlatformStand = true
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        local uis = game:GetService("UserInputService")
        
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        
        bv.Velocity = move * speed
        bg.CFrame = cam.CFrame
    end
end)

-- Auto Farm Avançado (Varredura contínua de Inimigos e trancamento de alvo)
task.spawn(function()
    while true do
        task.wait(0.2)
        if _Farm then
            pcall(function()
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in pairs(enemiesFolder:GetChildren()) do
                        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        
                        if _Farm and humanoid and hrp and humanoid.Health > 0 then
                            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if myHrp then
                                -- Mantém o personagem flutuando logo acima/atrás do mob para evitar dano direto e garantir o hit
                                myHrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 4)
                                
                                -- Equipa a arma/melee ativa automaticamente se houver
                                if LocalPlayer.Backpack:FindFirstChildOfClass("Tool") then
                                    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                                    if tool and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Botões Click Events
FarmBtn.MouseButton1Click:Connect(function()
    _Farm = not _Farm
    FarmBtn.Text = "Auto Farm Level (Pro): " .. (_Farm and "ON" or "OFF")
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
