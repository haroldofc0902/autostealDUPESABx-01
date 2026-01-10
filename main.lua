local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local spawn = workspace:WaitForChild("SpawnLocation")

local teleguiadoOn = false

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "HaroldHub"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0,300,0,200)
mainFrame.Position = UDim2.new(0.5,-150,0.5,-100)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Harold Hub"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.BackgroundTransparency = 1
title.TextScaled = true

local function createButton(name, posY)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,posY)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(220,220,220)
    btn.TextScaled = true
    return btn
end

local teleguiadoButton = createButton("Teleguiado",60)
local autoKickButton = createButton("Auto Kick",110)
local closeButton = createButton("Close Hub",160)

local icon = Instance.new("ImageButton", screenGui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,0,20)
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.AutoButtonColor = true
icon.Visible = false
icon.Active = true
icon.Draggable = true

icon.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    icon.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    icon.Visible = true
end)

local function activarTeleguiado(tool)
    if not teleguiadoOn then return end
    if not tool or (tool.Parent ~= player.Backpack and tool.Parent ~= player.Character) then
        player:Kick("You need to grab a pet first!")
        teleguiadoOn = false
        return
    end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    local distance = (spawn.Position - hrp.Position).Magnitude
    local speed = 1000
    local tweenInfo = TweenInfo.new(distance/speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(spawn.Position)})
    tween:Play()
    tween.Completed:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        teleguiadoOn = false
        player:Kick("You stole a pet!")
    end)
end

teleguiadoButton.MouseButton1Click:Connect(function()
    teleguiadoOn = true
    teleguiadoButton.TextColor3 = Color3.fromRGB(0,255,0)
end)

player.Backpack.ChildAdded:Connect(activarTeleguiado)
player.Character.ChildAdded:Connect(activarTeleguiado)
