local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local tokenFolder = workspace:WaitForChild("Collectibles")
local particlesFolder = workspace:WaitForChild("Particles")

local rootPart
local MOVE_SPEED = 75

local function cacheRoot()
	local char = player.Character or player.CharacterAdded:Wait()
	rootPart = char:WaitForChild("HumanoidRootPart")
end
cacheRoot()
player.CharacterAdded:Connect(cacheRoot)

local martinsugar2k = player:FindFirstChild("AutoSteal")
if not martinsugar2k then
	martinsugar2k = Instance.new("BoolValue")
	martinsugar2k.Name = "AutoSteal"
	martinsugar2k.Value = false
	martinsugar2k.Parent = player
end

local martinsugar4k = player:FindFirstChild("AutoStealSticker")
if not martinsugar4k then
	martinsugar4k = Instance.new("BoolValue")
	martinsugar4k.Name = "AutoStealSticker"
	martinsugar4k.Value = false
	martinsugar4k.Parent = player
end

local function destroyPermTokens()
	tokenFolder:ClearAllChildren()
end

local function isValidRotation(part)
	local r = part.Orientation
	local tol = 1
	local function flat(v)
		return math.abs(v) <= tol or math.abs(math.abs(v) - 180) <= tol
	end
	return flat(r.X) and flat(r.Z)
end

local function isAliveToken(v)
	return v and v.Parent == tokenFolder and v:IsDescendantOf(workspace)
end

local humanoid
local moving = false

local function cacheCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	rootPart = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end
cacheCharacter()
player.CharacterAdded:Connect(cacheCharacter)

local function moveToToken(token)
	if not token or not humanoid or humanoid.Health <= 0 then return end
	if moving then return end
	moving = true
	humanoid.WalkSpeed = MOVE_SPEED
	humanoid:MoveTo(token.Position)
	local connection
	local reached = false
	connection = humanoid.MoveToFinished:Connect(function()
		reached = true
	end)
	local startTime = tick()
	while not reached and tick() - startTime < 3 do
		if not token or not token.Parent then break end
		task.wait()
	end
	if connection then connection:Disconnect() end
	moving = false
	task.wait()
	moving = false
	if token and token.Parent then
		if not token:FindFirstChild("isTouched") then
			token:Destroy()
		end
	end
end

local function moveToSticker(StickerGlob)
	if not StickerGlob or not humanoid or humanoid.Health <= 0 then return end
	if moving then return end
	moving = true
	humanoid.WalkSpeed = MOVE_SPEED
	local reached = false
	local connection
	connection = humanoid.MoveToFinished:Connect(function()
		reached = true
	end)
	humanoid:MoveTo(StickerGlob.Position)
	local startTime = tick()
	while not reached and tick() - startTime < 0.5 do
		if not StickerGlob or not StickerGlob.Parent then break end
		if humanoid.Health <= 0 then break end
		task.wait()
	end
	if connection then connection:Disconnect() end
	moving = false
	if StickerGlob and StickerGlob.Parent then
		if not StickerGlob:FindFirstChild("isTouched") then
			StickerGlob:Destroy()
		end
	end
end

local function FindNearestSticker()
	local nearest, minDist = nil, math.huge
	local rpPos = rootPart.Position
	for _, v in ipairs(particlesFolder:GetChildren()) do
		if v:IsA("BasePart") and v.Transparency == 1 and v.Name == "StickerGlob" then
			if not v:FindFirstChild("isTouched") then
				local dist = (rpPos - v.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

local function FindNearestToken()
	local nearest, minDist = nil, math.huge
	local rpPos = rootPart.Position
	for _, v in ipairs(tokenFolder:GetChildren()) do
		if v:IsA("BasePart") and isAliveToken(v) and isValidRotation(v) and v.CanTouch then
			if not v:FindFirstChild("isTouched") then
				local dist = (rpPos - v.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

task.spawn(function()
	while task.wait(0.05) do
		if martinsugar2k.Value and rootPart then
			local token = FindNearestToken()
			if token and isAliveToken(token) then
				pcall(function() moveToToken(token) end)
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.05) do
		if martinsugar4k.Value and rootPart then
			local StickerGlob = FindNearestSticker()
			if StickerGlob then
				pcall(function() moveToSticker(StickerGlob) end)
			end
		end
	end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow("BSS Script", {
	"rbxassetid://104032410076701", 0,
})

local Tab1 = Window:AddTab("Token")

Tab1:AddToggle("Token Stealer", false, function(state)
	martinsugar2k.Value = state
end)

Tab1:AddToggle("Sticker Stealer", false, function(state)
	martinsugar4k.Value = state
end)

Tab1:AddButton("Remove Permanent Tokens [Recommended]", function()
	destroyPermTokens()
end)

local Tab2 = Window:AddTab("Misc")

Tab2:AddButton("Teleport to Hive Hub", function()
	martinsugar2k.Value = false
	martinsugar4k.Value = false
	pcall(function()
		if queue_on_teleport then
			queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/bss_script.lua"))()]])
		elseif syn and syn.queue_on_teleport then
			syn.queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/bss_script.lua"))()]])
		end
	end)
	TeleportService:Teleport(15579077077, player)
end)

Tab2:AddButton("Reload Script", function()
	martinsugar2k.Value = false
	martinsugar4k.Value = false
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/bss_script.lua"))()
	end)
end)

Tab2:AddButton("Load Infinite Yield", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

local Tab3 = Window:AddTab("Info")
Tab3:AddLabel("Made By m249")


