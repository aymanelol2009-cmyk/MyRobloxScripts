local Functions = {}

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local HitSounds = {
        ["Bell"] = "rbxassetid://137731492025967",
        ["Skeet"] = "rbxassetid://80461265049096",
        ["Neverlose"] = "rbxassetid://139268006913867",
        ["Metallic"] = "rbxassetid://140728903346385",
        ["Bubble"] = "rbxassetid://104824514322839"
    }

    function Functions:PlayHitSound()
        if not getgenv().HitSound then return end
        local Sound = Instance.new("Sound", game:GetService("SoundService"))
        Sound.SoundId = HitSounds[getgenv().SelectedHitSound or "Bell"]
        Sound.Volume = getgenv().HitSoundVolume or 4
        Sound:Play()
        Debris:AddItem(Sound, 2)
    end;

    local HitLogsTable = {}
    function Functions:UpdateHitLogs()
        local center = (Camera.ViewportSize / 2)
        local fontSize = getgenv().HitLogsSize or 14
        for i = 1, #HitLogsTable do
            HitLogsTable[i].Position = Vector2.new(center.X, (center.Y + 150) + (i * (fontSize + 4)))
        end
    end

    function Functions:CreateHitLog(hitpart, username)
        if not getgenv().HitLogsEnabled then return end
        task.spawn(function()
            local timestamp = os.date("%H:%M:%S")
            local hitlog = Drawing.new('Text')
            hitlog.Size = getgenv().HitLogsSize or 14
            hitlog.Font = getgenv().HitLogsFont or 3
            hitlog.Text = string.format("[%s] hit %s in %s", timestamp, username:lower(), hitpart:lower())
            hitlog.Visible = true
            hitlog.ZIndex = 3
            hitlog.Center = true
            hitlog.Color = getgenv().HitLogsColor or (getgenv().Library and getgenv().Library.Theme and getgenv().Library.Theme.Accent) or Color3.fromRGB(255, 255, 255)
            hitlog.Outline = true
            hitlog.OutlineColor = Color3.new(0, 0, 0)

            table.insert(HitLogsTable, hitlog)
            Functions:UpdateHitLogs()
            
            local lifetime = getgenv().HitLogsLifetime or 5
            task.wait(lifetime)
            
            -- Smooth fade out animation
            for i = 1, 10 do
                hitlog.Transparency = 1 - (i / 10)
                task.wait(0.02)
            end

            table.remove(HitLogsTable, table.find(HitLogsTable, hitlog))
            Functions:UpdateHitLogs()
            hitlog:Remove()
        end)
    end

    local CenterHitmarker = {
        L1 = Drawing.new("Line"), L2 = Drawing.new("Line"), L3 = Drawing.new("Line"), L4 = Drawing.new("Line")
    }
    for _, l in pairs(CenterHitmarker) do l.Visible = false; l.Thickness = 2 end

    function Functions:FlashCenterHitmarker()
        if not getgenv().CenterHitmarker then return end
        task.spawn(function()
            local Color = getgenv().HitmarkersColor or Color3.new(1,1,1)
            local Size = getgenv().HitmarkersSize or 7
            local Center = Camera.ViewportSize / 2
            
            for _, l in pairs(CenterHitmarker) do l.Color = Color; l.Visible = true end
            local Start = tick()
            while tick() - Start < 0.2 do
                local Alpha = 1 - ((tick() - Start) / 0.2)
                CenterHitmarker.L1.From, CenterHitmarker.L1.To = Center - Vector2.new(Size, Size), Center - Vector2.new(Size/2.5, Size/2.5)
                CenterHitmarker.L2.From, CenterHitmarker.L2.To = Center + Vector2.new(Size, -Size), Center + Vector2.new(Size/2.5, -Size/2.5)
                CenterHitmarker.L3.From, CenterHitmarker.L3.To = Center + Vector2.new(-Size, Size), Center + Vector2.new(-Size/2.5, Size/2.5)
                CenterHitmarker.L4.From, CenterHitmarker.L4.To = Center + Vector2.new(Size, Size), Center + Vector2.new(Size/2, Size/2)
                for _, l in pairs(CenterHitmarker) do l.Transparency = Alpha end
                task.wait()
            end
            for _, l in pairs(CenterHitmarker) do l.Visible = false end
        end)
    end

    function Functions:CreateHitMarker(HitPart, Pos)
        if not getgenv().HitMarkers or not HitPart then return end
        task.spawn(function()
            local Color = getgenv().HitmarkersColor or Color3.new(1, 1, 1)
            local Lifetime = getgenv().HitmarkersLifetime or 0.4
            local MaxSize = getgenv().HitmarkersSize or 7
            local Type = getgenv().HitmarkerType or "X"
            local Offset = HitPart.CFrame:PointToObjectSpace(Pos)
            local Drawings = {}
            
            if Type == "X" or Type == "Cross" then
                Drawings[1] = Drawing.new("Line")
                Drawings[2] = Drawing.new("Line")
                for _, d in ipairs(Drawings) do d.Thickness = 2; d.Color = Color end
            elseif Type == "Circle" then
                Drawings[1] = Drawing.new("Circle")
                Drawings[1].Thickness = 1; Drawings[1].Color = Color; Drawings[1].NumSides = 12
            end

            local Start = tick()
            while tick() - Start < Lifetime do
                local Elapsed = tick() - Start
                local Alpha = 1 - (Elapsed / Lifetime)
                local CurrentSize = math.clamp((Elapsed / 0.05) * MaxSize, 2, MaxSize)
                
                if HitPart and HitPart.Parent then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HitPart.CFrame:PointToWorldSpace(Offset))
                    if OnScreen then
                        local Pos2D = Vector2.new(ScreenPos.X, ScreenPos.Y)
                        if Type == "X" then
                            Drawings[1].Visible, Drawings[2].Visible = true, true
                            Drawings[1].From, Drawings[1].To = Pos2D - Vector2.new(CurrentSize, CurrentSize), Pos2D + Vector2.new(CurrentSize, CurrentSize)
                            Drawings[2].From, Drawings[2].To = Pos2D + Vector2.new(CurrentSize, -CurrentSize), Pos2D - Vector2.new(CurrentSize, -CurrentSize)
                        elseif Type == "Cross" then
                            Drawings[1].Visible, Drawings[2].Visible = true, true
                            Drawings[1].From, Drawings[1].To = Pos2D - Vector2.new(CurrentSize, 0), Pos2D + Vector2.new(CurrentSize, 0)
                            Drawings[2].From, Drawings[2].To = Pos2D - Vector2.new(0, CurrentSize), Pos2D + Vector2.new(0, CurrentSize)
                        elseif Type == "Circle" then
                            Drawings[1].Visible = true
                            Drawings[1].Position = Pos2D
                            Drawings[1].Radius = CurrentSize
                        end
                        for _, d in ipairs(Drawings) do d.Transparency = Alpha end
                    else for _, d in ipairs(Drawings) do d.Visible = false end end
                else break end
                task.wait()
            end
            for _, d in ipairs(Drawings) do d:Remove() end
        end)
    end;

    function Functions:CreateTracer(Origin, EndPos)
        local Color = getgenv().TracerColor or Color3.new(1, 1, 1)
        local Lifetime = getgenv().BulletTracersLifetime or 0.3
        local TravelTime = getgenv().BulletTracersTravelTime or 0.05
        local Thickness = getgenv().TracerThickness or 0.05
        local Design = getgenv().TracerDesign or "Default"

        -- Impact Flash (Pre-declared)
        local Impact = Instance.new("Part", workspace)
        Impact.Shape, Impact.Anchored, Impact.CanCollide = Enum.PartType.Ball, true, false
        Impact.Size, Impact.Position = Vector3.new(0.1, 0.1, 0.1), EndPos
        Impact.Material, Impact.Color = Enum.Material.Neon, Color
        Impact.Transparency = 1

        if Design == "Default" then
            local Core = Instance.new("Part", workspace)
            Core.Name = "InariTracerCore"
            Core.Anchored, Core.CanCollide, Core.CanQuery, Core.CastShadow = true, false, false, false
            Core.Material = Enum.Material.Neon
            Core.Color = Color3.new(2, 2, 2)
            Core.Size = Vector3.new(Thickness, Thickness, 0)
            Core.CFrame = CFrame.new(Origin, EndPos)

            local Glow = Core:Clone()
            Glow.Name = "InariTracerGlow"; Glow.Parent = workspace
            Glow.Color = Color
            Glow.Size = Vector3.new(Thickness * 3.75, Thickness * 3.75, 0)
            Glow.Transparency = 0.5

            local TargetSize = (Origin - EndPos).Magnitude
            TweenService:Create(Core, TweenInfo.new(TravelTime), {Size = Vector3.new(Thickness, Thickness, TargetSize), CFrame = CFrame.new(Origin:Lerp(EndPos, 0.5), EndPos)}):Play()
            TweenService:Create(Glow, TweenInfo.new(TravelTime), {Size = Vector3.new(Thickness * 3.75, Thickness * 3.75, TargetSize), CFrame = CFrame.new(Origin:Lerp(EndPos, 0.5), EndPos)}):Play()

            task.delay(TravelTime, function()
                TweenService:Create(Core, TweenInfo.new(Lifetime), {Transparency = 1}):Play()
                TweenService:Create(Glow, TweenInfo.new(Lifetime), {Transparency = 1}):Play()
                Impact.Transparency = 0
                TweenService:Create(Impact, TweenInfo.new(Lifetime), {Transparency = 1, Size = Vector3.new(1.5, 1.5, 1.5)}):Play()
            end)
            Debris:AddItem(Core, Lifetime + TravelTime); Debris:AddItem(Glow, Lifetime + TravelTime)

        elseif Design == "Lightning" then
            local Points = {Origin}
            local Segments = 5
            local Distance = (Origin - EndPos).Magnitude
            local Direction = (EndPos - Origin).Unit
            
            for i = 1, Segments - 1 do
                local BasePos = Origin + (Direction * (Distance / Segments) * i)
                local Offset = Vector3.new(math.random(-5, 5)/10, math.random(-5, 5)/10, math.random(-5, 5)/10)
                table.insert(Points, BasePos + Offset)
            end
            table.insert(Points, EndPos)

            for i = 1, #Points - 1 do
                local P1, P2 = Points[i], Points[i+1]
                local Segment = Instance.new("Part", workspace)
                Segment.Anchored, Segment.CanCollide, Segment.CanQuery = true, false, false
                Segment.Material = Enum.Material.Neon
                Segment.Color = Color
                Segment.Size = Vector3.new(Thickness, Thickness, (P1 - P2).Magnitude)
                Segment.CFrame = CFrame.new(P1:Lerp(P2, 0.5), P2)
                
                TweenService:Create(Segment, TweenInfo.new(Lifetime), {Transparency = 1}):Play()
                Debris:AddItem(Segment, Lifetime)
            end
            Impact.Transparency = 0
            TweenService:Create(Impact, TweenInfo.new(Lifetime), {Transparency = 1, Size = Vector3.new(1.5, 1.5, 1.5)}):Play()

        elseif Design == "Beam" or Design == "Image" then
            local Attachment0 = Instance.new("Attachment", workspace.Terrain)
            local Attachment1 = Instance.new("Attachment", workspace.Terrain)
            Attachment0.WorldPosition = Origin
            Attachment1.WorldPosition = EndPos

            local Beam = Instance.new("Beam", workspace.Terrain)
            Beam.Attachment0 = Attachment0
            Beam.Attachment1 = Attachment1
            Beam.Color = ColorSequence.new(Color)
            Beam.Width0 = Thickness * 2
            Beam.Width1 = Thickness * 2
            Beam.LightEmission = 1
            Beam.LightInfluence = 0
            
            if Design == "Image" then
                Beam.Texture = getgenv().TracerTextureID or "rbxassetid://18837739"
                Beam.TextureMode = Enum.TextureMode.Wrap
                Beam.TextureSpeed = 2
                Beam.TextureLength = 2
                Beam.FaceCamera = true
                Beam.LightEmission = 0.8
            end

            task.spawn(function()
                local start = tick()
                while tick() - start < Lifetime do
                    local elapsed = tick() - start
                    local alpha = elapsed / Lifetime
                    pcall(function()
                        Beam.Transparency = NumberSequence.new(alpha)
                    end)
                    task.wait()
                end
                pcall(function()
                    Beam.Enabled = false
                end)
            end)
            Debris:AddItem(Beam, Lifetime + 0.1)
            Debris:AddItem(Attachment0, Lifetime + 0.1)
            Debris:AddItem(Attachment1, Lifetime + 0.1)
            
            Impact.Transparency = 0
            TweenService:Create(Impact, TweenInfo.new(Lifetime), {Transparency = 1, Size = Vector3.new(1.5, 1.5, 1.5)}):Play()
        end
        Debris:AddItem(Impact, Lifetime + TravelTime)
    end;

getgenv().CombatFunctions = Functions
return Functions
