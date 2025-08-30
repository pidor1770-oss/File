-- Версия с плавно меняющимся одинаковым цветом для всех ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Глобальный цвет для всех ESP
local globalHue = 0

-- Таблица для хранения ESP объектов
local ESPTable = {}

-- Функция для создания/обновления ESP
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            
            -- Если ESP еще не создано для этого игрока
            if not ESPTable[player] then
                local esp = Instance.new("BoxHandleAdornment")
                esp.Adornee = character
                esp.ZIndex = 0
                esp.AlwaysOnTop = true
                esp.Name = "EspBox"
                esp.Parent = character
                
                ESPTable[player] = esp
            end
                
            -- Получаем текущий ESP
            local esp = ESPTable[player]
            
            -- Адаптируем размер ESP к телу персонажа
            if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
                esp.Size = Vector3.new(3, 5.5, 2)  -- Размер для R6
            else
                esp.Size = Vector3.new(3, 6, 3)    -- Размер для R15
            end
            
            -- Устанавливаем одинаковый цвет для всех ESP
            esp.Color3 = Color3.fromHSV(globalHue, 1, 1)
            esp.Transparency = 0.3  -- Фиксированная прозрачность
        elseif ESPTable[player] and (not player.Character or not player.Character:FindFirstChild("Humanoid")) then
            -- Удаляем ESP если игрок больше не существует или не имеет персонажа
            ESPTable[player]:Destroy()
            ESPTable[player] = nil
        end
    end
end

-- Функция для плавного изменения глобального цвета
local function UpdateGlobalColor()
    globalHue = (globalHue + 0.001) % 1  -- Медленное изменение оттенка
end

-- Функция проверки видимости (не через стены)
function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit
    local distance = (origin - target).Magnitude
    local ray = Ray.new(origin, direction * distance)
    
    local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(
        ray, 
        {LocalPlayer.Character, Camera}
    )
    
    return hitPart and hitPart:IsDescendantOf(targetPart.Parent)
end

-- Аимбот с проверкой стен
RunService.RenderStepped:Connect(function()
    local closestPlayer = nil
    local closestDistance = math.huge  -- Максимальная дистанция прицеливания
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local distance = (LocalPlayer.Character.Head.Position - head.Position).Magnitude
            
            if distance < closestDistance and isVisible(head) then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    if closestPlayer then
        local headPos = closestPlayer.Character.Head.Position
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, headPos)
    end
end)

-- Обновляем ESP каждый кадр
RunService.RenderStepped:Connect(UpdateESP)

-- Обновляем глобальный цвет каждый кадр
RunService.RenderStepped:Connect(UpdateGlobalColor)

-- Обработчик для новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)  -- Ждем полной загрузки персонажа
        if player ~= LocalPlayer and character:FindFirstChild("Humanoid") then
            local esp = Instance.new("BoxHandleAdornment")
            esp.Adornee = character
            esp.ZIndex = 0
            esp.AlwaysOnTop = true
            esp.Name = "EspBox"
            esp.Parent = character
            
            ESPTable[player] = esp
        end
    end)
end)

print("ESP с плавно меняющимся одинаковым цветом и аимбот активированы!")
print("У всех игроков одинаковый цвет ESP, который плавно меняется")
