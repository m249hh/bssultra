-- Unload previous instance if already running
if _G.BSSUnload then
	pcall(_G.BSSUnload)
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local tokenFolder = workspace:WaitForChild("Collectibles")
local particlesFolder = workspace:WaitForChild("Particles")

local rootPart
local MOVE_SPEED = 75
local running = true

-- Called to fully stop this instance
local function unload()
	running = false
	if _G.BSSLibrary then
		pcall(function() _G.BSSLibrary:Destroy() end)
		_G.BSSLibrary = nil
	end
	-- Reset all toggle values
	local function clearVal(name)
		local v = player:FindFirstChild(name)
		if v then v.Value = false end
	end
	clearVal("AutoSteal")
	clearVal("AutoStealSticker")
	clearVal("TeleportSticker")
	clearVal("AbilityTokens")
end
_G.BSSUnload = unload

local STICKER_IDS = {
	["rbxassetid://1873723985"] = true,
	["rbxassetid://4520736128"] = true,
	["rbxassetid://15859974319"] = true,
	["rbxassetid://15460472468"] = true,
	["rbxassetid://15460472604"] = true,
	["rbxassetid://15460472736"] = true,
	["rbxassetid://15460472901"] = true,
	["rbxassetid://15460473043"] = true,
	["rbxassetid://15460473252"] = true,
	["rbxassetid://15460473405"] = true,
	["rbxassetid://15460473581"] = true,
	["rbxassetid://15460473734"] = true,
	["rbxassetid://15460473858"] = true,
	["rbxassetid://15460473987"] = true,
	["rbxassetid://15460474176"] = true,
	["rbxassetid://15460474326"] = true,
	["rbxassetid://15460474562"] = true,
	["rbxassetid://15460474729"] = true,
	["rbxassetid://15460474929"] = true,
	["rbxassetid://15460475166"] = true,
	["rbxassetid://15460475388"] = true,
	["rbxassetid://15460475510"] = true,
	["rbxassetid://15460475675"] = true,
	["rbxassetid://15460475957"] = true,
	["rbxassetid://15460476117"] = true,
	["rbxassetid://15460476313"] = true,
	["rbxassetid://15460476433"] = true,
	["rbxassetid://15460476565"] = true,
	["rbxassetid://15460476691"] = true,
	["rbxassetid://15460476908"] = true,
	["rbxassetid://15460477173"] = true,
	["rbxassetid://15460477388"] = true,
	["rbxassetid://15460477625"] = true,
	["rbxassetid://15460477801"] = true,
	["rbxassetid://15460477943"] = true,
	["rbxassetid://15460478123"] = true,
	["rbxassetid://15460478252"] = true,
	["rbxassetid://15460478405"] = true,
	["rbxassetid://15460478559"] = true,
	["rbxassetid://15460478724"] = true,
	["rbxassetid://15460478837"] = true,
	["rbxassetid://15460478976"] = true,
	["rbxassetid://15460479124"] = true,
	["rbxassetid://15460479248"] = true,
	["rbxassetid://15460479436"] = true,
	["rbxassetid://15460479658"] = true,
	["rbxassetid://15460479864"] = true,
	["rbxassetid://15460480097"] = true,
	["rbxassetid://15460480244"] = true,
	["rbxassetid://15460480420"] = true,
	["rbxassetid://15460480608"] = true,
	["rbxassetid://15460480800"] = true,
	["rbxassetid://15460482962"] = true,
	["rbxassetid://15460483169"] = true,
	["rbxassetid://15460483337"] = true,
	["rbxassetid://15460483597"] = true,
	["rbxassetid://15460483804"] = true,
	["rbxassetid://15460484053"] = true,
	["rbxassetid://15460484249"] = true,
	["rbxassetid://15460484453"] = true,
	["rbxassetid://15460484620"] = true,
	["rbxassetid://15460484784"] = true,
	["rbxassetid://15460484934"] = true,
	["rbxassetid://15460485138"] = true,
	["rbxassetid://15460486642"] = true,
	["rbxassetid://15482553370"] = true,
	["rbxassetid://15482553467"] = true,
	["rbxassetid://15482553557"] = true,
	["rbxassetid://15482553699"] = true,
	["rbxassetid://15482553910"] = true,
	["rbxassetid://15482554069"] = true,
	["rbxassetid://15618201288"] = true,
	["rbxassetid://15482554400"] = true,
	["rbxassetid://15482554502"] = true,
	["rbxassetid://15482554608"] = true,
	["rbxassetid://15482554735"] = true,
	["rbxassetid://15482554891"] = true,
	["rbxassetid://15482554967"] = true,
	["rbxassetid://15482555065"] = true,
	["rbxassetid://15482555178"] = true,
	["rbxassetid://15482555269"] = true,
	["rbxassetid://15482555362"] = true,
	["rbxassetid://15482555511"] = true,
	["rbxassetid://15482555722"] = true,
	["rbxassetid://15482556448"] = true,
	["rbxassetid://15482493052"] = true,
	["rbxassetid://15482492928"] = true,
	["rbxassetid://15482492783"] = true,
	["rbxassetid://15482492663"] = true,
	["rbxassetid://15482492393"] = true,
	["rbxassetid://15482492278"] = true,
	["rbxassetid://15482492184"] = true,
	["rbxassetid://15482492097"] = true,
	["rbxassetid://15529300429"] = true,
	["rbxassetid://15482492019"] = true,
	["rbxassetid://15482491908"] = true,
	["rbxassetid://15482491802"] = true,
	["rbxassetid://15482491636"] = true,
	["rbxassetid://15482491543"] = true,
	["rbxassetid://15482491440"] = true,
	["rbxassetid://15482491337"] = true,
	["rbxassetid://15482491192"] = true,
	["rbxassetid://15482491096"] = true,
	["rbxassetid://15482490996"] = true,
	["rbxassetid://15482490904"] = true,
	["rbxassetid://15482490830"] = true,
	["rbxassetid://15482490715"] = true,
	["rbxassetid://15482490589"] = true,
	["rbxassetid://15482490472"] = true,
	["rbxassetid://15482490363"] = true,
	["rbxassetid://15482490209"] = true,
	["rbxassetid://15482490134"] = true,
	["rbxassetid://15482490039"] = true,
	["rbxassetid://15482489925"] = true,
	["rbxassetid://15482489782"] = true,
	["rbxassetid://15482489671"] = true,
	["rbxassetid://15482489588"] = true,
	["rbxassetid://15482489441"] = true,
	["rbxassetid://15482489237"] = true,
	["rbxassetid://15482489075"] = true,
	["rbxassetid://15482553280"] = true,
	["rbxassetid://15482930304"] = true,
	["rbxassetid://15482934195"] = true,
	["rbxassetid://15482934333"] = true,
	["rbxassetid://15482934402"] = true,
	["rbxassetid://15482934482"] = true,
	["rbxassetid://15482934581"] = true,
	["rbxassetid://15482934708"] = true,
	["rbxassetid://15482934870"] = true,
	["rbxassetid://15482935014"] = true,
	["rbxassetid://15482935577"] = true,
	["rbxassetid://15482935685"] = true,
	["rbxassetid://15482935830"] = true,
	["rbxassetid://15482935937"] = true,
	["rbxassetid://15482936051"] = true,
	["rbxassetid://15482936154"] = true,
	["rbxassetid://15482936837"] = true,
	["rbxassetid://15482936952"] = true,
	["rbxassetid://15484768616"] = true,
	["rbxassetid://15529300591"] = true,
	["rbxassetid://15529300776"] = true,
	["rbxassetid://15529300924"] = true,
	["rbxassetid://15529301041"] = true,
	["rbxassetid://15529301296"] = true,
	["rbxassetid://15529301414"] = true,
	["rbxassetid://15529301538"] = true,
	["rbxassetid://15529301645"] = true,
	["rbxassetid://15529301745"] = true,
	["rbxassetid://15529301903"] = true,
	["rbxassetid://15529302054"] = true,
	["rbxassetid://15529302210"] = true,
	["rbxassetid://15529302363"] = true,
	["rbxassetid://15529302537"] = true,
	["rbxassetid://15529302667"] = true,
	["rbxassetid://15529302771"] = true,
	["rbxassetid://15529302907"] = true,
	["rbxassetid://15529302996"] = true,
	["rbxassetid://15529303094"] = true,
	["rbxassetid://15529303251"] = true,
	["rbxassetid://15529303377"] = true,
	["rbxassetid://15529303572"] = true,
	["rbxassetid://15529303721"] = true,
	["rbxassetid://15529303897"] = true,
	["rbxassetid://15529304062"] = true,
	["rbxassetid://15529304162"] = true,
	["rbxassetid://15529304300"] = true,
	["rbxassetid://15529304439"] = true,
	["rbxassetid://15529309006"] = true,
	["rbxassetid://15529309170"] = true,
	["rbxassetid://15529309333"] = true,
	["rbxassetid://15529309468"] = true,
	["rbxassetid://15529309703"] = true,
	["rbxassetid://15529309901"] = true,
	["rbxassetid://15529310090"] = true,
	["rbxassetid://15529310183"] = true,
	["rbxassetid://15529310326"] = true,
	["rbxassetid://15529310452"] = true,
	["rbxassetid://15529633314"] = true,
	["rbxassetid://15529633409"] = true,
	["rbxassetid://15529633523"] = true,
	["rbxassetid://15529633649"] = true,
	["rbxassetid://15529301204"] = true,
	["rbxassetid://15618107311"] = true,
	["rbxassetid://15618107456"] = true,
	["rbxassetid://15618107558"] = true,
	["rbxassetid://15618107778"] = true,
	["rbxassetid://15618107954"] = true,
	["rbxassetid://15618108161"] = true,
	["rbxassetid://15618108366"] = true,
	["rbxassetid://15618108514"] = true,
	["rbxassetid://15618108724"] = true,
	["rbxassetid://15618109827"] = true,
	["rbxassetid://15618142445"] = true,
	["rbxassetid://15618142562"] = true,
	["rbxassetid://15618142653"] = true,
	["rbxassetid://15618142716"] = true,
	["rbxassetid://15618142798"] = true,
	["rbxassetid://15618142912"] = true,
	["rbxassetid://15618142972"] = true,
	["rbxassetid://15618143079"] = true,
	["rbxassetid://15460475809"] = true,
	["rbxassetid://15482935199"] = true,
	["rbxassetid://15460472333"] = true,
	["rbxassetid://15460485365"] = true,
	["rbxassetid://15617968516"] = true,
	["rbxassetid://15617968590"] = true,
	["rbxassetid://15617968675"] = true,
	["rbxassetid://15617968799"] = true,
	["rbxassetid://15617968922"] = true,
	["rbxassetid://15617969016"] = true,
	["rbxassetid://15617969092"] = true,
	["rbxassetid://15617969167"] = true,
	["rbxassetid://15617969251"] = true,
	["rbxassetid://15617969350"] = true,
	["rbxassetid://15617969456"] = true,
	["rbxassetid://15617969558"] = true,
	["rbxassetid://15617969675"] = true,
	["rbxassetid://15617969867"] = true,
	["rbxassetid://15617969951"] = true,
	["rbxassetid://15618201411"] = true,
	["rbxassetid://15618201469"] = true,
	["rbxassetid://15618201536"] = true,
	["rbxassetid://15618201612"] = true,
	["rbxassetid://15618201673"] = true,
	["rbxassetid://15618201755"] = true,
	["rbxassetid://15618201849"] = true,
	["rbxassetid://15618201919"] = true,
	["rbxassetid://15618202004"] = true,
	["rbxassetid://15617805255"] = true,
	["rbxassetid://15617805381"] = true,
	["rbxassetid://15617805499"] = true,
	["rbxassetid://15617805611"] = true,
	["rbxassetid://15617805712"] = true,
	["rbxassetid://15617805864"] = true,
	["rbxassetid://15617805930"] = true,
	["rbxassetid://15617805993"] = true,
	["rbxassetid://15617806096"] = true,
	["rbxassetid://15617806189"] = true,
	["rbxassetid://15617806273"] = true,
	["rbxassetid://15617806342"] = true,
	["rbxassetid://15617806418"] = true,
	["rbxassetid://15617806641"] = true,
	["rbxassetid://15617806727"] = true,
	["rbxassetid://15617806925"] = true,
	["rbxassetid://15617807109"] = true,
	["rbxassetid://15617826387"] = true,
	["rbxassetid://15617807338"] = true,
	["rbxassetid://15482554195"] = true,
	["rbxassetid://15742510252"] = true,
	["rbxassetid://15742510646"] = true,
	["rbxassetid://15742510384"] = true,
	["rbxassetid://15742510808"] = true,
	["rbxassetid://15742511004"] = true,
	["rbxassetid://15742510713"] = true,
	["rbxassetid://15742511120"] = true,
	["rbxassetid://15742510568"] = true,
	["rbxassetid://15742510907"] = true,
	["rbxassetid://15742510461"] = true,
	["rbxassetid://17047441010"] = true,
	["rbxassetid://17047440768"] = true,
	["rbxassetid://17047440899"] = true,
	["rbxassetid://17047441929"] = true,
	["rbxassetid://70614540118942"] = true,
	["rbxassetid://17153568399"] = true,
	["rbxassetid://17845773325"] = true,
	["rbxassetid://17845773108"] = true,
	["rbxassetid://17845772962"] = true,
}

