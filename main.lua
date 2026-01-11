-- DRAGON HUB (LocalScript)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Guardar spawn
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
local normalSpeed = 16
local fastSpeed = 35

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DragonHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.3,0.45)
frame.Position = UDim2.fromScale(0.35,0.28)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Barra superior
local topBar = Instance.new("Frame")
topBar.Parent = frame
topBar.Size = UDim2.fromScale(1,0.13)
topBar.BackgroundColor3 = Color3.fromRGB(240,240,240)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.fromScale(0.9,1)
title.Position = UDim2.fromScale(0.05,0)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.TextColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Sonido click
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967" -- click limpio
clickSound.Volume = 0.8
clickSound.Parent = gui

local function playClick()
	clickSound:Play()
end

-- Animaciones
local openPos = frame.Position
local closedPos = UDim2.fromScale(openPos.X.Scale, 1.2)

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

-- Función botones
local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.fromScale(0.9,0.13)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(230,230,230)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

-- Botones
local teleBtn  = makeButton("TP TO BASE",0.20)
local speedBtn = makeButton("SPEED (OFF)",0.36)
local kickBtn  = makeButton("AUTO KICK (OFF)",0.52)
local closeBtn = makeButton("CLOSE MENU",0.68)

-- Teleguiado
teleBtn.MouseButton1Click:Connect(function()
	playClick()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.wait(2)
		player:Kick("You Stole a Pet!")
	end
end)

-- Velocidad
speedBtn.MouseButton1Click:Connect(function()
	playClick()
	speedOn = not speedOn
	if speedOn then
		humanoid.WalkSpeed = fastSpeed
		speedBtn.Text = "SPEED (ON)"
		speedBtn.BackgroundColor3 = Color3.fromRGB(90,50,50)
	else
		humanoid.WalkSpeed = normalSpeed
		speedBtn.Text = "SPEED (OFF)"
		speedBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	end
end)

-- Auto Kick
kickBtn.MouseButton1Click:Connect(function()
	playClick()
	autoKick = not autoKick
	if autoKick then
		kickBtn.Text = "AUTO KICK (ON)"
		kickBtn.BackgroundColor3 = Color3.fromRGB(90,50,50)
	else
		kickBtn.Text = "AUTO KICK (OFF)"
		kickBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	end
end)

-- Cerrar menú (animado)
closeBtn.MouseButton1Click:Connect(function()
	playClick()
	tweenOut:Play()
end)

-- Botón flotante
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.fromScale(0.08,0.08)
toggleBtn.Position = UDim2.fromScale(0.03,0.45)
toggleBtn.BackgroundColor3 = Color3.new(0,0,0)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

toggleBtn.MouseButton1Click:Connect(function()
	playClick()
	frame.Visible = true
	frame.Position = closedPos
	tweenIn:Play()
end)

-- Drag menú
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
