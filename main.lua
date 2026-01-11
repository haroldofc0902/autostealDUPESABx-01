--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
end)

--// STATES
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local autoTouch = false

local normalSpeed = 28
local fastSpeed = 35
local spawnCFrame = hrp.CFrame

--// SAVED POSITIONS
local savedFramePos = UDim2.fromScale(0.34,0.3)
local savedIconPos  = UDim2.fromScale(0.03,0.45)

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CatHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// CLICK SOUND
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--// MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32,0.45)
frame.Position = savedFramePos
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

--// TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)

--// BUTTON MAKER
local function makeButton(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.1)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

--// BUTTON ORDER
local tpBtn    = makeButton("TELEGUIADO", 0.12)
local speedBtn = makeButton("SPEED : OFF", 0.23)
local kickBtn  = makeButton("AUTO KICK : OFF", 0.34)
local closeBtn = makeButton("CLOSE", 0.45)
local espBtn   = makeButton("ESP : OFF", 0.57)
local xrayBtn  = makeButton("X-RAY : OFF", 0.68)

--// AUTO TOUCH (BOTTOM)
local autoTouchBtn = Instance.new("TextButton", frame)
autoTouchBtn.Size = UDim2.fromScale(0.9,0.08)
autoTouchBtn.Position = UDim2.fromScale(0.05,0.85)
autoTouchBtn.Text = "AUTO TOUCH : OFF"
autoTouchBtn.Font = Enum.Font.GothamBold
autoTouchBtn.TextScaled = true
autoTouchBtn.TextColor3 = Color3.fromRGB(150,200,255)
autoTouchBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
autoTouchBtn.BorderSizePixel = 0
Instance.new("UICorner", autoTouchBtn).CornerRadius = UDim.new(0,12)

--// TELEGUIADO
tpBtn.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.delay(2,function()
			player:Kick("Auto Kick")
		end)
	end
end)

--// SPEED
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

--// AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

--// ===== ESP (INCLUYE A TI) =====
local espObjects = {}

local function clearESP()
	for _,v in pairs(espObjects) do
		if v then v:Destroy() end
	end
	table.clear(espObjects)
end

local function createESP(plr, color)
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end

	local bb = Instance.new("BillboardGui")
	bb.Name = "ESP"
	bb.Adornee = plr.Character.Head
	bb.Size = UDim2.new(0,200,0,50)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.Parent = gui

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = plr.Name
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBlack
	txt.TextColor3 = color
	txt.TextStrokeTransparency = 0
	txt.TextStrokeColor3 = Color3.new(0,0,0)

	table.insert(espObjects, bb)
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"

	clearESP()

	if espOn then
		-- TU ESP (AZUL)
		createESP(player, Color3.fromRGB(0,170,255))
		-- OTROS (ROJO)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				createESP(plr, Color3.fromRGB(255,0,0))
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espOn then
		plr.CharacterAdded:Wait()
		createESP(plr, Color3.fromRGB(255,0,0))
	end
end)

--// X-RAY (PAREDES, NO SUELO)
xrayBtn.MouseButton1Click:Connect(function()
	click()
	xrayOn = not xrayOn
	xrayBtn.Text = xrayOn and "X-RAY : ON" or "X-RAY : OFF"

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "Baseplate" then
			if v.Position.Y > hrp.Position.Y - 3 then
				v.LocalTransparencyModifier = xrayOn and 0.6 or 0
			end
		end
	end
end)

--// AUTO TOUCH
autoTouchBtn.MouseButton1Click:Connect(function()
	click()
	autoTouch = not autoTouch
	autoTouchBtn.Text = autoTouch and "AUTO TOUCH : ON" or "AUTO TOUCH : OFF"
end)

RunService.Heartbeat:Connect(function()
	if autoTouch then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				v.HoldDuration = 0
			end
		end
	end
end)

--// CLOSE ANIMATION
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open = not open
	savedFramePos = frame.Position

	TweenService:Create(
		frame,
		TweenInfo.new(0.25,Enum.EasingStyle.Quad),
		{Size = open and UDim2.fromScale(0.32,0.45) or UDim2.fromScale(0,0)}
	):Play()

	task.delay(0.25,function()
		frame.Visible = open
	end)
end)

--// DRAG FRAME
local dragging, ds, sp
frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		ds = i.Position
		sp = frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - ds
		frame.Position = UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
		savedFramePos = frame.Position
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--// FLOATING ICON
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = savedIconPos
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

icon.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
	if open then frame.Size = UDim2.fromScale(0.32,0.45) end
end)

--// DRAG ICON
local d2, ds2, sp2
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		d2 = true
		ds2 = i.Position
		sp2 = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if d2 and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - ds2
		icon.Position = UDim2.new(sp2.X.Scale,sp2.X.Offset+d.X,sp2.Y.Scale,sp2.Y.Offset+d.Y)
		savedIconPos = icon.Position
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then d2 = false end
end)
