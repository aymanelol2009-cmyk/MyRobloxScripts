--[[
    WAR AIM - V19.8 (KEY SYSTEM INTEGRATED)
    Developed by: Aym the Developer
    Key System: V1.0
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// CONFIGURATION
local CORRECT_KEY = "WA-v19x8_99_QX-0012-Z" -- Change this to your desired key
local KEY_LINK = "https://work.ink/2hgY/key"   -- Your discord or key link

--// KEY SYSTEM UI
local KeyGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local KeyMain = Instance.new("Frame", KeyGui)
KeyMain.Size = UDim2.new(0, 300, 0, 180)
KeyMain.Position = UDim2.new(0.5, -150, 0.5, -90)
KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
KeyMain.BorderSizePixel = 0
Instance.new("UICorner", KeyMain)

local KeyGlow = Instance.new("Frame", KeyMain)
KeyGlow.ZIndex = 0
KeyGlow.Position = UDim2.new(0, -1, 0, -1)
KeyGlow.Size = UDim2.new(1, 2, 1, 2)
KeyGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", KeyGlow)

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "AUTHENTICATION"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 240, 0, 35)
KeyInput.Position = UDim2.new(0.5, -120, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 12
Instance.new("UICorner", KeyInput)

local SubmitBtn = Instance.new("TextButton", KeyMain)
SubmitBtn.Size = UDim2.new(0, 115, 0, 35)
SubmitBtn.Position = UDim2.new(0.5, -120, 0.7, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SubmitBtn.Text = "CHECK KEY"
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 12
Instance.new("UICorner", SubmitBtn)

local GetKeyBtn = Instance.new("TextButton", KeyMain)
GetKeyBtn.Size = UDim2.new(0, 115, 0, 35)
GetKeyBtn.Position = UDim2.new(0.5, 5, 0.7, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
GetKeyBtn.Text = "COPY LINK"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 12
Instance.new("UICorner", GetKeyBtn)

--// NOTIFICATION SYSTEM
local function Notify(txt)
    SubmitBtn.Text = txt
    task.wait(2)
    SubmitBtn.Text = "CHECK KEY"
end

--// MAIN SCRIPT WRAPPER
local function StartScript()
    -- ANIMATE UI OUT
    TweenService:Create(KeyMain, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(KeyGlow, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    KeyGui:Destroy()

    --// PASTE ORIGINAL CODE BELOW
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local Settings = {
        Aimbot = false, FOV = 150,
        Box = false, Health = false, Tracers = false, Skeleton = false,
        Fly = false, NoClip = false, FlySpeed = 75,
        EnableSpeed = false, SpeedHack = 16,
        MainColor = Color3.fromRGB(255, 0, 0)
    }

    local ESPData = {}
    local TogglesUI = {}
    local IsMenuOpen = true

    --// FOV DRAWING OBJECT
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 60
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Settings.MainColor

    --// ESP ENGINE
    local function CreateESP(p)
        if ESPData[p] then return end
        ESPData[p] = {
            Box = Drawing.new("Square"),
            Health = Drawing.new("Text"),
            Tracer = Drawing.new("Line"),
            Skeleton = {
                Spine = Drawing.new("Line"),
                LeftArm = Drawing.new("Line"),
                RightArm = Drawing.new("Line"),
                LeftLeg = Drawing.new("Line"),
                RightLeg = Drawing.new("Line")
            }
        }
        local d = ESPData[p]
        d.Box.Thickness = 1.5; d.Health.Size = 14; d.Health.Center = true; d.Health.Outline = true; d.Tracer.Thickness = 1
        for _, line in pairs(d.Skeleton) do line.Thickness = 1.5; line.Visible = false end
    end

    --// UI SETUP
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui); ScreenGui.ResetOnSpawn = false
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 420, 0, 320); Main.Position = UDim2.new(0.5, -210, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Main.BackgroundTransparency = 0.15; Main.Active = true; Main.Draggable = true; Main.ClipsDescendants = false; Instance.new("UICorner", Main)
    local Glow = Instance.new("Frame", Main); Glow.ZIndex = 0; Glow.Position = UDim2.new(0,-1,0,-1); Glow.Size = UDim2.new(1,2,1,2); Glow.BackgroundColor3 = Settings.MainColor; Instance.new("UICorner", Glow)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 110, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Sidebar.BackgroundTransparency = 0.2; Instance.new("UICorner", Sidebar)
    local Title = Instance.new("TextLabel", Sidebar); Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "WAR AIM"; Title.TextColor3 = Settings.MainColor; Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1; Title.TextSize = 16

    local NavHolder = Instance.new("Frame", Sidebar); NavHolder.Size = UDim2.new(1, 0, 0, 150); NavHolder.Position = UDim2.new(0, 0, 0, 50); NavHolder.BackgroundTransparency = 1
    local NavList = Instance.new("UIListLayout", NavHolder); NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center; NavList.Padding = UDim.new(0, 5)

    -- PROFILE
    local ProfileFrame = Instance.new("Frame", Sidebar); ProfileFrame.Size = UDim2.new(1, 0, 0, 100); ProfileFrame.Position = UDim2.new(0, 0, 1, -105); ProfileFrame.BackgroundTransparency = 1
    local pImg = Instance.new("ImageLabel", ProfileFrame); pImg.Size = UDim2.new(0, 40, 0, 40); pImg.Position = UDim2.new(0.5, -20, 0, 5); pImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"; Instance.new("UICorner", pImg).CornerRadius = UDim.new(1, 0)
    local pName = Instance.new("TextLabel", ProfileFrame); pName.Size = UDim2.new(1, 0, 0, 15); pName.Position = UDim2.new(0, 0, 0, 50); pName.Text = LocalPlayer.DisplayName; pName.TextColor3 = Color3.new(1,1,1); pName.Font = Enum.Font.GothamBold; pName.TextSize = 9; pName.BackgroundTransparency = 1

    local Pages = Instance.new("Frame", Main); Pages.Position = UDim2.new(0, 120, 0, 10); Pages.Size = UDim2.new(1, -130, 1, -20); Pages.BackgroundTransparency = 1

    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame", Pages); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.Name = name; Page.ScrollBarImageColor3 = Settings.MainColor
        local List = Instance.new("UIListLayout", Page); List.Padding = UDim.new(0, 8)
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10) end)
        return Page
    end

    local CombatPage = CreatePage("Combat"); CombatPage.Visible = true
    local VisualPage = CreatePage("Visuals"); local InfoPage = CreatePage("Info")

    local function AddTab(name, page)
        local Btn = Instance.new("TextButton", NavHolder); Btn.Size = UDim2.new(0, 90, 0, 35); Btn.BackgroundTransparency = 0.9; Btn.BackgroundColor3 = Color3.new(1,1,1); Btn.Text = name; Btn.TextColor3 = Color3.new(0.8,0.8,0.8); Btn.Font = Enum.Font.Gotham; Btn.TextSize = 10; Instance.new("UICorner", Btn)
        Btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages:GetChildren()) do p.Visible = false end; page.Visible = true end)
    end
    AddTab("COMBAT", CombatPage); AddTab("VISUALS", VisualPage); AddTab("CREDITS", InfoPage)

    local function LoadIY()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end

    local function AddCreditBox(p, t, d, isButton)
        local F = Instance.new("Frame", p); F.Size = UDim2.new(1, -5, 0, 60); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", F)
        local T = Instance.new("TextLabel", F); T.Size = UDim2.new(1, 0, 0, 25); T.Position = UDim2.new(0, 10, 0, 5); T.BackgroundTransparency = 1; T.Text = t; T.TextColor3 = Settings.MainColor; T.Font = Enum.Font.GothamBold; T.TextSize = 12; T.TextXAlignment = Enum.TextXAlignment.Left
        local D = Instance.new("TextLabel", F); D.Size = UDim2.new(1, -20, 0, 25); D.Position = UDim2.new(0, 10, 0, 25); D.BackgroundTransparency = 1; D.Text = d; D.TextColor3 = Color3.new(0.8,0.8,0.8); D.Font = Enum.Font.Gotham; D.TextSize = 10; D.TextXAlignment = Enum.TextXAlignment.Left; D.TextWrapped = true
        if isButton then
            local B = Instance.new("TextButton", F); B.Size = UDim2.new(0, 80, 0, 20); B.Position = UDim2.new(1, -90, 0.5, -10); B.BackgroundColor3 = Settings.MainColor; B.Text = "RUN"; B.TextColor3 = Color3.new(1,1,1); B.Font = Enum.Font.GothamBold; B.TextSize = 10; Instance.new("UICorner", B)
            B.MouseButton1Click:Connect(LoadIY)
        end
    end

    AddCreditBox(InfoPage, "Lead Developer", "Developed by Aym the Developer")
    AddCreditBox(InfoPage, "Infinite Yield", "Run the universal admin command bar.", true)
    AddCreditBox(InfoPage, "Status", "V19.8 - Speed Hack Toggle Enabled")

    local function UpdateToggleUI(key) if TogglesUI[key] then TweenService:Create(TogglesUI[key], TweenInfo.new(0.2), {BackgroundColor3 = Settings[key] and Settings.MainColor or Color3.new(0.2, 0.2, 0.2)}):Play() end end
    local function AddToggle(parent, text, key)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, -5, 0, 38); B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Text = "  "..text; B.TextColor3 = Color3.new(1,1,1); B.TextXAlignment = Enum.TextXAlignment.Left; B.Font = Enum.Font.Gotham; B.TextSize = 11; Instance.new("UICorner", B)
        local Ind = Instance.new("Frame", B); Ind.Size = UDim2.new(0, 10, 0, 10); Ind.Position = UDim2.new(1, -25, 0.5, -5); Ind.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2); Instance.new("UICorner", Ind); TogglesUI[key] = Ind
        B.MouseButton1Click:Connect(function() Settings[key] = not Settings[key]; UpdateToggleUI(key) end)
    end
    local function AddSlider(parent, text, min, max, key)
        local SFrame = Instance.new("Frame", parent); SFrame.Size = UDim2.new(1, -5, 0, 55); SFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", SFrame)
        local Label = Instance.new("TextLabel", SFrame); Label.Size = UDim2.new(1, 0, 0, 30); Label.BackgroundTransparency = 1; Label.Text = "  "..text..": "..Settings[key]; Label.TextColor3 = Color3.new(1,1,1); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.Gotham; Label.TextSize = 11
        local Bar = Instance.new("Frame", SFrame); Bar.Size = UDim2.new(0, 220, 0, 4); Bar.Position = UDim2.new(0.5, -110, 0.75, 0); Bar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1); local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((Settings[key]-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Settings.MainColor
        Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then local move; move = RunService.RenderStepped:Connect(function() local relX = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1) local val = math.floor(min + (relX * (max - min))) Settings[key] = val; Label.Text = "  "..text..": "..val; Fill.Size = UDim2.new(relX, 0, 1, 0) end) UserInputService.InputEnded:Connect(function(endInp) if endInp.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end) end end)
    end

    AddToggle(CombatPage, "Enable Aimbot", "Aimbot")
    AddSlider(CombatPage, "FOV Radius", 50, 600, "FOV")
    AddToggle(CombatPage, "Enable Speed Hack", "EnableSpeed")
    AddSlider(CombatPage, "Walk Speed", 16, 250, "SpeedHack")

    AddToggle(VisualPage, "Box ESP", "Box")
    AddToggle(VisualPage, "Health ESP", "Health")
    AddToggle(VisualPage, "Tracer ESP", "Tracers")
    AddToggle(VisualPage, "Skeleton ESP", "Skeleton")
    AddToggle(VisualPage, "Flight (Q)", "Fly")
    AddToggle(VisualPage, "NoClip (N)", "NoClip")

    local function ToggleMenu()
        IsMenuOpen = not IsMenuOpen
        if IsMenuOpen then
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 320), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(Glow, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(Glow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.delay(0.3, function() if not IsMenuOpen then Main.Visible = false end end)
        end
    end

    --// CORE ENGINE
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Settings.Aimbot
        FOVCircle.Radius = Settings.FOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Color = Settings.MainColor

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            if Settings.EnableSpeed then char.Humanoid.WalkSpeed = Settings.SpeedHack else char.Humanoid.WalkSpeed = 16 end
            if Settings.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if Settings.Fly then
                local m = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
                char.HumanoidRootPart.Velocity = m * Settings.FlySpeed; char.Humanoid.PlatformStand = true
            else if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end end
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                CreateESP(p); local d = ESPData[p]; local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Head") and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
                    local rootPos, vis = Camera:WorldToViewportPoint(c.HumanoidRootPart.Position)
                    if vis then
                        local size = 3000 / rootPos.Z; local color = Settings.MainColor
                        d.Box.Visible = Settings.Box; d.Box.Size = Vector2.new(size, size * 1.5); d.Box.Position = Vector2.new(rootPos.X - size/2, rootPos.Y - (size*1.5)/2); d.Box.Color = color
                        d.Health.Visible = Settings.Health; d.Health.Text = math.floor(c.Humanoid.Health).." HP"; d.Health.Position = Vector2.new(rootPos.X, rootPos.Y + (size*0.75)+5); d.Health.Color = color
                        d.Tracer.Visible = Settings.Tracers; d.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); d.Tracer.To = Vector2.new(rootPos.X, rootPos.Y); d.Tracer.Color = color
                        if Settings.Skeleton then
                            local head = Camera:WorldToViewportPoint(c.Head.Position); local torso = Camera:WorldToViewportPoint(c.HumanoidRootPart.Position)
                            local lArm = c:FindFirstChild("LeftUpperArm") or c:FindFirstChild("Left Arm"); local rArm = c:FindFirstChild("RightUpperArm") or c:FindFirstChild("Right Arm")
                            local lLeg = c:FindFirstChild("LeftUpperLeg") or c:FindFirstChild("Left Leg"); local rLeg = c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg")
                            d.Skeleton.Spine.Visible = true; d.Skeleton.Spine.From = Vector2.new(head.X, head.Y); d.Skeleton.Spine.To = Vector2.new(torso.X, torso.Y); d.Skeleton.Spine.Color = color
                            if lArm then local p = Camera:WorldToViewportPoint(lArm.Position); d.Skeleton.LeftArm.Visible = true; d.Skeleton.LeftArm.From = Vector2.new(torso.X, torso.Y); d.Skeleton.LeftArm.To = Vector2.new(p.X, p.Y); d.Skeleton.LeftArm.Color = color else d.Skeleton.LeftArm.Visible = false end
                            if rArm then local p = Camera:WorldToViewportPoint(rArm.Position); d.Skeleton.RightArm.Visible = true; d.Skeleton.RightArm.From = Vector2.new(torso.X, torso.Y); d.Skeleton.RightArm.To = Vector2.new(p.X, p.Y); d.Skeleton.RightArm.Color = color else d.Skeleton.RightArm.Visible = false end
                            if lLeg then local p = Camera:WorldToViewportPoint(lLeg.Position); d.Skeleton.LeftLeg.Visible = true; d.Skeleton.LeftLeg.From = Vector2.new(torso.X, torso.Y); d.Skeleton.LeftLeg.To = Vector2.new(p.X, p.Y); d.Skeleton.LeftLeg.Color = color else d.Skeleton.LeftLeg.Visible = false end
                            if rLeg then local p = Camera:WorldToViewportPoint(rLeg.Position); d.Skeleton.RightLeg.Visible = true; d.Skeleton.RightLeg.From = Vector2.new(torso.X, torso.Y); d.Skeleton.RightLeg.To = Vector2.new(p.X, p.Y); d.Skeleton.RightLeg.Color = color else d.Skeleton.RightLeg.Visible = false end
                        else for _, l in pairs(d.Skeleton) do l.Visible = false end end
                    else d.Box.Visible = false; d.Health.Visible = false; d.Tracer.Visible = false; for _, l in pairs(d.Skeleton) do l.Visible = false end end
                else d.Box.Visible = false; d.Health.Visible = false; d.Tracer.Visible = false; for _, l in pairs(d.Skeleton) do l.Visible = false end end
            end
        end

        if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target, dist = nil, Settings.FOV
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if vis and mDist < dist then target = p.Character.Head; dist = mDist end
                end
            end
            if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
        end
    end)

    UserInputService.InputBegan:Connect(function(i, g)
        if not g then
            if i.KeyCode == Enum.KeyCode.RightShift then ToggleMenu()
            elseif i.KeyCode == Enum.KeyCode.Q then Settings.Fly = not Settings.Fly; UpdateToggleUI("Fly")
            elseif i.KeyCode == Enum.KeyCode.N then Settings.NoClip = not Settings.NoClip; UpdateToggleUI("NoClip") end
        end
    end)
end

--// KEY LOGIC
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        SubmitBtn.Text = "CORRECT!"
        task.wait(0.5)
        StartScript()
    else
        Notify("INVALID KEY")
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_LINK)
    Notify("LINK COPIED")
end)
