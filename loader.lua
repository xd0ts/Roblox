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
		local TweenService = game:GetService("TweenService")
		local RunService = game:GetService("RunService")
		local lp = Players.LocalPlayer
		while not lp do
			task.wait()
			lp = Players.LocalPlayer
		end
		local parent = lp:WaitForChild("PlayerGui")
		pcall(function()
			if type(env.gethui) == "function" then
				parent = env.gethui()
			end
		end)
		local old = parent:FindFirstChild("xd0tsAccess")
		if old then
			old:Destroy()
		end

		local ACCENT = Color3.fromRGB(88, 140, 255)
		local ACCENT2 = Color3.fromRGB(160, 100, 255)
		local RED = Color3.fromRGB(235, 80, 90)
		local text = tostring(msg)
		text = text:sub(1, 1):upper() .. text:sub(2)

		local gui = Instance.new("ScreenGui")
		gui.Name = "xd0tsAccess"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 999
		gui.Parent = parent

		local card = Instance.new("CanvasGroup")
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.new(0.5, 0, 0.5, 14)
		card.Size = UDim2.fromOffset(380, 210)
		card.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
		card.BorderSizePixel = 0
		card.GroupTransparency = 1
		card.ClipsDescendants = true
		card.Parent = gui
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

		local stroke = Instance.new("UIStroke", card)
		stroke.Thickness = 1.5
		stroke.Color = Color3.new(1, 1, 1)
		stroke.Transparency = 1
		local grad = Instance.new("UIGradient", stroke)
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, ACCENT),
			ColorSequenceKeypoint.new(0.5, ACCENT2),
			ColorSequenceKeypoint.new(1, ACCENT),
		})

		local shapes = {}
		for i = 1, 9 do
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Text = (i % 2 == 0) and "O" or "X"
			l.Font = Enum.Font.GothamBold
			l.TextSize = 22 + (i % 3) * 10
			l.TextColor3 = (i % 3 == 0) and ACCENT2 or ACCENT
			l.TextTransparency = 0.9
			l.Size = UDim2.fromOffset(40, 40)
			l.Position = UDim2.fromOffset((i * 47) % 360, (i * 61) % 200)
			l.Rotation = (i * 37) % 360
			l.ZIndex = 1
			l.Parent = card
			shapes[#shapes + 1] = { l, 6 + (i % 4) * 3, ((i * 53) % 100) / 100 }
		end

		local function label(text2, x, y, w, h, size, color, font, align)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Position = UDim2.fromOffset(x, y)
			l.Size = UDim2.fromOffset(w, h)
			l.Text = text2
			l.TextColor3 = color
			l.TextSize = size
			l.Font = font
			l.TextXAlignment = align or Enum.TextXAlignment.Left
			l.TextWrapped = true
			l.ZIndex = 3
			l.Parent = card
			return l
		end

		label("xd0ts", 20, 16, 120, 24, 22, ACCENT, Enum.Font.GothamBold)
		label("private client", 20, 40, 140, 16, 12, Color3.fromRGB(130, 130, 150), Enum.Font.Gotham)

		local pill = Instance.new("Frame")
		pill.AnchorPoint = Vector2.new(1, 0)
		pill.Position = UDim2.new(1, -20, 0, 20)
		pill.Size = UDim2.fromOffset(112, 24)
		pill.BackgroundColor3 = RED
		pill.BackgroundTransparency = 0.82
		pill.BorderSizePixel = 0
		pill.ZIndex = 3
		pill.Parent = card
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
		local pillStroke = Instance.new("UIStroke", pill)
		pillStroke.Color = RED
		pillStroke.Transparency = 0.5
		local pillText = Instance.new("TextLabel")
		pillText.BackgroundTransparency = 1
		pillText.Size = UDim2.fromScale(1, 1)
		pillText.Text = "ACCESS DENIED"
		pillText.Font = Enum.Font.GothamBold
		pillText.TextSize = 11
		pillText.TextColor3 = RED
		pillText.ZIndex = 4
		pillText.Parent = pill

		local line = Instance.new("Frame")
		line.Position = UDim2.fromOffset(20, 68)
		line.Size = UDim2.new(1, -40, 0, 1)
		line.BackgroundColor3 = Color3.fromRGB(40, 40, 54)
		line.BorderSizePixel = 0
		line.ZIndex = 3
		line.Parent = card

		label(text, 20, 80, 340, 28, 20, Color3.fromRGB(240, 240, 248), Enum.Font.GothamBold)
		label("You don't have access to xd0ts with this key.", 20, 110, 340, 18, 13, Color3.fromRGB(170, 170, 188), Enum.Font.Gotham)
		label("message @xd0ts on discord for support", 20, 130, 340, 18, 13, Color3.fromRGB(120, 120, 140), Enum.Font.Gotham)

		local function button(txt, x, w, fill, textColor)
			local b = Instance.new("TextButton")
			b.Position = UDim2.new(0, x, 1, -46)
			b.Size = UDim2.fromOffset(w, 30)
			b.BackgroundColor3 = fill
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Text = txt
			b.Font = Enum.Font.GothamBold
			b.TextSize = 13
			b.TextColor3 = textColor
			b.ZIndex = 4
			b.Parent = card
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
			b.MouseEnter:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play()
			end)
			b.MouseLeave:Connect(function()
				TweenService:Create(b, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
			end)
			return b
		end

		local copy = button("Copy Discord", 20, 170, ACCENT, Color3.fromRGB(10, 10, 16))
		local close = button("Close", 200, 160, Color3.fromRGB(34, 34, 46), Color3.fromRGB(225, 225, 235))

		copy.MouseButton1Click:Connect(function()
			local fn = env.setclipboard or env.toclipboard or env.set_clipboard
			if type(fn) == "function" then
				pcall(fn, "xd0ts")
				copy.Text = "Copied!"
			else
				copy.Text = "Discord: xd0ts"
			end
			task.delay(1.6, function()
				if copy.Parent then
					copy.Text = "Copy Discord"
				end
			end)
		end)

		local closing = false
		local function dismiss()
			if closing then
				return
			end
			closing = true
			TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				GroupTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 14),
			}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.22), { Transparency = 1 }):Play()
			task.delay(0.25, function()
				gui:Destroy()
			end)
		end
		close.MouseButton1Click:Connect(dismiss)

		TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			GroupTransparency = 0,
			Position = UDim2.fromScale(0.5, 0.5),
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.35), { Transparency = 0.15 }):Play()

		local t0 = os.clock()
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not gui.Parent then
				conn:Disconnect()
				return
			end
			local t = os.clock() - t0
			grad.Rotation = (t * 60) % 360
			for _, sh in ipairs(shapes) do
				local l = sh[1]
				l.Rotation = l.Rotation + sh[2] * 0.016
				local y = (sh[3] * 260 + t * sh[2]) % 260 - 30
				l.Position = UDim2.fromOffset(l.Position.X.Offset, y)
			end
		end)

		task.delay(25, dismiss)
	end)
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
