-- Professional Dot ESP - Clean, Modern, AI/Person-made style
-- 🟢 Green = Visible | 🔴 Red = Behind wall
-- Smooth animations, glow effect, dynamic scaling

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local activeDots = {}

-- Smooth tween settings
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Check line of sight
local function hasLineOfSight(player)
    local localChar = LocalPlayer.Character
    local targetChar = player.Character
    if not localChar or not targetChar then return false end
    
    local localHead = localChar:FindFirstChild("Head")
    local targetHead = targetChar:FindFirstChild("Head")
    if not localHead or not targetHead then return false end
    
    local origin = localHead.Position + Vector3.new(0, 0.5, 0)
    local direction = targetHead.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localChar, targetChar}
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

-- Calculate dynamic dot size (smooth curve)
local function getDotSize(distance)
    -- Smooth scaling: close = small, far = bigger
    local size = 28 + (distance / 18)
    return math.clamp(size, 28, 85)
end

-- Create a professional-looking dot
local function createDot(player)
    if player == LocalPlayer or activeDots[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    -- Main BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ProDotESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 35, 0, 35)
    billboard.StudsOffset = Vector3.new(0, 0.45, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Outer glow layer
    local outerGlow = Instance.new("Frame")
    outerGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
    outerGlow.Position = UDim2.new(-0.15, 0, -0.15, 0)
    outerGlow.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    outerGlow.BackgroundTransparency = 0.7
    outerGlow.BorderSizePixel = 0
    
    local outerCorner = Instance.new("UICorner")
    outerCorner.CornerRadius = UDim.new(1, 0)
    outerCorner.Parent = outerGlow
    
    -- Main dot frame
    local mainDot = Instance.new("Frame")
    mainDot.Size = UDim2.new(1, 0, 1, 0)
    mainDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    mainDot.BackgroundTransparency = 0.1
    mainDot.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(1, 0)
    mainCorner.Parent = mainDot
    
    -- Inner highlight (for 3D effect)
    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0.6, 0, 0.6, 0)
    highlight.Position = UDim2.new(0.2, 0, 0.2, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    highlight.BackgroundTransparency = 0.65
    highlight.BorderSizePixel = 0
    
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(1, 0)
    highlightCorner.Parent = highlight
    
    -- Clean outline
    local outline = Instance.new("UIStroke")
    outline.Thickness = 2
    outline.Color = Color3.fromRGB(255, 255, 255)
    outline.Transparency = 0.4
    outline.Parent = mainDot
    
    -- Pulse animation (subtle breathing effect)
    local pulse = Instance.new("UIScale")
    pulse.Parent = mainDot
    
    -- Assemble
    highlight.Parent = mainDot
    mainDot.Parent = billboard
    outerGlow.Parent = billboard
    billboard.Parent = head
    
    -- Animate pulse
    local pulseUp = TweenService:Create(pulse, tweenInfo, {Scale = 1.08})
    local pulseDown = TweenService:Create(pulse, tweenInfo, {Scale = 1})
    
    pulseUp:Play()
    pulseUp.Completed:Connect(function()
        pulseDown:Play()
        pulseDown.Completed:Connect(function()
            pulseUp:Play()
        end)
    end)
    
    activeDots[player] = {
        billboard = billboard,
        mainDot = mainDot,
        outerGlow = outerGlow,
        head = head,
        pulse = pulse,
        lastColor = nil
    }
end

-- Update dot (color & size)
local function updateDot(player)
    local data = activeDots[player]
    if not data or not data.head or not data.head.Parent then return end
    
    local localChar = LocalPlayer.Character
    if not localChar then return end
    
    local localHead = localChar:FindFirstChild("Head")
    if not localHead then return end
    
    -- Distance calculation
    local distance = (localHead.Position - data.head.Position).Magnitude
    local newSize = getDotSize(distance)
    
    -- Smooth size transition
    local currentSize = data.billboard.Size.X.Offset
    if math.abs(currentSize - newSize) > 1 then
        local sizeTween = TweenService:Create(data.billboard, tweenInfo, {
            Size = UDim2.new(0, newSize, 0, newSize)
        })
        sizeTween:Play()
    end
    
    -- Visibility check
    local visible = hasLineOfSight(player)
    local targetColor = visible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    local targetGlowColor = visible and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(255, 80, 80)
    
    -- Smooth color transition if changed
    if data.lastColor ~= targetColor then
        data.lastColor = targetColor
        
        local colorTween = TweenService:Create(data.mainDot, tweenInfo, {
            BackgroundColor3 = targetColor
        })
        colorTween:Play()
        
        local glowTween = TweenService:Create(data.outerGlow, tweenInfo, {
            BackgroundColor3 = targetGlowColor
        })
        glowTween:Play()
    end
end

-- Remove dot
local function removeDot(player)
    if activeDots[player] then
        activeDots[player].billboard:Destroy()
        activeDots[player] = nil
    end
end

-- Check all players
local function checkAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Head") then
                if not activeDots[player] then
                    createDot(player)
                end
            elseif activeDots[player] then
                removeDot(player)
            end
        end
    end
end

-- Update all dots
local function updateAllDots()
    for player, _ in pairs(activeDots) do
        if player.Character and player.Character:FindFirstChild("Head") then
            updateDot(player)
        end
    end
end

-- Character added handler
local function onCharacterAdded(player, character)
    task.wait(0.2)
    if player ~= LocalPlayer and character and character:FindFirstChild("Head") then
        if not activeDots[player] then
            createDot(player)
        end
    end
end

-- Initialize players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            onCharacterAdded(player, player.Character)
        end
        player.CharacterAdded:Connect(function(char)
            onCharacterAdded(player, char)
        end)
    end
end

-- New players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            onCharacterAdded(player, char)
        end)
        if player.Character then
            onCharacterAdded(player, player.Character)
        end
    end
end)

Players.PlayerRemoving:Connect(removeDot)

-- Main update loop
RunService.RenderStepped:Connect(function()
    checkAllPlayers()
    updateAllDots()
end)

print("✨ Professional Dot ESP Loaded ✨")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  🟢 Green  →  Line of sight (visible)")
print("  🔴 Red    →  Behind wall/cover")
print("  📏 Size   →  Scales with distance")
print("  💫 Effect →  Smooth pulse animation")
print("  🎨 Style  →  Glow + 3D highlight")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
