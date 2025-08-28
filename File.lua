-- Улучшенный ESP чит с большими блоками и компактным GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Создаем GUI для управления
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Основной фрейм (изначально компактный)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 40)  -- Компактный размер
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Parent = ScreenGui

-- Заголовок с кнопкой сворачивания
local Title = Instance.new("TextButton")  -- Делаем кликабельным
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "👁️ ESP MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Переменные для управления
local ESPEnabled = false
local ESPObjects = {}
local GUIExpanded = false

-- Функция создания больших ESP блоков над игроками
local function CreateBigESP(player)
    if ESPObjects[player] then return end
    
    -- Создаем большой блок над головой игрока
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 100)  -- Большой размер
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500  -- Видимость на расстоянии
    billboard.Parent = ScreenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = billboard
    
    -- Текст с именем игрока
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, -20)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = billboard
    
    ESPObjects[player] = billboard
    
    -- Функция обновления позиции
    local function updatePosition()
        if player.Character and player.Character:FindFirstChild("Head") then
            billboard.Adornee = player.Character.Head
            billboard.Enabled = true
        else
            billboard.Enabled = false
        end
    end
    
    -- Обновляем позицию каждый кадр
    RunService.Heartbeat:Connect(updatePosition)
    updatePosition()
end

-- Функция обновления ESP
local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not player or not player.Parent then
            esp:Destroy()
            ESPObjects[player] = nil
        end
    end

    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateBigESP(player)
            end
        end
    else
        for player, esp in pairs(ESPObjects) do
            esp:Destroy()
            ESPObjects[player] = nil
        end
    end
end

-- Создаем расширяемый интерфейс
local function CreateExpandableGUI()
    -- Контент (изначально скрыт)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 160)
    contentFrame.Position = UDim2.new(0, 0, 1, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    contentFrame.BorderSizePixel = 0
    contentFrame.Visible = false
    contentFrame.Parent = MainFrame
    
    -- Кнопка включения/выключения ESP
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 180, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.Text = ESPEnabled and "ОСТАНОВИТЬ ESP" or "ЗАПУСТИТЬ ESP"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = contentFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        toggleButton.Text = ESPEnabled and "ОСТАНОВИТЬ ESP" or "ЗАПУСТИТЬ ESP"
        toggleButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
        UpdateESP()
    end)
    
    -- Кнопка закрытия GUI
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 180, 0, 40)
    closeButton.Position = UDim2.new(0, 10, 0, 60)
    closeButton.Text = "СКРЫТЬ МЕНЮ"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = contentFrame
    
    closeButton.MouseButton1Click:Connect(function()
        GUIExpanded = false
        contentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 200, 0, 40)
    end)
    
    -- Информация
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 60)
    infoLabel.Position = UDim2.new(0, 10, 0, 110)
    infoLabel.Text = "Большие блоки над игроками. Перетаскивайте за заголовок."
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextWrapped = true
    infoLabel.Parent = contentFrame
    
    -- Обработчик клика по заголовку
    Title.MouseButton1Click:Connect(function()
        GUIExpanded = not GUIExpanded
        contentFrame.Visible = GUIExpanded
        MainFrame.Size = GUIExpanded and UDim2.new(0, 200, 0, 200) or UDim2.new(0, 200, 0, 40)
    end)
end

-- Функция для перемещения GUI
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Инициализация
CreateExpandableGUI()
warn("Improved ESP Cheat loaded! Click the title to expand/collapse.")

-- Авто-обновление ESP
RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        UpdateESP()
    end
end)