local ABILITY_IDS = {
	["rbxassetid://2499514197"] = true,
	["rbxassetid://2499540966"] = true,
	["rbxassetid://1442725244"] = true,
	["rbxassetid://1442764904"] = true,
	["rbxassetid://1442859163"] = true,
	["rbxassetid://1442863423"] = true,
	["rbxassetid://1629649299"] = true,
	["rbxassetid://65867881"] = true,
	["rbxassetid://1629547638"] = true,
	["rbxassetid://1839454544"] = true,
}

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

local martinsugar6k = player:FindFirstChild("TeleportSticker")
if not martinsugar6k then
	martinsugar6k = Instance.new("BoolValue")
	martinsugar6k.Name = "TeleportSticker"
	martinsugar6k.Value = false
	martinsugar6k.Parent = player
end

local abilityTokenEnabled = player:FindFirstChild("AbilityTokens")
if not abilityTokenEnabled then
	abilityTokenEnabled = Instance.new("BoolValue")
	abilityTokenEnabled.Name = "AbilityTokens"
	abilityTokenEnabled.Value = false
	abilityTokenEnabled.Parent = player
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

local function isStickerToken(part)
	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("Decal") and STICKER_IDS[child.Texture] then
			return true
		end
	end
	return false
end

local function isAbilityToken(part)
	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("Decal") and ABILITY_IDS[child.Texture] then
			return true
		end
	end
	return false
