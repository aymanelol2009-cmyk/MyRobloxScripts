local ESP = {
    Cache = {},
    Connections = {},
    Enabled = false
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Sincronización con variables globales de la UI
getgenv().ESP_Enabled = getgenv().ESP_Enabled or false
getgenv().BoxType = getgenv().BoxType or "2D"
getgenv().ShowTracer = getgenv().ShowTracer or false
getgenv().TracerOrigin = getgenv().TracerOrigin or "Bottom"
getgenv().ShowDistance = getgenv().ShowDistance or false
getgenv().MaxDistance = getgenv().MaxDistance or 2000
getgenv().TeamCheck = getgenv().TeamCheck or false
getgenv().WallCheck = getgenv().WallCheck or false
getgenv().ShowName = getgenv().ShowName or false
getgenv().ShowHealth = getgenv().ShowHealth or false
getgenv().ShowSkeletons = getgenv().ShowSkeletons or false
getgenv().TracerColor = getgenv().TracerColor or Color3.new(1, 1, 1)
getgenv().BoxColor = getgenv().BoxColor or Color3.new(1, 1, 1)

-- Nuevas variables para World ESP y Loot
getgenv().ContainerESP = getgenv().ContainerESP or false
getgenv().ContainerRenderDistance = getgenv().ContainerRenderDistance or 200
getgenv().NPC_ESP = getgenv().NPC_ESP or false
getgenv().NPCRenderDistance = getgenv().NPCRenderDistance or 1500
getgenv().Vehicle_ESP = getgenv().Vehicle_ESP or false
getgenv().VehicleRenderDistance = getgenv().VehicleRenderDistance or 2000
getgenv().DroppedItemESP = getgenv().DroppedItemESP or false
getgenv().DroppedItemRenderDistance = getgenv().DroppedItemRenderDistance or 200
getgenv().PlayerLootESP = getgenv().PlayerLootESP or false

-- Cache de precios y configuración de valores (Extraído de inari)
local ValueCache = {
    ["6B45"] = 16, ["AS Val"] = 16, ["ATC Key"] = 4, ["Airfield Key"] = 6, ["Altyn"] = 16,
    ["Altyn Visor"] = 8, ["Attak-5 60L"] = 16, ["Bolts"] = 1, ["Crane Key"] = 6, ["DAGR"] = 8,
    ["Duct Tape"] = 1, ["Fast MT"] = 10, ["Flare Gun"] = 8, ["Fueling Station Key"] = 4,
    ["Garage Key"] = 4, ["Hammer"] = 1, ["JPC"] = 10, ["Lighthouse Key"] = 6, ["M4A1"] = 12,
    ["Nails"] = 1, ["Nuts"] = 1, ["Saiga 12"] = 8, ["Super Glue"] = 1, ["Village Key"] = 4, ["Wrench"] = 1
}

local ValueSettings = {
    [0] = Color3.fromRGB(255, 255, 255),
    [4] = Color3.fromRGB(76, 187, 23),
    [8] = Color3.fromRGB(218, 112, 214),
    [16] = Color3.fromRGB(233, 116, 81),
    [32] = Color3.fromRGB(255, 36, 0)
}

local validItemNames = {}
local validNPCNames = {}
getgenv().ItemIcons = getgenv().ItemIcons or {}

local function CacheAssets()
    local RS = game:GetService("ReplicatedStorage")
    local lists = {RS:FindFirstChild("ItemsList"), RS:FindFirstChild("ItemList"), RS:FindFirstChild("ItemsListModels"), RS:FindFirstChild("AmmoTypes")}
    local blacklist = {"MeshPart", "Part", "UnionOperation", "Weld", "WeldConstraint", "Mesh", "SpecialMesh", "HelmetMask", "Harness", "UT", "Hood", "RL", "LU", "RU", "LL", "RA", "LA", "TR", "HD", "Handle", "Casing", "ItemProperties", "Folder", "Configuration", "Model", "SelectionBox", "SurfaceAppearance", "Texture", "Decal"}

    for _, list in pairs(lists) do
        if list then
            for _, obj in pairs(list:GetChildren()) do
                if not table.find(blacklist, obj.Name) then
                    validItemNames[obj.Name] = true
                    local props = obj:FindFirstChild("ItemProperties")
                    local icon = props and props:FindFirstChild("ItemIcon")
                    if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) then
                        getgenv().ItemIcons[obj.Name] = icon.Image
                    end
                end
            end
        end
    end

    local presets = RS:FindFirstChild("AiPresets")
    if presets then
        for _, v in pairs(presets:GetChildren()) do validNPCNames[v.Name] = true end
    end
