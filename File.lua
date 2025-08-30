-- Версия с плавно меняющимся цветом ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
                
                ESPTable[player] = {
                    object = esp,
                    hue = math.random()  -- Начальный случайный оттенок
                }
            end
                
            -- Получаем текущий ESP
            local espData = ESPTable[player]
            local esp = espData.object
            
            -- Адаптируем размер ESP к телу персонажа
            if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
                esp.Size = Vector3.new(3, 5.5, 2)  -- Размер для R6
            else
                esp.Size = Vector3.new(3, 6, 3)    -- Размер для R15
            end
            
            -- Плавно меняем оттенок со временем
            espData.hue = (espData.hue + 0.001) % 1  -- Медленное изменение оттенка
            
            -- Устанавливаем цвет с плавным переходом
            esp.Color3 = Color3.fromHSV(espData.hue, 1, 1)
            
            -- Легкая пульсация прозрачности
            esp.Transparency = 0.3 + math.sin(tick() * 2) * 0.1
        elseif ESPTable[player] and (not player.Character or not player.Character:FindFirstChild("Humanoid")) then
            -- Удаляем ESP если игрок больше не существует или не имеет персонажа
            ESPTable[player].object:Destroy()
            ESPTable[player] = nil
        end
    end
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

-- Обновляем ESP каждый кадр для плавного изменения цвета
RunService.RenderStepped:Connect(UpdateESP)

print("ESP с плавно меняющимся цветом и аимбот активированы!")
print("Цвет ESP плавно перетекает через все оттенки радуги")
