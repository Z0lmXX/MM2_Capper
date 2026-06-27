-- =============================================================================
-- 1. MAIN UI WINDOW SETUP (Centered Top-Middle & Draggable)
-- =============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("CapperUI") then
	PlayerGui.CapperUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CapperUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 440)
MainFrame.Position = UDim2.new(0.5, -250, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TitleLabel.Text = "Capper Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Active = true
TitleLabel.Parent = MainFrame

-- =============================================================================
-- MULTI-TAB NAVIGATION INTERFACE
-- =============================================================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -75)
ContentContainer.Position = UDim2.new(0, 10, 0, 70)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Scrolling frames for separate tabs
local MM2Scroll = Instance.new("ScrollingFrame")
MM2Scroll.Size = UDim2.new(1, 0, 1, 0)
MM2Scroll.BackgroundTransparency = 1
MM2Scroll.CanvasSize = UDim2.new(0, 0, 1.6, 0)
MM2Scroll.ScrollBarThickness = 6
MM2Scroll.Visible = true
MM2Scroll.Parent = ContentContainer

local MM2Layout = Instance.new("UIListLayout")
MM2Layout.SortOrder = Enum.SortOrder.LayoutOrder
MM2Layout.Padding = UDim.new(0, 6)
MM2Layout.Parent = MM2Scroll

local UniversalScroll = Instance.new("ScrollingFrame")
UniversalScroll.Size = UDim2.new(1, 0, 1, 0)
UniversalScroll.BackgroundTransparency = 1
UniversalScroll.CanvasSize = UDim2.new(0, 0, 2.2, 0)
UniversalScroll.ScrollBarThickness = 6
UniversalScroll.Visible = false
UniversalScroll.Parent = ContentContainer

local UniversalLayout = Instance.new("UIListLayout")
UniversalLayout.SortOrder = Enum.SortOrder.LayoutOrder
UniversalLayout.Padding = UDim.new(0, 6)
UniversalLayout.Parent = UniversalScroll

-- Tab Buttons Creator
local mm2TabBtn = Instance.new("TextButton")
mm2TabBtn.Size = UDim2.new(0.5, 0, 1, 0)
mm2TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
mm2TabBtn.Text = "MM2"
mm2TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mm2TabBtn.Font = Enum.Font.SourceSansBold
mm2TabBtn.TextSize = 14
mm2TabBtn.BorderSizePixel = 0
mm2TabBtn.Parent = TabBar

local uniTabBtn = Instance.new("TextButton")
uniTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
uniTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
uniTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
uniTabBtn.Text = "Universal"
uniTabBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
uniTabBtn.Font = Enum.Font.SourceSansBold
uniTabBtn.TextSize = 14
uniTabBtn.BorderSizePixel = 0
uniTabBtn.Parent = TabBar

mm2TabBtn.MouseButton1Click:Connect(function()
	MM2Scroll.Visible = true
	UniversalScroll.Visible = false
	mm2TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	mm2TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	uniTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	uniTabBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
end)

uniTabBtn.MouseButton1Click:Connect(function()
	MM2Scroll.Visible = false
	UniversalScroll.Visible = true
	uniTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	uniTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	mm2TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	mm2TabBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
end)

-- Toggle & Drag Core Actions Integration
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F3 then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

TitleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

TitleLabel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then updateDrag(input) end
end)

-- =============================================================================
-- 3. REUSABLE UI CREATION HELPERS
-- =============================================================================
local function createHeader(text, order, parentPage)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 25)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(160, 160, 170)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.SourceSansItalic
	label.TextSize = 14
	label.LayoutOrder = order
	label.Parent = parentPage
end

local function createActionButton(text, color, order, parentPage, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 35)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parentPage

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.94, 0, 0.8, 0)
	btn.Position = UDim2.new(0.03, 0, 0.1, 0)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(callback)
end

