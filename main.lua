--[[ 
====================================================
 TSUNAMI SCRIPTS | HAROLD
 GOD MODE HUB + LOADING SCREEN
 FIXED GOD MODE (ANTI RESET)
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
-- LOADING SCREEN (SIN CAMBIOS)
-------------------------------------------------
local LoadingGui = Instance.new("ScreenGui", PlayerGui)
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true

local Background = Instance.new("Frame", LoadingGui)
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundColor3 = Color3.new(0,0,0)
Background.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Background)
Title.Size = UDim2.new(1,0,0,60)
Title.Position = UDim2.new(0,0,0.4,0)
Title.BackgroundTransparency = 1
Title.Text = "Loading Tsunami Script..."
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextTransparency = 1

local BarBack = Instance.new("Frame", Background)
BarBack.Size = UDim2.new(0.4,0,0,18)
BarBack.Position = UDim2.new(0.3,0,0.52,0)
BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
BarBack.BackgroundTransparency = 1
BarBack.BorderSizePixel = 0
Instance.new("UICorner", BarBack)

local Bar = Instance.new("Frame", BarBack)
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
Bar.BorderSizePixel = 0
Instance.new("UICorner", Bar)

TweenService:Create(Background, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(BarBack, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()

task.wait(0.5)

TweenService:Create(
	Bar,
	TweenInfo.new(1.2),
	{Size = UDim2.new(1,0,1,0)}
):Play()

task.wait(2)
LoadingGui:Destroy()

-------------------------------------------------
-- UI HUB
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,260,0,150)
MainFrame.Position = UDim2.new(0.5,-130,0.5,-75)
MainFrame.BackgroundColor3 = Color3.new(0,0,0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local TitleHub = Instance.new("TextLabel", MainFrame)
TitleHub.Size = UDim2.new(1,0,0,25)
TitleHub.BackgroundTransparency = 1
TitleHub.Text = "Tsunami Scripts | Harold"
TitleHub.TextColor3 = Color3.new(1,1,1)
TitleHub.Font = Enum.Font.GothamBold
TitleHub.TextSize = 14

local GodButton = Instance.new("TextButton", MainFrame)
GodButton.Size = UDim2.new(0.9,0,0,45)
GodButton.Position = UDim2.new(0.05,0,0,60)
GodButton.Text = "GOD MODE"
GodButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
GodButton.TextColor3 = Color3.new(1,1,1)
GodButton.Font = Enum.Font.GothamBold
GodButton.TextSize = 18
Instance.new("UICorner", GodButton)

-------------------------------------------------
-- GOD MODE REAL (ANTI TSUNAMI RESET)
-------------------------------------------------
local godEnabled = false
local heartbeatConn

local function applyGod(character)
	local hum = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")

	-- bloquear muerte
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.BreakJointsOnDeath = false

	-- loop duro
	if heartbeatConn then heartbeatConn:Disconnect() end
	heartbeatConn = RunService.Heartbeat:Connect(function()
		if godEnabled and hum then
			hum.Health = hum.MaxHealth
			hum:ChangeState(Enum.HumanoidStateType.Physics)
			root.AssemblyLinearVelocity = Vector3.zero
		end
	end)
end

local function enableGod()
	godEnabled = true
	GodButton.Text = "ON"
	GodButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
	GodButton.TextColor3 = Color3.fromRGB(0,255,0)

	local char = player.Character or player.CharacterAdded:Wait()
	applyGod(char)
end

local function disableGod()
	godEnabled = false
	GodButton.Text = "GOD MODE"
	GodButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
	GodButton.TextColor3 = Color3.new(1,1,1)

	if heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end
end

GodButton.MouseButton1Click:Connect(function()
	if godEnabled then
		disableGod()
	else
		enableGod()
	end
end)

-------------------------------------------------
-- REAPLICAR AL RESPAWN
-------------------------------------------------
player.CharacterAdded:Connect(function(char)
	if godEnabled then
		task.wait(0.5)
		applyGod(char)
	end
end)
