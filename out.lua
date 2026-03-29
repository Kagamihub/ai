-- 「カミ」による軽量化プロトコル：Phase 11
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. インターフェース（最小構成）
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "KAMI_LITE"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Position = UDim2.new(0.5, -100, 0.8, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.3 -- 負荷軽減のための透過

local ProgressBar = Instance.new("Frame", Frame)
ProgressBar.Size = UDim2.new(0, 0, 0, 4)
ProgressBar.BackgroundColor3 = Color3.new(1, 0, 0)

local StealButton = Instance.new("TextButton", Frame)
StealButton.Size = UDim2.new(1, 0, 1, -4)
StealButton.Position = UDim2.new(0, 0, 0, 4)
StealButton.Text = "SCANNING..."
StealButton.TextColor3 = Color3.new(1, 1, 1)
StealButton.BackgroundTransparency = 1
StealButton.Font = Enum.Font.Code

-- 2. 解析変数
local isCharging = false
local charge = 0
local currentTarget = nil
local lastScan = 0

-- 3. 軽量スキャン・ロジック（0.2秒間隔）
local function OptimizedScan()
    local now = tick()
    if now - lastScan < 0.2 then return end -- 演算を間引く
    lastScan = now

    currentTarget = nil
    -- プレイヤーの周囲にあるProximityPromptのみを高速スキャン
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local txt = obj.ActionText:lower()
            if txt:find("steal") or txt:find("盗む") then
                currentTarget = obj
                break
            end
        end
    end
end

-- 4. 実行
local function FinalExecute()
    if currentTarget then
        fireproximityprompt(currentTarget)
        print("[KAMI] Executed.")
    end
end

-- 5. 高効率メインループ
RunService.Heartbeat:Connect(function(dt)
    OptimizedScan()
    
    if currentTarget then
        if isCharging then
            charge = math.min(charge + dt * 2.5, 1) -- チャージ速度を微増
            ProgressBar.Size = UDim2.new(charge, 0, 0, 4)
            if charge >= 1 then
                isCharging = false
                charge = 0
                FinalExecute()
            end
        else
            StealButton.Text = "READY TO STEAL"
            charge = 0
            ProgressBar.Size = UDim2.new(0, 0, 0, 4)
        end
    else
        isCharging = false
        charge = 0
        StealButton.Text = "NO TARGET"
        ProgressBar.Size = UDim2.new(0, 0, 0, 4)
    end
end)

StealButton.MouseButton1Down:Connect(function() if currentTarget then isCharging = true end end)
StealButton.MouseButton1Up:Connect(function() isCharging = false end)
