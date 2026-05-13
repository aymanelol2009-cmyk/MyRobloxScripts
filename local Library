-- Amber UI Library (Inspirada en image_0.png)
local Library = {}

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local localPlayer = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local connections = {} -- To manage connections for unloading

-- Definición de colores base
local colors = {
    background = Color3.fromRGB(12, 12, 14),
    secondary = Color3.fromRGB(18, 18, 20),
    border = Color3.fromRGB(35, 35, 40),
    headerText = Color3.fromRGB(150, 150, 150),
    tabActiveIndicator = Color3.fromRGB(230, 40, 90),
    text = Color3.fromRGB(220, 220, 220),
    textDim = Color3.fromRGB(140, 140, 145),
    elementBackground = Color3.fromRGB(25, 25, 25),
    elementBorder = Color3.fromRGB(40, 40, 40),
}

local fonts = {
    header = Enum.Font.Code,
    main = Enum.Font.Gotham, -- Cambiado por una fuente más moderna si está disponible, o Gotham
}

-- Utilidades
local function rippleEffect(object)
    object.MouseEnter:Connect(function()
        tweenService:Create(object, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
    end)
    object.MouseLeave:Connect(function()
        tweenService:Create(object, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end)
end

-- Connection Management for Library
function Library:SafeConnect(event, handler, name)
    local connection = event:Connect(handler)
    table.insert(connections, connection)
    return connection
end

-- Keybind List Logic
function Library:UpdateKeybindList(id, name, keyName, active, isButton)
    if not self.KeybindList then return end
    local container = self.KeybindList.Container
    local item = container:FindFirstChild(id)

    if not item then
        item = Instance.new("TextLabel")
        item.Name = id
        item.Size = UDim2.new(1, 0, 0, 18)
        item.BackgroundTransparency = 1
        item.Font = fonts.main
        item.TextSize = 12
        item.TextColor3 = colors.textDim
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.Parent = container
    end

    item.Text = string.format("[%s] %s", keyName, name)
    
    if isButton and active then
        tweenService:Create(item, TweenInfo.new(0.1), {TextColor3 = colors.tabActiveIndicator}):Play()
        task.delay(0.2, function()
            if item and item.Parent then
                tweenService:Create(item, TweenInfo.new(0.3), {TextColor3 = colors.textDim}):Play()
            end
        end)
    else
        tweenService:Create(item, TweenInfo.new(0.2), {TextColor3 = active and colors.tabActiveIndicator or colors.textDim}):Play()
    end
end

function Library:Notify(title, text, duration)
    if not self.ScreenGui then
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "AmberUI"
        self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.ScreenGui.Parent = coreGui
    end

    if not self.NotifContainer then
        self.NotifContainer = Instance.new("Frame")
        self.NotifContainer.Name = "Notifications"
        self.NotifContainer.Size = UDim2.new(0, 250, 1, -20)
        self.NotifContainer.Position = UDim2.new(1, -260, 0, 10)
        self.NotifContainer.BackgroundTransparency = 1
        self.NotifContainer.Parent = self.ScreenGui

        local Layout = Instance.new("UIListLayout")
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Padding = UDim.new(0, 8)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = self.NotifContainer
    end

    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.BackgroundColor3 = colors.background
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.LayoutOrder = -os.time()
    Notification.Parent = self.NotifContainer

    local Stroke = Instance.new("UIStroke", Notification)
    Stroke.Color = colors.border
    Stroke.Thickness = 1

    local Liner = Instance.new("Frame", Notification)
    Liner.Size = UDim2.new(1, 0, 0, 1)
    Liner.Position = UDim2.new(0, 0, 1, -1)
    Liner.BackgroundColor3 = colors.tabActiveIndicator
    Liner.BorderSizePixel = 0

    local TitleLabel = Instance.new("TextLabel", Notification)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "<b>" .. title:upper() .. "</b>"
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = colors.text
    TitleLabel.Font = fonts.header
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TextLabel = Instance.new("TextLabel", Notification)
    TextLabel.Size = UDim2.new(1, -20, 0, 0)
    TextLabel.Position = UDim2.new(0, 10, 0, 22)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = colors.textDim
    TextLabel.Font = fonts.header
    TextLabel.TextSize = 11
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y

    tweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 45)}):Play()

    task.delay(duration or 5, function()
        local outTween = tweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 0)})
        outTween:Play()
        outTween.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

function Library:CreateKeybindList()
    local Main = Instance.new("Frame")
    Main.Name = "KeybindList"
    Main.Size = UDim2.new(0, 180, 0, 0)
    Main.Position = UDim2.new(0, 20, 0.5, 0)
    Main.BackgroundColor3 = colors.background
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.AutomaticSize = Enum.AutomaticSize.Y
    Main.Parent = self.ScreenGui

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = colors.tabActiveIndicator
    Stroke.Thickness = 1.2

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 25)
    Header.BackgroundColor3 = colors.secondary
    Header.BorderSizePixel = 0
    Header.Parent = Main
    
    local Title = Instance.new("TextLabel", Header)
    Title.Text = "KEYBINDS"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = colors.tabActiveIndicator
    Title.Font = fonts.header
    Title.TextSize = 12
    Title.BackgroundTransparency = 1

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 0, 0, 25)
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.Parent = Main

    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 2)
    local pad = Instance.new("UIPadding", Container)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 5)

    -- Basic Draggable for the HUD
    local Dragging, DragInput, DragStart, StartPos
    Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = input.Position StartPos = Main.Position end end)
    userInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - DragStart Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y) end end)
    userInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    self.KeybindList = {Main = Main, Container = Container}
