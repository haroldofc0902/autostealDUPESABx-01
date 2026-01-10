local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Guardar la posición donde apareces al entrar (tu base real)
local spawnCFrame = hrp.CFrame

-- Estado
local autoKickEnabled = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HaroldHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.25, 0.2)
frame.Position = UDim2.fromScale(0.375, 0.4)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

-- Botón Teleguiado
local teleBtn = Instance.new("TextButton")
teleBtn.Parent = frame
teleBtn.Size = UDim2.fromScale(0.9, 0.4)
teleBtn.Position = UDim2.fromScale(0.05, 0.1)
teleBtn.Text = "TELEGUIADO"
teleBtn.TextColor3 = Color3.new(0,0,0)
teleBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
teleBtn.BorderSizePixel = 0
Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0,8)

-- Botón Auto Kick
local kickBtn = Instance.new("TextButton")
kickBtn.Parent = frame
kickBtn.Size = UDim2.fromScale(0.9, 0.4)
kickBtn.Position = UDim2.fromScale(0.05, 0.55)
kickBtn.Text = "AUTO KICK: OFF"
kickBtn.TextColor3 = Color3.new(0,0,0)
kickBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
kickBtn.BorderSizePixel = 0
Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0,8)

-- Funciones de botones
teleBtn.MouseButton1Click:Connect(function()
	hrp.CFrame = spawnCFrame
	if autoKickEnabled then
		task.wait(0.3)
		player:Kick("You Stole a Pet!")
	end
end)

kickBtn.MouseButton1Click:Connect(function()
	autoKickEnabled = not autoKickEnabled
	if autoKickEnabled then
		kickBtn.Text = "AUTO KICK: ON"
	else
		kickBtn.Text = "AUTO KICK: OFF"
	end
end)

-- Hacer el menú movible (drag)
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
