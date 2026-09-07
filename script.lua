-- [[ BLOX FRUITS - ULTRA HUB v10 (PRO AUTO FARM + QUEST & FLY) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -180)
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
Title.Text = "⚡ Blox Fruits Hub - Real Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
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

local function makeBtn(txt, isDestructive)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.BackgroundColor3 = isDestructive and Color3.fromRGB(60, 20, 20) or Color3.fromRGB(30, 30, 45)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Font = Enum.Font.GothamSemibold
    b.Text = txt .. (isDestructive and "" or ": OFF")
    b.TextColor3 = isDestructive and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(180, 180, 180)
    b.TextSize = 14
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local FarmBtn = makeBtn("Auto Farm (Real Quest + Fly)")
local AttackBtn = makeBtn("Auto Attack (Click)")
local EspBtn = makeBtn("ESP Frutas (Nome + Distância)")
local ExitBtn = makeBtn("❌ Finalizar / Fechar Script", true)

local _Farm = false
local _Attack = false
local _EspFruit = false
local espDrawings = {}

local function clearEsp()
    for _, obj in pairs(espDrawings) do
        if obj then obj:Destroy() end
    end
    espDrawings = {}
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

-- Sistema de Quests e Auto Farm Real com Fly Lento Embutido
task.spawn(function()
    while true do
        task.wait(0.2)
        if _Farm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then return end
                local root = char.HumanoidRootPart
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                
                if humanoid.Health <= 0 then return end

                -- Verifica se a quest está ativa no PlayerGui
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local hasQuest = false
                if playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest") then
                    hasQuest = playerGui.Main.Quest.Visible
                end

                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local commF = remotes and remotes:FindFirstChild("CommF_")

                -- Se não tiver missão, pega automaticamente baseada no nível atual do player
                if not hasQuest and commF then
                    local lvl = LocalPlayer.Data.Level.Value
                    if lvl >= 1 and lvl <= 9 then
                        commF:InvokeServer("StartQuest", "BanditQuest1", 1)
                    elseif lvl >= 10 and lvl <= 14 then
                        commF:InvokeServer("StartQuest", "JungleQuest", 1)
                    elseif lvl >= 15 and lvl <= 29 then
                        commF:InvokeServer("StartQuest", "JungleQuest", 2)
                    elseif lvl >= 30 and lvl <= 39 then
                        commF:InvokeServer("StartQuest", "BuggyQuest1", 1)
                    elseif lvl >= 40 and lvl <= 59 then
                        commF:InvokeServer("StartQuest", "BuggyQuest1", 2)
                    elseif lvl >= 60 and lvl <= 89 then
                        commF:InvokeServer("StartQuest", "DesertQuest", 1)
                    elseif lvl >= 90 and lvl <= 119 then
                        commF:InvokeServer("StartQuest", "DesertQuest", 2)
                    else
                        commF:InvokeServer("StartQuest", "BanditQuest1", 1)
                    end
                end

                -- Varre os inimigos na pasta Enemies
                local targetMob = nil
                local enemiesFolder = Workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    local shortestDist = math.huge
                    for _, mob in pairs(enemiesFolder:GetChildren()) do
                        local mobHum = mob:FindFirstChildOfClass("Humanoid")
                        local mobHrp = mob:FindFirstChild("HumanoidRootPart")
                        if mobHum and mobHrp and mobHum.Health > 0 then
                            local dist = (mobHrp.Position - root.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                targetMob = mobHrp
                            end
                        end
                    end
                end

                -- Teleporte suave com Fly Lento integrado (mantém 7 studs acima para não afundar no chão)
                if targetMob then
                    humanoid.PlatformStand = true
                    local targetCFrame = targetMob.CFrame + Vector3.new(0, 7, 0)
                    root.CFrame = root.CFrame:Lerp(targetCFrame, 0.3)
                    root.Velocity = Vector3.new(0, 0, 0)
                else
                    humanoid.PlatformStand = false
                end
            end)
        else
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end)
        end
    end
end)

-- ESP de Frutas (Vermelho, Nome e Distância)
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

-- Botões Click Events
FarmBtn.MouseButton1Click:Connect(function()
    _Farm = not _Farm
    FarmBtn.Text = "Auto Farm (Real Quest + Fly): " .. (_Farm and "ON" or "OFF")
    FarmBtn.TextColor3 = _Farm and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
end)

AttackBtn.MouseButton1Click:Connect(function()
    _Attack = not _Attack
    AttackBtn.Text = "Auto Attack (Click): " .. (_Attack and "ON" or "OFF")
    AttackBtn.TextColor3 = _Attack and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
end)

EspBtn.MouseButton1Click:Connect(function()
    _EspFruit = not _EspFruit
    EspBtn.Text = "ESP Frutas (Nome + Distância): " .. (_EspFruit and "ON" or "OFF")
    EspBtn.TextColor3 = _EspFruit and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(180, 180, 180)
    if not _EspFruit then clearEsp() end
end)

ExitBtn.MouseButton1Click:Connect(function()
    _Farm = false
    _Attack = false
    _EspFruit = false
    clearEsp()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
    ScreenGui:Destroy()
end)
