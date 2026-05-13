local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LightingMore = {
    CrosshairLines = {
        T = Drawing.new("Line"), B = Drawing.new("Line"), 
        L = Drawing.new("Line"), R = Drawing.new("Line")
    },
    CrosshairText = Drawing.new("Text"),
    CrosshairDot = Drawing.new("Circle")
}

-- Configuración inicial Crosshair
for _, line in pairs(LightingMore.CrosshairLines) do
    line.Visible = false
    line.Thickness = 1.5
    line.Transparency = 1
    line.Color = Color3.new(1, 1, 1)
end

LightingMore.CrosshairDot.Visible = false
LightingMore.CrosshairDot.Filled = true
LightingMore.CrosshairDot.Transparency = 1
LightingMore.CrosshairDot.Color = Color3.new(1, 1, 1)

LightingMore.CrosshairText.Visible = false
LightingMore.CrosshairText.Center = true
LightingMore.CrosshairText.Outline = true
LightingMore.CrosshairText.Font = 2
LightingMore.CrosshairText.Size = 13

function LightingMore:UpdateCrosshair()
    local enabled = getgenv().CrosshairEnabled
    if not enabled then 
        for _, l in pairs(self.CrosshairLines) do l.Visible = false end
        self.CrosshairText.Visible = false
        self.CrosshairDot.Visible = false
        return 
    end

    local center = (getgenv().CrosshairFollowMouse and UIS:GetMouseLocation()) or (Camera.ViewportSize / 2)
    local size = getgenv().CrosshairSize or 10
    local gap = getgenv().CrosshairGap or 5
    local color = getgenv().CrosshairColor or Color3.new(1, 1, 1)
    local thickness = getgenv().CrosshairThickness or 1.5
    local rotation = getgenv().CrosshairRotation or 0

    if getgenv().CrosshairRotating then
        rotation = (tick() * (getgenv().CrosshairRotationSpeed or 2) * 50) % 360
    end

    local function rotate(vec, deg)
        local rad = math.rad(deg)
        local cos, sin = math.cos(rad), math.sin(rad)
        return Vector2.new(vec.X * cos - vec.Y * sin, vec.X * sin + vec.Y * cos)
    end

    local lines = self.CrosshairLines
    lines.T.From = center + rotate(Vector2.new(0, -gap - size), rotation); lines.T.To = center + rotate(Vector2.new(0, -gap), rotation)
    lines.B.From = center + rotate(Vector2.new(0, gap), rotation); lines.B.To = center + rotate(Vector2.new(0, gap + size), rotation)
    lines.L.From = center + rotate(Vector2.new(-gap - size, 0), rotation); lines.L.To = center + rotate(Vector2.new(-gap, 0), rotation)
    lines.R.From = center + rotate(Vector2.new(gap, 0), rotation); lines.R.To = center + rotate(Vector2.new(gap + size, 0), rotation)

    for _, l in pairs(lines) do 
        l.Visible = true 
        l.Color = color
        l.Thickness = thickness
    end

    -- Watermark de la Crosshair
    local watermark = self.CrosshairText
    local textContent = getgenv().CrosshairWatermark or ""
    if getgenv().CrosshairWatermarkEnabled and textContent ~= "" then
        watermark.Visible = true
        watermark.Text = textContent
        watermark.Color = color
        watermark.Position = center + Vector2.new(0, gap + size + 8)
    else
        watermark.Visible = false
    end

    -- Dot central
    local dot = self.CrosshairDot
    if getgenv().CrosshairDotEnabled then
        dot.Visible = true
        dot.Color = color
        dot.Position = center
        dot.Radius = getgenv().CrosshairDotSize or 2
    else
        dot.Visible = false
    end
end

-- Bucle de actualización para el Crosshair
RunService.RenderStepped:Connect(function()
    LightingMore:UpdateCrosshair()
    
    -- [ FORCE OVERRIDES ]
    -- Usamos verificaciones 'if ~= then' para evitar re-asignaciones innecesarias que causan lag

    -- Fuerza de Tiempo (Evita que el juego lo resetee)
    if getgenv().OverrideTimeEnabled and getgenv().TargetTime then
        if math.abs(Lighting.ClockTime - getgenv().TargetTime) > 0.001 then
            Lighting.ClockTime = getgenv().TargetTime
        end
    end

    -- Fuerza de Atmósfera
    if getgenv().AtmosphereOverride then
        local atm = Lighting:FindFirstChildOfClass("Atmosphere")
        if atm then
            if getgenv().TargetAtmDensity and math.abs(atm.Density - getgenv().TargetAtmDensity) > 0.001 then 
                atm.Density = getgenv().TargetAtmDensity 
            end
            if getgenv().TargetAtmHaze and math.abs(atm.Haze - getgenv().TargetAtmHaze) > 0.001 then 
                atm.Haze = getgenv().TargetAtmHaze 
            end
            if getgenv().TargetAtmColor and atm.Color ~= getgenv().TargetAtmColor then 
                atm.Color = getgenv().TargetAtmColor 
            end
            if getgenv().TargetAtmDecay and atm.Decay ~= getgenv().TargetAtmDecay then 
                atm.Decay = getgenv().TargetAtmDecay 
            end
            if getgenv().TargetAtmGlare and math.abs(atm.Glare - getgenv().TargetAtmGlare) > 0.001 then 
                atm.Glare = getgenv().TargetAtmGlare 
            end
        end
    end

    -- Fuerza de Iluminación Global
    if getgenv().BrightnessOverride and getgenv().TargetBrightness then
        if math.abs(Lighting.Brightness - getgenv().TargetBrightness) > 0.001 then Lighting.Brightness = getgenv().TargetBrightness end
    end
    if getgenv().ExposureOverride and getgenv().TargetExposure then
        if math.abs(Lighting.ExposureCompensation - getgenv().TargetExposure) > 0.001 then Lighting.ExposureCompensation = getgenv().TargetExposure end
    end

    -- Fuerza de Sombras
    if getgenv().NoShadowsEnabled and Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
end)

