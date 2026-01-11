-- DRAGON HUB (LocalScript)
-- Poner en: StarterGui > ScreenGui > LocalScript

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Guardar spawn
local spawnCFrame
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

-- Frame principal (estilo oscuro como antes)
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,220,0,190)
frame.Position = UDim2.new(0.5,-110,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.TextColor3 = Color3.fromRGB(255,80,80)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Botones estilo antiguo
local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(1,-16,0,28)
	b.Position = UDim2.new(0,8,0,y)
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 16
	b.BorderSizePixel = 0
	b.Text = text
	return b
end

local teleBtn  = makeButton("Teleguiado",40)
local speedBtn = makeButton("SPEED",75)
local wallBtn  = makeButton("Wallhack",110)
local kickBtn  = makeButton("Auto Kick",145)

-- Variables
local wallhack = false
local autoKick = false

-- Teleguiado
teleBtn.MouseButton1Click:Connect(function()
	if spawnCFrame and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawnCFrame
		if autoKick then
			task.delay(2, function() -- 2 segundos
				player:Kick("You Stole a Pet!")
			end)
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
	wallBtn.Text = wallhack and "Wallhack (ON)" or "Wallhack (OFF)"
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
	kickBtn.Text = autoKick and "Auto Kick (ON)" or "Auto Kick (OFF)"
end)

-- Botón flotante negro, redondo
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.new(0,45,0,45)
toggleBtn.Position = UDim2.new(0.05,0,0.5,0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Text = ""
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
