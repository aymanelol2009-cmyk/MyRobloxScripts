-- NPC Combat Module (Integrated with Amber UI & Inari Logic)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global NPC Combat Settings
getgenv().NPCAimbotEnabled = getgenv().NPCAimbotEnabled or false
getgenv().NPCSilentAimEnabled = getgenv().NPCSilentAimEnabled or false
getgenv().NPCTargetPart = getgenv().NPCTargetPart or "Head"
getgenv().NPCAimbotSmoothness = getgenv().NPCAimbotSmoothness or 1
getgenv().NPCWallCheck = getgenv().NPCWallCheck or false
getgenv().NPCFOVRadius = getgenv().NPCFOVRadius or 100
getgenv().NPCShowFOV = getgenv().NPCShowFOV or false
getgenv().NPCAimbotLockTarget = getgenv().NPCAimbotLockTarget or false -- NEW: Fixed lock-on for NPCs
getgenv().NPCAimbotSwitchTargetKey = getgenv().NPCAimbotSwitchTargetKey or Enum.KeyCode.X

-- Identify valid NPCs (Logic synced with wa_esp.lua)
local validNPCNames = {}
local function CacheNPCs()
    local RS = game:GetService("ReplicatedStorage")
    local presets = RS:FindFirstChild("AiPresets")
    if presets then
        for _, v in pairs(presets:GetChildren()) do validNPCNames[v.Name] = true end
    end
end
task.spawn(CacheNPCs)

local function isTargetableNPC(model)
    if not model or not model:IsA("Model") then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not (hum and hum.Health > 0) then return false end
    
    local name = model:GetAttribute("DisplayName") or model:GetAttribute("CallSign") or model.Name
    if validNPCNames[name] or model:GetAttribute("Preset") then return true end
    
    -- Comprobación de carpetas (Ampliada para mayor compatibilidad)
    local validFolders = {"AIs", "AiZones", "NPCs", "Zombies", "Mobs", "Entities", "Living"}
    for _, folderName in ipairs(validFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder and model:IsDescendantOf(folder) then
            return true
        end
    end
    return false
end

local function checkVisibility(targetPart, targetCharacter)
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter, Camera}
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local currentNPCTarget = nil -- Stores the currently locked NPC target
local currentNPCTargetPart = nil -- Stores the currently locked NPC target part

local function getAllValidNPCs()
    local validNPCs = {}
    local function scan(obj)
        if not obj then return end
        for _, v in pairs(obj:GetChildren()) do
            if v:IsA("Model") and isTargetableNPC(v) then
                local hitPart = v:FindFirstChild(getgenv().NPCTargetPart) or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                if hitPart then
                    local pos, visible = Camera:WorldToViewportPoint(hitPart.Position)
                    if visible then
                        if not getgenv().NPCWallCheck or checkVisibility(hitPart, v) then
                            table.insert(validNPCs, {NPC = v, Part = hitPart})
                        end
                    end
                end
            elseif v:IsA("Folder") then scan(v) end
        end
    end

    local targetFolders = {"AIs", "AiZones", "NPCs", "Zombies", "Mobs", "Entities", "Living"}
    for _, folderName in ipairs(targetFolders) do
        local f = workspace:FindFirstChild(folderName)
        if f then scan(f) end
    end
    return validNPCs
end

