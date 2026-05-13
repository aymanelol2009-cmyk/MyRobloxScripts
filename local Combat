-- Inari Combat Module (Standalone & Loadstring ready)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Global Settings (Toggled via UI)
getgenv().isAimbotEnabled = getgenv().isAimbotEnabled or false
getgenv().SilentAImUser = getgenv().SilentAImUser or false
getgenv().AimbotTargetPart = getgenv().AimbotTargetPart or "Head"
getgenv().AimbotSmoothness = getgenv().AimbotSmoothness or 1
getgenv().TeamCheck = getgenv().TeamCheck or false
getgenv().WallCheck = getgenv().WallCheck or false
getgenv().TriggerbotEnabled = getgenv().TriggerbotEnabled or false
getgenv().TriggerbotDelay = getgenv().TriggerbotDelay or 0
getgenv().drawFOV = getgenv().drawFOV or false
getgenv().fovRadius = getgenv().fovRadius or 50
getgenv().AimbotLockTarget = getgenv().AimbotLockTarget or false -- NEW: Fixed lock-on for players
getgenv().AimbotSwitchTargetKey = getgenv().AimbotSwitchTargetKey or Enum.KeyCode.X -- NEW: Key to switch targets

-- Internal Variables
local isLocking = false
local currentAimbotTarget = nil -- Stores the currently locked player target
local currentAimbotTargetPart = nil -- Stores the currently locked player target part
local lastTargetSwitchTime = 0
local targetSwitchCooldown = 0.5 -- Cooldown to prevent rapid target switching

-- Helper Functions
local function isAlive(player)
    return player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart")
end

local function checkVisibility(targetPart, targetCharacter)
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function getClosestPlayerToMouse()
    local shortestDistance = math.huge
    local target = nil
    local targetPart = nil
    local mousePos = UIS:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isAlive(player) then
            if getgenv().TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local part = player.Character:FindFirstChild(getgenv().AimbotTargetPart)
            if part then
                local pos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible then
                    if getgenv().WallCheck then
                        if not checkVisibility(part, player.Character) then continue end
                    end

                    local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDistance and dist <= (getgenv().drawFOV and getgenv().fovRadius or math.huge) then
                        shortestDistance = dist
                        target = player
                        targetPart = part
                    end
                end
            end
        end
    end
    return target, targetPart
end

-- Input Handling
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isLocking = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isLocking = false
    end
end)

-- FOV Circle logic
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 100
fovCircle.Filled = false
fovCircle.Transparency = 1

-- Main Render Loop
RunService.RenderStepped:Connect(function(deltaTime)
    -- Update FOV
    fovCircle.Position = UIS:GetMouseLocation()
    fovCircle.Radius = getgenv().fovRadius
    fovCircle.Visible = getgenv().drawFOV

    -- Update Target
    if getgenv().isAimbotEnabled or getgenv().SilentAImUser then
        if not getgenv().AimbotLockTarget or not isLocking then
            -- If not fixed lock-on, or not currently locking, update target dynamically
            currentAimbotTarget, currentAimbotTargetPart = getClosestPlayerToMouse()
        end
        -- Aimbot (Camera Lock)
        if isLocking and getgenv().isAimbotEnabled and currentAimbotTarget and currentAimbotTarget.Parent and currentAimbotTargetPart and currentAimbotTargetPart.Parent then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, currentAimbotTargetPart.Position)
            local smoothness = getgenv().AimbotSmoothness or 1
            
            if smoothness > 1 then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1/smoothness)
            else
                Camera.CFrame = targetCFrame
            end
        end
    else
        currentAimbotTarget = nil -- Clear target when aimbot is disabled
        currentAimbotTargetPart = nil
    end
end)

-- Silent Aim Implementation
local BulletModule = nil
pcall(function()
    BulletModule = require(game:GetService("ReplicatedStorage").Modules.FPS.Bullet)
end)