end
task.spawn(CacheAssets)

function ESP:ScanInventory(Target)
    local found = {}
    if not Target or not next(validItemNames) then return found end
    local blacklist = {"MeshPart", "Part", "UnionOperation", "Weld", "WeldConstraint", "Mesh", "SpecialMesh", "HelmetMask", "Harness", "UT", "Hood", "RL", "LU", "RU", "LL", "RA", "LA", "TR", "HD", "Handle", "Casing", "ItemProperties", "Folder", "Configuration", "SelectionBox", "SurfaceAppearance", "Texture", "Decal"}

    local function scan(root)
        if not root then return end
        for _, v in pairs(root:GetDescendants()) do
            if table.find(blacklist, v.Name) or table.find(blacklist, v.ClassName) then continue end
            local itemName = (v:FindFirstChild("ItemProperties") and v.ItemProperties:GetAttribute("CallSign")) or v:GetAttribute("CallSign") or (validItemNames[v.Name] and v.Name)
            if itemName and validItemNames[itemName] and not table.find(found, itemName) then
                table.insert(found, itemName)
            end
        end
    end

    if Target:IsA("Player") then
        scan(Target.Character)
        local bp = Target:FindFirstChild("Backpack")
        if bp then scan(bp) end
        local rsPlayers = game:GetService("ReplicatedStorage"):FindFirstChild("Players")
        local pFolder = (rsPlayers and rsPlayers:FindFirstChild(Target.Name)) or game:GetService("ReplicatedStorage"):FindFirstChild(Target.Name)
        if pFolder and pFolder:FindFirstChild("Inventory") then scan(pFolder.Inventory) end
    elseif Target:IsA("Model") then
        scan(Target)
        local plr = Players:GetPlayerFromCharacter(Target)
        if plr then return self:ScanInventory(plr) end
    end
    return found
end

