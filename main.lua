local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Guardamos la posición donde apareces al entrar (tu “base”)
local spawnCFrame = hrp.CFrame

-- Estados
local autoKickEnabled = false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "HaroldHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.25, 0.2)
frame.Position = UDim2.fromScale(0.375, 0.4)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,12)

-- Botón Teleguiado
local teleBtn = Instance.new("TextButton", frame)
teleBtn.Size = UDim2.fromScale(0.9, 0.4)
teleBtn.Position = UDim2.fromScale(0.05, 0.1)
teleBtn.Text = "TELEGUIADO"
teleBtn.TextColor3 = Color3.new(0,0,0)
teleBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
teleBtn.BorderSizePixel = 0

Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0,8)

-- Botón Auto Kick
local kickBtn = Instance.new("TextButton", frame)
kickBtn.Size = UDim2.fromScale(0.9, 0.4)
kickBtn.Position = UDim2.fromScale(0.05, 0.55)
kickBtn.Text = "AUTO KICK: OFF"
kickBtn.TextColor3 = Color3.new(0,0,0)
kickBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
kickBtn.BorderSizePixel = 0

Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0,8)

-- Funciones
teleBtn.MouseButton1Click:Connect(function()
	-- Teletransporta exactamente a donde apareciste al unirte
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