local function getClosestNPCToMouse()
    local shortestDistance = math.huge
    local target = nil
    local part = nil
    local mousePos = UIS:GetMouseLocation()

    local function scan(obj)
        if not obj then return end
        for _, v in pairs(obj:GetChildren()) do
            if v:IsA("Model") and isTargetableNPC(v) then
                local hitPart = v:FindFirstChild(getgenv().NPCTargetPart)
                if hitPart then
                    local pos, visible = Camera:WorldToViewportPoint(hitPart.Position)
                    if visible then
                        if getgenv().NPCWallCheck and not checkVisibility(hitPart, v) then continue end
                        local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                        if dist < shortestDistance and dist <= (getgenv().NPCShowFOV and getgenv().NPCFOVRadius or math.huge) then
                            shortestDistance = dist
                            target = v
                            part = hitPart
                        end
                    end
                end
            elseif v:IsA("Folder") then scan(v) end
        end
    end

    -- If fixed lock-on is enabled and we already have a target, stick to it.
    if getgenv().NPCAimbotLockTarget and currentNPCTarget and currentNPCTarget.Parent and currentNPCTargetPart and currentNPCTargetPart.Parent then
        -- Re-validate current target
        if isTargetableNPC(currentNPCTarget) and (not getgenv().NPCWallCheck or checkVisibility(currentNPCTargetPart, currentNPCTarget)) then
            return currentNPCTarget, currentNPCTargetPart
        else
            -- Current target is no longer valid, clear it.
            currentNPCTarget = nil
            currentNPCTargetPart = nil
        end
    end

    -- Escanear múltiples carpetas comunes
    local targetFolders = {"AIs", "AiZones", "NPCs", "Zombies", "Mobs", "Entities", "Living"}
    for _, folderName in ipairs(targetFolders) do
        scan(workspace:FindFirstChild(folderName))
    end
    return target, part
end
 
local lastNPCSwitchTime = 0
local function cycleNPCTarget()
    if not getgenv().NPCAimbotLockTarget or not isLocking or (tick() - lastNPCSwitchTime < 0.5) then return end
    local validNPCs = getAllValidNPCs()
    if #validNPCs == 0 then return end

    local currentIndex = -1
    if currentNPCTarget then
        for i, data in pairs(validNPCs) do
            if data.NPC == currentNPCTarget then currentIndex = i break end
        end
    end

    local nextIndex = (currentIndex % #validNPCs) + 1
    currentNPCTarget = validNPCs[nextIndex].NPC
    currentNPCTargetPart = validNPCs[nextIndex].Part
    lastNPCSwitchTime = tick()
end

-- FOV Circle logic (NPC Specific)
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 50, 50)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 0.8

local isLocking = false
UIS.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton2 then 
        isLocking = true 
    elseif i.KeyCode == getgenv().NPCAimbotSwitchTargetKey then
        cycleNPCTarget()
    end 
end)
UIS.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton2 then 
        isLocking = false 
        currentNPCTarget = nil
        currentNPCTargetPart = nil
    end 
end)

RunService.RenderStepped:Connect(function(deltaTime)
    Camera = workspace.CurrentCamera -- Actualizar referencia por si el juego la cambia
    fovCircle.Position = UIS:GetMouseLocation()
    fovCircle.Radius = getgenv().NPCFOVRadius
    fovCircle.Visible = getgenv().NPCShowFOV

    if getgenv().NPCAimbotEnabled and isLocking then
        local _, part = getClosestNPCToMouse()
        if part then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            local smoothness = getgenv().NPCAimbotSmoothness or 1
            if smoothness > 1 then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1/smoothness)
            else
                Camera.CFrame = targetCFrame
            end
        end
    end
end)

-- Silent Aim Hook for NPCs
local BulletModule = nil
pcall(function() BulletModule = require(game:GetService("ReplicatedStorage").Modules.FPS.Bullet) end)

if BulletModule and BulletModule.CreateBullet and hookfunction and newcclosure then
    local OldBullet; OldBullet = hookfunction(BulletModule.CreateBullet, newcclosure(function(...)
        local Args = {...}
        if not checkcaller() and Args[5] and typeof(Args[5]) == "Instance" and getgenv().NPCSilentAimEnabled then
            local Target, Part = getClosestNPCToMouse()
            if Target and Part then
                local Success, ShotCFrame = pcall(function() return Args[5].CFrame end)
                if Success then
                    Args[5].CFrame = CFrame.new(ShotCFrame.Position, Part.Position)
                end
            end
        end
        return OldBullet(table.unpack(Args))
    end))
end

return { GetTarget = getClosestNPCToMouse }
