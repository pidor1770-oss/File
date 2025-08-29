-- Исправленная версия с оптимизированным ESP и аимботом
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Оптимизированный ESP
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            if not player.Character:FindFirstChild("EspBox") then
                local esp = Instance.new("BoxHandleAdornment")
                esp.Adornee = player.Character
                esp.ZIndex = 0
                esp.Size = Vector3.new(4, 5, 2)
                esp.Transparency = 0.65
                esp.Color3 = Color3.fromRGB(255, 48, 48)
                esp.AlwaysOnTop = true
                esp.Name = "EspBox"
                esp.Parent = player.Character
            end
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
    local closestDistance = 1000  -- Максимальная дистанция прицеливания
    
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

-- Обновляем ESP каждые 0.5 секунды вместо бесконечного цикла
while wait(0.5) do
    UpdateESP()
end
