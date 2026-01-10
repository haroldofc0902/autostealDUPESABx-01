local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,120)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(1,-20,0,40)
teleBtn.Position = UDim2.new(0,10,0,20)
teleBtn.Text = "Teleguiado"
teleBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
teleBtn.TextColor3 = Color3.fromRGB(0,0,0)
teleBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1,-20,0,30)
closeBtn.Position = UDim2.new(0,10,0,70)
closeBtn.Text = "Cerrar"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
closeBtn.Parent = frame

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,40,0,40)
openBtn.Position = UDim2.new(0,10,0.5,0)
openBtn.Text = ""
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = gui

local function hasTool()
	local char = player.Character
	if not char then return false end
	for _,v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") then
			return true
		end
	end
	for _,v in ipairs(player.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			return true
		end
	end
	return false
end

local function teleGuiado()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local base = workspace:FindFirstChild("Base de HaroldEs08")

	if base then
		hrp.CFrame = base:GetModelCFrame() + Vector3.new(0,5,0)
		if hasTool() then
			task.wait(0.5)
			player:Kick("You stole a Pet!")
		end
	end
end

teleBtn.MouseButton1Click:Connect(teleGuiado)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)
