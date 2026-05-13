-- Inventory Viewer for Amber UI (wa.lua)
local InventoryViewer = {
    Enabled = false,
    Target = nil,
    Connections = {},
    ItemCache = {},
    InvListRef = nil
}

local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Colores y Fuentes exactos de wa.lua
local colors = {
    background = Color3.fromRGB(12, 12, 14),
    secondary = Color3.fromRGB(18, 18, 20),
    border = Color3.fromRGB(35, 35, 40),
    tabActiveIndicator = Color3.fromRGB(230, 40, 90),
    text = Color3.fromRGB(220, 220, 220),
    textDim = Color3.fromRGB(140, 140, 145),
    elementBackground = Color3.fromRGB(25, 25, 25),
    elementBorder = Color3.fromRGB(40, 40, 40),
}

local fonts = {
    header = Enum.Font.Code,
    main = Enum.Font.Gotham,
}

-- ValueCache and ValueSettings from inari updrage.txt for item pricing
-- Helper para crear instancias
local function Create(class, props)
    local inst = Instance.new(class)
    -- Apply common styling if properties are not explicitly set
    if inst:IsA("TextLabel") or inst:IsA("TextButton") then
        if not props.Font then inst.Font = fonts.main end
        if not props.TextSize then inst.TextSize = 14 end
        if not props.TextColor3 then inst.TextColor3 = colors.text end
        if not props.BackgroundTransparency then inst.BackgroundTransparency = 1 end
    elseif inst:IsA("Frame") or inst:IsA("ScrollingFrame") then
        if not props.BackgroundColor3 then inst.BackgroundColor3 = colors.background end
        if not props.BorderSizePixel then inst.BorderSizePixel = 0 end
    end

    -- Apply specific properties
    for i, v in pairs(props) do inst[i] = v end
    return inst
end

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

-- Cache for item icons (from inari updrage.txt)
getgenv().ItemIcons = {}

-- Función para indexar qué ítems existen en el juego según pedido
function InventoryViewer:CacheGameItems()
    local folders = {
        replicatedStorage:FindFirstChild("AmmoTypes"),
        replicatedStorage:FindFirstChild("ItemsList"),
        replicatedStorage:FindFirstChild("ItemsListModels")
    }
    local blacklist = {"MeshPart", "Part", "UnionOperation", "Weld", "WeldConstraint", "Mesh", "SpecialMesh", "HelmetMask", "Harness", "UT", "Hood", "RL", "LU", "RU", "LL", "RA", "LA", "TR", "HD", "Handle", "Casing", "ItemProperties", "Folder", "Configuration", "Model", "SelectionBox", "SurfaceAppearance", "Texture", "Decal"}

    for _, folder in ipairs(folders) do
        if folder then
            for _, item in ipairs(folder:GetChildren()) do
                if not table.find(blacklist, item.Name) then
                    self.ItemCache[item.Name] = true
                    local props = item:FindFirstChild("ItemProperties")
                    local icon = props and props:FindFirstChild("ItemIcon")
                    if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) then
                        getgenv().ItemIcons[item.Name] = icon.Image
                    end
                end
            end
        end
    end
end

function InventoryViewer:CreateStatsLabel(parent, text)
    return Create("TextLabel", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 12),
        TextColor3 = colors.textDim,
        TextSize = 10,
        Font = fonts.main,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = text
    })
end

function InventoryViewer:CreateInvItem(parent, name, iconId)
    local f = Create("Frame", {
        Parent = parent,
        BackgroundColor3 = colors.elementBackground,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = f, CornerRadius = UDim.new(0, 4)})
    local s = Create("UIStroke", {Parent = f, Color = colors.border, Thickness = 1})
    
    Create("ImageLabel", {
        Parent = f,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = iconId or "rbxassetid://0"
    })

    f.MouseEnter:Connect(function()
        tweenService:Create(s, TweenInfo.new(0.2), {Color = colors.tabActiveIndicator}):Play()
        tweenService:Create(f, TweenInfo.new(0.2), {BackgroundColor3 = colors.secondary}):Play()
        if self.Tooltip then
            self.Tooltip.Text = name:upper()
            self.Tooltip.Visible = true -- Tooltip visibility is handled by the main loop
        end
    end)
    f.MouseLeave:Connect(function()
        tweenService:Create(s, TweenInfo.new(0.2), {Color = colors.elementBorder}):Play()
        if self.Tooltip then self.Tooltip.Visible = false end
    end)
    return f

end

function InventoryViewer:GetClosestPlayerToMouse()
    local shortestDistance = math.huge
    local closestPlayer = nil
    local mousePos = userInputService:GetMouseLocation()
    local camera = workspace.CurrentCamera
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance < 150 then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

