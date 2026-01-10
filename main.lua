local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,150)
frame.Position = UDim2.new(0.4,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Harold Hub"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Botón Teleguiado
local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(1,-20,0,35)
teleBtn.Position = UDim2.new(0,10,0,40)
teleBtn.Text = "Teleguiado"
teleBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
teleBtn.TextColor3 = Color3.fromRGB(0,0,0)
teleBtn.Font = Enum.Font.SourceSansBold
teleBtn.TextSize = 16
teleBtn.Parent = frame

-- Botón Auto Kick
local kickBtn = Instance.new("TextButton")
kickBtn.Size = UDim2.new(1,-20,0,30)
kickBtn.Position = UDim2.new(0,10,0,80)
kickBtn.Text = "Auto Kick"
kickBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
kickBtn.TextColor3 = Color3.fromRGB(0,0,0)
kickBtn.Font = Enum.Font.SourceSansBold
kickBtn.TextSize = 14
kickBtn.Parent = frame

-- Botón Cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1,-20,0,25)
closeBtn.Position = UDim2.new(0,10,0,115)
closeBtn.Text = "Cerrar"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 13
closeBtn.Parent = frame

-- Variables
local autoKickEnabled = false

-- Función Teleguiado (teleporta al Spawn)
local function TeleGuiado()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local spawnPoint = workspace:FindFirstChild("SpawnLocation")

    if spawnPoint then
        hrp.CFrame = spawnPoint.CFrame + Vector3.new(0,5,0)

        -- Si el Auto Kick está activado, te saca del juego
        if autoKickEnabled then
            task.wait(1)
            player:Kick("You stole a pet!")
        end
    else
        warn("No se encontró el SpawnLocation")
    end
end

teleBtn.MouseButton1Click:Connect(function()
    TeleGuiado()
end)

kickBtn.MouseButton1Click:Connect(function()
    autoKickEnabled = not autoKickEnabled
    if autoKickEnabled then
        kickBtn.Text = "Auto Kick: ON"
        kickBtn.BackgroundColor3 = Color3.fromRGB(180,255,180)
    else
        kickBtn.Text = "Auto Kick: OFF"
        kickBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Botón pequeño para volver a abrir el menú
local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0,40,0,40)
openBtn.Position = UDim2.new(0,20,0.5,0)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.AutoButtonColor = true
openBtn.Visible = true
openBtn.Parent = gui
openBtn.Active = true
openBtn.Draggable = true

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
end)
