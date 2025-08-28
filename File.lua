-- Улучшенный Game Breaker Toolkit с компактным GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Создаем GUI для управления эксплоитом
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Основной фрейм (компактный, в виде полоски)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 40)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
MainFrame.Parent = ScreenGui

-- Заголовок с кнопкой сворачивания
local Title = Instance.new("TextButton")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "⚠️ GAME BREAKER"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Переменные для управления
local GUIExpanded = false

-- Контент фрейм (изначально скрыт)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 0, 400)
ContentFrame.Position = UDim2.new(0, 0, 1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Visible = false
ContentFrame.Parent = MainFrame

-- Методы обхода защиты
local function BypassAntiCheat()
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    
    local oldNamecall
    if mt then
        oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if tostring(method):lower() == "kick" then
                warn("Kick attempt blocked")
                return nil
            end
            return oldNamecall(self, ...)
        end)
    end
end

-- Улучшенная функция для краша сервера с использованием Part
local function CrashServer()
    warn("Testing game stability with Part objects...")
    
    -- Создаем большое количество Part объектов
    for i = 1, 2000 do
        local part = Instance.new("Part")
        part.Name = "CrashPart_" .. i
        part.Size = Vector3.new(5, 5, 5)
        part.Position = Vector3.new(
            math.random(-500, 500),
            math.random(100, 500),
            math.random(-500, 500)
        )
        part.Anchored = true
        part.CanCollide = true
        part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        part.Material = Enum.Material.Neon
        part.Parent = workspace
        
        -- Добавляем дополнительные эффекты для увеличения нагрузки
        if i % 100 == 0 then
            local fire = Instance.new("Fire")
            fire.Parent = part
            fire.Size = 10
            fire.Heat = 10
        end
        
        if i % 50 == 0 then
            local smoke = Instance.new("Smoke")
            smoke.Parent = part
            smoke.Size = 10
            smoke.Opacity = 0.5
        end
        
        -- Небольшая задержка для увеличения времени выполнения
        if i % 100 == 0 then
            task.wait(0.01)
        end
    end
    
    -- Дополнительная нагрузка на сервер
    for i = 1, 100 do
        local explosion = Instance.new("Explosion")
        explosion.Position = Vector3.new(math.random(-100, 100), 10, math.random(-100, 100))
        explosion.BlastPressure = 100000
        explosion.BlastRadius = 50
        explosion.Parent = workspace
    end
    
    warn("Crash test completed with 2000 Part objects created")
end

-- Перехват сетевых событий
local function HookRemoteEvents()
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldFire = remote.FireServer
            remote.FireServer = newcclosure(function(self, ...)
                print("Intercepted Remote: " .. remote.Name)
                print("Arguments: " .. HttpService:JSONEncode({...}))
                return oldFire(self, ...)
            end)
        end
    end
end

-- Изменение игровых переменных
local function ModifyGameValues()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("StringValue") then
            if obj.Name:lower():find("health") or obj.Name:lower():find("money") then
                obj.Value = 999999
            end
        end
    end
end

-- NoClip режим
local NoClipEnabled = false
local function NoClip()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not NoClipEnabled
            end
        end
    end
end

-- Ускорение игры
local SpeedHackEnabled = false
local SpeedMultiplier = 2
local function SpeedHack()
    if SpeedHackEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            game:GetService("Workspace").Gravity = 196.2 * SpeedMultiplier
            humanoid.WalkSpeed = 50 * SpeedMultiplier
            humanoid.JumpPower = 50 * SpeedMultiplier
        end
    else
        game:GetService("Workspace").Gravity = 196.2
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end
end

-- Создание кнопок интерфейса
local yOffset = 10
local function CreateButton(text, yPos, callback, dangerous)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Text = text
    button.TextColor3 = dangerous and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = dangerous and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Parent = ContentFrame
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Создаем кнопки
CreateButton("🛡️ Обход античита", yOffset, BypassAntiCheat, false)
yOffset = yOffset + 45

CreateButton("🎯 Перехват сетевых событий", yOffset, HookRemoteEvents, false)
yOffset = yOffset + 45

CreateButton("⚡ Изменить игровые значения", yOffset, ModifyGameValues, true)
yOffset = yOffset + 45

CreateButton("🚀 NoClip режим", yOffset, function()
    NoClipEnabled = not NoClipEnabled
    NoClip()
end, false)
yOffset = yOffset + 45

CreateButton("💨 Ускорение игры", yOffset, function()
    SpeedHackEnabled = not SpeedHackEnabled
    SpeedHack()
end, false)
yOffset = yOffset + 45

CreateButton("☢️ Тест на устойчивость (Part)", yOffset, CrashServer, true)
yOffset = yOffset + 45

-- Кнопка закрытия GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 180, 0, 40)
closeButton.Position = UDim2.new(0, 10, 0, yOffset)
closeButton.Text = "СКРЫТЬ МЕНЮ"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Parent = ContentFrame

closeButton.MouseButton1Click:Connect(function()
    GUIExpanded = false
    ContentFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 200, 0, 40)
end)

-- Предупреждение
local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(0, 180, 0, 60)
warning.Position = UDim2.new(0, 10, 0, yOffset + 45)
warning.Text = "⚠️ ВНИМАНИЕ: Использование может привести к банам!"
warning.TextColor3 = Color3.fromRGB(255, 100, 100)
warning.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
warning.TextWrapped = true
warning.Parent = ContentFrame

-- Функция для перемещения GUI
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Обработчик клика по заголовку
Title.MouseButton1Click:Connect(function()
    GUIExpanded = not GUIExpanded
    ContentFrame.Visible = GUIExpanded
    MainFrame.Size = GUIExpanded and UDim2.new(0, 200, 0, 440) or UDim2.new(0, 200, 0, 40)
end)

-- Авто-обновление NoClip и SpeedHack
RunService.Stepped:Connect(function()
    if NoClipEnabled and LocalPlayer.Character then
        NoClip()
    end
    if SpeedHackEnabled and LocalPlayer.Character then
        SpeedHack()
    end
end)

warn("Improved Game Breaker Toolkit loaded! Click the title to expand/collapse.")