end

function Library:Watermark(text)
    if not self.ScreenGui then
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "AmberUI"
        self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.ScreenGui.Parent = coreGui
    end

    local Main = Instance.new("Frame")
    Main.Name = "Watermark"
    Main.Size = UDim2.new(0, 0, 0, 22)
    Main.Position = UDim2.new(0.5, 0, 0, 15)
    Main.AnchorPoint = Vector2.new(0.5, 0)
    Main.BackgroundColor3 = colors.background
    Main.BorderSizePixel = 0
    Main.AutomaticSize = Enum.AutomaticSize.X
    Main.Parent = self.ScreenGui

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = colors.border
    Stroke.Thickness = 1

    local Liner = Instance.new("Frame", Main)
    Liner.Size = UDim2.new(1, 0, 0, 1)
    Liner.Position = UDim2.new(0, 0, 1, -1)
    Liner.BackgroundColor3 = colors.tabActiveIndicator
    Liner.BorderSizePixel = 0
    
    local Label = Instance.new("TextLabel", Main)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = colors.text
    Label.Font = fonts.header
    Label.TextSize = 12
    Label.AutomaticSize = Enum.AutomaticSize.X
    Label.Parent = Main
    
    local padding = Instance.new("UIPadding", Main)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)

    -- Draggable
    local Dragging, DragInput, DragStart, StartPos
    Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true DragStart = input.Position StartPos = Main.Position end end)
    userInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - DragStart Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y) end end)
    userInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    return {
        SetVisible = function(_, state) Main.Visible = state end,
        SetText = function(_, newText) Label.Text = newText end
    }
end

function Library:Unload()
    for _, connection in pairs(connections) do if connection.Connected then connection:Disconnect() end end
    connections = {}
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