local function createConfigurableToggle(text, defaultKey, order, parentPage, toggleCallback, keybindCallback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 32)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parentPage

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.Text = "  " .. text
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.TextSize = 14
	label.Font = Enum.Font.SourceSans
	label.Parent = frame

	local bindBtn = Instance.new("TextButton")
	bindBtn.Size = UDim2.new(0.20, 0, 0.8, 0)
	bindBtn.Position = UDim2.new(0.51, 0, 0.1, 0)
	bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	bindBtn.Text = defaultKey and ("[" .. defaultKey.Name .. "]") or "[NONE]"
	bindBtn.TextColor3 = Color3.fromRGB(180, 180, 185)
	bindBtn.Font = Enum.Font.SourceSans
	bindBtn.TextSize = 12
	bindBtn.Parent = frame
	
	local bindCorner = Instance.new("UICorner")
	bindCorner.CornerRadius = UDim.new(0, 4)
	bindCorner.Parent = bindBtn

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0.23, 0, 0.8, 0)
	toggleBtn.Position = UDim2.new(0.74, 0, 0.1, 0)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	toggleBtn.Text = "OFF"
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font = Enum.Font.SourceSansBold
	toggleBtn.Parent = frame

	if not defaultKey then
		bindBtn.Visible = false
		toggleBtn.Position = UDim2.new(0.74, 0, 0.1, 0)
	end

	local enabled = false
	toggleBtn.MouseButton1Click:Connect(function()
		enabled = not enabled
		toggleBtn.Text = enabled and "ON" or "OFF"
		toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
		if toggleCallback then toggleCallback(enabled) end
	end)

	local listeningForBind = false
	bindBtn.MouseButton1Click:Connect(function()
		listeningForBind = true
		bindBtn.Text = "..."
		bindBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if not listeningForBind then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForBind = false
			bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
			bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
			if keybindCallback then keybindCallback(input.KeyCode) end
		end
	end)

	return toggleBtn
end

local function createSlider(text, min, max, default, order, parentPage, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -5, 0, 40)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.LayoutOrder = order
	sliderFrame.Parent = parentPage

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0, 15)
	label.Text = "  " .. text .. ": " .. tostring(default)
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.TextSize = 12
	label.Font = Enum.Font.SourceSans
	label.Parent = sliderFrame

	-- Decrement Arrow Button (<)
	local decButton = Instance.new("TextButton")
	decButton.Size = UDim2.new(0, 20, 0, 15)
	decButton.Position = UDim2.new(0.8, -25, 0, 0)
	decButton.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	decButton.Text = "<"
	decButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	decButton.Font = Enum.Font.SourceSansBold
	decButton.TextSize = 12
	decButton.Parent = sliderFrame
	local decCorner = Instance.new("UICorner")
	decCorner.CornerRadius = UDim.new(0, 3)
	decCorner.Parent = decButton

	-- Increment Arrow Button (>)
	local incButton = Instance.new("TextButton")
	incButton.Size = UDim2.new(0, 20, 0, 15)
	incButton.Position = UDim2.new(0.8, 0, 0, 0)
	incButton.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	incButton.Text = ">"
	incButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	incButton.Font = Enum.Font.SourceSansBold
	incButton.TextSize = 12
	incButton.Parent = sliderFrame
	local incCorner = Instance.new("UICorner")
	incCorner.CornerRadius = UDim.new(0, 3)
	incCorner.Parent = incButton

	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(0.94, 0, 0, 8)
	barBackground.Position = UDim2.new(0.03, 0, 0.6, 0)
	barBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	barBackground.BorderSizePixel = 0
	barBackground.Parent = sliderFrame

	local fillBar = Instance.new("Frame")
	local startPercent = (default - min) / (max - min)
	fillBar.Size = UDim2.new(startPercent, 0, 1, 0)
	fillBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	fillBar.BorderSizePixel = 0
	fillBar.Parent = barBackground

	local sliderButton = Instance.new("TextButton")
	sliderButton.Size = UDim2.new(1, 0, 1, 0)
	sliderButton.BackgroundTransparency = 1
	sliderButton.Text = ""
	sliderButton.Parent = barBackground

	local currentVal = default

	local function updateSliderVisuals(value)
		currentVal = math.clamp(value, min, max)
		local percentage = (max - min) > 0 and ((currentVal - min) / (max - min)) or 0
		fillBar.Size = UDim2.new(percentage, 0, 1, 0)
		label.Text = "  " .. text .. ": " .. tostring(currentVal)
		if callback then callback(currentVal) end
	end

	-- Arrow Button Functionalities (Increases/Decreases by 10)
	decButton.MouseButton1Click:Connect(function()
		updateSliderVisuals(currentVal - 10)
	end)

	incButton.MouseButton1Click:Connect(function()
		updateSliderVisuals(currentVal + 10)
	end)

	local draggingSlider = false
	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			local mousePos = UserInputService:GetMouseLocation()
			local relativeX = mousePos.X - barBackground.AbsolutePosition.X
			local percentage = math.clamp(relativeX / barBackground.AbsoluteSize.X, 0, 1)
			updateSliderVisuals(math.round(min + (percentage * (max - min))))
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local mousePos = UserInputService:GetMouseLocation()
			local relativeX = mousePos.X - barBackground.AbsolutePosition.X
			local percentage = math.clamp(relativeX / barBackground.AbsoluteSize.X, 0, 1)
			updateSliderVisuals(math.round(min + (percentage * (max - min))))
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	return {
		Get = function() return currentVal end,
		Set = function(newVal) updateSliderVisuals(newVal) end
	}
