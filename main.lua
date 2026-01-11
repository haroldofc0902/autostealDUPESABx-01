--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

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
local autoGrab = false

local normalSpeed = 28
local fastSpeed = 35
local spawnCFrame = hrp.CFrame

--// GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CatHub"
gui.ResetOnSpawn = false

--// CLICK SOUND
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--// MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36,0.52)
frame.Position = UDim2.fromScale(0.33,0.28)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

--// TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

--// BUTTON MAKERS
local function bigButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.11)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

local function halfButton(text, x, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.42,0.11)
	b.Position = UDim2.fromScale(x,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

--// BUTTON LAYOUT
local tpBtn    = bigButton("TELEGUIADO", 0.12)
local speedBtn = bigButton("SPEED : OFF", 0.25)
local kickBtn  = bigButton("AUTO KICK : OFF", 0.38)

local espBtn   = halfButton("ESP : OFF",   0.05, 0.53)
local xrayBtn  = halfButton("X-RAY : OFF", 0.53, 0.53)

local grabBtn  = bigButton("AUTO GRAB : OFF", 0.70)

--// TELEGUIADO
tpBtn.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.delay(2, function()
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

--// ESP (TÚ AZUL / OTROS ROJO)
local espObjects = {}

local function clearESP()
	for _,v in pairs(espObjects) do
		if v then v:Destroy() end
	end
	table.clear(espObjects)
end

local function createESP(plr, color)
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
	local bb = Instance.new("BillboardGui", gui)
	bb.Adornee = plr.Character.Head
	bb.Size = UDim2.new(0,220,0,55)
	bb.AlwaysOnTop = true
	bb.StudsOffset = Vector3.new(0,3,0)

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.Text = plr.Name
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBlack
	txt.TextColor3 = color
	txt.TextStrokeTransparency = 0

	table.insert(espObjects, bb)
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
	clearESP()

	if espOn then
		createESP(player, Color3.fromRGB(0,170,255))
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				createESP(plr, Color3.fromRGB(255,0,0))
			end
		end
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

--// AUTO GRAB (100% AUTOMÁTICO, SIN TOCAR NADA)
grabBtn.MouseButton1Click:Connect(function()
	click()
	autoGrab = not autoGrab
	grabBtn.Text = autoGrab and "AUTO GRAB : ON" or "AUTO GRAB : OFF"
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
	if not autoGrab then return end
	prompt.RequiresLineOfSight = false
	prompt.HoldDuration = 0

	task.wait(0.05)
	pcall(function()
		prompt:InputHoldBegin()
		task.wait(0.1)
		prompt:InputHoldEnd()
	end)
end)

--// DRAG MENU
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
		frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--// FLOATING ICON
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.04,0.45)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local open = true
icon.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
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
		icon.Position = UDim2.new(sp2.X.Scale, sp2.X.Offset+d.X, sp2.Y.Scale, sp2.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then d2 = false end
end)
