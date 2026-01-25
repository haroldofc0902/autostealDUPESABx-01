--[[ 
====================================================
 TSUNAMI SCRIPTS | HAROLD
 GOD MODE HUB + LOADING SCREEN
 TSUNAMI FIX DEFINITIVO
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
local LoadingGui = Instance.new("ScreenGui", PlayerGui)
LoadingGui.Name = "TsunamiLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true

local Background = Instance.new("Frame", LoadingGui)
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
Background.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Background)
Title.Size = UDim2.new(1,0,0,60)
Title.Position = UDim2.new(0,0,0.4,0)
Title.BackgroundTransparency = 1
Title.Text = "Loading Tsunami Script..."
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextTransparency = 1

local BarBack = Instance.new("Frame", Background)
BarBack.Size = UDim2.new(0.4,0,0,18)
BarBack.Position = UDim2.new(0.3,0,0.52,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
BarBack.BackgroundTransparency = 1
Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0,10)

local Bar = Instance.new("Frame", BarBack)
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0,10)

TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(BarBack, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()

task.wait(0.6)
TweenService:Create(Bar, TweenInfo.new(1.2), {Size = UDim2.new(1,0,1,0)}):Play()
task.wait(1.5)

TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(BarBack, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()

task.wait(0.7)
LoadingGui:Destroy()

-------------------------------------------------
-- VARIABLES GOD MODE
-------------------------------------------------
local godModeEnabled = false
local humanoid
local connections = {}

-------------------------------------------------
-- UI HUB
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "TsunamiHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,260,0,150)
MainFrame.Position = UDim2.new(0.5,-130,0.5,-75)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderColor3 = Color3.fromRGB(255,255,255)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

local CreatorLabel = Instance.new("TextLabel", MainFrame)
CreatorLabel.Size = UDim2.new(1,0,0,25)
CreatorLabel.Position = UDim2.new(0,0,0,5)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Tsunami Scripts | Harold"
CreatorLabel.TextColor3 = Color3.new(1,1,1)
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextSize = 14

local GodModeButton = Instance.new("TextButton", MainFrame)
GodModeButton.Size = UDim2.new(0.9,0,0,45)
GodModeButton.Position = UDim2.new(0.05,0,0,60)
GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
GodModeButton.Text = "GOD MODE"
GodModeButton.TextColor3 = Color3.new(1,1,1)
GodModeButton.Font = Enum.Font.GothamBold
GodModeButton.TextSize = 18
Instance.new("UICorner", GodModeButton).CornerRadius = UDim.new(0,10)

-------------------------------------------------
-- GOD MODE REAL (ANTI TSUNAMI RESET)
-------------------------------------------------
local function applyFix(hum)
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
	hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
	hum.BreakJointsOnDeath = false
end

local function enableGod()
	local char = player.Character or player.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	humanoid.MaxHealth = math.huge
	humanoid.Health = math.huge
	applyFix(humanoid)

	table.insert(connections,
		humanoid.HealthChanged:Connect(function()
			humanoid.Health = humanoid.MaxHealth
		end)
	)

	table.insert(connections,
		RunService.Heartbeat:Connect(function()
			if humanoid and godModeEnabled then
				humanoid.Health = humanoid.MaxHealth
				if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end
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
		GodModeButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
		GodModeButton.TextColor3 = Color3.fromRGB(0,255,0)
		enableGod()
	else
		GodModeButton.Text = "GOD MODE"
		GodModeButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
		GodModeButton.TextColor3 = Color3.new(1,1,1)
		disableGod()
	end
end)

-------------------------------------------------
-- REAPLICAR AL MORIR / MORPH
-------------------------------------------------
player.CharacterAdded:Connect(function()
	if godModeEnabled then
		task.wait(0.5)
		enableGod()
	end
end)