end

local function createPureKeybindField(text, defaultKey, order, parentPage, keybindCallback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 32)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parentPage

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Text = "  " .. text
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.TextSize = 14
	label.Font = Enum.Font.SourceSans
	label.Parent = frame

	local bindBtn = Instance.new("TextButton")
	bindBtn.Size = UDim2.new(0.34, 0, 0.8, 0)
	bindBtn.Position = UDim2.new(0.63, 0, 0.1, 0)
	bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
	bindBtn.Text = "[" .. defaultKey.Name .. "]"
	bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	bindBtn.Font = Enum.Font.SourceSansBold
	bindBtn.TextSize = 12
	bindBtn.Parent = frame
	
	local bindCorner = Instance.new("UICorner")
	bindCorner.CornerRadius = UDim.new(0, 4)
	bindCorner.Parent = bindBtn

	local listeningForBind = false
	bindBtn.MouseButton1Click:Connect(function()
		listeningForBind = true
		bindBtn.Text = "..."
		bindBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if not listeningForBind then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForBind = false
			bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
			bindBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
			if keybindCallback then keybindCallback(input.KeyCode) end
		end
	end)
end

local function createLegendRow(text, color, order, parentPage)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -5, 0, 28)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = order
	frame.Parent = parentPage

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 6, 0, 16)
	indicator.Position = UDim2.new(0, 8, 0.5, -8)
	indicator.BackgroundColor3 = color
	indicator.BorderSizePixel = 0
	indicator.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -25, 1, 0)
	label.Position = UDim2.new(0, 20, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 205)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.SourceSans
	label.TextSize = 13
	label.Parent = frame
end

