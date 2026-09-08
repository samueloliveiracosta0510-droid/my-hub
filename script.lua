-- [[ BLOX FRUITS - HUB COMPLETO (ESP FRUTAS + TP + FLY + REACH) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

if LocalPlayer.PlayerGui:FindFirstChild("CompleteBloxFruitsHub") then
    LocalPlayer.PlayerGui.CompleteBloxFruitsHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CompleteBloxFruitsHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -190)
MainFrame.Size = UDim2.new(0, 340, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -12, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Blox Fruits - Hub Pro (ESP + TP + Fly)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize, Title.TextXAlignment = 12, Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.BackgroundTransparency = 1
Scroll.Position = UDim2.new(0, 12, 0, 50)
Scroll.Size = UDim2.new(1, -24, 1, -60)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 360)
Scroll.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local function makeBtn(txt)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Font = Enum.Font.GothamSemibold
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local EspBtn = makeBtn("ESP Frutas")
local TpFruitBtn = Instance.new("TextButton")
TpFruitBtn.Parent = Scroll
TpFruitBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
TpFruitBtn.Size = UDim2.new(1, 0, 0, 40)
TpFruitBtn.Font = Enum.Font.GothamSemibold
TpFruitBtn.Text = "⚡ TP para Fruta Mais Próxima"
TpFruitBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
TpFruitBtn.TextSize = 13
Instance.new("UICorner", TpFruitBtn).CornerRadius = UDim.new(0, 8)

local FlyBtn = makeBtn("Fly (Controle de Velocidade)")
local ReachBtn = makeBtn("Auto Attack + Reach (Longe)")

-- Controles de Velocidade do Fly
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Parent = Scroll
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Size = UDim2.new(1, 0, 0, 35)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = SpeedFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0.5, 0, 1, 0)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "Velocidade: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = SpeedFrame
MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
MinusBtn.Position = UDim2.new(0.55, 0, 0, 0)
MinusBtn.Size = UDim2.new(0, 40, 0, 35)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
MinusBtn.TextSize = 16
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = SpeedFrame
PlusBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
PlusBtn.Position = UDim2.new(0.75, 0, 0, 0)
PlusBtn.Size = UDim2.new(0, 40, 0, 35)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
PlusBtn.TextSize = 16
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

local _EspFruit, _Fly, _Reach = false, false, false
local flySpeed = 50
local bv, bg
local espDrawings = {}

local function clearEsp()
    for _, obj in pairs(espDrawings) do
        if obj then obj:Destroy() end
    end
    espDrawings = {}
end

-- ESP Loop
task.spawn(function()
    while true do
        task.wait(1)
        if _EspFruit then
            pcall(function()
                clearEsp()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") or obj.Name:find("Fruit") then
                        local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
                        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if handle and myRoot then
                            local distance = math.floor((handle.Position - myRoot.Position).Magnitude)
                            local bill = Instance.new("BillboardGui")
                            bill.Name = "FruitESP"
                            bill.Adornee = handle
                            bill.Size = UDim2.new(0, 150, 0, 50)
                            bill.StudsOffset = Vector3.new(0, 2, 0)
                            bill.AlwaysOnTop = true
                            
                            local label = Instance.new("TextLabel")
                            label.Parent = bill
                            label.BackgroundTransparency = 1
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 13
                            label.TextColor3 = Color3.fromRGB(255, 0, 0)
                            label.TextStrokeTransparency = 0
                            label.Text = "🍎 " .. obj.Name .. "\n[" .. distance .. "m]"
                            
                            bill.Parent = handle
                            table.insert(espDrawings, bill)
                        end
                    end
                end
            end)
        else
            clearEsp()
        end
    end
end)

-- TP para Fruta mais próxima
TpFruitBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        
        local nearestFruit = nil
        local shortestDist = math.huge
        
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") or obj.Name:find("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
                if handle then
                    local dist = (handle.Position - root.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearestFruit = handle
                    end
                end
            end
        end
        
        if nearestFruit then
            root.CFrame = nearestFruit.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end)

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

RunService.RenderStepped:Connect(function()
    if _Fly then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if bv and bg then
                local cam = Workspace.CurrentCamera
                local move = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                bv.Velocity = move * flySpeed
                bg.CFrame = cam.CFrame
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if _Reach then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local enemiesFolder = Workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, mob in pairs(enemiesFolder:GetChildren()) do
                        local mobHrp = mob:FindFirstChild("HumanoidRootPart")
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        if mobHrp and mobHum and mobHum.Health > 0 then
                            if (mobHrp.Position - root.Position).Magnitude < 35 then
                                mobHrp.CFrame = root.CFrame * CFrame.new(0, 0, -3)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    _EspFruit = not _EspFruit
    EspBtn.Text = "ESP Frutas: " .. (_EspFruit and "ON" or "OFF")
    EspBtn.TextColor3 = _EspFruit and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
    if not _EspFruit then clearEsp() end
end)

FlyBtn.MouseButton1Click:Connect(function()
    _Fly = not _Fly
    FlyBtn.Text = "Fly: " .. (_Fly and "ON" or "OFF")
    FlyBtn.TextColor3 = _Fly and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
    if _Fly then startFly() else stopFly() end
end)

ReachBtn.MouseButton1Click:Connect(function()
    _Reach = not _Reach
    ReachBtn.Text = "Auto Attack + Reach: " .. (_Reach and "ON" or "OFF")
    ReachBtn.TextColor3 = _Reach and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
end)

PlusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 15, 250)
    SpeedLabel.Text = "Velocidade: " .. flySpeed
end)

MinusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 15, 15)
    SpeedLabel.Text = "Velocidade: " .. flySpeed
end)