-- Función para Foliage (Global e Instantánea)
function LightingMore:SetSpawnerFoliage(state)
    -- Nota: Ahora busca en todo el mapa para máxima efectividad como en Inari
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local mat = obj.Material
            local name = obj.Name:lower()
            local modelName = (obj.Parent and obj.Parent.Name:lower()) or ""
            
            -- Filtra por material o por nombres clave (bush, fern, tree, leaf)
            if mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass or 
               name:find("leaf") or name:find("foliage") or name:find("bush") or name:find("fern") or name:find("tree") or
               modelName:find("bush") or modelName:find("fern") or modelName:find("tree") then
                obj.Transparency = state and 1 or 0
            end
        end
    end
end

-- Funciones de Atmósfera
local function getAtm()
    local a = Lighting:FindFirstChildOfClass("Atmosphere")
    if not a then
        a = Instance.new("Atmosphere", Lighting)
    end
    return a
end

function LightingMore:SetTime(val)
    getgenv().TargetTime = val
    getgenv().OverrideTimeEnabled = true
    Lighting.ClockTime = val
end

function LightingMore:SetBrightness(val)
    getgenv().TargetBrightness = val
    getgenv().BrightnessOverride = true
    Lighting.Brightness = val
end

function LightingMore:SetExposure(val)
    getgenv().TargetExposure = val
    getgenv().ExposureOverride = true
    Lighting.ExposureCompensation = val
end

function LightingMore:SetStyle(style)
    if style == "Realistic" then
        self:SetBrightness(2)
        Lighting.ShadowSoftness = 0.2
        Lighting.EnvironmentDiffuseScale = 1
        self:SetNoShadows(false)
    elseif style == "Soft" then
        self:SetBrightness(1)
        Lighting.ShadowSoftness = 1
        Lighting.EnvironmentDiffuseScale = 0.5
        self:SetNoShadows(true)
    end
end

function LightingMore:SetNoShadows(state)
    getgenv().NoShadowsEnabled = state
    Lighting.GlobalShadows = not state
end

function LightingMore:SetPerformanceMode(state)
    getgenv().PerformanceEnabled = state
    
    -- Desactivar efectos visuales costosos
    local effects = {"BloomEffect", "BlurEffect", "SunRaysEffect", "ColorCorrectionEffect", "DepthOfFieldEffect"}
    for _, v in pairs(Lighting:GetChildren()) do
        if table.find(effects, v.ClassName) then
            v.Enabled = not state
        end
    end

    -- Optimización de terreno
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace.Terrain.Decoration = not state
    end
end

function LightingMore:SetFOV(val)
    Camera.FieldOfView = val
end

function LightingMore:SetAtmosphereDensity(val)
    getgenv().TargetAtmDensity = val
    getgenv().AtmosphereOverride = true
end

function LightingMore:SetAtmosphereHaze(val)
    getgenv().TargetAtmHaze = val
    getgenv().AtmosphereOverride = true
end

function LightingMore:SetAtmosphereColor(color)
    getgenv().TargetAtmColor = color
    getgenv().AtmosphereOverride = true
end

function LightingMore:SetAtmosphereDecay(color)
    getgenv().TargetAtmDecay = color
    getgenv().AtmosphereOverride = true
end

function LightingMore:SetAtmosphereGlare(val)
    getgenv().TargetAtmGlare = val
    getgenv().AtmosphereOverride = true
end

task.spawn(function()
    -- Observador para nuevos objetos en TODO el mapa
    workspace.DescendantAdded:Connect(function(obj)
            if getgenv().RemoveSpawnerFoliage and obj:IsA("BasePart") then
                local mat = obj.Material
                local name = obj.Name:lower()
                local pName = obj.Parent.Name:lower()
                if mat == Enum.Material.Grass or mat == Enum.Material.LeafyGrass or name:find("leaf") or name:find("bush") or name:find("fern") or name:find("tree") or pName:find("bush") or pName:find("fern") or pName:find("tree") then
                    obj.Transparency = 1
                end
            end
        end)
end)

return LightingMore
