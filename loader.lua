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
	env.xd0ts_key = key
end
env.script_key = nil
_G.script_key = nil
if type(shared) == "table" then
	shared.script_key = nil
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

		local ACCENT = Color3.fromHSV(0.725, 0.6, 0.97)
		local ACCENT2 = Color3.fromHSV(0.66, 0.6, 0.97)
		local RED = Color3.fromRGB(235, 80, 90)
		local text = tostring(msg)
		text = text:sub(1, 1):upper() .. text:sub(2)

		local gui = Instance.new("ScreenGui")
		gui.Name = "xd0tsAccess"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 999
		gui.Parent = parent

		local card = Instance.new("Frame")
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.new(0.5, 0, 0.5, 14)
		card.Size = UDim2.fromOffset(380, 210)
		card.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
		card.BorderSizePixel = 0
		card.ClipsDescendants = true
		card.Parent = gui
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

		local stroke = Instance.new("UIStroke", card)
		stroke.Thickness = 1.5
		stroke.Color = Color3.new(1, 1, 1)
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

		local function label(text2, x, y, w, h, size, color, font)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Position = UDim2.fromOffset(x, y)
			l.Size = UDim2.fromOffset(w, h)
			l.Text = text2
			l.TextColor3 = color
			l.TextSize = size
			l.Font = font
			l.TextXAlignment = Enum.TextXAlignment.Left
			l.TextWrapped = true
			l.ZIndex = 3
			l.Parent = card
			return l
		end

		label("xd0ts", 20, 16, 120, 24, 22, ACCENT, Enum.Font.GothamBold)
		label("private client", 20, 40, 140, 16, 12, Color3.fromRGB(130, 130, 148), Enum.Font.Gotham)

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
		line.BackgroundColor3 = Color3.fromRGB(34, 34, 48)
		line.BorderSizePixel = 0
		line.ZIndex = 3
		line.Parent = card

		label(text, 20, 80, 340, 28, 20, Color3.fromRGB(235, 235, 243), Enum.Font.GothamBold)
		label("You don't have access to xd0ts with this key.", 20, 110, 340, 18, 13, Color3.fromRGB(170, 170, 188), Enum.Font.Gotham)
		label("message @xd0ts on discord for support", 20, 130, 340, 18, 13, Color3.fromRGB(130, 130, 148), Enum.Font.Gotham)

		local closing = false
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
				if not closing then
					TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = fill:Lerp(Color3.new(1, 1, 1), 0.12) }):Play()
				end
			end)
			b.MouseLeave:Connect(function()
				if not closing then
					TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = fill }):Play()
				end
			end)
			return b
		end

		local copy = button("Copy Discord", 20, 170, ACCENT, Color3.fromRGB(10, 10, 14))
		local close = button("Close", 200, 160, Color3.fromRGB(31, 31, 44), Color3.fromRGB(235, 235, 243))

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

		local fades = {}
		local function collect(inst)
			local props = {}
			if inst:IsA("GuiObject") then
				props.BackgroundTransparency = inst.BackgroundTransparency
				if inst:IsA("TextLabel") or inst:IsA("TextButton") then
					props.TextTransparency = inst.TextTransparency
				end
			elseif inst:IsA("UIStroke") then
				props.Transparency = inst.Transparency
			end
			if next(props) then
				fades[#fades + 1] = { inst, props }
			end
		end
		collect(card)
		collect(stroke)
		for _, d in ipairs(card:GetDescendants()) do
			collect(d)
		end

		local function fadeTo(out, duration, style, dir)
			local info = TweenInfo.new(duration, style, dir)
			for _, f in ipairs(fades) do
				local goal = {}
				for prop, orig in pairs(f[2]) do
					goal[prop] = out and 1 or orig
				end
				TweenService:Create(f[1], info, goal):Play()
			end
		end

		for _, f in ipairs(fades) do
			for prop in pairs(f[2]) do
				f[1][prop] = 1
			end
		end
		fadeTo(false, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5),
		}):Play()

		local function dismiss()
			if closing then
				return
			end
			closing = true
			fadeTo(true, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 14),
			}):Play()
			task.delay(0.26, function()
				gui:Destroy()
			end)
		end
		close.MouseButton1Click:Connect(dismiss)

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
