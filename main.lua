--------------------------------------------------
-- CAT HUB | LocalScript
--------------------------------------------------

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(c)
	char = c
end)

--------------------------------------------------
-- STATES
--------------------------------------------------
local espOn = false
local xrayOn = false
local autoGrabOn = false
local menuOpen = true

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CatHub"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32,0.6)
frame.Position = UDim2.fromScale(0.34,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Top Bar
local top = Instance.new("Frame", frame)
top.Size = UDim2.fromScale(1,0.12)
top.BackgroundColor3 = Color3.fromRGB(240,240,240)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(30,30,30)

-- Click Sound
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.8
local function click() clickSound:Play() end

--------------------------------------------------
-- MENU ANIMATION
--------------------------------------------------
local openPos = frame.Position
local closedPos = UDim2.fromScale(openPos.X.Scale,1.3)

local tweenIn = TweenService:Create(frame,
	TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
	{Position=openPos}
)

local tweenOut = TweenService:Create(frame,
	TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
	{Position=closedPos}
)

local function toggleMenu()
	click()
	menuOpen = not menuOpen
	if menuOpen then
		frame.Visible = true
		frame.Position = closedPos
		tweenIn:Play()
	else
		tweenOut:Play()
	end
end

--------------------------------------------------
-- ICONO FLOTANTE (CÍRCULO)
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.07,0.07)
icon.Position = UDim2.fromScale(0.05,0.5)
icon.Text = "🐱"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(40,40,40)
icon.TextColor3 = Color3.new(1,1,1)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)
icon.Draggable = true
icon.Active = true

icon.MouseButton1Click:Connect(toggleMenu)

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------
local function makeButton(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.1)
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

--------------------------------------------------
-- BUTTONS
--------------------------------------------------
local espBtn = makeButton("ESP (OFF)",0.16)
local xrayBtn = makeButton("X-RAY (OFF)",0.28)
local grabBtn = makeButton("AUTO GRAB (OFF)",0.40)
local closeBtn = makeButton("CLOSE",0.82)

closeBtn.MouseButton1Click:Connect(toggleMenu)

--------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------
local espObjects = {}

local function clearESP()
	for _,objs in pairs(espObjects) do
		for _,o in pairs(objs) do
			if o then o:Destroy() end
		end
	end
	espObjects = {}
end

local function addESP(plr)
	if plr == player or not plr.Character then return end
	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local h = Instance.new("Highlight", plr.Character)
	h.FillColor = Color3.fromRGB(255,0,0)
	h.OutlineColor = Color3.fromRGB(255,255,255)
	h.FillTransparency = 0.25
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	local bb = Instance.new("BillboardGui", plr.Character)
	bb.Adornee = hrp
	bb.AlwaysOnTop = true
	bb.MaxDistance = math.huge
	bb.Size = UDim2.fromScale(6,1)
	bb.StudsOffset = Vector3.new(0,3,0)

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.Text = plr.Name
	txt.TextColor3 = Color3.fromRGB(255,0,0)
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.GothamBold
	txt.TextScaled = true

	espObjects[plr] = {h,bb}
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP (ON)" or "ESP (OFF)"
	clearESP()
	if espOn then
		for _,p in pairs(Players:GetPlayers()) do
			addESP(p)
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if espOn then
			task.wait(1)
			addESP(p)
		end
	end)
end)

--------------------------------------------------
-- X-RAY REAL
--------------------------------------------------
local xrayData = {}

local function isBasePart(part)
	return part:IsA("BasePart")
		and part.Anchored
		and part.Size.Magnitude > 15
		and not part:IsDescendantOf(char)
end

local function setXray(state)
	for _,v in pairs(workspace:GetDescendants()) do
		if isBasePart(v) then
			if state then
				if not xrayData[v] then
					xrayData[v] = {v.Transparency,v.Material}
					v.Transparency = 0.7
					v.Material = Enum.Material.Glass
				end
			else
				if xrayData[v] then
					v.Transparency = xrayData[v][1]
					v.Material = xrayData[v][2]
				end
			end
		end
	end
	if not state then xrayData = {} end
end

xrayBtn.MouseButton1Click:Connect(function()
	click()
	xrayOn = not xrayOn
	xrayBtn.Text = xrayOn and "X-RAY (ON)" or "X-RAY (OFF)"
	setXray(xrayOn)
end)

--------------------------------------------------
-- AUTO GRAB (PROXIMITY PROMPT)
--------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not autoGrabOn then return end
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			if (v.Parent.Position - char.HumanoidRootPart.Position).Magnitude <= v.MaxActivationDistance then
				v:InputHoldBegin()
				task.wait(0.1)
				v:InputHoldEnd()
			end
		end
	end
end)

grabBtn.MouseButton1Click:Connect(function()
	click()
	autoGrabOn = not autoGrabOn
	grabBtn.Text = autoGrabOn and "AUTO GRAB (ON)" or "AUTO GRAB (OFF)"
end)