function InventoryViewer:ScanPlayerInventory(player)
    local foundItems = {}
    local blacklist = {"MeshPart", "Part", "UnionOperation", "Weld", "WeldConstraint", "Mesh", "SpecialMesh", "HelmetMask", "Harness", "UT", "Hood", "RL", "LU", "RU", "LL", "RA", "LA", "TR", "HD", "Handle", "Casing", "ItemProperties", "Folder", "Configuration", "SelectionBox", "SurfaceAppearance", "Texture", "Decal"}
    local function scan(root)
        if not root then return end
        for _, v in pairs(root:GetDescendants()) do
            if table.find(blacklist, v.Name) or table.find(blacklist, v.ClassName) then continue end
            local itemName = (v:FindFirstChild("ItemProperties") and v.ItemProperties:GetAttribute("CallSign")) or v:GetAttribute("CallSign") or (self.ItemCache[v.Name] and v.Name)
            if itemName and self.ItemCache[itemName] and not table.find(foundItems, itemName) then
                table.insert(foundItems, itemName)
            end
        end
    end
    if player:IsA("Player") then
        scan(player.Character); local bp = player:FindFirstChild("Backpack"); if bp then scan(bp) end
        local playerFolder = replicatedStorage:FindFirstChild(player.Name)
        local RSInv = playerFolder and playerFolder:FindFirstChild("Inventory")
        if RSInv then scan(RSInv) end
    elseif player:IsA("Model") then scan(player) end
    return foundItems
end

function InventoryViewer:SetVisible(state)
    self.Enabled = state
    if self.Gui then self.Gui.Enabled = state end
end

