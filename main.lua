--// CAT HUB - LocalScript (ULTRA COMPLETO)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local spawnCFrame = hrp.CFrame

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
	spawnCFrame = hrp.CFrame
end)

--------------------------------------------------
-- STATES
--------------------------------------------------
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local grabOn = false

local normalSpeed = 28
local fastSpeed = 35

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CatHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CLICK SOUND
--------------------------------------------------
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967" -- UI click
clickSound.Volume = 1

local function click()
	clickSound:Play()
end

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.34,0.55)
frame.Position = UDim2.fromScale(0.33,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

--------------------------------------------------
-- TITLE
--------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------
local function makeButton(text, sizeY, posY)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,sizeY)
	b.Position = UDim2.fromScale(0.05,posY)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

--------------------------------------------------
-- BUTTONS (ORDER)
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",0.08,0.12)
local speedBtn = makeButton("SPEED : OFF",0.08,0.21)
local kickBtn  = makeButton("AUTO KICK : OFF",0.08,0.30)

-- ESP + X-RAY
local espBtn = makeButton("ESP : OFF",0.08,0.39)
espBtn.Size = UDim2.fromScale(0.43,0.08)
espBtn.Position = UDim2.fromScale(0.05,0.39)

local xrayBtn = makeButton("X-RAY : OFF",0.08,0.39)
xrayBtn.Size = UDim2.fromScale(0.43,0.08)
xrayBtn.Position = UDim2.fromScale(0.52,0.39)

-- AUTO GRAB
local grabBtn = makeButton("AUTO GRAB : OFF",0.08,0.50)

--------------------------------------------------
-- TELEGUIADO
--------------------------------------------------
teleBtn.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.delay(2,function()
			player:Kick("Auto Kick Active")
		end)
	end
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

--------------------------------------------------
-- AUTO KICK
--------------------------------------------------
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

--------------------------------------------------
-- ESP (YOU INCLUDED)
--------------------------------------------------
local espObjects = {}

local function clearESP()
	for _,v in pairs(espObjects) do
		if v then v:Destroy() end
	end
	table.clear(espObjects)
end

local function createESP(plr,color)
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
	local bb = Instance.new("BillboardGui", gui)
	bb.Adornee = plr.Character.Head
	bb.Size = UDim2.new(0,220,0,40)
	bb.AlwaysOnTop = true

	local t = Instance.new("TextLabel", bb)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = plr.Name
	t.Font = Enum.Font.GothamBlack
	t.TextScaled = true
	t.TextColor3 = color
	t.TextStrokeTransparency = 0

	table.insert(espObjects, bb)
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
	clearESP()

	if espOn then
		createESP(player, Color3.fromRGB(0,170,255))
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= player then
				createESP(p, Color3.fromRGB(255,0,0))
			end
		end
	end
end)

--------------------------------------------------
-- X-RAY (NO FLOOR)
--------------------------------------------------
xrayBtn.MouseButton1Click:Connect(function()
	click()
	xrayOn = not xrayOn
	xrayBtn.Text = xrayOn and "X-RAY : ON" or "X-RAY : OFF"

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(char) then
			if not v.Name:lower():find("floor") then
				v.LocalTransparencyModifier = xrayOn and 0.6 or 0
			end
		end
	end
end)

--------------------------------------------------
-- AUTO GRAB (ROBAR / STEAL)
--------------------------------------------------
grabBtn.MouseButton1Click:Connect(function()
	click()
	grabOn = not grabOn
	grabBtn.Text = grabOn and "AUTO GRAB : ON" or "AUTO GRAB : OFF"
end)

RunService.Heartbeat:Connect(function()
	if grabOn then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				local t = string.lower(v.ActionText or "")
				if t:find("robar") or t:find("steal") then
					pcall(function()
						v.HoldDuration = 0
						v:InputHoldBegin()
					end)
				end
			end
		end
	end
end)

--------------------------------------------------
-- DRAG MENU
--------------------------------------------------
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,startPos.X.Offset+d.X,
			startPos.Y.Scale,startPos.Y.Offset+d.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)

--------------------------------------------------
-- ICONO CIRCULAR (DRAG + CLICK SOUND)
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.TextScaled = true
icon.Font = Enum.Font.GothamBlack
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.TextColor3 = Color3.new(1,1,1)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local open = true
icon.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
end)

-- DRAG ICON
local draggingI, dragStartI, startPosI
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingI = true
		dragStartI = i.Position
		startPosI = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingI and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - dragStartI
		icon.Position = UDim2.new(
			startPosI.X.Scale,startPosI.X.Offset+d.X,
			startPosI.Y.Scale,startPosI.Y.Offset+d.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	draggingI = false
end)
