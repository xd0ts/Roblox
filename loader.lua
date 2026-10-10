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
		game:GetService("StarterGui"):SetCore("SendNotification", { Title = "xd0ts", Text = msg, Duration = 6 })
	end)
end

if type(key) ~= "string" or key == "" then
	return warnUser('Set your key first: getgenv().script_key = "XD-XXXX-XXXX-XXXX"')
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
	return warnUser("Could not reach the key server")
end
if body:sub(1, 9) == "-- xd0ts:" then
	return warnUser((body:gsub("^%-%- xd0ts: ?", "")))
end

local fn, err = loadstring(body)
if not fn then
	return warnUser("Script failed to compile: " .. tostring(err))
end
fn()
