-- TSUNAMI SCRIPTS | GOD MODE HUB
-- Creador: Tsunami Scripts | Harold

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- VARIABLES GOD MODE
-------------------------------------------------
local godModeEnabled = false
local humanoid
local maxHealth = 100
local godConnection

-------------------------------------------------
-- UI
-------------------------------------------------

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TsunamiHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 260, 0, 150)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true

-- Bordes redondeados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Texto del creador
local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Parent = MainFrame
CreatorLabel.Size = UDim2.new(1, 0, 0, 25)
CreatorLabel.Position = UDim2.new(0, 0, 0, 5)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Tsunami Scripts | Harold"
CreatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextSize = 14
CreatorLabel.TextStrokeTransparency = 0

-- Botón God Mode
local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = MainFrame
GodModeButton.Size = UDim2.new(0.9, 0, 0, 45)
GodModeButton.Position = UDim2.new(0.05, 0, 0, 60)
GodModeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
GodModeButton.Text = "GOD MODE"
GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GodModeButton.Font = Enum.Font.GothamBold
GodModeButton.TextSize = 18
GodModeButton.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = GodModeButton

-- Hover
GodModeButton.MouseEnter:Connect(function()
	if not godModeEnabled then
		GodModeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)

GodModeButton.MouseLeave:Connect(function()
	if not godModeEnabled then
		GodModeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	end
end)

-------------------------------------------------
-- TEXTO DISCORD
-------------------------------------------------

-- discord:
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Parent = MainFrame
DiscordLabel.Size = UDim2.new(0, 55, 0, 15)
DiscordLabel.Position = UDim2.new(0.05, 0, 0, 115)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord:"
DiscordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordLabel.Font = Enum.Font.Gotham
DiscordLabel.TextSize = 11
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Link
local DiscordLink = Instance.new("TextButton")
DiscordLink.Parent = MainFrame
DiscordLink.Size = UDim2.new(0, 170, 0, 15)
DiscordLink.Position = UDim2.new(0.27, 0, 0, 115)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "https://discord.gg/WvmRU6RYn"
DiscordLink.TextColor3 = Color3.fromRGB(120, 170, 255)
DiscordLink.Font = Enum.Font.Gotham
DiscordLink.TextSize = 11
DiscordLink.TextXAlignment = Enum.TextXAlignment.Left
DiscordLink.AutoButtonColor = false

DiscordLink.MouseButton1Click:Connect(function()
	local url = "https://discord.gg/WvmRU6RYn"
	pcall(function()
		GuiService:OpenBrowserWindow(url)
	end)
end)

-------------------------------------------------
-- GOD MODE REAL
-------------------------------------------------

GodModeButton.MouseButton1Click:Connect(function()
	godModeEnabled = not godModeEnabled

	if godModeEnabled then
		GodModeButton.Text = "ON"
		GodModeButton.TextColor3 = Color3.fromRGB(0, 255, 0)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		print("God Mode: ON")

		local character = player.Character or player.CharacterAdded:Wait()
		humanoid = character:WaitForChild("Humanoid")
		maxHealth = humanoid.MaxHealth
		humanoid.Health = maxHealth

		-- Mantiene la vida siempre llena
		godConnection = RunService.Heartbeat:Connect(function()
			if humanoid and humanoid.Health < maxHealth then
				humanoid.Health = maxHealth
			end
		end)

	else
		GodModeButton.Text = "GOD MODE"
		GodModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		print("God Mode: OFF")

		if godConnection then
			godConnection:Disconnect()
			godConnection = nil
		end
	end
end)

-------------------------------------------------
-- REAPLICAR GOD MODE AL REAPARECER
-------------------------------------------------

player.CharacterAdded:Connect(function(char)
	if godModeEnabled then
		task.wait(1)
		humanoid = char:WaitForChild("Humanoid")
		maxHealth = humanoid.MaxHealth
		humanoid.Health = maxHealth

		if godConnection then
			godConnection:Disconnect()
		end

		godConnection = RunService.Heartbeat:Connect(function()
			if humanoid and humanoid.Health < maxHealth then
				humanoid.Health = maxHealth
			end
		end)
	end
end)
