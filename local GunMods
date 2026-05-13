-- Gun Mods Module for Amber UI
-- Logic extracted from inari upgrade and adapted for WA framework

local GunMods = {
    OriginalValues = {
        Recoil = {},
        Drag = {},
        Drop = {}
    }
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Global settings for logic control
getgenv().instantzoom = getgenv().instantzoom or false

-- Internal helper to toggle attributes on ammo types
local function toggleAmmoAttribute(attrName, storageKey, enabled)
    local ammoTypes = ReplicatedStorage:FindFirstChild("AmmoTypes")
    if not ammoTypes then return end
    
    for _, ammo in ipairs(ammoTypes:GetChildren()) do
        if ammo:GetAttribute(attrName) ~= nil then
            if enabled then
                -- Cache original value before setting to 0
                if GunMods.OriginalValues[storageKey][ammo.Name] == nil then
                    GunMods.OriginalValues[storageKey][ammo.Name] = ammo:GetAttribute(attrName)
                end
                ammo:SetAttribute(attrName, 0)
            else
                -- Restore original value from cache
                local original = GunMods.OriginalValues[storageKey][ammo.Name]
                if original ~= nil then
                    ammo:SetAttribute(attrName, original)
                end
            end
        end
    end
end

function GunMods:SetNoRecoil(state)
    toggleAmmoAttribute("RecoilStrength", "Recoil", state)
end

function GunMods:SetNoDrag(state)
    toggleAmmoAttribute("Drag", "Drag", state)
end

function GunMods:SetNoDrop(state)
    toggleAmmoAttribute("ProjectileDrop", "Drop", state)
end

function GunMods:SetNoSpread(state)
    -- Spread is currently a placeholder in the source logic
end

-- Hook logic for Instant Aim
local function InitializeHooks()
    local cameraModule = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("CameraSystem")
    if not cameraModule then return end
    
    local CameraSystem = require(cameraModule)
    if CameraSystem and CameraSystem.SetZoomTarget and hookfunction and (newcclosure or LPH_JIT_MAX) then
        local oldSetZoomTarget; oldSetZoomTarget = hookfunction(CameraSystem.SetZoomTarget, newcclosure(function(...)
            local args = {...}
            -- inari logic: if instantzoom enabled, arg[4] (zoom speed) is set to 0
            if getgenv().instantzoom then 
                args[4] = 0 
            end
            return oldSetZoomTarget(table.unpack(args))
        end))
    end
end

-- Initialize hooks on load
task.spawn(function()
    pcall(InitializeHooks)
end)

return GunMods