function ESP:IsAlive(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
        return true
    end
    return false
end

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do drawing[property] = value end
    return drawing
end

local function getLootInfo(target)
    local items = ESP:ScanInventory(target)
    local total = 0
    local text = ""
    for _, item in pairs(items) do
        local val = ValueCache[item] or 0
        total = total + val
        text = text .. item .. "\n"
    end
    
    local color = Color3.new(1,1,1)
    local highest = -1
    for i, v in pairs(ValueSettings) do
        if total >= i and i > highest then color = v; highest = i end
    end
    
    return total, text, color
end

local function StartESP()
    local bones = {
        {"Head", "UpperTorso"},{"UpperTorso", "RightUpperArm"},{"RightUpperArm", "RightLowerArm"},{"RightLowerArm", "RightHand"},
        {"UpperTorso", "LeftUpperArm"},{"LeftUpperArm", "LeftLowerArm"},{"LeftLowerArm", "LeftHand"},{"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},{"LeftUpperLeg", "LeftLowerLeg"},{"LeftLowerLeg", "LeftFoot"},{"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},{"RightLowerLeg", "RightFoot"}
    }

    local function createEsp(player)
        ESP.Cache[player] = {
            tracer = create("Line", {Thickness = 2, Color = Color3.new(1, 1, 1), Transparency = 0.5}),
            boxOutline = create("Square", {Color = Color3.new(0, 0, 0), Thickness = 3, Filled = false}),
            box = create("Square", {Color = Color3.new(1, 1, 1), Thickness = 1, Filled = false}),
            name = create("Text", {Color = Color3.new(1, 1, 1), Outline = true, Center = true, Size = 13}),
            healthOutline = create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
            health = create("Line", {Thickness = 1}),
            distance = create("Text", {Color = Color3.new(1, 1, 1), Size = 12, Outline = true, Center = true}),
            boxLines = {},
            skeletonlines = {},
            loot = create("Text", {Center = true, Font = 2, Outline = true, Size = 13, Visible = false})
        }
    end

    local function removeEsp(player)
        local esp = ESP.Cache[player]
        if not esp then return end
        for _, drawing in pairs(esp) do
            if type(drawing) == "table" then
                for _, sub in pairs(drawing) do
                    if type(sub) == "table" and sub[1] and sub[1].Remove then sub[1]:Remove()
                    elseif type(sub) ~= "table" and sub.Remove then sub:Remove() end
                end
            elseif drawing.Remove then drawing:Remove() end
        end
        ESP.Cache[player] = nil
    end

    local function hideEsp(esp)
        for _, drawing in pairs(esp) do
            if type(drawing) == "table" then
                for _, sub in pairs(drawing) do
                    if type(sub) == "table" and sub[1] and sub[1].Remove then sub[1].Visible = false
                    elseif type(sub) ~= "table" and sub.Remove then sub.Visible = false end
                end
            elseif drawing.Remove then drawing.Visible = false end
        end
    end

    local function updateEsp()
        for player, esp in pairs(ESP.Cache) do
            local character = player.Character
            if character and (not getgenv().TeamCheck or (player.Team ~= localPlayer.Team)) then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                local humanoid = character:FindFirstChild("Humanoid")
                
                local isBehindWall = getgenv().WallCheck and (function()
                    local origin = camera.CFrame.Position
                    local direction = (rootPart.Position - origin)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {localPlayer.Character, character}
                    local result = workspace:Raycast(origin, direction, rayParams)
                    return result ~= nil
                end)()

                local distance = (camera.CFrame.Position - (rootPart and rootPart.Position or Vector3.new())).Magnitude
                if rootPart and head and humanoid and (not isBehindWall) and getgenv().ESP_Enabled and distance <= (getgenv().MaxDistance or 2000) then
                    local hrp2D, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local charSize = (camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                        local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
                        local boxPos = Vector2.new(math.floor(hrp2D.X - charSize * 1.8 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))
                        
                        if getgenv().ShowName then
                            esp.name.Visible, esp.name.Text, esp.name.Position = true, string.lower(player.Name), Vector2.new(boxSize.X / 2 + boxPos.X, boxPos.Y - 16)
                        else esp.name.Visible = false end
                        
                        if getgenv().Boxes or getgenv().ShowBox then
                            if getgenv().BoxType == "2D" then
                                esp.box.Size, esp.box.Position, esp.box.Visible = boxSize, boxPos, true
                                esp.boxOutline.Size, esp.boxOutline.Position, esp.boxOutline.Visible = boxSize, boxPos, true
                                esp.box.Color = getgenv().BoxColor or Color3.new(1,1,1)
                                for _, l in ipairs(esp.boxLines) do l.Visible = false end
                            elseif getgenv().BoxType == "Corner Box Esp" then
                                local lw, lh, lt = (boxSize.X/5), (boxSize.Y/6), 1
                                if #esp.boxLines == 0 then for i=1,16 do esp.boxLines[i] = create("Line", {Thickness=1, Color=getgenv().BoxColor or Color3.new(1,1,1)}) end end
                                local bl = esp.boxLines
                                bl[1].From, bl[1].To = Vector2.new(boxPos.X-lt, boxPos.Y-lt), Vector2.new(boxPos.X+lw, boxPos.Y-lt)
                                bl[2].From, bl[2].To = Vector2.new(boxPos.X-lt, boxPos.Y-lt), Vector2.new(boxPos.X-lt, boxPos.Y+lh)
                                bl[3].From, bl[3].To = Vector2.new(boxPos.X+boxSize.X-lw, boxPos.Y-lt), Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y-lt)
                                bl[4].From, bl[4].To = Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y-lt), Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y+lh)
                                bl[5].From, bl[5].To = Vector2.new(boxPos.X-lt, boxPos.Y+boxSize.Y-lh), Vector2.new(boxPos.X-lt, boxPos.Y+boxSize.Y+lt)
                                bl[6].From, bl[6].To = Vector2.new(boxPos.X-lt, boxPos.Y+boxSize.Y+lt), Vector2.new(boxPos.X+lw, boxPos.Y+boxSize.Y+lt)
                                bl[7].From, bl[7].To = Vector2.new(boxPos.X+boxSize.X-lw, boxPos.Y+boxSize.Y+lt), Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y+boxSize.Y+lt)
                                bl[8].From, bl[8].To = Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y+boxSize.Y-lh), Vector2.new(boxPos.X+boxSize.X+lt, boxPos.Y+boxSize.Y+lt)
                                for i=9,16 do bl[i].Thickness, bl[i].Color = 2, Color3.new(0,0,0) end
                                bl[9].From, bl[9].To = Vector2.new(boxPos.X, boxPos.Y), Vector2.new(boxPos.X, boxPos.Y+lh)
                                bl[10].From, bl[10].To = Vector2.new(boxPos.X, boxPos.Y), Vector2.new(boxPos.X+lw, boxPos.Y)
                                bl[11].From, bl[11].To = Vector2.new(boxPos.X+boxSize.X-lw, boxPos.Y), Vector2.new(boxPos.X+boxSize.X, boxPos.Y)
                                bl[12].From, bl[12].To = Vector2.new(boxPos.X+boxSize.X, boxPos.Y), Vector2.new(boxPos.X+boxSize.X, boxPos.Y+lh)
                                bl[13].From, bl[13].To = Vector2.new(boxPos.X, boxPos.Y+boxSize.Y-lh), Vector2.new(boxPos.X, boxPos.Y+boxSize.Y)
                                bl[14].From, bl[14].To = Vector2.new(boxPos.X, boxPos.Y+boxSize.Y), Vector2.new(boxPos.X+lw, boxPos.Y+boxSize.Y)
                                bl[15].From, bl[15].To = Vector2.new(boxPos.X+boxSize.X-lw, boxPos.Y+boxSize.Y), Vector2.new(boxPos.X+boxSize.X, boxPos.Y+boxSize.Y)
                                bl[16].From, bl[16].To = Vector2.new(boxPos.X+boxSize.X, boxPos.Y+boxSize.Y-lh), Vector2.new(boxPos.X+boxSize.X, boxPos.Y+boxSize.Y)
                                for _, l in ipairs(bl) do l.Visible = true; l.Color = getgenv().BoxColor or Color3.new(1,1,1) end 
                                esp.box.Visible, esp.boxOutline.Visible = false, false
                            end
                        else 
                            esp.box.Visible, esp.boxOutline.Visible = false, false 
                            for _, l in ipairs(esp.boxLines) do l.Visible = false end
                        end

                        if getgenv().ShowHealth then
                            local hpPct = humanoid.Health / humanoid.MaxHealth
                            esp.healthOutline.Visible, esp.health.Visible = true, true
                            esp.healthOutline.From, esp.healthOutline.To = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y), Vector2.new(boxPos.X - 6, boxPos.Y)
                            esp.health.From, esp.health.To = Vector2.new(boxPos.X - 5, boxPos.Y + boxSize.Y), Vector2.new(boxPos.X - 5, boxPos.Y + boxSize.Y - hpPct * boxSize.Y)
                            esp.health.Color = Color3.fromHSV(hpPct * 0.3, 1, 1)
                        else esp.healthOutline.Visible, esp.health.Visible = false, false end
                        
                        if getgenv().ShowDistance then
                            esp.distance.Visible, esp.distance.Text, esp.distance.Position = true, string.format("%.1f studs", distance), Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 5)
                        else esp.distance.Visible = false end
                        
                        if getgenv().ShowSkeletons then
                            if #esp.skeletonlines == 0 then for _, bp in ipairs(bones) do if character:FindFirstChild(bp[1]) and character:FindFirstChild(bp[2]) then esp.skeletonlines[#esp.skeletonlines+1] = {create("Line", {Thickness=1, Color=Color3.new(1,1,1)}), bp[1], bp[2]} end end end
                            for _, ld in ipairs(esp.skeletonlines) do
                                if character:FindFirstChild(ld[2]) and character:FindFirstChild(ld[3]) then
                                    local p1, p2 = camera:WorldToViewportPoint(character[ld[2]].Position), camera:WorldToViewportPoint(character[ld[3]].Position)
                                    ld[1].From, ld[1].To, ld[1].Visible = Vector2.new(p1.X, p1.Y), Vector2.new(p2.X, p2.Y), true
                                else ld[1].Visible = false end
                            end
                        else for _, ld in ipairs(esp.skeletonlines) do ld[1].Visible = false end end
                        
                        if getgenv().ShowTracer then
                            local origin = getgenv().TracerOrigin or "Bottom"
                            local startPos
                            if origin == "Top" then
                                startPos = Vector2.new(camera.ViewportSize.X / 2, 0)
                            elseif origin == "Mouse" then
                                startPos = UIS:GetMouseLocation()
                            else -- Bottom por defecto
                                startPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            end
                            esp.tracer.Visible, esp.tracer.From, esp.tracer.To = true, startPos, Vector2.new(hrp2D.X, hrp2D.Y)
                            esp.tracer.Color = getgenv().TracerColor or Color3.new(1,1,1)
                        else esp.tracer.Visible = false end

                        if getgenv().PlayerLootESP then
                            local total, lootText, lootColor = getLootInfo(player)
                            esp.loot.Text = string.format("$%d\n%s", total, lootText)
                            esp.loot.Color = lootColor
                            esp.loot.Position = Vector2.new(hrp2D.X, hrp2D.Y + 45)
                            esp.loot.Visible = true
                        else esp.loot.Visible = false end
                    else hideEsp(esp) end
                else hideEsp(esp) end
            else hideEsp(esp) end
        end
    end

    -- Funciones de World ESP
    local function DrawWorldObject(obj, settings_flag, dist_flag, default_tag, color_default)
        local text = create("Text", {Center = true, Font = 2, Outline = true, Size = 13, Visible = false})
        local lastScan = 0
        local total, lootText, lootColor = 0, "", color_default

        local conn;
        conn = RunService.RenderStepped:Connect(function()
            if not getgenv()[settings_flag] or not ESP:IsAlive(localPlayer) then text.Visible = false; return end
            local root = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChild("Handle")) or (obj:IsA("BasePart") and obj)
            if not root then text.Visible = false; return end

            local dist = (root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist > (getgenv()[dist_flag] or 1000) then text.Visible = false; return end

            local pos, onScreen = camera:WorldToViewportPoint(root.Position)
            if not onScreen then text.Visible = false; return end

            if tick() - lastScan > 2 then
                lastScan = tick()
                if settings_flag == "ContainerESP" or settings_flag == "NPC_ESP" then
                    total, lootText, lootColor = getLootInfo(obj)
                else
                    total, lootText, lootColor = 0, "", color_default
                end
            end

            local name = obj:GetAttribute("DisplayName") or obj:GetAttribute("CallSign") or obj.Name
            local tag = default_tag
            local extra = ""
            if settings_flag == "NPC_ESP" then
                if validNPCNames[name] or obj:GetAttribute("Preset") then tag = "[AI]"
                elseif name:find("MON") or name:find("MINE") or name:find("Explosive") then tag = "[EXPLOSIVE]"
                else tag = "[NPC]" end

                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum then extra = string.format("\nHP: %d/%d", math.round(hum.Health), math.round(hum.MaxHealth)) end
            end

            text.Color = lootColor
            text.Position = Vector2.new(pos.X, pos.Y - 20)
            local lootDisplay = (total > 0) and string.format("\n$%d\n%s", total, lootText) or ""
            text.Text = string.format("%s %s%s%s\n%d studs", tag, name, extra, lootDisplay, math.round(dist))
            text.Visible = true
        end)

        obj.AncestryChanged:Connect(function() if not obj.Parent then text:Remove(); conn:Disconnect() end end)
        table.insert(ESP.Connections, conn)
    end

    -- Inicializar watchers de carpetas
    local function SetupFolder(folderName, settings_flag, dist_flag, tag, color)
        task.spawn(function()
            local folder = workspace:WaitForChild(folderName, 10)
            if folder then
                for _, v in pairs(folder:GetChildren()) do DrawWorldObject(v, settings_flag, dist_flag, tag, color) end
                folder.ChildAdded:Connect(function(v) DrawWorldObject(v, settings_flag, dist_flag, tag, color) end)
            end
        end)
    end

    SetupFolder("Containers", "ContainerESP", "ContainerRenderDistance", "[CONTAINER]", Color3.new(1,1,1))
    SetupFolder("Vehicles", "Vehicle_ESP", "VehicleRenderDistance", "[VEHICLE]", Color3.fromRGB(255, 255, 0))
    SetupFolder("DroppedItems", "DroppedItemESP", "DroppedItemRenderDistance", "[ITEM]", Color3.new(0, 1, 1))
    
    -- NPCs (AIs y AiZones)
    task.spawn(function()
        local ais = workspace:WaitForChild("AIs", 10)
        if ais then
            for _, v in pairs(ais:GetChildren()) do DrawWorldObject(v, "NPC_ESP", "NPCRenderDistance", "[AI]", Color3.fromRGB(255, 70, 70)) end
            ais.ChildAdded:Connect(function(v) DrawWorldObject(v, "NPC_ESP", "NPCRenderDistance", "[AI]", Color3.fromRGB(255, 70, 70)) end)
        end
        local zones = workspace:FindFirstChild("AiZones")
        if zones then
            for _, v in pairs(zones:GetDescendants()) do if v:IsA("Model") then DrawWorldObject(v, "NPC_ESP", "NPCRenderDistance", "[AI]", Color3.fromRGB(255, 70, 70)) end end
            zones.DescendantAdded:Connect(function(v) if v:IsA("Model") then DrawWorldObject(v, "NPC_ESP", "NPCRenderDistance", "[AI]", Color3.fromRGB(255, 70, 70)) end end)
        end
    end)

    ESP.Connections.Add = Players.PlayerAdded:Connect(function(p) if p ~= localPlayer then createEsp(p) end end)
    ESP.Connections.Remove = Players.PlayerRemoving:Connect(removeEsp)
    ESP.Connections.Update = RunService.RenderStepped:Connect(updateEsp)

    for _, p in ipairs(Players:GetPlayers()) do if p ~= localPlayer then createEsp(p) end end
end

function ESP:Init()
    if self.Enabled then return end
    self.Enabled = true
    StartESP()
    return self
end

function ESP:Unload()
    self.Enabled = false
    for _, v in pairs(self.Connections) do v:Disconnect() end
    for p, _ in pairs(self.Cache) do
        local esp = self.Cache[p]
        if esp then
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, sub in pairs(drawing) do if sub.Remove then sub:Remove() end end
                elseif drawing.Remove then drawing:Remove() end
            end
        end
    end
    self.Cache = {}
end


return ESP
