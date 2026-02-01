local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Aimbot = false,
    WallCheck = true,
    Smoothing = 0.2,
    Prediction = 0.165,
    Skeleton = false,
    Box = false,
    Health = false,
    Names = false,
    Rainbow = false,
    Fly = false,
    NoClip = false,
    FlySpeed = 66, 
    FOV = 150,
    MainColor = Color3.fromRGB(0, 255, 255),
    AimbotKey = Enum.UserInputType.MouseButton2,
    Visible = true
}

local ESPData = {}

-- Drawing API Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Color = Settings.MainColor
FOVCircle.Filled = false

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 500)
Main.Position = UDim2.new(0.5, -125, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local CanvasGroup = Instance.new("CanvasGroup", Main)
CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
CanvasGroup.BackgroundTransparency = 1

local function ToggleUI(visible)
    local targetPos = visible and UDim2.new(0.5, -125, 0.5, -250) or UDim2.new(0.5, -125, 0.5, -200)
    local targetAlpha = visible and 0 or 1
    if visible then Main.Visible = true end
    local info = TweenInfo.new(0.4, Enum.EasingStyle.Quart)
    TweenService:Create(Main, info, {Position = targetPos}):Play()
    local fade = TweenService:Create(CanvasGroup, info, {GroupTransparency = targetAlpha})
    fade:Play()
    fade.Completed:Connect(function() if not visible then Main.Visible = false end end)
end

local function AddToggle(name, y, callback)
    local btn = Instance.new("TextButton", CanvasGroup)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 8, 0, 8)
    ind.Position = UDim2.new(1, -18, 0.5, -4)
    ind.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        TweenService:Create(ind, TweenInfo.new(0.3), {BackgroundColor3 = s and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)}):Play()
        callback(s)
    end)
end

-- Layout
AddToggle("Aimbot (Right Click)", 50, function(v) Settings.Aimbot = v end)
AddToggle("Wall Check", 95, function(v) Settings.WallCheck = v end)
AddToggle("Skeleton ESP", 140, function(v) Settings.Skeleton = v end)
AddToggle("Box ESP", 185, function(v) Settings.Box = v end)
AddToggle("Names ESP", 230, function(v) Settings.Names = v end)
AddToggle("Health ESP", 275, function(v) Settings.Health = v end)
AddToggle("Fly Mode (Q)", 320, function(v) Settings.Fly = v end)
AddToggle("NoClip", 365, function(v) Settings.NoClip = v end)
AddToggle("Rainbow Mode", 410, function(v) Settings.Rainbow = v end)

-- Input Handling
UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then Settings.Visible = not Settings.Visible ToggleUI(Settings.Visible) end
    if i.KeyCode == Enum.KeyCode.Q then Settings.Fly = not Settings.Fly end
end)

local function GetClosestTarget()
    local target, dist = nil, Settings.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mDist < dist then
                    if Settings.WallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, p.Character})
                        if hit == nil then target = p.Character.Head; dist = mDist end
                    else
                        target = p.Character.Head; dist = mDist
                    end
                end
            end
        end
    end
    return target
end

local function CreateESP(p)
    ESPData[p] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Line = Drawing.new("Line")}
    for _, v in pairs(ESPData[p]) do v.Visible = false if v.Size then v.Size = 14 v.Center = true v.Outline = true end end
end

Players.PlayerRemoving:Connect(function(p)
    if ESPData[p] then for _, v in pairs(ESPData[p]) do v:Remove() end ESPData[p] = nil end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    local Color = Settings.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Settings.MainColor
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.Visible and Settings.Aimbot
    FOVCircle.Color = Color

    local char = LocalPlayer.Character
    if char then
        if Settings.NoClip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        if Settings.Fly and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            root.Velocity = dir * Settings.FlySpeed
            char.Humanoid.PlatformStand = true
        elseif char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end

    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Settings.AimbotKey) then
        local target = GetClosestTarget()
        if target then
            local aimPos = target.Position + (target.Parent.HumanoidRootPart.Velocity * Settings.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), Settings.Smoothing)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESPData[p] then CreateESP(p) end
            local d, c = ESPData[p], p.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid.Health > 0 then
                local rPos, vis = Camera:WorldToViewportPoint(c.HumanoidRootPart.Position)
                local size = 3000 / rPos.Z
                
                d.Box.Visible = Settings.Box and vis
                if d.Box.Visible then
                    d.Box.Size = Vector2.new(size, size * 1.4)
                    d.Box.Position = Vector2.new(rPos.X - size/2, rPos.Y - (size * 1.4)/2)
                    d.Box.Color = Color
                end

                d.Name.Visible = Settings.Names and vis
                if d.Name.Visible then
                    d.Name.Position = Vector2.new(rPos.X, rPos.Y - (size * 1.4)/2 - 15)
                    d.Name.Text = p.DisplayName; d.Name.Color = Color3.new(1,1,1)
                end

                d.Health.Visible = Settings.Health and vis
                if d.Health.Visible then
                    d.Health.Position = Vector2.new(rPos.X, rPos.Y + (size * 1.4)/2 + 5)
                    d.Health.Text = math.floor(c.Humanoid.Health) .. " HP"
                    d.Health.Color = Color3.fromHSV(c.Humanoid.Health/300, 1, 1)
                end

                d.Line.Visible = Settings.Skeleton and vis
                if d.Line.Visible then
                    local hPos = Camera:WorldToViewportPoint(c.Head.Position)
                    d.Line.From = Vector2.new(hPos.X, hPos.Y); d.Line.To = Vector2.new(rPos.X, rPos.Y)
                    d.Line.Color = Color
                end
            else
                for _, v in pairs(d) do v.Visible = false end
            end
        end
    end
end)
