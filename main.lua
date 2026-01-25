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
local PhysicsService = game:GetService("PhysicsService")

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

local Background = Instance.new("Frame")
Background.Parent = LoadingGui
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BackgroundTransparency = 1

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

local BarBack = Instance.new("Frame")
BarBack.Parent = Background
BarBack.Size = UDim2.new(0.4,0,0,18)
BarBack.Position = UDim2.new(0.3,0,0.52,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
BarBack.BackgroundTransparency = 1
BarBack.BorderSizePixel = 0
Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0,10)

local Bar = Instance.new("Frame")
Bar.Parent = BarBack
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
Bar.BorderSizePixel = 0
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,10)

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

-------------------------------------------------
-- UI HUB (NO MODIFICADO)
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

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Parent = MainFrame
CreatorLabel.Size = UDim2.new(1,0,0,25)
CreatorLabel.Position = UDim2.new(0,0,0,5)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Tsunami Scripts | Harold"
CreatorLabel.TextColor3 = Color3.fromRGB(255,255,255)
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextSize = 14

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

-------------------------------------------------
-- GOD MODE
-------------------------------------------------
local connections = {}

local function enableGod()
	local character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")

	humanoid.MaxHealth = math.huge
	humanoid.Health = math.huge
	humanoid.BreakJointsOnDeath = false

	table.insert(connections,
		humanoid.HealthChanged:Connect(function()
			humanoid.Health = humanoid.MaxHealth
		end)
	)
end

local function disableGod()
	for _,c in pairs(connections) do
		c:Disconnect()
	end
	connections = {}

	if humanoid then
		humanoid.MaxHealth = 100
	end
end

GodModeButton.MouseButton1Click:Connect(function()
	godModeEnabled = not godModeEnabled

	if godModeEnabled then
		GodModeButton.Text = "ON"
		GodModeButton.TextColor3 = Color3.fromRGB(0,255,0)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
		enableGod()
	else
		GodModeButton.Text = "GOD MODE"
		GodModeButton.TextColor3 = Color3.fromRGB(255,255,255)
		GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
		disableGod()
	end
end)

-------------------------------------------------
-- 🔥 ANTI OLAS / TSUNAMI IGNORE (NUEVO)
-------------------------------------------------
pcall(function()
	PhysicsService:CreateCollisionGroup("PlayerGhost")
end)

PhysicsService:CollisionGroupSetCollidable("PlayerGhost", "Default", false)

local function ghostCharacter(char)
	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Massless = true
			pcall(function()
				PhysicsService:SetPartCollisionGroup(v, "PlayerGhost")
			end)
		end
	end
end

local function ghostWaves()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			local n = v.Name:lower()
			if n:find("wave") or n:find("tsunami") or n:find("ola") then
				v.CanCollide = false
			end
		end
	end
end

if player.Character then
	ghostCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	ghostCharacter(char)
	if godModeEnabled then
		enableGod()
	end
end)

RunService.Stepped:Connect(function()
	ghostWaves()
end)
