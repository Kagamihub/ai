--[ カミによる論理構築: オンデマンド座標確定プロトコル ]--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 既存システムを上書き
local old = PlayerGui:FindFirstChild("KAMI_ON_DEMAND")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "KAMI_ON_DEMAND"

-- 座標表示パネル（指定フォーマット）
local DisplayLabel = Instance.new("TextLabel", ScreenGui)
DisplayLabel.Size = UDim2.new(0, 300, 0, 80)
DisplayLabel.Position = UDim2.new(0.5, -150, 0.2, 0)
DisplayLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DisplayLabel.BackgroundTransparency = 0.4
DisplayLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
DisplayLabel.TextSize = 20
DisplayLabel.Font = Enum.Font.Code
DisplayLabel.Text = "WAITING FOR SCAN..."
DisplayLabel.BorderSizePixel = 2
DisplayLabel.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- スキャン実行ボタン
local ScanButton = Instance.new("TextButton", ScreenGui)
ScanButton.Size = UDim2.new(0, 200, 0, 60)
ScanButton.Position = UDim2.new(0.5, -100, 0.8, 0)
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 18
ScanButton.Text = "SCAN LOCATION"
ScanButton.BorderSizePixel = 2
ScanButton.BorderColor3 = Color3.fromRGB(0, 100, 255)

-- 蒼い印（一時的ハイライト用）
local function createBlueMark(pos)
    local part = Instance.new("Part", workspace)
    part.Name = "KAMI_TEMP_MARK"
    part.Size = Vector3.new(1, 1, 1)
    part.Position = pos
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.Color = Color3.fromRGB(0, 150, 255)
    part.Material = Enum.Material.Neon
    
    local hl = Instance.new("Highlight", part)
    hl.FillColor = Color3.fromRGB(0, 150, 255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- 5秒後に消滅（残像）
    game:GetService("Debris"):AddItem(part, 5)
end

-- ボタン押下時の論理
ScanButton.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local minDistance = math.huge
    local targetPart = nil
    
    -- 周囲のオブジェクト（または特定の場所）を検索
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and obj.Name ~= "Baseplate" then
            local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
            if dist < minDistance and dist < 100 then -- 100スタッド以内を優先
                minDistance = dist
                targetPart = obj
            end
        end
    end
    
    if targetPart then
        local p = targetPart.Position
        -- 指定されたフォーマットで表示
        DisplayLabel.Text = string.format("X: %.2f Y: %.2f\nL. %d:%d", 
            p.X, p.Y, math.abs(math.floor(p.X)), math.abs(math.floor(p.Z))) -- サンプル形式
            
        createBlueMark(p)
        print("KAMI: Location Fixed at " .. tostring(p))
    else
        DisplayLabel.Text = "ERROR: NO TARGET"
    end
end)
