-- DRAGON HUB (LocalScript)
-- Poner en: StarterGui > ScreenGui > LocalScript

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Guardar el punto donde reapareces
local spawnCFrame = nil
player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if char:FindFirstChild("HumanoidRootPart") then
		spawnCFrame = char.HumanoidRootPart.CFrame
	end
end)

if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
	spawnCFrame = player.Character.HumanoidRootPart.CFrame
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DragonHub"
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 280, 0, 260)
frame.Position = UDim2.new(0.5, -140, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22

-- Función para botones
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(1,-20,0,35)
	btn.Position = UDim2.new(0,10,0,posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(230,230,230)
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	return btn
end

-- Botones
local teleBtn = createButton("Teleguiado", 50)
local speedBtn = createButton("SPEED", 95)
local wallBtn = createButton("Wallhack", 140)
local kickBtn = createButton("Auto Kick", 185)

-- Variables
local wallhack = false
local autoKick = false

-- Teleguiado
teleBtn.MouseButton1Click:Connect(function()
	if spawnCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawnCFrame
		if autoKick then
			player:Kick("You Stole a Pet!")
		end
	end
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = 35
	end
end)

-- Wallhack
wallBtn.MouseButton1Click:Connect(function()
	wallhack = not wallhack
	if wallhack then
		wallBtn.Text = "Wallhack (ON)"
	else
		wallBtn.Text = "Wallhack (OFF)"
	end
end)

RunService.Stepped:Connect(function()
	if wallhack and player.Character then
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Auto Kick
kickBtn.MouseButton1Click:Connect(function()
	autoKick = not autoKick
	if autoKick then
		kickBtn.Text = "Auto Kick (ON)"
	else
		kickBtn.Text = "Auto Kick (OFF)"
	end
end)

-- Botón flotante circular con tu imagen
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.05,0,0.5,0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://73387282416078"
toggleBtn.Active = true
toggleBtn.Draggable = true

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
