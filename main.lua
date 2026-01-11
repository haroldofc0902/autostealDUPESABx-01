-- CAT HUB (LocalScript)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

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
local speedOn, autoKick, espOn, xrayOn = false, false, false, false
local menuOpen = true
local normalSpeed, fastSpeed = 16, 35

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CatHub"
gui.ResetOnSpawn = false

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32,0.55)
frame.Position = UDim2.fromScale(0.34,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Barra superior
local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.fromScale(1,0.12)
topBar.BackgroundColor3 = Color3.fromRGB(240,240,240)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
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
local closedPos = UDim2.fromScale(openPos.X.Scale,1.3)

local tweenIn = TweenService:Create(
	frame, TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
	{Position=openPos}
)
local tweenOut = TweenService:Create(
	frame, TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
	{Position=closedPos}
)

-- Abrir / Cerrar menú
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

-- Crear botones
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

-- Botones
local teleBtn  = makeButton("TP TO BASE",0.15)
local speedBtn = makeButton("SPEED (OFF)",0.28)
local kickBtn  = makeButton("AUTO KICK (OFF)",0.41)
local closeBtn = makeButton("CLOSE MENU",0.54)

local espBtn  = makeButton("ESP (OFF)",0.70,UDim2.fromScale(0.42,0.11),0.05)
local xrayBtn = makeButton("X-RAY (OFF)",0.70,UDim2.fromScale(0.42,0.11),0.53)

-- Funciones básicas
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

closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ICONO CIRCULAR (DRAGGABLE)
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

icon.MouseButton1Click:Connect(toggleMenu)

-- Drag genérico (sirve para frame e icono)
local function makeDraggable(obj)
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = obj.Position
		end
	end)
	obj.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Activar drag
makeDraggable(frame)
makeDraggable(icon)