local function createPlayerScrollList(order, parentPage, onSelectedCallback)
	local containerFrame = Instance.new("Frame")
	containerFrame.Size = UDim2.new(1, -5, 0, 110)
	containerFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	containerFrame.BorderSizePixel = 0
	containerFrame.LayoutOrder = order
	containerFrame.Parent = parentPage

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, 0, 0, 20)
	statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
	statusLabel.Text = "  Selected Target: None"
	statusLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.Font = Enum.Font.SourceSansBold
	statusLabel.TextSize = 13
	statusLabel.Parent = containerFrame

	local listScroll = Instance.new("ScrollingFrame")
	listScroll.Size = UDim2.new(1, 0, 1, -20)
	listScroll.Position = UDim2.new(0, 0, 0, 20)
	listScroll.BackgroundTransparency = 1
	listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	listScroll.ScrollBarThickness = 4
	listScroll.Parent = containerFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = listScroll

	local selectedPlayerName = ""

	local function refreshPlayerList()
		for _, child in ipairs(listScroll:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		local itemsCount = 0
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				itemsCount = itemsCount + 1
				local rowBtn = Instance.new("TextButton")
				rowBtn.Size = UDim2.new(1, -6, 0, 24)
				rowBtn.BackgroundColor3 = (selectedPlayerName == player.Name) and Color3.fromRGB(55, 75, 110) or Color3.fromRGB(26, 26, 30)
				rowBtn.BorderSizePixel = 0
				rowBtn.Text = "  " .. player.Name
				rowBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
				rowBtn.TextXAlignment = Enum.TextXAlignment.Left
				rowBtn.Font = Enum.Font.SourceSans
				rowBtn.TextSize = 13
				rowBtn.Parent = listScroll

				rowBtn.MouseButton1Click:Connect(function()
					selectedPlayerName = player.Name
					statusLabel.Text = "  Selected Target: " .. player.Name
					if onSelectedCallback then onSelectedCallback(player) end
					refreshPlayerList()
				end)
			end
		end
		listScroll.CanvasSize = UDim2.new(0, 0, 0, itemsCount * 26)
	end

	refreshPlayerList()
	Players.PlayerAdded:Connect(refreshPlayerList)
	Players.PlayerRemoving:Connect(refreshPlayerList)
end

-- =============================================================================
-- 4. MOVEMENT, FLING & MM2 ESP PHYSICS ENGINE
-- =============================================================================
local flySpeed = 50
local currentWalkSpeed = 16
local currentJumpPower = 50

local flyEnabled = false
local walkSpeedEnabled = false
local jumpPowerEnabled = false
local hiddenfling = false
local mm2EspEnabled = false
local gunEspEnabled = false
local triggerBotEnabled = false

local flyKeybind = Enum.KeyCode.V
local speedKeybind = Enum.KeyCode.R       
local jumpKeybind = Enum.KeyCode.G        
local tpKeybind = Enum.KeyCode.T
local flingKeybind = Enum.KeyCode.X 
local shootKeybind = Enum.KeyCode.Z 
local gunTpKeybind = Enum.KeyCode.H

local selectedTeleportTarget = nil

local flightToggleButton = nil
local speedToggleButton = nil
local jumpToggleButton = nil
local flingToggleButton = nil
local espToggleButton = nil
local gunEspToggleButton = nil
local triggerBotToggleButton = nil

local flySpeedSliderHandle = nil
local walkSpeedSliderHandle = nil
local jumpPowerSliderHandle = nil

local flyConnection = nil
local flingThread = nil
local espRenderConnection = nil
local gunEspConnection = nil
local triggerBotConnection = nil

local hasSavedPosition = false
local savedPreTeleportCFrame = nil

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local function handleFlightPhysics()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local cam = workspace.CurrentCamera

	if not hrp or not hum then return end
	hum.PlatformStand = true

	local dir = Vector3.new(0, 0, 0)
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end

	if dir.Magnitude > 0 then
		hrp.AssemblyLinearVelocity = dir.Unit * flySpeed
	else
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
end

local function toggleFlightState(state)
	flyEnabled = state
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if flyEnabled then
		flyConnection = RunService.RenderStepped:Connect(handleFlightPhysics)
	else
		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		if hum then hum.PlatformStand = false end
		if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
	end
	
	if flightToggleButton then
		flightToggleButton.Text = flyEnabled and "ON" or "OFF"
		flightToggleButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
end

local function toggleSpeedState(state)
	walkSpeedEnabled = state
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = walkSpeedEnabled and currentWalkSpeed or 16
	end
	
	if speedToggleButton then
		speedToggleButton.Text = walkSpeedEnabled and "ON" or "OFF"
		speedToggleButton.BackgroundColor3 = walkSpeedEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
end

local function toggleJumpState(state)
	jumpPowerEnabled = state
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.UseJumpPower = true
		hum.JumpPower = jumpPowerEnabled and currentJumpPower or 50
	end
	
	if jumpToggleButton then
		jumpToggleButton.Text = jumpPowerEnabled and "ON" or "OFF"
		jumpToggleButton.BackgroundColor3 = jumpPowerEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
end

local function runFlingPhysics()
	local c, hrp, vel, movel = nil, nil, nil, 0.1
	while hiddenfling do
		RunService.Heartbeat:Wait()
		c = LocalPlayer.Character
		hrp = c and c:FindFirstChild("HumanoidRootPart")

		if hrp then
			vel = hrp.Velocity
			hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, movel, 0)
			movel = -movel
		end
	end
end

local function toggleFlingState(state)
	hiddenfling = state
	if flingToggleButton then
		flingToggleButton.Text = hiddenfling and "ON" or "OFF"
		flingToggleButton.BackgroundColor3 = hiddenfling and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
	if hiddenfling then
		flingThread = coroutine.create(runFlingPhysics)
		coroutine.resume(flingThread)
	end
end

-- =============================================================================
-- MM2 DYNAMIC ROLE DETECTOR & ESP CORE ENGINE
-- =============================================================================
local function getPlayerMM2Role(player)
	local character = player.Character
	local backpack = player:FindFirstChild("Backpack")
	
	local hasKnife = false
	local hasGun = false
	
	if character then
		if character:FindFirstChild("Knife") or character:FindFirstChild("LocalKnife") then hasKnife = true end
		if character:FindFirstChild("Gun") or character:FindFirstChild("LocalGun") then hasGun = true end
	end
	if backpack then
		if backpack:FindFirstChild("Knife") or backpack:FindFirstChild("LocalKnife") then hasKnife = true end
		if backpack:FindFirstChild("Gun") or backpack:FindFirstChild("LocalGun") then hasGun = true end
	end
	
	if hasKnife then
		return "Murderer", Color3.fromRGB(255, 50, 50)
	elseif hasGun then
		if player:FindFirstChild("FakeRole") or player.Name == "Sheriff" then 
			return "Sheriff", Color3.fromRGB(50, 80, 255)
		else
			return "Hero", Color3.fromRGB(255, 215, 0)
		end
	end
	return "Innocent", Color3.fromRGB(50, 255, 50)
