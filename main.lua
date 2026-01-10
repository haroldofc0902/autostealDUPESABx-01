local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,160)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Botón Teleguiado
local teleBtn = Instance.new("TextButton", frame)
teleBtn.Size = UDim2.new(1,-20,0,40)
teleBtn.Position = UDim2.new(0,10,0,20)
teleBtn.Text = "Teleguiado"
teleBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
teleBtn.TextColor3 = Color3.fromRGB(0,0,0)

-- Botón Auto Kick
local kickBtn = Instance.new("TextButton", frame)
kickBtn.Size = UDim2.new(1,-20,0,40)
kickBtn.Position = UDim2.new(0,10,0,70)
kickBtn.Text = "Auto Kick"
kickBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
kickBtn.TextColor3 = Color3.fromRGB(0,0,0)

-- Botón Cerrar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1,-20,0,30)
closeBtn.Position = UDim2.new(0,10,0,120)
closeBtn.Text = "Cerrar"
closeBtn.BackgroundColor3 = Color3.fromRGB(180,180,180)
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)

-- Icono para abrir menú
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,40,0,40)
openBtn.Position = UDim2.new(0,10,0.5,0)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true

-- Función para verificar Tools
local function hasTool()
	local char = player.Character
	if not char then return false end
	for _,v in ipairs(char:GetChildren()) do if v:IsA("Tool") then return true end end
	for _,v in ipairs(player.Backpack:GetChildren()) do if v:IsA("Tool") then return true end end
	return false
end

-- Teleport al spawn
local function teleportToSpawn()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local spawn = workspace:FindFirstChildOfClass("SpawnLocation") or workspace:FindFirstChild("SpawnLocation")
	if spawn then
		hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0)
	end
end

-- Función para auto kick
local function autoKick()
	if hasTool() then
		player:Kick("You Stole a Pet!")
	end
end

-- Botón Teleguiado
teleBtn.MouseButton1Click:Connect(function()
	teleportToSpawn()
end)

-- Botón Auto Kick
kickBtn.MouseButton1Click:Connect(autoKick)

-- Detecta Tools nuevas y auto-kickea si quieres que siempre funcione en segundo plano
player.CharacterAdded:Connect(function(char)
	char.ChildAdded:Connect(function(obj)
		if obj:IsA("Tool") then
			-- Aquí no hacemos nada automáticamente, se activa solo con el botón
		end
	end)
end)

-- Cerrar / abrir menú
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)
