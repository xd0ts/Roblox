local SERVER = "https://xd0ts-keys.clientapi.workers.dev"

local env = (type(getgenv) == "function" and getgenv()) or _G
local key = env.script_key or _G.script_key or (type(shared) == "table" and shared.script_key)
if type(key) ~= "string" or key == "" then
	pcall(function()
		key = getfenv(1).script_key or getfenv(0).script_key
	end)
end
if type(key) == "string" then
	key = key:gsub("%s+", "")
	env.script_key = key
end

local function warnUser(msg)
	warn("[xd0ts] " .. msg)
	pcall(function()
		local Players = game:GetService("Players")
		local lp = Players.LocalPlayer
		while not lp do
			task.wait()
			lp = Players.LocalPlayer
		end
		local parent = lp:WaitForChild("PlayerGui")
		pcall(function()
			local fn = env.gethui
			if type(fn) == "function" then
				parent = fn()
			end
		end)
		local old = parent:FindFirstChild("xd0tsAccess")
		if old then
			old:Destroy()
		end
		local gui = Instance.new("ScreenGui")
		gui.Name = "xd0tsAccess"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 999
		gui.Parent = parent

		local box = Instance.new("Frame")
		box.AnchorPoint = Vector2.new(0.5, 0.5)
		box.Position = UDim2.fromScale(0.5, 0.5)
		box.Size = UDim2.fromOffset(340, 140)
		box.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
		box.BorderSizePixel = 0
		box.Parent = gui
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
		local stroke = Instance.new("UIStroke", box)
		stroke.Color = Color3.fromRGB(200, 60, 60)
		stroke.Thickness = 1.5

		local function label(text, y, h, size, color, font)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Position = UDim2.new(0, 16, 0, y)
			l.Size = UDim2.new(1, -32, 0, h)
			l.Text = text
			l.TextColor3 = color
			l.TextSize = size
			l.Font = font
			l.TextWrapped = true
			l.Parent = box
		end
		label("Access denied", 12, 30, 22, Color3.fromRGB(230, 80, 80), Enum.Font.GothamBold)
		label(msg, 46, 36, 14, Color3.fromRGB(210, 210, 220), Enum.Font.Gotham)
		label("message @xd0ts on discord for support", 86, 20, 13, Color3.fromRGB(140, 140, 160), Enum.Font.Gotham)

		local close = Instance.new("TextButton")
		close.AnchorPoint = Vector2.new(0.5, 1)
		close.Position = UDim2.new(0.5, 0, 1, -8)
		close.Size = UDim2.fromOffset(90, 22)
		close.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
		close.BorderSizePixel = 0
		close.Text = "Close"
		close.TextColor3 = Color3.fromRGB(220, 220, 230)
		close.TextSize = 13
		close.Font = Enum.Font.Gotham
		close.Parent = box
		Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
		close.MouseButton1Click:Connect(function()
			gui:Destroy()
		end)
		task.delay(20, function()
			if gui.Parent then
				gui:Destroy()
			end
		end)
	end)
end

if type(key) ~= "string" or key == "" then
	return warnUser("No key set. Use getgenv().script_key = \"YOUR-KEY\" before the loader.")
end

local Players = game:GetService("Players")
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local uid = Players.LocalPlayer.UserId

local ok, body = pcall(function()
	return game:HttpGet(SERVER .. "/load?key=" .. key .. "&uid=" .. uid)
end)
if not ok or type(body) ~= "string" then
	return warnUser("Could not reach the key server: " .. tostring(body))
end
if body:sub(1, 9) == "-- xd0ts:" then
	return warnUser((body:gsub("^%-%- xd0ts: ?", "")))
end

local fn, err = loadstring(body)
if not fn then
	return warnUser("Script failed to compile: " .. tostring(err))
end
fn()
