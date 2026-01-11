-- DRAGON HUB (LocalScript)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Spawn
local spawnCFrame = hrp.CFrame
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
	spawnCFrame = hrp.CFrame
end)

-- Estados
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local menuOpen = true

local normalSpeed = 16
local fastSpeed = 35

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DragonHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.32,0.55)
frame.Position = UDim2.fromScale(0.34,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Top bar
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.fromScale(1,0.12)
topBar.BackgroundColor3 = Color3.fromRGB(240,240,240)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(30,30,30)

-- Sonido click
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.8
local function click() clickSound:Play() end

-- Animaciones
local openPos = frame.Position
local closedPos = UDim2.fromScale(openPos.X.Scale, 1.3)

local tweenIn = TweenService:Create(
	frame,
	TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Position = openPos}
)

local tweenOut = TweenService:Create(
	frame,
	TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
	{Position = closedPos}
)

-- FUNCIÓN ÚNICA PARA ABRIR / CERRAR
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

-- Botones
local function makeButton(text,y,w,x)
	local b = Instance.new("TextButton", frame)
	b.Size = w or UDim2.fromScale(0.9,0.11)
	b.Position = UDim2.fromScale(x or 0.05,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.fromRGB(230,230,230)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

local teleBtn  = makeButton("TP TO BASE",0.15)
local speedBtn = makeButton("SPEED (OFF)",0.28)
local kickBtn  = makeButton("AUTO KICK (OFF)",0.41)
local closeBtn = makeButton("CLOSE MENU",0.54)

local espBtn  = makeButton("ESP (OFF)",0.70,UDim2.fromScale(0.42,0.11),0.05)
local xrayBtn = makeButton("X-RAY (OFF)",0.70,UDim2.fromScale(0.42,0.11),0.53)

-- FUNCIONES

teleBtn.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.wait(2)
		player:Kick("Auto Kick Active")
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	speedBtn.Text = speedOn and "SPEED (ON)" or "SPEED (OFF)"
	speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(90,50,50) or Color3.fromRGB(40,40,40)
end)

kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK (ON)" or "AUTO KICK (OFF)"
	kickBtn.BackgroundColor3 = autoKick and Color3.fromRGB(90,50,50) or Color3.fromRGB(40,40,40)
end)

-- CLOSE MENU
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ICONO FLOTANTE
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.fromScale(0.08,0.08)
toggleBtn.Position = UDim2.fromScale(0.03,0.45)
toggleBtn.BackgroundColor3 = Color3.new(0,0,0)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

toggleBtn.MouseButton1Click:Connect(toggleMenu)
