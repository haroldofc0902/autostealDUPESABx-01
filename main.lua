local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Guardar la posición donde apareces al unirte (tu base real)
local spawnCFrame = hrp.CFrame

-- Estados
local autoKickEnabled = false
local speedEnabled = false
local wallhackEnabled = false

-- Velocidades
local normalSpeed = 16
local fastSpeed = 28

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HaroldHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.25, 0.35)
frame.Position = UDim2.fromScale(0.375, 0.35)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

-- TELEGUIADO
local teleBtn = Instance.new("TextButton")
teleBtn.Parent = frame
teleBtn.Size = UDim2.fromScale(0.9, 0.18)
teleBtn.Position = UDim2.fromScale(0.05, 0.05)
teleBtn.Text = "TELEGUIADO"
teleBtn.TextColor3 = Color3.new(0,0,0)
teleBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
teleBtn.BorderSizePixel = 0
Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0,8)

-- WALLHACK
local wallBtn = Instance.new("TextButton")
wallBtn.Parent = frame
wallBtn.Size = UDim2.fromScale(0.9, 0.18)
wallBtn.Position = UDim2.fromScale(0.05, 0.27)
wallBtn.Text = "WALLHACK: OFF"
wallBtn.TextColor3 = Color3.new(0,0,0)
wallBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
wallBtn.BorderSizePixel = 0
Instance.new("UICorner", wallBtn).CornerRadius = UDim.new(0,8)

-- SPEED
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = frame
speedBtn.Size = UDim2.fromScale(0.9, 0.18)
speedBtn.Position = UDim2.fromScale(0.05, 0.49)
speedBtn.Text = "SPEED: OFF"
speedBtn.TextColor3 = Color3.new(0,0,0)
speedBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
speedBtn.BorderSizePixel = 0
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0,8)

-- AUTO KICK
local kickBtn = Instance.new("TextButton")
kickBtn.Parent = frame
kickBtn.Size = UDim2.fromScale(0.9, 0.18)
kickBtn.Position = UDim2.fromScale(0.05, 0.71)
kickBtn.Text = "AUTO KICK: OFF"
kickBtn.TextColor3 = Color3.new(0,0,0)
kickBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
kickBtn.BorderSizePixel = 0
Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0,8)

-- Función noclip
local noclipConn
local function setNoclip(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
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
end

-- TELEGUIADO
teleBtn.MouseButton1Click:Connect(function()
	hrp.CFrame = spawnCFrame
	if autoKickEnabled then
		task.wait(0.3)
		player:Kick("You Stole a Pet!")
	end
end)

-- WALLHACK
wallBtn.MouseButton1Click:Connect(function()
	wallhackEnabled = not wallhackEnabled
	if wallhackEnabled then
		wallBtn.Text = "WALLHACK: ON"
		setNoclip(true)
	else
		wallBtn.Text = "WALLHACK: OFF"
		setNoclip(false)
	end
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	if speedEnabled then
		speedBtn.Text = "SPEED: ON"
		humanoid.WalkSpeed = fastSpeed
	else
		speedBtn.Text = "SPEED: OFF"
		humanoid.WalkSpeed = normalSpeed
	end
end)

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	autoKickEnabled = not autoKickEnabled
	if autoKickEnabled then
		kickBtn.Text = "AUTO KICK: ON"
	else
		kickBtn.Text = "AUTO KICK: OFF"
	end
end)

-- Drag del menú
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Botón circular para abrir/cerrar menú
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.fromScale(0.07, 0.07)
toggleBtn.Position = UDim2.fromScale(0.02, 0.45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BorderSizePixel = 0

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1,0)
toggleCorner.Parent = toggleBtn

local menuOpen = true

toggleBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	frame.Visible = menuOpen
end)

-- Drag del círculo
local draggingCircle = false
local dragStartCircle
local startPosCircle

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingCircle = true
		dragStartCircle = input.Position
		startPosCircle = toggleBtn.Position
	end
end)

toggleBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingCircle = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingCircle and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStartCircle
		toggleBtn.Position = UDim2.new(
			startPosCircle.X.Scale,
			startPosCircle.X.Offset + delta.X,
			startPosCircle.Y.Scale,
			startPosCircle.Y.Offset + delta.Y
		)
	end
end)
