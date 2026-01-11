-- DRAGON HUB (LocalScript)
-- Poner en: StarterGui > ScreenGui > LocalScript

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Guardar el punto donde reapareces
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

-- Frame principal (apartado igual que antes)
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,260,0,240)
frame.Position = UDim2.new(0.5,-130,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "DRAGON HUB"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22

-- Botones
local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(1,-20,0,32)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(235,235,235)
	b.TextColor3 = Color3.fromRGB(0,0,0)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.BorderSizePixel = 0
	b.Text = text
	return b
end

local teleBtn  = makeButton("Teleguiado",45)
local speedBtn = makeButton("SPEED",85)
local wallBtn  = makeButton("Wallhack",125)
local kickBtn  = makeButton("Auto Kick",165)

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

-- Icono flotante negro, redondo
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.new(0,55,0,55)
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