function InventoryViewer:Init(invListRef)
    self:CacheGameItems()
    self.InvListRef = invListRef

    local parent = (gethui and gethui()) or (pcall(game.GetService, game, "CoreGui") and game:GetService("CoreGui")) or localPlayer:WaitForChild("PlayerGui")

    -- Eliminar menús previos para evitar el error de "2 menús"
    if parent:FindFirstChild("Inari_TargetInfo") then parent.Inari_TargetInfo:Destroy() end
    if parent:FindFirstChild("Amber_TargetHUD") then parent.Amber_TargetHUD:Destroy() end

    local TargetInfoGui = Create("ScreenGui", {
        Name = "Amber_TargetHUD",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = parent
    })
    self.Gui = TargetInfoGui

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = TargetInfoGui,
        Size = UDim2.new(0, 180, 0, 220),
        Position = UDim2.new(0.5, 200, 0.5, -110),
        BackgroundColor3 = colors.background,
        BorderSizePixel = 0
    })
    self.MainFrame = MainFrame

    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    -- Borde rosado característico de wa.lua
    Create("UIStroke", {Parent = MainFrame, Color = colors.tabActiveIndicator, Thickness = 1.2})

    -- Shadow Effect (from wa.lua)
    Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 40, 1, 40),
        Image = "rbxassetid://6015667101", -- Assuming this is a generic shadow image
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ZIndex = -1
    })

    local TitleBar = Create("Frame", {Name = "TitleBar", Parent = MainFrame, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = colors.secondary, BorderSizePixel = 0})
    local TitleLabel = Create("TextLabel", {Parent = TitleBar, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = colors.text, TextSize = 14, Font = fonts.header, Text = "TARGET INFO", TextXAlignment = Enum.TextXAlignment.Left})
    self.Title = TitleLabel
    Create("Frame", {Parent = TitleBar, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = colors.tabActiveIndicator, BorderSizePixel = 0})

    local StatsContainer = Create("Frame", {Name = "Stats", Parent = MainFrame, Size = UDim2.new(1, -10, 0, 75), Position = UDim2.new(0, 5, 0, 35), BackgroundTransparency = 1})
    Create("UIListLayout", {Parent = StatsContainer, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})

    local HealthContainer = Create("Frame", {
        Name = "HealthContainer",
        Parent = StatsContainer,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1
    })

    self.HealthValueLabel = Create("TextLabel", {
        Parent = HealthContainer,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor3 = colors.text,
        TextSize = 10,
        Font = fonts.main,
        Text = "HP: 100/100",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HealthBarBg = Create("Frame", {Parent = HealthContainer, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 12), BackgroundColor3 = colors.secondary})
    Create("UICorner", {Parent = HealthBarBg, CornerRadius = UDim.new(0, 2)})
    self.HealthBarFill = Create("Frame", {Parent = HealthBarBg, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 255, 127)})
    Create("UICorner", {Parent = self.HealthBarFill, CornerRadius = UDim.new(0, 2)})

    self.WeaponLabel = self:CreateStatsLabel(StatsContainer, "Tool: None")
    self.LastWeaponLabel = self:CreateStatsLabel(StatsContainer, "Last Tool: None")
    self.ExtraLabel = self:CreateStatsLabel(StatsContainer, "SPD: 16 | DIST: 0")

    local InvScroll = Create("ScrollingFrame", {Parent = MainFrame, Size = UDim2.new(1, -10, 0, 130), Position = UDim2.new(0, 5, 0, 115), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarImageColor3 = colors.tabActiveIndicator})
    self.InvScroll = InvScroll
    Create("UIGridLayout", {Parent = InvScroll, CellPadding = UDim2.new(0, 4, 0, 4), CellSize = UDim2.new(0, 37, 0, 37)})
    
    self.Tooltip = Create("TextLabel", {Name = "ItemTooltip", Parent = TargetInfoGui, Size = UDim2.new(0, 100, 0, 20), BackgroundTransparency = 0.1, BackgroundColor3 = colors.secondary, TextColor3 = colors.text, TextSize = 12, Font = fonts.main, TextXAlignment = Enum.TextXAlignment.Center, Visible = false, ZIndex = 9999})
    Create("UICorner", {Parent = self.Tooltip, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = self.Tooltip, Color = colors.border, Thickness = 1})
    Create("UICorner", {Parent = self.Tooltip, CornerRadius = UDim.new(0, 4)})

    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = MainFrame.Position end end)
    userInputService.InputChanged:Connect(function(input) 
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        if self.Tooltip and self.Tooltip.Visible then 
            local mPos = userInputService:GetMouseLocation()
            self.Tooltip.Position = UDim2.new(0, mPos.X + 10, 0, mPos.Y + 10) 
        end
    end)
    userInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local lastInvContent = ""
    task.spawn(function()
        print("[AMBER] Inventory Viewer loop started")
        while task.wait(0.1) do 
            -- Si estamos en modo test, forzamos la activación
            local isTesting = _G.InventoryTest == true
            local enabled = getgenv().TargetHUDEnabled or getgenv().InventoryViewerEnabled or isTesting
            
            local targetPlayer = self:GetClosestPlayerToMouse()
            -- En modo test, si no hay nadie cerca, nos mostramos a nosotros mismos para debug
            if isTesting and not targetPlayer then targetPlayer = localPlayer end
            
            local char = targetPlayer and targetPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if enabled and char and hum then
                self.MainFrame.Visible = true
                self.Title.Text = targetPlayer.Name:upper()
                if getgenv().TargetHUDEnabled then
                    StatsContainer.Visible = true
                    local hp, mhp = math.round(hum.Health), math.round(hum.MaxHealth)
                    local hpPct = math.clamp(hp / mhp, 0, 1)
                    self.HealthValueLabel.Text = string.format("HP: %d/%d", hp, mhp)
                    tweenService:Create(self.HealthBarFill, TweenInfo.new(0.2), {Size = UDim2.new(hpPct, 0, 1, 0), BackgroundColor3 = Color3.fromHSV(hpPct * 0.3, 1, 1)}):Play()

                    -- Búsqueda de tool equipado en ReplicatedStorage siguiendo la ruta solicitada
                    local toolName = "None"
                    local lastToolName = "None"
                    local rsPlayers = replicatedStorage:FindFirstChild("Players")
                    local playerRS = rsPlayers and rsPlayers:FindFirstChild(targetPlayer.Name)
                    local gVariables = playerRS and playerRS:FindFirstChild("Status") and playerRS.Status:FindFirstChild("GameplayVariables")
                    
                    if gVariables then
                        local equippedVal = gVariables:FindFirstChild("EquippedTool")
                        if equippedVal and equippedVal:IsA("ObjectValue") and equippedVal.Value then toolName = equippedVal.Value.Name end
                        
                        local lastEquippedVal = gVariables:FindFirstChild("LastEquippedTool")
                        if lastEquippedVal and lastEquippedVal:IsA("ObjectValue") and lastEquippedVal.Value then lastToolName = lastEquippedVal.Value.Name end
                    end
                    self.WeaponLabel.Text = "Tool: " .. toolName
                    self.LastWeaponLabel.Text = "Last Tool: " .. lastToolName

                    local dist = (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart")) and (localPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude or 0
                    self.ExtraLabel.Text = string.format("SPD: %.1f | DIST: %d", hum.WalkSpeed, math.round(dist))
                else StatsContainer.Visible = false end

                if getgenv().InventoryViewerEnabled then
                    InvScroll.Visible = true
                    local items = self:ScanPlayerInventory(targetPlayer)
                    local currentContent = table.concat(items, ",")
                    if currentContent ~= lastInvContent then
                        lastInvContent = currentContent
                        for _, v in pairs(InvScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
                        for _, itemName in pairs(items) do self:CreateInvItem(InvScroll, itemName, getgenv().ItemIcons[itemName]) end
                        if self.InvListRef then local dL = {unpack(items)}; table.insert(dL, 1, "[" .. self.Title.Text .. "]"); self.InvListRef:Refresh(dL) end
                    end
                else InvScroll.Visible = false end
                MainFrame.Size = UDim2.new(0, 180, 0, 30 + (StatsContainer.Visible and 80 or 0) + (InvScroll.Visible and 135 or 0))
                InvScroll.Position = UDim2.new(0, 5, 0, StatsContainer.Visible and 115 or 35)
            else
                self.MainFrame.Visible = false; lastInvContent = ""
                if self.InvListRef then self.InvListRef:Refresh({"No target found"}) end
            end
        end
    end)
    return self
end

-- Lógica de ejecución Standalone (Para pruebas rápidas)
-- Para probarlo sin wa.lua, ejecuta: _G.InventoryTest = true; loadstring(...)()
if _G.InventoryTest then
    getgenv().TargetHUDEnabled = true
    getgenv().InventoryViewerEnabled = true
    InventoryViewer:Init():SetVisible(true)
    warn("[AMBER] Inventory Viewer iniciado en modo Standalone (Debug ON)")
end

return InventoryViewer