end

local function cleanAllESP()
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("Highlight") and string.sub(v.Name, -4) == "_ESP" then
			v:Destroy()
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("EspBillboard") then
			p.Character.HumanoidRootPart.EspBillboard:Destroy()
		end
	end
end

local function updateMM2EspPhysics()
	if not mm2EspEnabled then return end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local char = player.Character
			local hrp = char.HumanoidRootPart
			
			local roleName, roleColor = getPlayerMM2Role(player)
			
			local highlight = workspace:FindFirstChild(player.Name .. "_ESP")
			if not highlight then
				highlight = Instance.new("Highlight")
				highlight.Name = player.Name .. "_ESP"
				highlight.Adornee = char
				highlight.FillTransparency = 0.5
				highlight.OutlineTransparency = 0
				highlight.Parent = workspace
			end
			highlight.FillColor = roleColor
			highlight.OutlineColor = roleColor
			
			local billboard = hrp:FindFirstChild("EspBillboard")
			if not billboard then
				billboard = Instance.new("BillboardGui")
				billboard.Name = "EspBillboard"
				billboard.Size = UDim2.new(0, 200, 0, 50)
				billboard.AlwaysOnTop = true
				billboard.ExtentsOffset = Vector3.new(0, 3, 0)
				billboard.Parent = hrp
				
				local txt = Instance.new("TextLabel")
				txt.Name = "Label"
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.BackgroundTransparency = 1
				txt.TextSize = 14
				txt.Font = Enum.Font.SourceSansBold
				txt.Parent = billboard
			end
			billboard.Label.Text = player.Name .. "\n[" .. roleName .. "]"
			billboard.Label.TextColor3 = roleColor
		end
	end
end

local function toggleMM2EspState(state)
	mm2EspEnabled = state
	if espToggleButton then
		espToggleButton.Text = mm2EspEnabled and "ON" or "OFF"
		espToggleButton.BackgroundColor3 = mm2EspEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
	
	if mm2EspEnabled then
		espRenderConnection = RunService.Heartbeat:Connect(updateMM2EspPhysics)
	else
		if espRenderConnection then
			espRenderConnection:Disconnect()
			espRenderConnection = nil
		end
		cleanAllESP()
	end
end

-- =============================================================================
-- DROPPED GUN ESP LOGIC ENGINE (Purple Color)
-- =============================================================================
local function highlightGun(object)
	if (object:IsA("Part") and object.Name == "GunDrop") or (object:IsA("Tool") and (object.Name == "Gun" or object.Name == "Remington") and object.Parent == workspace) then
		local targetPart = object:IsA("Tool") and object:FindFirstChild("Handle") or object
		if targetPart and not targetPart:FindFirstChild("GunEspHighlight") then
			local highlight = Instance.new("Highlight")
			highlight.Name = "GunEspHighlight"
			highlight.FillColor = Color3.fromRGB(148, 0, 211) -- Purple
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.4
			highlight.OutlineTransparency = 0
			highlight.Adornee = object
			highlight.Parent = targetPart
		end
	end
end

local function cleanGunEsp()
	for _, object in ipairs(workspace:GetDescendants()) do
		if object:IsA("Highlight") and object.Name == "GunEspHighlight" then
			object:Destroy()
		end
	end
end

local function toggleGunEspState(state)
	gunEspEnabled = state
	if gunEspToggleButton then
		gunEspToggleButton.Text = gunEspEnabled and "ON" or "OFF"
		gunEspToggleButton.BackgroundColor3 = gunEspEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end

	if gunEspEnabled then
		-- Check existing objects
		for _, descendant in ipairs(workspace:GetDescendants()) do
			highlightGun(descendant)
		end
		-- Listen for new objects spawning
		gunEspConnection = workspace.DescendantAdded:Connect(function(descendant)
			task.wait(0.05)
			if gunEspEnabled then highlightGun(descendant) end
		end)
	else
		if gunEspConnection then
			gunEspConnection:Disconnect()
			gunEspConnection = nil
		end
		cleanGunEsp()
	end
end

