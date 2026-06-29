local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

-- 1. Create the dark background overlay
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 1 -- Starts clear
background.BorderSizePixel = 0
background.Parent = script.Parent

-- 2. Create the Error Window (Matches Roblox's disconnect prompt style)
local errorWindow = Instance.new("Frame")
errorWindow.Size = UDim2.new(0, 400, 0, 180)
errorWindow.Position = UDim2.new(0.5, -200, 0.4, -90)
errorWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Dark gray
errorWindow.BorderSizePixel = 0
errorWindow.Parent = background

-- Round the corners slightly
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = errorWindow

-- 3. Title Text ("Disconnected")
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Disconnected"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.Parent = errorWindow

-- 4. Error Message Box
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0.9, 0, 0, 60)
messageLabel.Position = UDim2.new(0.05, 0, 0, 50)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "You have been banned from this game."
messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
messageLabel.Font = Enum.Font.SourceSans
messageLabel.TextSize = 18
messageLabel.TextWrapped = true
messageLabel.Parent = errorWindow

-- 5. The "Leave" Button
local leaveButton = Instance.new("TextButton")
leaveButton.Size = UDim2.new(0.8, 0, 0, 40)
leaveButton.Position = UDim2.new(0.1, 0, 1, -55)
leaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White button
leaveButton.Text = "Leave"
leaveButton.TextColor3 = Color3.fromRGB(35, 35, 35)
leaveButton.Font = Enum.Font.SourceSansBold
leaveButton.TextSize = 20
leaveButton.Parent = errorWindow

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = leaveButton

-- --- ACTIVATION LOGIC ---

-- Smoothly fade in the background to mimic the disconnection freeze
TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()

-- Handle the click functionality
leaveButton.MouseButton1Click:Connect(function()
    -- Actually disconnects the player from the Roblox servers completely
    localPlayer:Kick("You have been banned from this game.")
end)
