-- [[ BLOX FRUITS - ULTRA CUSTOM GUI (DELTA / EMULADOR) ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Evitar multiplas execuções da GUI
if LocalPlayer.PlayerGui:FindFirstChild("OptimizedBloxFruitsHub") then
    LocalPlayer.PlayerGui.OptimizedBloxFruitsHub:Destroy()
end

-- Criando a Interface Gráfica Moderna
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OptimizedBloxFruitsHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- TopBar / Cabeçalho
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Blox Fruits - Hub Otimizado (Delta)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container dos Botões
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 55)
Container.Size = UDim2.new(1, -20, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 0, 300)
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Função criadora de Botões Customizados
local function createButton(name, defaultText)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = defaultText .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

local AutoFarmBtn = createButton("AutoFarm", "Auto Farm Level")
local AutoAttackBtn = createButton("AutoAttack", "Auto Attack / Click")
local SlowFlyBtn = createButton("SlowFly", "Fly Lento (Seguro)")

-- Variáveis de Estado das Funções
local _G_AutoFarm = false
local _G_AutoAttack = false
local _G_SlowFly = false

-- Variáveis do Fly Lento
local flySpeed = 35 -- Velocidade segura para emulador/Delta
local bv, bg
local character, rootPart, humanoid

local function setupFly()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = rootPart.CFrame
    bg.Parent = rootPart
end

local function removeFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- Lógica do Auto Attack (Simula cliques rápidos na tela/mouse)
RunService.Stepped:Connect(function()
    if _G_AutoAttack then
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
end)

-- Lógica do Fly Lento
RunService.RenderStepped:Connect(function()
    if _G_SlowFly and rootPart and humanoid and bg and bv then
        humanoid.PlatformStand = true
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        
        bv.Velocity = moveDirection * flySpeed
        bg.CFrame = camera.CFrame
    elseif humanoid then
        humanoid.PlatformStand = false
    end
end)

-- Lógica Básica do Auto Farm (Procura Missão / Inimigos próximos de forma segura)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G_AutoFarm then
            pcall(function()
                -- Simulação de busca segura por mobs para evitar crash no Delta
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if _G_AutoFarm and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teletransporte suave até o mob de forma controlada
                            LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 3)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Eventos de Clique nos Botões da GUI
AutoFarmBtn.MouseButton1Click:Connect(function()
    _G_AutoFarm = not _G_AutoFarm
    AutoFarmBtn.Text = "Auto Farm Level: " .. (_G_AutoFarm and "ON" or "OFF")
    AutoFarmBtn.TextColor3 = _G_AutoFarm and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
end)

AutoAttackBtn.MouseButton1Click:Connect(function()
    _G_AutoAttack = not _G_AutoAttack
    AutoAttackBtn.Text = "Auto Attack / Click: " + (_G_AutoAttack and "ON" or "OFF") -- Corrigido para concatenar em Lua
    AutoAttackBtn.Text = "Auto Attack / Click: " .. (_G_AutoAttack and "ON" or "OFF")
    AutoAttackBtn.TextColor3 = _G_AutoAttack and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
end)

SlowFlyBtn.MouseButton1Click:Connect(function()
    _G_SlowFly = not _G_SlowFly
    SlowFlyBtn.Text = "Fly Lento (Seguro): " .. (_G_SlowFly and "ON" or "OFF")
    SlowFlyBtn.TextColor3 = _G_SlowFly and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(200, 200, 200)
    
    if _G_SlowFly then
        setupFly()
    else
        removeFly()
        if humanoid then humanoid.PlatformStand = false end
    end
end)