-- =============================================================================
-- TRIGGER BOT ENGINE (Automation Filter Logic)
-- =============================================================================
local function runTriggerBotPhysics()
	if not triggerBotEnabled then return end
	
	local mouse = LocalPlayer:GetMouse()
	local targetPart = mouse.Target
	if not targetPart then return end
	
	-- Make sure we are actually holding the MM2 gun
	local char = LocalPlayer.Character
	local gun = char and (char:FindFirstChild("Gun") or char:FindFirstChild("Remington"))
	if not gun then return end
	
	-- Verify target parent structure maps to a player model
	local targetModel = targetPart.Parent
	if targetModel:IsA("Accessory") then targetModel = targetModel.Parent end
	
	local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
	if targetPlayer and targetPlayer ~= LocalPlayer then
		local role, _ = getPlayerMM2Role(targetPlayer)
		if role == "Murderer" then
			gun:Activate() -- Internal click mechanic execution
			task.wait(0.3) -- Built-in safety cooldown to prevent weapon lock
		end
	end
end

local function toggleTriggerBotState(state)
	triggerBotEnabled = state
	if triggerBotToggleButton then
		triggerBotToggleButton.Text = triggerBotEnabled and "ON" or "OFF"
		triggerBotToggleButton.BackgroundColor3 = triggerBotEnabled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(180, 60, 60)
	end
	
	if triggerBotEnabled then
		triggerBotConnection = RunService.RenderStepped:Connect(runTriggerBotPhysics)
	else
		if triggerBotConnection then
			triggerBotConnection:Disconnect()
			triggerBotConnection = nil
		end
	end
end

-- =============================================================================
-- PERFORMANCE EVENT-BASED NOTIFICATIONS & ANTI-CAMP TOGGLE MEMORY TRIGGER
-- =============================================================================
local function sendSystemNotification(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 4,
			Button1 = "OK"
		})
	end)
end

workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("Part") and descendant.Name == "GunDrop" then
		sendSystemNotification("⚠️ SHERIFF DOWN!", "The gun has been dropped! Press your keybind to collect it.")
	elseif descendant:IsA("Tool") and (descendant.Name == "Gun" or descendant.Name == "Remington") and descendant.Parent == workspace then
		sendSystemNotification("⚠️ SHERIFF DOWN!", "The gun model spawned in Workspace! Press your keybind to collect it.")
	end
end)

local function manualTeleportToGun()
	local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myHrp then return end

	if hasSavedPosition and savedPreTeleportCFrame then
		myHrp.CFrame = savedPreTeleportCFrame
		hasSavedPosition = false
		savedPreTeleportCFrame = nil
		sendSystemNotification("Anti-Camper", "Instantly teleported back to safety!")
		return
	end

	local targetGunPart = nil
	for _, object in ipairs(workspace:GetDescendants()) do
		if object:IsA("Part") and object.Name == "GunDrop" then
			targetGunPart = object
			break
		elseif object:IsA("Tool") and (object.Name == "Gun" or object.Name == "Remington") and object.Parent == workspace then
			local handle = object:FindFirstChild("Handle")
			if handle then
				targetGunPart = handle
				break
			end
		end
	end
	
	if targetGunPart then
		savedPreTeleportCFrame = myHrp.CFrame
		hasSavedPosition = true
		
		myHrp.CFrame = targetGunPart.CFrame
		sendSystemNotification("Anti-Camp", "Snapped to Gun! Press keybind again to recall instantly.")
	else
		sendSystemNotification("Capper Menu", "No dropped gun detected on map floors.")
	end
end

-- =============================================================================
-- RE-ENGINEERED MECHANIC: CFRAME-LOOK REPLICATION SILENT AIM
-- =============================================================================
local function runSilentAimShoot()
	local myChar = LocalPlayer.Character
	-- Ensure gun is equipped or grab it from backpack automatically
	local myGun = myChar and (myChar:FindFirstChild("Gun") or myChar:FindFirstChild("Remington"))
	if not myGun and LocalPlayer:FindFirstChild("Backpack") then
		local inventoryGun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Remington")
		if inventoryGun then
			inventoryGun.Parent = myChar
			myGun = inventoryGun
			task.wait(0.05)
		end
	end
	
	if not myGun then
		sendSystemNotification("Silent Aim Error", "You must have the Sheriff/Hero gun equipped to fire!")
		return
	end
	
	-- Track down the Murderer
	local murdererPlayer = nil
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local role, _ = getPlayerMM2Role(p)
			if role == "Murderer" then
				murdererPlayer = p
				break
			end
		end
	end
	
	if murdererPlayer and murdererPlayer.Character and murdererPlayer.Character:FindFirstChild("Head") then
		local targetHead = murdererPlayer.Character.Head
		local cam = workspace.CurrentCamera
		
		-- Store exactly where you were looking originally
		local originalCamCFrame = cam.CFrame
		
		-- Snap camera focus vector natively to target head position
		cam.CFrame = CFrame.new(cam.CFrame.Position, targetHead.Position)
		task.wait(0.02) -- Tiny delay to ensure raycast updates to look vector
		
		-- Trigger gun tool activation natively inside engine
		myGun:Activate()
		
		-- Instantly restore view angle back to player's natural perspective
		task.wait(0.02)
		cam.CFrame = originalCamCFrame
		
		sendSystemNotification("🎯 Silent Aim", "Accurate alignment fire shot at: " .. murdererPlayer.Name)
	else
		sendSystemNotification("🎯 Silent Aim", "Murderer not found or currently out of range.")
	end
