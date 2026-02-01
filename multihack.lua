--[[
    MERAKCHY V17 - RAW SCRIPT
    Features: Aimbot, ESP (Box/Health/Name), Fly, Rainbow UI
    Fix: No more ghost ESP when players leave
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Aimbot = false,
    WallCheck = false,
    Smoothing = 0.2,
    Prediction = 0.165,
    Skeleton = false, -- Skeletons can be heavy, usually kept off by default
    Box = false,
    Health = false,
    Names = false,
    Rainbow = false,
    Fly = false,
    FlySpeed = 70, 
    FOV = 150,
    MainColor = Color3.fromRGB(0, 255, 255),
    AimbotKey = Enum.UserInputType.MouseButton2
}

local ESPData = {}
local UIObjects = {}

--// CLEANUP SYSTEM (Prevents the "Ghost Bug")
local function RemoveESP(p)
    if ESPData[p] then
        for _, drawing in pairs(ESPData[p]) do
            drawing.Visible = false
            drawing:Remove()
        end
        ESPData[p] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

--// UI CREATION
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 480)
Main.Position = UDim2.new(0.5, -130, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
local Glow = Instance.new("Frame", Main); Glow.ZIndex = 0; Glow.Position = UDim2.new(0,-2,0,-2); Glow.Size = UDim2.new(1,4,1,4); Glow.BackgroundColor3 = Settings.MainColor; Instance.new("UICorner", Glow); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 45); Title.BackgroundTransparency = 1; Title.Text = "MERAKCHY // V17"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.TextSize = 18
local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, 0, 1, -55); Container.Position = UDim2.new(0, 0, 0, 50); Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0; Container.CanvasSize = UDim2.new(0, 0, 0, 450); local UIList = Instance.new("UIListLayout", Container); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIList.Padding = UDim.new(0, 8)

local function AddToggle(name, settingKey, callback)
    local TBtn = Instance.new("TextButton", Container); TBtn.Size = UDim2.new(0, 230, 0, 40); TBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30); TBtn.Text = name:upper(); TBtn.TextColor3 = Color3.fromRGB(180,180,180); TBtn.Font = Enum.Font.GothamMedium; TBtn.TextSize = 11; Instance.new("UICorner", TBtn)
    local Switch = Instance.new("Frame", TBtn); Switch.Size = UDim2.new(0, 30, 0, 16); Switch.Position = UDim2.new(1, -40, 0.5, -8); Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", Switch); Dot.Size = UDim2.new(0, 12, 0, 12); Dot.Position = UDim2.new(0, 2, 0.5, -6); Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local function update(state)
        local targetPos = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        local targetCol = state and Settings.MainColor or Color3.fromRGB(100, 100, 100)
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetCol}):Play()
    end
    TBtn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        update(Settings[settingKey])
        if callback then callback(Settings[settingKey]) end
    end)
    UIObjects[settingKey] = update
end

AddToggle("Aimbot", "Aimbot")
AddToggle("Box ESP", "Box")
AddToggle("Health ESP", "Health")
AddToggle("Fly Mode (Q)", "Fly")
AddToggle("Rainbow UI", "Rainbow")

--// ESP CREATION FUNCTION
local function CreateESP(p)
    ESPData[p] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text")
    }
    for _, v in pairs(ESPData[p]) do v.Visible = false; v.Thickness = 1.5 end
    ESPData[p].Name.Size = 14; ESPData[p].Name.Center = true; ESPData[p].Name.Outline = true
    ESPData[p].Health.Size = 14; ESPData[p].Health.Center = true; ESPData[p].Health.Outline = true
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.NumSides = 60; FOVCircle.Visible = false

--// MAIN LOOP
RunService.RenderStepped:Connect(function()
    local CurrentColor = Settings.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Settings.MainColor
    if Settings.Rainbow then Glow.BackgroundColor3 = CurrentColor; Title.TextColor3 = CurrentColor; FOVCircle.Color = CurrentColor end

    -- Aimbot FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.Aimbot

    -- Fly Logic
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        if Settings.Fly then
            hum.PlatformStand = true
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            root.Velocity = dir * Settings.FlySpeed
        else
            if hum.PlatformStand then hum.PlatformStand = false end
        end
    end

    -- ESP Rendering
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESPData[p] then CreateESP(p) end
            local d = ESPData[p]
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
                local rPos, vis = Camera:WorldToViewportPoint(c.HumanoidRootPart.Position)
                local size = 3000 / rPos.Z

                d.Box.Visible = Settings.Box and vis
                if d.Box.Visible then
                    d.Box.Size = Vector2.new(size, size * 1.5)
                    d.Box.Position = Vector2.new(rPos.X - size/2, rPos.Y - (size * 1.5)/2)
                    d.Box.Color = CurrentColor
                end

                d.Health.Visible = Settings.Health and vis
                if d.Health.Visible then
                    d.Health.Text = math.floor(c.Humanoid.Health) .. " HP"
                    d.Health.Position = Vector2.new(rPos.X, rPos.Y + (size * 0.75) + 5)
                    d.Health.Color = Color3.fromHSV(c.Humanoid.Health/300, 1, 1)
                end
            else
                for _, v in pairs(d) do v.Visible = false end
            end
        end
    end
end)

--// INPUT HANDLING
UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible
    elseif i.KeyCode == Enum.KeyCode.Q then 
        Settings.Fly = not Settings.Fly 
        if UIObjects["Fly"] then UIObjects["Fly"](Settings.Fly) end
    end
end)