end

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

local function TeleportToSticker(stickerToken)
	if not stickerToken or not rootPart then return end
	if humanoid and humanoid.Health <= 0 then return end
	rootPart.CFrame = CFrame.new(stickerToken.Position + Vector3.new(0, 3, 0))
	task.wait(0.1)
	if stickerToken and stickerToken.Parent then
		if not stickerToken:FindFirstChild("isTouched") then
			stickerToken:Destroy()
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

local function FindNearestStickerToken()
	local nearest, minDist = nil, math.huge
	local rpPos = rootPart.Position
	for _, v in ipairs(tokenFolder:GetChildren()) do
		if v:IsA("BasePart") and v:IsDescendantOf(workspace) and isStickerToken(v) then
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

local function FindNearestAbilityToken()
	local nearest, minDist = nil, math.huge
	local rpPos = rootPart.Position
	for _, v in ipairs(tokenFolder:GetChildren()) do
		if v:IsA("BasePart") and v:IsDescendantOf(workspace) and isAbilityToken(v) then
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
	while running and task.wait(0.05) do
		if martinsugar2k.Value and rootPart then
			local token = FindNearestToken()
			if token and isAliveToken(token) then
				pcall(function() moveToToken(token) end)
			end
		end
	end
end)

task.spawn(function()
	while running and task.wait(0.05) do
		if martinsugar4k.Value and rootPart then
			local StickerGlob = FindNearestSticker()
			if StickerGlob then
				pcall(function() moveToSticker(StickerGlob) end)
			end
		end
	end
end)

