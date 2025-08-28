-- Исправленный Game Breaker Toolkit с прокруткой
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаем GUI для управления эксплоитом
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Основной фрейм (компактный, в виде полоски) - размещаем по центру
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 40) -- Фиксированный размер
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0) -- Центр сверху
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

-- Контент фрейм с прокруткой (изначально скрыт)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0, 300) -- Фиксированная высота с прокруткой
ScrollFrame.Position = UDim2.new(0, 0, 1, 0)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450) -- Внутренний размер контента
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

-- Контейнер для кнопок внутри ScrollFrame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = ScrollFrame

-- ... (остальной код функций BypassAntiCheat, CrashServer и т.д. остается без изменений)

-- Создание кнопок ВНУТРИ ContentFrame
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

-- Создаем кнопки ВНУТРИ ContentFrame
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

CreateButton("☢️ Тест на устойчивость", yOffset, CrashServer, true)
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
    ScrollFrame.Visible = false
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

-- Обработчик клика по заголовку
Title.MouseButton1Click:Connect(function()
    GUIExpanded = not GUIExpanded
    ScrollFrame.Visible = GUIExpanded
    MainFrame.Size = GUIExpanded and UDim2.new(0, 200, 0, 340) or UDim2.new(0, 200, 0, 40)
end)

-- ... (остальной код перемещения GUI и авто-обновления функций без изменений)

warn("Game Breaker Toolkit loaded! Click the title to expand/collapse.")
