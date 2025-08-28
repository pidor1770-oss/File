local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создаем главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 40)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = CoreGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 280, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Arceus X File Explorer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 20, 0, 20)
toggleBtn.Position = UDim2.new(1, -25, 0, 10)
toggleBtn.Text = "-"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainFrame

-- Создаем окно проводника (изначально скрыто)
local explorerFrame = Instance.new("ScrollingFrame")
explorerFrame.Size = UDim2.new(0, 400, 0, 400)
explorerFrame.Position = UDim2.new(0, 320, 0, 10)
explorerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
explorerFrame.BorderSizePixel = 0
explorerFrame.Visible = false
explorerFrame.Parent = CoreGui

local explorerTitle = Instance.new("TextLabel")
explorerTitle.Size = UDim2.new(1, 0, 0, 30)
explorerTitle.Text = "File Explorer"
explorerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
explorerTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
explorerTitle.Parent = explorerFrame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1
content.Parent = explorerFrame

-- Функция для отображения содержимого
local function DisplayChildren(parent, layout)
    for _, child in ipairs(parent:GetChildren()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.Position = UDim2.new(0, 5, 0, #layout:GetChildren() * 30)
        btn.Text = "📁 " .. child.Name .. " (" .. child.ClassName .. ")"
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.BorderSizePixel = 0
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
            info.Size = UDim2.new(1, -10, 0, 100)
            info.Position = UDim2.new(0, 5, 0, 5)
            info.Text = "Name: " .. child.Name .. "\nClass: " .. child.ClassName .. "\nPath: " .. child:GetFullName()
            info.TextXAlignment = Enum.TextXAlignment.Left
            info.TextYAlignment = Enum.TextYAlignment.Top
            info.TextColor3 = Color3.fromRGB(255, 255, 255)
            info.BackgroundTransparency = 1
            info.Parent = content
            
            -- Если это скрипт, показываем исходный код
            if child:IsA("ModuleScript") or child:IsA("Script") then
                pcall(function()
                    local source = child.Source
                    local code = Instance.new("TextLabel")
                    code.Size = UDim2.new(1, -10, 0, 200)
                    code.Position = UDim2.new(0, 5, 0, 110)
                    code.Text = "Source: " .. string.sub(source, 1, 500) .. (string.len(source) > 500 and "..." or "")
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
                childrenLabel.Size = UDim2.new(1, -10, 0, 20)
                childrenLabel.Position = UDim2.new(0, 5, 0, 320)
                childrenLabel.Text = "Children:"
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
    toggleBtn.Text = explorerFrame.Visible and "+" or "-"
    
    if explorerFrame.Visible then
        -- Очищаем предыдущее содержимое
        for _, v in ipairs(content:GetChildren()) do
            v:Destroy()
        end
        
        -- Показываем корневые объекты игры
        DisplayChildren(game, content)
    end
end)

-- Делаем окна перемещаемыми
local function makeDraggable(gui)
    local dragging = false
    local dragInput, dragStart, startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(explorerFrame)
