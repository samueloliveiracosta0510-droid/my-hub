-- [[ BLOX FRUITS - ESP + TELEPORT PARA FRUTA MAIS PRÓXIMA ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

if LocalPlayer.PlayerGui:FindFirstChild("FruitEspHub") then
    LocalPlayer.PlayerGui.FruitEspHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitEspHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.Size = UDim2.new(0, 300, 0, 190)
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
Title.Text = "🍎 Blox Fruits - ESP & TP Frutas"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local EspBtn = Instance.new("TextButton")
EspBtn.Parent = MainFrame
EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
EspBtn.Position = UDim2.new(0, 15, 0, 55)
EspBtn.Size = UDim2.new(1, -30, 0, 40)
EspBtn.Font = Enum.Font.GothamSemibold
EspBtn.Text = "ESP Frutas: OFF"
EspBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
EspBtn.TextSize = 14

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 8)
BtnCorner1.Parent = EspBtn

local TpBtn = Instance.new("TextButton")
TpBtn.Parent = MainFrame
TpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TpBtn.Position = UDim2.new(0, 15, 0, 110)
TpBtn.Size = UDim2.new(1, -30, 0, 40)
TpBtn.Font = Enum.Font.GothamSemibold
TpBtn.Text = "⚡ Teleportar para Fruta Mais Próxima"
TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBtn.TextSize = 14

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = TpBtn

local _EspFruit = false
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

EspBtn.MouseButton1Click:Connect(function()
    _EspFruit = not _EspFruit
    EspBtn.Text = "ESP Frutas: " .. (_EspFruit and "ON" or "OFF")
    EspBtn.TextColor3 = _EspFruit and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
    if not _EspFruit then clearEsp() end
end)

-- Botão de Teleport para a Fruta Mais Próxima
TpBtn.MouseButton1Click:Connect(function()
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
