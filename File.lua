-- Адаптированная версия для мобильных устройств
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Создаем главное окно (увеличено для мобильного использования)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 60)  -- Увеличено для мобильных устройств
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.Parent = CoreGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 40)  -- Увеличено
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "📱 Arceus X File Explorer"
title.TextSize = 16  -- Увеличено для мобильных
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)  -- Увеличено для сенсорного экрана
toggleBtn.Position = UDim2.new(1, -50, 0, 10)
toggleBtn.Text = "📂"
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainFrame

-- Окно проводника (занимает почти весь экран на мобильном)
local explorerFrame = Instance.new("ScrollingFrame")
explorerFrame.Size = UDim2.new(0.9, 0, 0.8, 0)  -- Относительные размеры
explorerFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
explorerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
explorerFrame.BorderSizePixel = 2
explorerFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
explorerFrame.Visible = false
explorerFrame.Parent = CoreGui

-- Кнопка закрытия для мобильных
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -60, 0, 10)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Visible = false
closeBtn.Parent = explorerFrame

local explorerTitle = Instance.new("TextLabel")
explorerTitle.Size = UDim2.new(1, 0, 0, 50)  -- Увеличено
explorerTitle.Text = "📁 File Explorer"
explorerTitle.TextSize = 18
explorerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
explorerTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
explorerTitle.Parent = explorerFrame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -60)
content.Position = UDim2.new(0, 5, 0, 55)
content.BackgroundTransparency = 1
content.Parent = explorerFrame

-- Функция для отображения содержимого с увеличенными кнопками
local function DisplayChildren(parent, layout)
    for _, child in ipairs(parent:GetChildren()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)  -- Увеличено для сенсорного экрана
        btn.Position = UDim2.new(0, 5, 0, #layout:GetChildren() * 45)
        btn.Text = "📁 " .. child.Name .. " (" .. child.ClassName .. ")"
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
        btn.Parent = layout
        
        btn.MouseButton1Click:Connect(function()
            -- Очищаем текущее содержимое
            for _, v in ipairs(content:GetChildren()) do
                if v:IsA("TextButton") or v:IsA("TextLabel") then
                    v:Destroy()
                end
            end
            
            -- Показываем информацию об объекте
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, -10, 0, 120)
            info.Position = UDim2.new(0, 5, 0, 5)
            info.Text = "Name: " .. child.Name .. "\nClass: " .. child.ClassName .. "\nPath: " .. child:GetFullName()
            info.TextSize = 14
            info.TextXAlignment = Enum.TextXAlignment.Left
            info.TextYAlignment = Enum.TextYAlignment.Top
            info.TextColor3 = Color3.fromRGB(255, 255, 255)
            info.BackgroundTransparency = 1
            info.Parent = content
            
            -- Кнопка назад для мобильных
            local backBtn = Instance.new("TextButton")
            backBtn.Size = UDim2.new(0, 100, 0, 40)
            backBtn.Position = UDim2.new(0, 5, 0, 130)
            backBtn.Text = "⬅ Назад"
            backBtn.TextSize = 14
            backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            backBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            backBtn.BorderSizePixel = 0
            backBtn.Parent = content
            
            backBtn.MouseButton1Click:Connect(function()
                for _, v in ipairs(content:GetChildren()) do
                    v:Destroy()
                end
                DisplayChildren(game, content)
            end)
            
            -- Если это скрипт, показываем исходный код
            if child:IsA("ModuleScript") or child:IsA("Script") then
                pcall(function()
                    local source = child.Source
                    local code = Instance.new("TextLabel")
                    code.Size = UDim2.new(1, -10, 0, 200)
                    code.Position = UDim2.new(0, 5, 0, 180)
                    code.Text = "Source: " .. string.sub(source, 1, 300) .. (string.len(source) > 300 and "..." or "")
                    code.TextSize = 12
                    code.TextXAlignment = Enum.TextXAlignment.Left
                    code.TextYAlignment = Enum.TextYAlignment.Top
                    code.TextColor3 = Color3.fromRGB(255, 255, 255)
                    code.BackgroundTransparency = 1
                    code.Parent = content
                end)
            end
            
            -- Показываем детей объекта
            if #child:GetChildren() > 0 then
                local childrenLabel = Instance.new("TextLabel")
                childrenLabel.Size = UDim2.new(1, -10, 0, 30)
                childrenLabel.Position = UDim2.new(0, 5, 0, 390)
                childrenLabel.Text = "Children:"
                childrenLabel.TextSize = 14
                childrenLabel.TextXAlignment = Enum.TextXAlignment.Left
                childrenLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                childrenLabel.BackgroundTransparency = 1
                childrenLabel.Parent = content
                
                DisplayChildren(child, content)
            end
        end)
    end
end

-- Обработчик кнопки переключения
toggleBtn.MouseButton1Click:Connect(function()
    explorerFrame.Visible = not explorerFrame.Visible
    closeBtn.Visible = explorerFrame.Visible
    
    if explorerFrame.Visible then
        -- Очищаем предыдущее содержимое
        for _, v in ipairs(content:GetChildren()) do
            v:Destroy()
        end
        
        -- Показываем корневые объекты игры
        DisplayChildren(game, content)
    end
end)

-- Обработчик кнопки закрытия
closeBtn.MouseButton1Click:Connect(function()
    explorerFrame.Visible = false
    closeBtn.Visible = false
end)

-- Упрощенная функция перемещения для мобильных устройств
local function makeDraggable(gui)
    local dragging = false
    local dragStart, startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)

    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(explorerFrame)

-- Адаптация под разные разрешения экрана
if UserInputService.TouchEnabled then
    -- Увеличиваем элементы для сенсорного ввода
    mainFrame.Size = UDim2.new(0, 400, 0, 70)
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.TextSize = 24
end