if BulletModule and BulletModule.CreateBullet and hookfunction and (newcclosure or LPH_JIT_MAX) then
    print("[COMBAT] SILENT AIM SUPPORTED")
    local OldBullet; OldBullet = hookfunction(BulletModule.CreateBullet, newcclosure(function(...)
        local Args          = {...};
        local Target, Part  = nil, nil
        if getgenv().AimbotLockTarget and currentAimbotTarget then
            Target = currentAimbotTarget
            Part = currentAimbotTargetPart
        else
            Target, Part = getClosestPlayerToMouse();
        end
        
        if not checkcaller() and Args[5] and typeof(Args[5]) == "Instance" then
            local Success, ShotCFrame = pcall(function() return Args[5].CFrame end)
            if not Success then return OldBullet(table.unpack(Args)) end

            if Target and Part and getgenv().SilentAImUser then 
                ShotCFrame = CFrame.new(ShotCFrame.Position, Part.Position)
                Args[5].CFrame = ShotCFrame
            end;

            task.spawn(function()
                local CombatFuncs = getgenv().CombatFunctions
                if not CombatFuncs then return end
                
                pcall(function()
                    local Origin = ShotCFrame.Position
                    local Direction = ShotCFrame.LookVector * 1500
                    local RayParams = RaycastParams.new()
                    RayParams.FilterType = Enum.RaycastFilterType.Exclude
                    RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                    
                    local Result = workspace:Raycast(Origin, Direction, RayParams)
                    local EndPos = Result and Result.Position or (Origin + Direction)

                    if Result and Result.Instance then
                        local Character = Result.Instance:FindFirstAncestorOfClass("Model")
                        local Player = Character and Players:GetPlayerFromCharacter(Character)
                        local IsNPC = Character and Character:FindFirstChildOfClass("Humanoid")
                        
                        if (Player and Player ~= LocalPlayer) or (IsNPC and not Player) then
                            if CombatFuncs.PlayHitSound then CombatFuncs:PlayHitSound() end
                            if CombatFuncs.FlashCenterHitmarker then CombatFuncs:FlashCenterHitmarker() end
                            if CombatFuncs.CreateHitMarker then CombatFuncs:CreateHitMarker(Result.Instance, Result.Position) end
                            if CombatFuncs.CreateHitLog then 
                                local targetName = Player and Player.Name or (Character and Character.Name or "Unknown")
                                CombatFuncs:CreateHitLog(Result.Instance.Name, targetName)
                            end
                        end
                    end

                    if getgenv().BulletTracers and CombatFuncs.CreateTracer then
                        CombatFuncs:CreateTracer(Origin, EndPos)
                    end
                end)
            end)
        end;
        
        return OldBullet(table.unpack(Args))
    end));
    print("[COMBAT] Silent Aim Hooked successfully.")
end

-- Unload Function (for clean re-injection)
getgenv().UnloadCombat = function()
    fovCircle:Remove()
    -- Note: hookfunction cannot be easily reversed without original ref, 
    -- but for a library this setup is persistent until game restart or script re-hook.
end

-- Expanded Anti-Cheat Bypass & Security
local function SecureBypass()
    local mt = getrawmetatable(game)
    local old_idx = mt.__index
    setreadonly(mt, false)

    mt.__index = newcclosure(function(self, index)
        if not checkcaller() and typeof(self) == "Instance" then
            local name = tostring(index)
            if self:IsA("BasePart") and (name == "Velocity" or name == "AssemblyLinearVelocity") then
                if self.Name == "HumanoidRootPart" or (LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character)) then
                    return Vector3.new(0, 0, 0)
                end
            end
        end
        return old_idx(self, index)
    end)

    setreadonly(mt, true)
end

local function BypassAC(Char)
    if not Char then return end
    
    local signals = {Char.ChildRemoved, Char.DescendantAdded, Char.ChildAdded}
    local humanoid = Char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        table.insert(signals, humanoid.StateChanged)
        table.insert(signals, humanoid.Changed)
    end

    for _, signal in pairs(signals) do
        for _, v in pairs(getconnections(signal)) do
            if v.Function then
                local src = debug.info(v.Function, "s")
                if src:find("CharacterController") or src:find("Anticheat") or src:find("Handler") then
                    pcall(function() v:Disable() end)
                    
                    local upvals = getupvalues(v.Function)
                    for _, up in pairs(upvals) do
                        if type(up) == "function" then
                            local up_src = debug.info(up, "s")
                            if up_src:find("CharacterController") or up_src:find("Anticheat") then
                                pcall(function()
                                    hookfunction(up, function(...) return coroutine.yield() end)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Initialize Security
if hookfunction and newcclosure then
    task.spawn(function()
        print("[COMBAT] Initializing Security Bypasses...")
        pcall(SecureBypass)
        if LocalPlayer.Character then
            pcall(BypassAC, LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(function(char)
            pcall(BypassAC, char)
        end)
        
        -- Hook Kick
        local old_kick; old_kick = hookfunction(game.Players.LocalPlayer.Kick, newcclosure(function(self, ...)
            if not checkcaller() then return end
            return old_kick(self, ...)
        end))
        
        print("[COMBAT] Security Bypasses Ready.")
    end)
end

-- Triggerbot Implementation
task.spawn(function()
    while task.wait() do
        if getgenv().TriggerbotEnabled then
            local target = Mouse.Target
            if target and target.Parent then
                local character = target:FindFirstAncestorOfClass("Model")
                local player = character and Players:GetPlayerFromCharacter(character)
                
                if player and player ~= LocalPlayer and isAlive(player) then
                    if getgenv().TeamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    
                    if getgenv().TriggerbotDelay > 0 then
                        task.wait(getgenv().TriggerbotDelay)
                    end
                    
                    -- Re-check target after delay
                    if Mouse.Target and Mouse.Target:IsDescendantOf(character) then
                        pcall(mouse1press)
                        task.wait(0.01)
                        pcall(mouse1release)
                    end
                end
            end
        end
    end
end)

return {
    GetTarget = function() return currentAimbotTarget, currentAimbotTargetPart end,
    Settings = getgenv()
}