end

local function performTeleport()
	if selectedTeleportTarget and selectedTeleportTarget.Character then
		local targetHrp = selectedTeleportTarget.Character:FindFirstChild("HumanoidRootPart")
		local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		
		if targetHrp and myHrp then
			myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
		end
	end
end

local function rejoinServer()
	local placeId = game.PlaceId
	local jobId = game.JobId
	if jobId ~= "" then
		TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
	else
		TeleportService:Teleport(placeId, LocalPlayer)
	end
end

local function serverHop()
	local placeId = game.PlaceId
	local currentJobId = game.JobId
	
	local success, result = pcall(function()
		local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
		return HttpService:JSONDecode(game:HttpGet(url))
	end)
	
	if success and result and result.data then
		local targetServer = nil
		for _, server in ipairs(result.data) do
			if server.id ~= currentJobId and server.playing < server.maxPlayers then
				targetServer = server.id
				break
			end
		end
		if targetServer then
			TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
		else
			warn("No alternative servers found.")
		end
	else
		warn("Serverhop error.")
	end
end

-- Input Bind Modifiers
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if UserInputService:IsKeyDown(flyKeybind) then
		if input.KeyCode == Enum.KeyCode.A and flySpeedSliderHandle then
			flySpeedSliderHandle.Set(flySpeedSliderHandle.Get() - 10)
			return
		elseif input.KeyCode == Enum.KeyCode.D and flySpeedSliderHandle then
			flySpeedSliderHandle.Set(flySpeedSliderHandle.Get() + 10)
			return
		end
	end

	if UserInputService:IsKeyDown(speedKeybind) then
		if input.KeyCode == Enum.KeyCode.A and walkSpeedSliderHandle then
			walkSpeedSliderHandle.Set(walkSpeedSliderHandle.Get() - 10)
			return
		elseif input.KeyCode == Enum.KeyCode.D and walkSpeedSliderHandle then
			walkSpeedSliderHandle.Set(walkSpeedSliderHandle.Get() + 10)
			return
		end
	end
	
	if UserInputService:IsKeyDown(jumpKeybind) then
		if input.KeyCode == Enum.KeyCode.A and jumpPowerSliderHandle then
			jumpPowerSliderHandle.Set(jumpPowerSliderHandle.Get() - 10)
			return
		elseif input.KeyCode == Enum.KeyCode.D and jumpPowerSliderHandle then
			jumpPowerSliderHandle.Set(jumpPowerSliderHandle.Get() + 10)
			return
		end
	end

	if input.KeyCode == flyKeybind then
		toggleFlightState(not flyEnabled)
	elseif input.KeyCode == speedKeybind then
		toggleSpeedState(not walkSpeedEnabled)
	elseif input.KeyCode == jumpKeybind then
		toggleJumpState(not jumpPowerEnabled)
	elseif input.KeyCode == flingKeybind then
		toggleFlingState(not hiddenfling)
	elseif input.KeyCode == shootKeybind then
		runSilentAimShoot()
	elseif input.KeyCode == tpKeybind then
		performTeleport()
	elseif input.KeyCode == gunTpKeybind then
		manualTeleportToGun()
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local highlight = workspace:FindFirstChild(player.Name .. "_ESP")
	if highlight then highlight:Destroy() end
end)

workspace.ChildRemoved:Connect(function(child)
	if child.Name == "Normal" then
		hasSavedPosition = false
		savedPreTeleportCFrame = nil
	end
end)

-- =============================================================================
-- 5. MENU DRAW MOUNTING (TAB 1: MM2 FEATURES)
-- =============================================================================
createHeader("-- Murder Mystery 2 ESP Systems", 1, MM2Scroll)

