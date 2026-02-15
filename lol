local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then return end

local Window = Rayfield:CreateWindow({
   Name = "UNSTOPPABLE | V2.69 🎯", -- Updated Versioning
   LoadingTitle = "🎯 UNSTOPPABLE V2.69",
   LoadingSubtitle = "By AYM",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- // SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // STATE VARIABLES //
local aimOn, smooth, fovSize, fovCircle = false, 1, 100, false
local aimPart = "HumanoidRootPart" 
local aimKey = Enum.UserInputType.MouseButton2 
local isHolding = false

local espOn, espBox, espName, espHp = false, false, false, false
local skellyOn, chamOn = false, false
local walkSpeed, speedActive, spinOn = 16, false, false
local xrayOn = false

local PlayerData = {}

-- // BONE MAPS //
local R15_Bones = {
    {"UpperTorso", "Head"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
}
local R6_Bones = {
    {"Torso", "Head"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

-- // FOV //
local fovDraw = Drawing.new("Circle")
fovDraw.Thickness, fovDraw.NumSides, fovDraw.Color = 1, 60, Color3.new(1,1,1)

-- // INPUTS //
UserInputService.InputBegan:Connect(function(i) 
    if i.UserInputType == aimKey or i.KeyCode == aimKey then isHolding = true end 
end)
UserInputService.InputEnded:Connect(function(i) 
    if i.UserInputType == aimKey or i.KeyCode == aimKey then isHolding = false end 
end)

-- // TARGETING //
local function getTarget()
    local target, shortestDist = nil, fovSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild(aimPart) or v.Character:FindFirstChild("Head")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mag < shortestDist then shortestDist, target = mag, v end
                end
            end
        end
    end
    return target
end

-- // VISUALS CONSTRUCTOR //
local function createVisuals(plr)
    if PlayerData[plr] then return end
    local d = { Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Bones = {} }
    d.Box.Thickness = 1
    d.Name.Size, d.Name.Center, d.Name.Outline = 16, true, true
    d.Health.Size, d.Health.Center, d.Health.Outline = 14, true, true
    for i = 1, 15 do local l = Drawing.new("Line") l.Thickness = 1 table.insert(d.Bones, l) end
    PlayerData[plr] = d
end
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then createVisuals(p) end end
Players.PlayerAdded:Connect(createVisuals)

-- // TABS //
local TabAim = Window:CreateTab("Aimbot 🎯")
local TabVis = Window:CreateTab("Visuals 👁️")
local TabWorld = Window:CreateTab("World 🌎")
local TabPlr = Window:CreateTab("Player ⚡")
local TabInfo = Window:CreateTab("Info 👑")

-- INFO SECTION
TabInfo:CreateSection("Who's the Owner? 👑")
TabInfo:CreateParagraph({Title = "Developer", Content = "UNSTOPPABLE V2.69 - Authorized Build by AYM."})
TabInfo:CreateButton({
   Name = "Copy Credits",
   Callback = function()
       setclipboard("UNSTOPPABLE V2.69 🎯 | Made by AYM")
       Rayfield:Notify({Title = "System", Content = "V2.69 Credits Copied!", Duration = 3})
   end,
})

-- AIMBOT SECTION
TabAim:CreateSection("Targeting 🎯")
TabAim:CreateToggle({Name = "Enable Aimbot System", CurrentValue = false, Callback = function(v) aimOn = v end})
TabAim:CreateDropdown({Name = "Target Bone 🦴", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, CurrentOption = {"HumanoidRootPart"}, Callback = function(opt) aimPart = opt[1] end})
TabAim:CreateKeybind({Name = "Aim Key", CurrentKeybind = "MouseButton2", Callback = function(Key) aimKey = Key end})
TabAim:CreateSlider({Name = "FOV Size", Range = {10, 800}, Increment = 1, CurrentValue = 100, Callback = function(v) fovSize = v end})
TabAim:CreateToggle({Name = "Show FOV Circle", CurrentValue = false, Callback = function(v) fovCircle = v end})

-- VISUALS SECTION
TabVis:CreateSection("ESP Settings 👁️")
TabVis:CreateToggle({Name = "Enable ESP Master", CurrentValue = false, Callback = function(v) espOn = v end})
TabVis:CreateToggle({Name = "Boxes 📦", CurrentValue = false, Callback = function(v) espBox = v end})
TabVis:CreateToggle({Name = "Names (White) 🏷️", CurrentValue = false, Callback = function(v) espName = v end})
TabVis:CreateToggle({Name = "Health (Green) 💚", CurrentValue = false, Callback = function(v) espHp = v end})
TabVis:CreateToggle({Name = "Skeleton 🦴", CurrentValue = false, Callback = function(v) skellyOn = v end})
TabVis:CreateToggle({Name = "Chams ✨", CurrentValue = false, Callback = function(v) chamOn = v end})

-- WORLD SECTION
TabWorld:CreateSection("Environment 🌎")
TabWorld:CreateToggle({Name = "Xray Mode 💠", CurrentValue = false, Callback = function(v) xrayOn = v for _, p in pairs(workspace:GetDescendants()) do if p:IsA("BasePart") and not p:IsDescendantOf(LocalPlayer.Character) then p.Transparency = v and 0.5 or 0 end end end})
TabWorld:CreateToggle({Name = "Night Mode 🌙", CurrentValue = false, Callback = function(v) Lighting.ClockTime = v and 0 or 12 end})

-- PLAYER SECTION
TabPlr:CreateSection("Movement ⚡")
TabPlr:CreateToggle({Name = "Enable Speed Hack", CurrentValue = false, Callback = function(v) speedActive = v end})
TabPlr:CreateSlider({Name = "Speed Value", Range = {16, 300}, Increment = 1, CurrentValue = 16, Callback = function(v) walkSpeed = v end})
TabPlr:CreateToggle({Name = "SpinBot 🔄", CurrentValue = false, Callback = function(v) spinOn = v end})

-- // MAIN LOOP //
RunService.RenderStepped:Connect(function()
    fovDraw.Visible, fovDraw.Radius, fovDraw.Position = fovCircle, fovSize, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedActive and walkSpeed or 16
        if spinOn then LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(25), 0) end
    end

    if aimOn and isHolding then
        local t = getTarget()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, (t.Character[aimPart] or t.Character.Head).Position), 0.2) end
    end

    for plr, data in pairs(PlayerData) do
        local char, hum, root = plr.Character, (plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")), (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart"))
        local isVisible = false
        if espOn and char and hum and root and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                isVisible = true
                local boxW, boxH = 2200/pos.Z, 3500/pos.Z
                data.Box.Visible, data.Box.Size, data.Box.Position, data.Box.Color = espBox, Vector2.new(boxW, boxH), Vector2.new(pos.X - boxW/2, pos.Y - boxH/2), Color3.new(1,0,0)
                data.Name.Visible, data.Name.Text, data.Name.Position, data.Name.Color = espName, plr.Name, Vector2.new(pos.X, pos.Y - (boxH/2) - 18), Color3.new(1,1,1)
                data.Health.Visible, data.Health.Text, data.Health.Position, data.Health.Color = espHp, math.floor(hum.Health).." HP", Vector2.new(pos.X, pos.Y + (boxH/2) + 5), Color3.fromRGB(0,255,100)
                
                local bones = (hum.RigType == Enum.HumanoidRigType.R15) and R15_Bones or R6_Bones
                for i, bS in ipairs(bones) do
                    local p1, p2, line = char:FindFirstChild(bS[1]), char:FindFirstChild(bS[2]), data.Bones[i]
                    if skellyOn and p1 and p2 then
                        local b1, o1 = Camera:WorldToViewportPoint(p1.Position) local b2, o2 = Camera:WorldToViewportPoint(p2.Position)
                        line.Visible, line.From, line.To, line.Color = o1 and o2, Vector2.new(b1.X, b1.Y), Vector2.new(b2.X, b2.Y), Color3.new(1,0,0)
                    else line.Visible = false end
                end
            end
        end
        if not isVisible then data.Box.Visible, data.Name.Visible, data.Health.Visible = false, false, false for _, l in pairs(data.Bones) do l.Visible = false end end
        if char then
            local h = char:FindFirstChildOfClass("Highlight")
            if chamOn and hum and hum.Health > 0 then
                if not h then h = Instance.new("Highlight", char) end
                h.Enabled, h.FillColor = true, Color3.new(1,0,0)
            elseif h then h.Enabled = false end
        end
    end
end)
