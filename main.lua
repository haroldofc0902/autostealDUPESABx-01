--[[ 
====================================================
 TSUNAMI SCRIPTS | HAROLD
 GOD MODE HUB + LOADING SCREEN
 LocalScript
====================================================
]]

-------------------------------------------------
-- SERVICIOS
-------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- LOADING SCREEN
-------------------------------------------------
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "TsunamiLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.Parent = PlayerGui

-- Fondo
local Background = Instance.new("Frame")
Background.Parent = LoadingGui
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BackgroundTransparency = 1

-- Texto
local Title = Instance.new("TextLabel")
Title.Parent = Background
Title.Size = UDim2.new(1,0,0,60)
Title.Position = UDim2.new(0,0,0.4,0)
Title.BackgroundTransparency = 1
Title.Text = "Loading Tsunami Script..."
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextTransparency = 1

-- Barra fondo
local BarBack = Instance.new("Frame")
BarBack.Parent = Background
BarBack.Size = UDim2.new(0.4,0,0,18)
BarBack.Position = UDim2.new(0.3,0,0.52,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
BarBack.BackgroundTransparency = 1
BarBack.BorderSizePixel = 0
Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0,10)

-- Barra verde
local Bar = Instance.new("Frame")
Bar.Parent = BarBack
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
Bar.BorderSizePixel = 0
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,10)

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = Background
Avatar.Size = UDim2.new(0,80,0,80)
Avatar.Position = UDim2.new(0.5,-40,0.65,0)
Avatar.BackgroundTransparency = 1
Avatar.ImageTransparency = 1

local avatarUrl = Players:GetUserThumbnailAsync(
	player.UserId,
	Enum.ThumbnailType.HeadShot,
	Enum.ThumbnailSize.Size420x420
)
Avatar.Image = avatarUrl

-- Animaciones
TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(BarBack, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenService:Create(Avatar, TweenInfo.new(0.6), {ImageTransparency = 0}):Play()

task.wait(0.6)

local barTween = TweenService:Create(
	Bar,
	TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Size = UDim2.new(1,0,1,0)}
)
barTween:Play()
barTween.Completed:Wait()

task.wait(0.3)

TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(BarBack, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(Avatar, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()

task.wait(0.7)
LoadingGui:Destroy()

-------------------------------------------------
-- VARIABLES GOD MODE
-------------------------------------------------
local godModeEnabled = false
local humanoid
local maxHealth = 100
local godConnection

-------------------------------------------------
-- UI HUB
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TsunamiHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 260, 0, 150)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255,255,255)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

-- Título
local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Parent = MainFrame
CreatorLabel.Size = UDim2.new(1,0,0,25)
CreatorLabel.Position = UDim2.new(0,0,0,5)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Tsunami Scripts | Harold"
CreatorLabel.TextColor3 = Color3.fromRGB(255,255,255)
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextSize = 14

-- Botón God Mode
local GodModeButton = Instance.new("TextButton")
GodModeButton.Parent = MainFrame
GodModeButton.Size = UDim2.new(0.9,0,0,45)
GodModeButton.Position = UDim2.new(0.05,0,0,60)
GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
GodModeButton.Text = "GOD MODE"
GodModeButton.TextColor3 = Color3.fromRGB(255,255,255)
GodModeButton.Font = Enum.Font.GothamBold
GodModeButton.TextSize = 18
GodModeButton.BorderSizePixel = 0
Instance.new("UICorner", GodModeButton).CornerRadius = UDim.new(0,10)

-- Texto Discord
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Parent = MainFrame
DiscordLabel.Size = UDim2.new(0,55,0,15)
DiscordLabel.Position = UDim2.new(0.05,0,0,115)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "discord:"
DiscordLabel.TextColor3 = Color3.fromRGB(255,255,255)
DiscordLabel.Font = Enum.Font.Gotham
DiscordLabel.TextSize = 11
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left

local DiscordLink = Instance.new("TextButton")
DiscordLink.Parent = MainFrame
DiscordLink.Size = UDim2.new(0,170,0,15)
DiscordLink.Position = UDim2.new(0.27,0,0,115)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "https://discord.gg/WvmRU6RYn"
DiscordLink.TextColor3 = Color3.fromRGB(120,170,255)
DiscordLink.Font = Enum.Font.Gotham
DiscordLink.TextSize = 11
DiscordLink.TextXAlignment = Enum.TextXAlignment.Left
DiscordLink.AutoButtonColor = false

DiscordLink.MouseButton1Click:Connect(function()
	pcall(function()
		GuiService:OpenBrowserWindow("https://discord.gg/WvmRU6RYn")
	end)
end)

-------------------------------------------------
-- GOD MODE REAL
-------------------------------------------------
GodModeButton.MouseButton1Click:Connect(function()
	godModeEnabled = not godModeEnabled

	if godModeEnabled then
		GodModeButton.Text = "ON"
		GodModeButton.TextColor3 = Color3.fromRGB(0,255,0)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(40,40,40)

		local character = player.Character or player.CharacterAdded:Wait()
		humanoid = character:WaitForChild("Humanoid")
		maxHealth = humanoid.MaxHealth
		humanoid.Health = maxHealth

		godConnection = RunService.Heartbeat:Connect(function()
			if humanoid and humanoid.Health < maxHealth then
				humanoid.Health = maxHealth
			end
		end)

	else
		GodModeButton.Text = "GOD MODE"
		GodModeButton.TextColor3 = Color3.fromRGB(255,255,255)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)

		if godConnection then
			godConnection:Disconnect()
			godConnection = nil
		end
	end
end)

-------------------------------------------------
-- REAPLICAR GOD MODE AL MORIR
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
