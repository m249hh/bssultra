local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local Theme = {
	TopBar = Color3.fromRGB(20, 20, 20),
	TabBar = Color3.fromRGB(0, 0, 0),
	Tab = Color3.fromRGB(60, 60, 60),
	TabSelected = Color3.fromRGB(90, 90, 90),
	Button = Color3.fromRGB(30, 30, 30),
	ButtonHover = Color3.fromRGB(50, 50, 50),
	Toggle = Color3.fromRGB(30, 30, 30),
	ToggleOn = Color3.fromRGB(0, 200, 100),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(180, 180, 180),
	Accent = Color3.fromRGB(0, 200, 100),
}

function Library:CreateWindow(title, images)
	local window = {}
	local tabs = {}
	local selectedTab = nil
	images = images or {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "UILibrary"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.fromOffset(300, 300)
	mainFrame.Position = UDim2.fromScale(0.5, 0.5)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = gui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = mainFrame

	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.Position = UDim2.fromOffset(0, 0)
	topBar.BackgroundColor3 = Theme.TopBar
	topBar.BorderSizePixel = 0
	topBar.ZIndex = 10
	topBar.Parent = mainFrame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 8)
	topBarCorner.Parent = topBar

	local topBarFix = Instance.new("Frame")
	topBarFix.Size = UDim2.new(1, 0, 0, 8)
	topBarFix.Position = UDim2.new(0, 0, 1, -8)
	topBarFix.BackgroundColor3 = Theme.TopBar
	topBarFix.BorderSizePixel = 0
	topBarFix.ZIndex = 10
	topBarFix.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 1, 0)
	titleLabel.Position = UDim2.fromOffset(15, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "UI Library"
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 11
	titleLabel.Parent = topBar

	local bodyFrame = Instance.new("Frame")
	bodyFrame.Size = UDim2.new(1, 0, 1, -40)
	bodyFrame.Position = UDim2.fromOffset(0, 40)
	bodyFrame.BackgroundTransparency = 1
	bodyFrame.BorderSizePixel = 0
	bodyFrame.ZIndex = 1
	bodyFrame.Parent = mainFrame

	local imgIndex = 1
	local zIndex = 1
	while imgIndex <= #images do
		local id = images[imgIndex]
		local transparency = images[imgIndex + 1]
		if type(transparency) ~= "number" then
			transparency = 0
			imgIndex = imgIndex + 1
		else
			imgIndex = imgIndex + 2
		end
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.fromScale(1, 1)
		img.AnchorPoint = Vector2.new(1, 0)
		img.Position = UDim2.fromScale(1, 0)
		img.BackgroundTransparency = 1
		img.ImageTransparency = transparency
		img.ZIndex = zIndex
		img.Image = id
		img.ScaleType = Enum.ScaleType.Crop
		img.Parent = bodyFrame
		zIndex = zIndex + 1
	end

	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(1, 0, 0, 35)
	tabBar.Position = UDim2.fromOffset(0, 0)
	tabBar.BackgroundColor3 = Theme.TabBar
	tabBar.BackgroundTransparency = 0.4
	tabBar.BorderSizePixel = 0
	tabBar.ZIndex = 10
	tabBar.Parent = bodyFrame

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.Parent = tabBar

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0, 8)
	tabPadding.Parent = tabBar

	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, 0, 1, -35)
	contentArea.Position = UDim2.fromOffset(0, 35)
	contentArea.BackgroundTransparency = 1
	contentArea.ZIndex = 10
	contentArea.Parent = bodyFrame

	local dragging, dragStart, startPos
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	topBar.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	topBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	function window:AddTab(name)
		local tab = {}

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.fromOffset(70, 25)
		tabBtn.BackgroundColor3 = Theme.Tab
		tabBtn.BackgroundTransparency = 0.4
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = name
		tabBtn.TextColor3 = Theme.SubText
		tabBtn.TextSize = 13
		tabBtn.Font = Enum.Font.Gotham
		tabBtn.ZIndex = 11
		tabBtn.Parent = tabBar

		local tabBtnCorner = Instance.new("UICorner")
		tabBtnCorner.CornerRadius = UDim.new(0, 6)
		tabBtnCorner.Parent = tabBtn

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 1
		tabContent.BorderSizePixel = 0
		tabContent.ScrollBarThickness = 3
		tabContent.ScrollBarImageColor3 = Theme.Accent
		tabContent.ZIndex = 10
		tabContent.Visible = false
		tabContent.Parent = contentArea

		local contentLayout = Instance.new("UIListLayout")
		contentLayout.Padding = UDim.new(0, 8)
		contentLayout.Parent = tabContent

		local contentPadding = Instance.new("UIPadding")
		contentPadding.PaddingLeft = UDim.new(0, 12)
		contentPadding.PaddingRight = UDim.new(0, 12)
		contentPadding.PaddingTop = UDim.new(0, 10)
		contentPadding.Parent = tabContent

		contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabContent.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 20)
		end)

		local function selectTab()
			for _, t in pairs(tabs) do
				t.content.Visible = false
				t.button.BackgroundColor3 = Theme.Tab
				t.button.TextColor3 = Theme.SubText
			end
			tabContent.Visible = true
			tabBtn.BackgroundColor3 = Theme.TabSelected
			tabBtn.TextColor3 = Theme.Text
			selectedTab = tab
		end

		tabBtn.MouseButton1Click:Connect(selectTab)
		tabs[name] = {button = tabBtn, content = tabContent}
		if not selectedTab then selectTab() end

		function tab:AddButton(label, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 38)
			btn.BackgroundColor3 = Theme.Button
			btn.BackgroundTransparency = 0.3
			btn.BorderSizePixel = 0
			btn.Text = label
			btn.TextColor3 = Theme.Text
			btn.TextSize = 14
			btn.Font = Enum.Font.Gotham
			btn.ZIndex = 11
			btn.Parent = tabContent

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 6)
			btnCorner.Parent = btn

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonHover}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Button}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
			return btn
		end

		function tab:AddToggle(label, default, callback)
			local toggled = default or false

			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, 0, 0, 38)
			container.BackgroundColor3 = Theme.Toggle
			container.BackgroundTransparency = 0.3
			container.BorderSizePixel = 0
			container.ZIndex = 11
			container.Parent = tabContent

			local containerCorner = Instance.new("UICorner")
			containerCorner.CornerRadius = UDim.new(0, 6)
			containerCorner.Parent = container

			local toggleLabel = Instance.new("TextLabel")
			toggleLabel.Size = UDim2.new(1, -60, 1, 0)
			toggleLabel.Position = UDim2.fromOffset(12, 0)
			toggleLabel.BackgroundTransparency = 1
			toggleLabel.Text = label
			toggleLabel.TextColor3 = Theme.Text
			toggleLabel.TextSize = 14
			toggleLabel.Font = Enum.Font.Gotham
			toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			toggleLabel.ZIndex = 12
			toggleLabel.Parent = container

			local toggleBg = Instance.new("Frame")
			toggleBg.Size = UDim2.fromOffset(40, 22)
			toggleBg.Position = UDim2.new(1, -52, 0.5, -11)
			toggleBg.BackgroundColor3 = toggled and Theme.ToggleOn or Theme.Button
			toggleBg.BorderSizePixel = 0
			toggleBg.ZIndex = 12
			toggleBg.Parent = container

			local toggleBgCorner = Instance.new("UICorner")
			toggleBgCorner.CornerRadius = UDim.new(1, 0)
			toggleBgCorner.Parent = toggleBg

			local toggleCircle = Instance.new("Frame")
			toggleCircle.Size = UDim2.fromOffset(16, 16)
			toggleCircle.Position = toggled and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)
			toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			toggleCircle.BorderSizePixel = 0
			toggleCircle.ZIndex = 13
			toggleCircle.Parent = toggleBg

			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(1, 0)
			circleCorner.Parent = toggleCircle

			local clickable = Instance.new("TextButton")
			clickable.Size = UDim2.fromScale(1, 1)
			clickable.BackgroundTransparency = 1
			clickable.Text = ""
			clickable.ZIndex = 14
			clickable.Parent = container

			clickable.MouseButton1Click:Connect(function()
				toggled = not toggled
				TweenService:Create(toggleBg, TweenInfo.new(0.2), {
					BackgroundColor3 = toggled and Theme.ToggleOn or Theme.Button
				}):Play()
				TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
					Position = toggled and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)
				}):Play()
				if callback then callback(toggled) end
			end)

			return container
		end

		function tab:AddLabel(text)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 30)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Theme.SubText
			lbl.TextSize = 13
			lbl.Font = Enum.Font.Gotham
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.ZIndex = 11
			lbl.Parent = tabContent
			return lbl
		end

		return tab
	end

	return window
end

return Library