function Library:CreateWindow(title, subtitle)
    local activeTab = nil
    local tabs = {}
    local tabCount = 0
    -- ScreenGui
    if not self.ScreenGui then
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "AmberUI"
        self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.ScreenGui.Parent = coreGui
    end
    local ScreenGui = self.ScreenGui

    self:CreateKeybindList()

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 560, 0, 620)
    Main.Position = UDim2.new(0.5, -280, 0.5, -310)
    Main.BackgroundColor3 = colors.background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Image = "rbxassetid://6015667101"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = -1
    Shadow.Parent = Main

    local OuterBorder = Instance.new("UIStroke")
    OuterBorder.Thickness = 1.2
    OuterBorder.Color = colors.tabActiveIndicator
    OuterBorder.Parent = Main

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundTransparency = 1
    Header.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.RichText = true
    TitleLabel.Text = "<b>" .. title:upper() .. "</b> <font color='#888888'>| " .. (subtitle or os.date("%b. %d. %Y")) .. "</font>"
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = fonts.header
    TitleLabel.TextSize = 14
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = colors.headerText
    MinimizeBtn.Font = fonts.header
    MinimizeBtn.TextSize = 22
    MinimizeBtn.Parent = Header

    Library:SafeConnect(MinimizeBtn.MouseEnter, function()
        tweenService:Create(MinimizeBtn, TweenInfo.new(0.3), {TextColor3 = colors.tabActiveIndicator}):Play()
    end)

    Library:SafeConnect(MinimizeBtn.MouseLeave, function()
        tweenService:Create(MinimizeBtn, TweenInfo.new(0.3), {TextColor3 = colors.headerText}):Play()
    end)

    function tabs:SetOpen(state)
        Main.Visible = state
    end

    Library:SafeConnect(MinimizeBtn.MouseButton1Click, function()
        tabs:SetOpen(false)
    end)

    -- Bucle para actualizar la hora automáticamente
    task.spawn(function()
        while task.wait(1) and ScreenGui.Parent do
            TitleLabel.Text = "<b>" .. title:upper() .. "</b> <font color='#888888'>| " .. os.date("%b %d, %Y - %H:%M:%S") .. "</font>"
        end
    end)

    -- Draggable Logic (Restringido al Header para evitar conflictos con sliders/pickers)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPos = nil
    local function updateDrag(input)
        local delta = input.Position - DragStart
        local newPosition = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        Main.Position = newPosition
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            updateDrag(input)
        end
    end)

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.ZIndex = 2
    TabContainer.Size = UDim2.new(1, -20, 0, 35)
    TabContainer.Position = UDim2.new(0, 10, 0, 35)
    TabContainer.BackgroundColor3 = colors.secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main
    
    local TabStroke = Instance.new("UIStroke", TabContainer)
    TabStroke.Color = colors.border

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 10) -- Aumentado para más separación entre pestañas
    TabList.Parent = TabContainer

    -- Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "Pages"
    PageContainer.Size = UDim2.new(1, -20, 1, -85)
    PageContainer.Position = UDim2.new(0, 10, 0, 75)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = Main

    -- Función de creación de pestañas
    function tabs:AddTab(text)
        tabCount += 1
        local tabId = tabCount

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = text .. "_Tab"
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = text
        TabBtn.TextColor3 = (tabId == 1 and Color3.new(1,1,1) or colors.headerText)
        TabBtn.Font = fonts.main
        TabBtn.TextSize = 14
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.Parent = TabContainer
        
        -- Añadir padding al texto de la pestaña
        local TabTextPadding = Instance.new("UIPadding")
        TabTextPadding.PaddingLeft = UDim.new(0, 10)
        TabTextPadding.PaddingRight = UDim.new(0, 10)
        TabTextPadding.Parent = TabBtn

        -- Indicador de pestaña activa
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Size = UDim2.new(0, 0, 0, 2)
        TabIndicator.Position = UDim2.new(0.5, 0, 1, -2)
        TabIndicator.AnchorPoint = Vector2.new(0.5, 0)
        TabIndicator.BackgroundColor3 = colors.tabActiveIndicator
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Parent = TabBtn
        if tabId == 1 then TabIndicator.Size = UDim2.new(0.8, 0, 0, 2) end

        -- Page
        local Page = Instance.new("Frame")
        Page.Name = text .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = (tabId == 1)
        Page.Parent = PageContainer

        -- Page Layout (Columns)
        local Grid = Instance.new("UIGridLayout")
        Grid.CellSize = UDim2.new(0.485, 0, 1, 0)
        Grid.CellPadding = UDim2.new(0.03, 0, 0, 0)
        Grid.Parent = Page

        -- Versión corregida de las funciones internas
        local function createColumn(sideName)
            local Column = Instance.new("ScrollingFrame")
            Column.Name = text .. "_" .. sideName .. "_Column"
            Column.Size = UDim2.new(1, 0, 1, 0)
            Column.BackgroundTransparency = 1
            Column.CanvasSize = UDim2.new(0, 0, 0, 0)
            Column.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Column.ScrollBarThickness = 2
            Column.ScrollBarImageColor3 = colors.tabActiveIndicator
            Column.Active = true
            Column.Parent = Page
            local ColLayout = Instance.new("UIListLayout")
            ColLayout.Padding = UDim.new(0, 8)
            ColLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ColLayout.Parent = Column
            return Column
        end

        local LeftColumn = createColumn("Left")
        local RightColumn = createColumn("Right")

        -- Función de callback para el botón de pestaña
        TabBtn.MouseButton1Click:Connect(function()
            -- Ocultar todas las páginas
            for _, otherPage in ipairs(PageContainer:GetChildren()) do
                if otherPage:IsA("Frame") then
                    otherPage.Visible = false
                end
            end
            for _, otherTab in ipairs(TabContainer:GetChildren()) do
                if otherTab:IsA("TextButton") then
                    tweenService:Create(otherTab, TweenInfo.new(0.3), {TextColor3 = colors.headerText}):Play()
                    local ind = otherTab:FindFirstChild("Frame")
                    if ind then
                        tweenService:Create(ind, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 2)}):Play()
                    end
                end
            end

            Page.Visible = true
            tweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
            tweenService:Create(TabIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0.8, 0, 0, 2)}):Play()
        end)

        -- --- FUNCIONES DE ELEMENTOS PARA COLUMNAS ---
        local elements = {}

        -- Section Container
        function elements:AddSection(title, columnSide)
            local targetColumn = (columnSide == "Right" and RightColumn or LeftColumn)

            local Section = Instance.new("Frame")
            Section.Name = title .. "_Section"
            Section.Size = UDim2.new(1, -10, 0, 0)
            Section.BackgroundColor3 = colors.secondary
            Section.BorderSizePixel = 0
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.Parent = targetColumn
            
            local SecStroke = Instance.new("UIStroke", Section)
            SecStroke.Color = colors.border

            local SecLayout = Instance.new("UIListLayout")
            SecLayout.Padding = UDim.new(0, 10) -- Solo UDim
            SecLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            SecLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SecLayout.Parent = Section

            local SecPadding = Instance.new("UIPadding")
            SecPadding.PaddingLeft = UDim.new(0, 10)
            SecPadding.PaddingTop = UDim.new(0, 10)
            SecPadding.PaddingBottom = UDim.new(0, 10)
            SecPadding.PaddingRight = UDim.new(0, 10)
            SecPadding.Parent = Section

            local SecTitle = Instance.new("TextLabel")
            SecTitle.Text = title
            SecTitle.LayoutOrder = -100
            SecTitle.Size = UDim2.new(1, 0, 0, 15)
            SecTitle.TextColor3 = colors.headerText
            SecTitle.Font = Enum.Font.SourceSansBold
            SecTitle.TextSize = 14
            SecTitle.BackgroundTransparency = 1
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            SecTitle.Parent = Section
            
            return Section
        end

        -- Checkbox
        function elements:AddCheckbox(section, text, default, callback)
            local state = default or false

            local CheckboxBtn = Instance.new("TextButton")
            CheckboxBtn.Name = text .. "_Checkbox"
            CheckboxBtn.Size = UDim2.new(1, 0, 0, 20)
            CheckboxBtn.BackgroundTransparency = 1
            CheckboxBtn.Text = ""
            CheckboxBtn.Parent = section

            local CheckboxVisual = Instance.new("Frame")
            CheckboxVisual.Size = UDim2.new(0, 16, 0, 16)
            CheckboxVisual.Position = UDim2.new(0, 0, 0, 2)
            CheckboxVisual.BackgroundColor3 = state and colors.tabActiveIndicator or colors.background
            CheckboxVisual.BorderSizePixel = 0
            CheckboxVisual.Parent = CheckboxBtn

            local CheckStateIndicator = Instance.new("Frame")
            CheckStateIndicator.Name = "Indicator"
            CheckStateIndicator.Size = UDim2.new(0, 10, 0, 10)
            CheckStateIndicator.Position = UDim2.new(0.5, -5, 0.5, -5)
            CheckStateIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
            CheckStateIndicator.BackgroundTransparency = state and 0 or 1
            CheckStateIndicator.Parent = CheckboxVisual
            Instance.new("UICorner", CheckStateIndicator).CornerRadius = UDim.new(1, 0)

            local CheckboxLabel = Instance.new("TextLabel")
            CheckboxLabel.Text = text
            CheckboxLabel.Size = UDim2.new(1, -26, 1, 0)
            CheckboxLabel.Position = UDim2.new(0, 26, 0, 0)
            CheckboxLabel.TextColor3 = state and Color3.new(1,1,1) or colors.textDim
            CheckboxLabel.Font = fonts.main
            CheckboxLabel.TextSize = 14
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            CheckboxLabel.Parent = CheckboxBtn

            local checkboxObject = {
                State = state,
                Button = CheckboxBtn
            }

            function checkboxObject:SetState(newState)
                self.State = newState
                tweenService:Create(CheckboxVisual, TweenInfo.new(0.2), {BackgroundColor3 = self.State and colors.tabActiveIndicator or colors.background}):Play()
                tweenService:Create(CheckStateIndicator, TweenInfo.new(0.2), {BackgroundTransparency = self.State and 0 or 1}):Play()
                tweenService:Create(CheckboxLabel, TweenInfo.new(0.2), {TextColor3 = self.State and Color3.new(1,1,1) or colors.textDim}):Play()
                if self.BoundKey then
                    Library:UpdateKeybindList(text, text, self.BoundKey.Name, self.State, false)
                end
                callback(self.State)
            end

            CheckboxBtn.MouseButton1Click:Connect(function()
                checkboxObject:SetState(not checkboxObject.State)
            end)

            function checkboxObject:AddKeybind(key)
                local currentKey = key
                local binding = false

                local KeyLabel = Instance.new("TextLabel")
                KeyLabel.Text = "[" .. (currentKey and currentKey.Name or "None") .. "]"
                KeyLabel.Size = UDim2.new(1, -5, 1, 0)
                KeyLabel.TextColor3 = colors.tabActiveIndicator
                KeyLabel.Font = fonts.main
                KeyLabel.TextSize = 12
                KeyLabel.BackgroundTransparency = 1
                KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
                KeyLabel.Parent = CheckboxBtn

                self.BoundKey = currentKey
                Library:UpdateKeybindList(text, text, self.BoundKey.Name, self.State, false)

                CheckboxBtn.MouseButton2Click:Connect(function()
                    binding = true
                    KeyLabel.Text = "[...]"
                end)

                Library:SafeConnect(userInputService.InputBegan, function(input, gpe)
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            self.BoundKey = currentKey
                            binding = false
                            KeyLabel.Text = "[" .. currentKey.Name .. "]"
                            Library:UpdateKeybindList(text, text, self.BoundKey.Name, self.State, false)
                        end
                    elseif not gpe and input.KeyCode == currentKey then
                        self:SetState(not self.State)
                    end
                end)
                return self
            end

            return checkboxObject
        end

        -- Button
        function elements:AddButton(section, text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 25)
            Button.BackgroundColor3 = colors.background
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.TextColor3 = colors.text
            Button.Font = fonts.main
            Button.TextSize = 14
            Button.Parent = section
            
            local bStroke = Instance.new("UIStroke", Button)
            bStroke.Color = colors.border

            Button.MouseButton1Click:Connect(function()
                tweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = colors.tabActiveIndicator}):Play()
                task.wait(0.1)
                tweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = colors.background}):Play()
                callback()
            end)

            return Button
        end

        -- Keybind
        function elements:AddKeybind(section, text, default, callback)
            local binding = false
            local currentKey = default or Enum.KeyCode.F

            local KeybindBtn = Instance.new("TextButton")
            KeybindBtn.Name = text .. "_Keybind"
            KeybindBtn.Size = UDim2.new(1, 0, 0, 25)
            KeybindBtn.BackgroundColor3 = colors.background
            KeybindBtn.BorderSizePixel = 0
            KeybindBtn.Text = "  " .. text
            KeybindBtn.TextColor3 = colors.textDim
            KeybindBtn.Font = fonts.main
            KeybindBtn.TextSize = 14
            KeybindBtn.TextXAlignment = Enum.TextXAlignment.Left
            KeybindBtn.Parent = section
            local kbStroke = Instance.new("UIStroke", KeybindBtn)
            kbStroke.Color = colors.border

            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Text = "[" .. (currentKey and currentKey.Name or "None") .. "]"
            KeyLabel.Size = UDim2.new(1, -10, 1, 0)
            KeyLabel.Position = UDim2.new(0, 0, 0, 0)
            KeyLabel.TextColor3 = colors.tabActiveIndicator
            KeyLabel.Font = fonts.main
            KeyLabel.TextSize = 12
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
            KeyLabel.Parent = KeybindBtn

            Library:UpdateKeybindList(text, text, currentKey.Name, false, true)

            KeybindBtn.MouseButton1Click:Connect(function()
                binding = true
                KeyLabel.Text = "[...]"
            end)

            Library:SafeConnect(userInputService.InputBegan, function(input, gpe)
                if binding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        binding = false
                        KeyLabel.Text = "[" .. currentKey.Name .. "]"
                        Library:UpdateKeybindList(text, text, currentKey.Name, false, true)
                    end
                else
                    if not gpe and input.KeyCode == currentKey then
                        Library:UpdateKeybindList(text, text, currentKey.Name, true, true)
                        callback()
                    end
                end
            end)

            return KeybindBtn
        end

        -- Dropdown (Improved)
        function elements:AddDropdown(section, text, list, default, callback)
            local isOpen = false
            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 25)
            DropBtn.BackgroundColor3 = colors.background
            DropBtn.BorderSizePixel = 0
            DropBtn.Text = text .. ": " .. (default or "...")
            DropBtn.TextColor3 = colors.textDim
            DropBtn.Font = fonts.main
            DropBtn.TextSize = 14
            DropBtn.Parent = section
            local dStroke = Instance.new("UIStroke", DropBtn)
            dStroke.Color = colors.border

            local ListLabel = Instance.new("TextLabel")
            ListLabel.Text = "˅"
            ListLabel.Size = UDim2.new(0, 20, 1, 0)
            ListLabel.Position = UDim2.new(1, -20, 0, 0)
            ListLabel.TextColor3 = colors.headerText
            ListLabel.Font = fonts.main
            ListLabel.TextSize = 12
            ListLabel.BackgroundTransparency = 1
            ListLabel.Parent = DropBtn

            local DropList = Instance.new("Frame")
            DropList.Size = UDim2.new(1, 0, 0, 0)
            DropList.Position = UDim2.new(0, 0, 1, 2)
            DropList.BackgroundColor3 = colors.secondary
            DropList.BorderSizePixel = 0
            DropList.Active = true
            DropList.Visible = false
            DropList.ClipsDescendants = true
            DropList.ZIndex = 5
            DropList.Parent = DropBtn
            
            local listLayout = Instance.new("UIListLayout", DropList)
            local dlStroke = Instance.new("UIStroke", DropList)
            dlStroke.Color = colors.border

            for _, val in ipairs(list) do
                local Opt = Instance.new("TextButton")
                Opt.Size = UDim2.new(1, 0, 0, 20)
                Opt.BackgroundTransparency = 1
                Opt.Text = tostring(val)
                Opt.TextColor3 = colors.textDim
                Opt.Font = fonts.main
                Opt.TextSize = 12
                Opt.Active = true
                Opt.ZIndex = 6
                Opt.Parent = DropList
                
                Opt.MouseEnter:Connect(function()
                    tweenService:Create(Opt, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = colors.text}):Play()
                end)
                Opt.MouseLeave:Connect(function()
                    tweenService:Create(Opt, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end)
                
                Opt.MouseButton1Click:Connect(function()
                    default = val
                    DropBtn.Text = text .. ": " .. tostring(val)
                    isOpen = false
                    DropList.Visible = false
                    section.ZIndex = 1
                    DropBtn.ZIndex = 1
                    callback(val)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropList.Visible = isOpen
                section.ZIndex = isOpen and 10 or 1
                DropBtn.ZIndex = isOpen and 10 or 1
                DropList.Size = isOpen and UDim2.new(1, 0, 0, #list * 20) or UDim2.new(1, 0, 0, 0)
            end)

            -- Lógica para cerrar el dropdown al hacer clic fuera
            Library:SafeConnect(userInputService.InputBegan, function(input, gpe)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not gpe and isOpen then
                    local mPos = input.Position
                    local isInsideBtn = mPos.X >= DropBtn.AbsolutePosition.X and mPos.X <= DropBtn.AbsolutePosition.X + DropBtn.AbsoluteSize.X and
                                        mPos.Y >= DropBtn.AbsolutePosition.Y and mPos.Y <= DropBtn.AbsolutePosition.Y + DropBtn.AbsoluteSize.Y
                    local isInsideList = mPos.X >= DropList.AbsolutePosition.X and mPos.X <= DropList.AbsolutePosition.X + DropList.AbsoluteSize.X and
                                         mPos.Y >= DropList.AbsolutePosition.Y and mPos.Y <= DropList.AbsolutePosition.Y + DropList.AbsoluteSize.Y
                    
                    if not isInsideBtn and not isInsideList then
                        isOpen = false
                        DropList.Visible = false
                        section.ZIndex = 1
                        DropBtn.ZIndex = 1
                    end
                end
            end)

            return DropBtn
        end

        -- Slider (Nuevo componente)
        function elements:AddSlider(section, text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 35)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = section

            local Label = Instance.new("TextLabel")
            Label.Text = text .. ": " .. default
            Label.Size = UDim2.new(1, 0, 0, 15)
            Label.TextColor3 = colors.textDim
            Label.Font = fonts.main
            Label.TextSize = 12
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(1, 0, 0, 4)
            Bar.Position = UDim2.new(0, 0, 0, 22)
            Bar.BackgroundColor3 = colors.background
            Bar.BorderSizePixel = 0
            Bar.Parent = SliderFrame

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = colors.tabActiveIndicator
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar

            local function update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = text .. ": " .. val
                callback(val)
            end

            local dragging = false
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end
            end)
            userInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            userInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            return SliderFrame
        end

        -- Textbox (Nuevo componente)
        -- Textbox component
        function elements:AddTextbox(section, text, default, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 45)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.Parent = section

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(1, 0, 0, 15)
            Label.TextColor3 = colors.textDim
            Label.Font = fonts.main
            Label.TextSize = 12
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TextboxFrame

            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 25)
            InputFrame.Position = UDim2.new(0, 0, 0, 20)
            InputFrame.BackgroundColor3 = colors.background
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TextboxFrame
            local iStroke = Instance.new("UIStroke", InputFrame)
            iStroke.Color = colors.border

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 5, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = default or ""
            TextBox.PlaceholderText = "..."
            TextBox.TextColor3 = colors.text
            TextBox.Font = fonts.main
            TextBox.TextSize = 12
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Parent = InputFrame

            TextBox.FocusLost:Connect(function()
                if callback then pcall(callback, TextBox.Text) end
            end)

            return {
                Set = function(_, val) TextBox.Text = val; if callback then callback(val) end end,
                Get = function() return TextBox.Text end
            }
        end

        -- Color Picker (Nuevo componente)
        function elements:AddColorPicker(section, text, default, callback)
            local colorValue = default or Color3.fromRGB(255, 255, 255)
            local hue, sat, val = colorValue:ToHSV()
            local alpha = 1 -- Default alpha

            local ColorPickerBtn = Instance.new("TextButton")
            ColorPickerBtn.Size = UDim2.new(1, 0, 0, 25)
            ColorPickerBtn.BackgroundColor3 = colors.background
            ColorPickerBtn.BorderSizePixel = 0
            ColorPickerBtn.Text = text
            ColorPickerBtn.TextColor3 = colors.textDim
            ColorPickerBtn.Font = fonts.main
            ColorPickerBtn.TextSize = 14
            ColorPickerBtn.Parent = section
            local cpStroke = Instance.new("UIStroke", ColorPickerBtn)
            cpStroke.Color = colors.border

            local ColorPreview = Instance.new("Frame")
            ColorPreview.Size = UDim2.new(0, 20, 0, 15)
            ColorPreview.Position = UDim2.new(1, -25, 0.5, -7.5)
            ColorPreview.AnchorPoint = Vector2.new(1, 0.5)
            ColorPreview.BackgroundColor3 = colorValue
            ColorPreview.BorderSizePixel = 0
            ColorPreview.Parent = ColorPickerBtn
            Instance.new("UIStroke", ColorPreview).Color = colors.border

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Name = "ColorPickerWindow"
            PickerFrame.Size = UDim2.new(0, 200, 0, 180)
            PickerFrame.AnchorPoint = Vector2.new(0, 0.5) -- Set anchor point to center-left for easier positioning
            PickerFrame.BackgroundColor3 = colors.background
            PickerFrame.BorderSizePixel = 0
            PickerFrame.Active = true
            PickerFrame.Visible = false
            PickerFrame.ZIndex = 10
            PickerFrame.Parent = ScreenGui -- Parent to ScreenGui to be on top
            Instance.new("UIStroke", PickerFrame).Color = colors.border
            
            -- Make the picker frame draggable
            local pickerDragging, pickerDragInput, pickerDragStart, pickerStartPos
            local function isInputOnWidgets(input)
                local p = input.Position
                for _, w in ipairs({SV_Picker, HueBar, AlphaBar}) do
                    local wp, ws = w.AbsolutePosition, w.AbsoluteSize
                    if p.X >= wp.X and p.X <= wp.X + ws.X and p.Y >= wp.Y and p.Y <= wp.Y + ws.Y then
                        return true
                    end
                end
                return false
            end

            PickerFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not isInputOnWidgets(input) then
                    pickerDragging = true
                    pickerDragStart = input.Position
                    pickerStartPos = PickerFrame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            pickerDragging = false
                        end
                    end)
                end
            end)
            PickerFrame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    pickerDragInput = input
                end
            end)
            userInputService.InputChanged:Connect(function(input)
                if input == pickerDragInput and pickerDragging then
                    local delta = input.Position - pickerDragStart
                    PickerFrame.Position = UDim2.new(pickerStartPos.X.Scale, pickerStartPos.X.Offset + delta.X, pickerStartPos.Y.Scale, pickerStartPos.Y.Offset + delta.Y)
                end
            end)


            local SV_Picker = Instance.new("ImageLabel")
            SV_Picker.Name = "SaturationValuePicker"
            SV_Picker.Size = UDim2.new(0, 150, 0, 100)
            SV_Picker.Position = UDim2.new(0, 10, 0, 10)
            SV_Picker.Image = "rbxassetid://130624743341203" -- Saturation gradient
            SV_Picker.BackgroundTransparency = 1
            SV_Picker.Active = true
            SV_Picker.Parent = PickerFrame

            local SV_ValueOverlay = Instance.new("ImageLabel")
            SV_ValueOverlay.Name = "ValueOverlay"
            SV_ValueOverlay.Size = UDim2.new(1, 0, 1, 0)
            SV_ValueOverlay.Image = "rbxassetid://96192970265863" -- Value gradient
            SV_ValueOverlay.BackgroundTransparency = 1
            SV_ValueOverlay.Parent = SV_Picker

            local SV_Cursor = Instance.new("Frame")
            SV_Cursor.Name = "SVCursor"
            SV_Cursor.Size = UDim2.new(0, 8, 0, 8)
            SV_Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            SV_Cursor.BackgroundColor3 = Color3.new(1, 1, 1)
            SV_Cursor.BorderSizePixel = 0
            SV_Cursor.Parent = SV_Picker
            Instance.new("UICorner", SV_Cursor).CornerRadius = UDim.new(1, 0)
            Instance.new("UIStroke", SV_Cursor).Color = Color3.new(0, 0, 0)

            local HueBar = Instance.new("ImageLabel")
            HueBar.Name = "HueBar"
            HueBar.Size = UDim2.new(0, 20, 0, 100)
            HueBar.Position = UDim2.new(0, 170, 0, 10)
            HueBar.Image = "rbxassetid://133334110106525" -- Hue gradient
            HueBar.BackgroundTransparency = 1
            HueBar.Active = true
            HueBar.Parent = PickerFrame

            local Hue_Cursor = Instance.new("Frame")
            Hue_Cursor.Name = "HueCursor"
            Hue_Cursor.Size = UDim2.new(1, 4, 0, 2)
            Hue_Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            Hue_Cursor.BackgroundColor3 = Color3.new(1, 1, 1)
            Hue_Cursor.BorderSizePixel = 0
            Hue_Cursor.Parent = HueBar
            Instance.new("UIStroke", Hue_Cursor).Color = Color3.new(0, 0, 0)

            local AlphaBar = Instance.new("Frame")
            AlphaBar.Name = "AlphaBar"
            AlphaBar.Size = UDim2.new(1, -20, 0, 20)
            AlphaBar.Position = UDim2.new(0, 10, 0, 140)
            AlphaBar.BackgroundColor3 = Color3.new(1, 1, 1) -- Will be covered by gradient
            AlphaBar.BorderSizePixel = 0
            AlphaBar.Active = true
            AlphaBar.Parent = PickerFrame
            Instance.new("UIStroke", AlphaBar).Color = colors.border

            local AlphaCheckers = Instance.new("ImageLabel")
            AlphaCheckers.Name = "AlphaCheckers"
            AlphaCheckers.Size = UDim2.new(1, 0, 1, 0)
            AlphaCheckers.Image = "rbxassetid://18274452449" -- Checkerboard pattern
            AlphaCheckers.ScaleType = Enum.ScaleType.Tile
            AlphaCheckers.TileSize = UDim2.new(0, 10, 0, 10)
            AlphaCheckers.BackgroundTransparency = 1
            AlphaCheckers.Parent = AlphaBar

            local AlphaGradient = Instance.new("UIGradient")
            AlphaGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)) -- Will be updated
            AlphaGradient.Transparency = NumberSequence.new(0, 1)
            AlphaGradient.Parent = AlphaBar

            local Alpha_Cursor = Instance.new("Frame")
            Alpha_Cursor.Name = "AlphaCursor"
            Alpha_Cursor.Size = UDim2.new(0, 2, 1, 4)
            Alpha_Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            Alpha_Cursor.BackgroundColor3 = Color3.new(1, 1, 1)
            Alpha_Cursor.BorderSizePixel = 0
            Alpha_Cursor.Parent = AlphaBar
            Instance.new("UIStroke", Alpha_Cursor).Color = Color3.new(0, 0, 0)

            local function updateColorDisplay()
                local currentColor = Color3.fromHSV(hue, sat, val)
                ColorPreview.BackgroundColor3 = currentColor
                SV_Picker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                AlphaGradient.Color = ColorSequence.new(currentColor, currentColor)
                if callback then
                    callback(currentColor, alpha)
                end
            end

            local function updateSV(input)
                local x = math.clamp((input.Position.X - SV_Picker.AbsolutePosition.X) / SV_Picker.AbsoluteSize.X, 0, 1)
                local y = math.clamp((input.Position.Y - SV_Picker.AbsolutePosition.Y) / SV_Picker.AbsoluteSize.Y, 0, 1)
                sat = x
                val = 1 - y
                tweenService:Create(SV_Cursor, TweenInfo.new(0.05), {Position = UDim2.new(x, 0, y, 0)}):Play()
                updateColorDisplay()
            end

            local function updateHue(input)
                local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                hue = y
                tweenService:Create(Hue_Cursor, TweenInfo.new(0.05), {Position = UDim2.new(0.5, 0, y, 0)}):Play()
                updateColorDisplay()
            end

            local function updateAlpha(input)
                local x = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
                alpha = x
                tweenService:Create(Alpha_Cursor, TweenInfo.new(0.05), {Position = UDim2.new(x, 0, 0.5, 0)}):Play()
                ColorPreview.BackgroundTransparency = 1 - alpha
                if callback then
                    callback(Color3.fromHSV(hue, sat, val), alpha)
                end
            end

            local svDragging = false
            SV_Picker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = true
                    updateSV(input)
                end
            end)
            SV_Picker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    svDragging = false
                end
            end)

            local hueDragging = false
            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = true
                    updateHue(input)
                end
            end)
            HueBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                end
            end)

            local alphaDragging = false
            AlphaBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    alphaDragging = true
                    updateAlpha(input)
                end
            end)
            AlphaBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    alphaDragging = false
                end
            end)

            userInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if svDragging then updateSV(input) end
                    if hueDragging then updateHue(input) end
                    if alphaDragging then updateAlpha(input) end
                end
            end)

            ColorPickerBtn.MouseButton1Click:Connect(function()
                local isVisible = not PickerFrame.Visible
                PickerFrame.Visible = isVisible
                if isVisible then
                    PickerFrame.Position = UDim2.new(0, ColorPickerBtn.AbsolutePosition.X + ColorPickerBtn.AbsoluteSize.X + 5, 0, ColorPickerBtn.AbsolutePosition.Y + ColorPickerBtn.AbsoluteSize.Y / 2)
                    tweenService:Create(ColorPickerBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.secondary}):Play()
                else
                    tweenService:Create(ColorPickerBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.background}):Play()
                end
            end)

            -- Initial setup
            SV_Cursor.Position = UDim2.new(sat, 0, 1 - val, 0)
            Hue_Cursor.Position = UDim2.new(0.5, 0, hue, 0) -- Initial position is fine without tween
            Alpha_Cursor.Position = UDim2.new(alpha, 0, 0.5, 0)
            ColorPreview.BackgroundTransparency = 1 - alpha
            updateColorDisplay()
            
            -- Click-outside-to-close logic
            Library:SafeConnect(userInputService.InputBegan, function(input, gameProcessedEvent)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessedEvent then
                    local mousePos = input.Position
                    local isClickOnPicker = mousePos.X >= PickerFrame.AbsolutePosition.X and mousePos.X <= PickerFrame.AbsolutePosition.X + PickerFrame.AbsoluteSize.X and
                                            mousePos.Y >= PickerFrame.AbsolutePosition.Y and mousePos.Y <= PickerFrame.AbsolutePosition.Y + PickerFrame.AbsoluteSize.Y
                    local isClickOnButton = mousePos.X >= ColorPickerBtn.AbsolutePosition.X and mousePos.X <= ColorPickerBtn.AbsolutePosition.X + ColorPickerBtn.AbsoluteSize.X and
                                            mousePos.Y >= ColorPickerBtn.AbsolutePosition.Y and mousePos.Y <= ColorPickerBtn.AbsolutePosition.Y + ColorPickerBtn.AbsoluteSize.Y

                    if PickerFrame.Visible and not isClickOnPicker and not isClickOnButton then
                        PickerFrame.Visible = false
                        tweenService:Create(ColorPickerBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.background}):Play()
                    end
                end
            end, "ColorPickerClickOutside_" .. text)

            return ColorPickerBtn
        end

        return elements
    end

    return tabs
end
return Library