espToggleButton = createConfigurableToggle("ESP Master Switch", nil, 2, MM2Scroll,
	function(state) toggleMM2EspState(state) end,
	nil
)

gunEspToggleButton = createConfigurableToggle("Gun ESP Switch", nil, 3, MM2Scroll,
	function(state) toggleGunEspState(state) end,
	nil
)

createHeader("-- Combat & Automation Utilities", 4, MM2Scroll)

createPureKeybindField("Anti-Camp Gun Warp", gunTpKeybind, 5, MM2Scroll, function(newKey)
	gunTpKeybind = newKey
end)

triggerBotToggleButton = createConfigurableToggle("Murderer Trigger Bot", nil, 6, MM2Scroll,
	function(state) toggleTriggerBotState(state) end,
	nil
)

createHeader("-- Visual Legend Reference", 7, MM2Scroll)
createLegendRow("Murderer Highlight Target Color -> RED", Color3.fromRGB(255, 50, 50), 8, MM2Scroll)
createLegendRow("Sheriff Highlight Target Color -> BLUE", Color3.fromRGB(50, 80, 255), 9, MM2Scroll)
createLegendRow("Hero (Gun Holder) Target Color -> YELLOW", Color3.fromRGB(255, 215, 0), 10, MM2Scroll)
createLegendRow("Innocent Highlight Target Color -> GREEN", Color3.fromRGB(50, 255, 50), 11, MM2Scroll)
createLegendRow("Dropped Gun Target Color -> PURPLE", Color3.fromRGB(148, 0, 211), 12, MM2Scroll)

-- =============================================================================
-- 6. MENU DRAW MOUNTING (TAB 2: UNIVERSAL FEATURES)
-- =============================================================================
createHeader("-- Movement Utilities", 1, UniversalScroll)

flightToggleButton = createConfigurableToggle("Flight Switch", flyKeybind, 2, UniversalScroll, 
	function(state) toggleFlightState(state) end,
	function(newKey) flyKeybind = newKey end
)
flySpeedSliderHandle = createSlider("Fly Speed", 1, 500, 50, 3, UniversalScroll, function(value) 
	flySpeed = value 
end)

speedToggleButton = createConfigurableToggle("Custom Speed", speedKeybind, 4, UniversalScroll, 
	function(state) toggleSpeedState(state) end,
	function(newKey) speedKeybind = newKey end
)
walkSpeedSliderHandle = createSlider("Walk Speed", 16, 500, 16, 5, UniversalScroll, function(value)
	currentWalkSpeed = value
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and walkSpeedEnabled then hum.WalkSpeed = value end
end)

jumpToggleButton = createConfigurableToggle("Custom Jump", jumpKeybind, 6, UniversalScroll, 
	function(state) toggleJumpState(state) end,
	function(newKey) jumpKeybind = newKey end
)
jumpPowerSliderHandle = createSlider("Jump Power", 50, 500, 50, 7, UniversalScroll, function(value)
	currentJumpPower = value
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and jumpPowerEnabled then 
		hum.UseJumpPower = true
		hum.JumpPower = value 
	end
end)

flingToggleButton = createConfigurableToggle("Touch Fling", flingKeybind, 8, UniversalScroll,
	function(state) toggleFlingState(state) end,
	function(newKey) flingKeybind = newKey end
)

createHeader("-- Player Teleportation", 9, UniversalScroll)

createPlayerScrollList(10, UniversalScroll, function(playerObj)
	selectedTeleportTarget = playerObj
end)

createPureKeybindField("Teleport Keybind", tpKeybind, 11, UniversalScroll, function(newKey) 
	tpKeybind = newKey 
end)

createActionButton("Teleport Instantly Now", Color3.fromRGB(60, 140, 60), 12, UniversalScroll, performTeleport)

createHeader("-- Server Management", 13, UniversalScroll)
createActionButton("Rejoin Current Server", Color3.fromRGB(45, 60, 110), 14, UniversalScroll, rejoinServer)
createActionButton("Serverhop (Find New Server)", Color3.fromRGB(110, 50, 110), 15, UniversalScroll, serverHop)

-- Character Spawn Tracking Filters
LocalPlayer.CharacterAdded:Connect(function(character)
	local hum = character:WaitForChild("Humanoid")
	task.wait(0.2)
	if walkSpeedEnabled then hum.WalkSpeed = currentWalkSpeed end
	if jumpPowerEnabled then
		hum.UseJumpPower = true
		hum.JumpPower = currentJumpPower
	end
end)
