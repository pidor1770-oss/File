-- Универсальный эксплоит для тестирования уязвимостей в играх Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- GUI для управления эксплоитом
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "⚠️ GAME BREAKER TOOLKIT"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.Parent = MainFrame

-- Методы обхода защиты
local function BypassAntiCheat()
    -- Обход базовых античитов
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    
    -- Защита от кика
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

-- Функция для краша сервера (теоретическая)
local function CrashServer()
    -- Создание большого количества объектов
    for i = 1, 10000 do
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Position = Vector3.new(0, 1000, 0)
        task.wait(0.001)
    end
end

-- Перехват и модификация сетевых событий
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

-- Изменение игровых переменных в реальном времени
local function ModifyGameValues()
    -- Поиск и изменение важных значений
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
    if SpeedHackEnabled then
        game:GetService("Workspace").Gravity = 196.2 * SpeedMultiplier
        LocalPlayer.Character.Humanoid.WalkSpeed = 50 * SpeedMultiplier
        LocalPlayer.Character.Humanoid.JumpPower = 50 * SpeedMultiplier
    else
        game:GetService("Workspace").Gravity = 196.2
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end

-- Создание кнопок интерфейса
local yOffset = 50
local function CreateButton(text, yPos, callback, dangerous)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 320, 0, 40)
    button.Position = UDim2.new(0, 15, 0, yPos)
    button.Text = text
    button.TextColor3 = dangerous and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = dangerous and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Опасные функции
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

CreateButton("☢️ Тест на устойчивость", yOffset, function()
    warn("Testing game stability...")
    CrashServer()
end, true)
yOffset = yOffset + 45

-- Предупреждение
local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(0, 320, 0, 60)
warning.Position = UDim2.new(0, 15, 0, yOffset)
warning.Text = "⚠️ ВНИМАНИЕ: Использование может привести к банам и нарушению правил игры. Только для образовательных целей!"
warning.TextColor3 = Color3.fromRGB(255, 100, 100)
warning.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
warning.TextWrapped = true
warning.Parent = MainFrame

-- Функция для перемещения GUI
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Авто-обновление NoClip
RunService.Stepped:Connect(function()
    if NoClipEnabled and LocalPlayer.Character then
        NoClip()
    end
    if SpeedHackEnabled and LocalPlayer.Character then
        SpeedHack()
    end
end)

warn("Game Breaker Toolkit loaded! Use with extreme caution.")
