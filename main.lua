-- DRAGON HUB (LocalScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Guardar el lugar donde apareces
local spawnCFrame = hrp.CFrame

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
	spawnCFrame = hrp.CFrame
end)

-- Estados
local autoKick = false
local speedOn = false
local noclipOn = false

local normalSpeed = 16
local fastSpeed = 35

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DragonHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- FRAME PRINCIPAL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.32,0.4)
frame.Position = UDim2.fromScale(0.34,0.3)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- TITULO
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0,0,0)

-- FUNCIÓN PARA CREAR BOTONES
local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.fromScale(0.9,0.14)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.TextColor3 = Color3.new(0,0,0)
	b.BackgroundColor3 = Color3.fromRGB(220,220,220)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

-- BOTONES
local teleBtn  = makeButton("TELEGUIADO",0.15)
local wallBtn  = makeButton("WALLHACK : OFF",0.33)
local speedBtn = makeButton("SPEED : OFF",0.51)
local kickBtn  = makeButton("AUTO KICK : OFF",0.69)

-- TELEGUIADO
teleBtn.MouseButton1Click:Connect(function()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.wait(2) -- 2 segundos después
		player:Kick("You Stole a Pet!")
	end
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	if speedOn then
		humanoid.WalkSpeed = fastSpeed
		speedBtn.Text = "SPEED : ON"
	else
		humanoid.WalkSpeed = normalSpeed
		speedBtn.Text = "SPEED : OFF"
	end
end)

-- WALLHACK (Noclip)
local noclipConn
wallBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	if noclipOn then
		wallBtn.Text = "WALLHACK : ON"
		noclipConn = RunService.Stepped:Connect(function()
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
		wallBtn.Text = "WALLHACK : OFF"
		if noclipConn then
			noclipConn:Disconnect()
			noclipConn = nil
		end
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	autoKick = not autoKick
	if autoKick then
		kickBtn.Text = "AUTO KICK : ON"
	else
		kickBtn.Text = "AUTO KICK : OFF"
	end
end)

-- DRAG DEL MENÚ
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

-- BOTÓN FLOTANTE CIRCULAR
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.fromScale(0.08,0.08)
toggleBtn.Position = UDim2.fromScale(0.03,0.45)
toggleBtn.Image = "rbxassetid://73387282416078"
toggleBtn.BackgroundTransparency = 1
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

local open = true
toggleBtn.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
end)

-- DRAG DEL CÍRCULO
local draggingC, dragStartC, startPosC
toggleBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		draggingC = true
		dragStartC = i.Position
		startPosC = toggleBtn.Position
	end
end)

toggleBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		draggingC = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingC and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStartC
		toggleBtn.Position = UDim2.new(
			startPosC.X.Scale, startPosC.X.Offset + delta.X,
			startPosC.Y.Scale, startPosC.Y.Offset + delta.Y
		)
	end
end)