task.spawn(function()
	while running and task.wait(0.05) do
		if martinsugar6k.Value and rootPart then
			local stickerToken = FindNearestStickerToken()
			if stickerToken then
				pcall(function() TeleportToSticker(stickerToken) end)
			end
		end
	end
end)

task.spawn(function()
	while running and task.wait(0.05) do
		if abilityTokenEnabled.Value and rootPart then
			local abilityToken = FindNearestAbilityToken()
			if abilityToken and abilityToken:IsDescendantOf(workspace) then
				pcall(function() moveToToken(abilityToken) end)
			end
		end
	end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/Library.lua"))()

_G.BSSLibrary = Library

local Window = Library:CreateWindow("BSS Script", {
	"rbxassetid://104032410076701", 0,
})

-- Patch scrollbar color to dark on all current and future ScrollingFrames in the UI
task.defer(function()
	local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("UILibrary")
	if gui then
		for _, v in ipairs(gui:GetDescendants()) do
			if v:IsA("ScrollingFrame") then
				v.ScrollBarImageColor3 = Color3.fromRGB(10, 10, 10)
			end
		end
		gui.DescendantAdded:Connect(function(v)
			if v:IsA("ScrollingFrame") then
				v.ScrollBarImageColor3 = Color3.fromRGB(10, 10, 10)
			end
		end)
	end
end)

local Tab1 = Window:AddTab("Token")

Tab1:AddToggle("Token Stealer", false, function(state)
	martinsugar2k.Value = state
end)

Tab1:AddToggle("Sticker Stealer", false, function(state)
	martinsugar4k.Value = state
end)

Tab1:AddToggle("Teleport Sticker Collector", false, function(state)
	martinsugar6k.Value = state
end)

Tab1:AddToggle("Ability Tokens", false, function(state)
	abilityTokenEnabled.Value = state
end)

Tab1:AddButton("Remove Permanent Tokens [Recommended]", function()
	destroyPermTokens()
end)

local TabBattle = Window:AddTab("Battle")

TabBattle:AddButton("Ladybugs", function()
	-- TODO
end)

TabBattle:AddButton("Rhino Beetles", function()
	-- TODO
end)

TabBattle:AddButton("Mantises", function()
	-- TODO
end)

TabBattle:AddButton("Spider", function()
	-- TODO
end)

TabBattle:AddButton("Werewolf", function()
	-- TODO
end)

local Tab2 = Window:AddTab("Misc")

Tab2:AddButton("Teleport to Hive Hub", function()
	martinsugar2k.Value = false
	martinsugar4k.Value = false
	martinsugar6k.Value = false
	abilityTokenEnabled.Value = false
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
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/m249hh/bssultra/refs/heads/main/bss_script.lua"))()
	end)
end)

Tab2:AddButton("Load Infinite Yield", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

local Tab3 = Window:AddTab("Info")
Tab3:AddLabel("Made By m249")
