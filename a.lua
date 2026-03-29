-- [[ ALONE: Precision Coordinate HUD - Format Ver. ]] --
-- [[ 干渉レベル: 100 / 指定フォーマット同期プロトコル ]] --

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- 座標表示HUD（指定フォーマット：X: -000.00 Y: -000.00 L. 101:11）
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0, 400, 0, 50)
coordLabel.Position = UDim2.new(0.5, -200, 0.05, 0)
coordLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
coordLabel.BackgroundTransparency = 0.7
coordLabel.TextColor3 = Color3.fromRGB(0, 255, 100) -- 解析用グリーン
coordLabel.Font = Enum.Font.Code
coordLabel.TextSize = 20
coordLabel.Parent = screenGui

-- ボタン：単一座標固定（前回のロジックを継承）
local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(0, 280, 0, 50)
actionButton.Position = UDim2.new(0.5, -140, 0.85, 0)
actionButton.Text = "TARGET LOCK / UPDATE"
actionButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0) -- 警告色
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.Font = Enum.Font.Code
actionButton.Parent = screenGui

local activeMarker = nil

-- リアルタイム更新ループ（指定フォーマットの適用）
game:GetService("RunService").RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        -- 指定された書式: X: -331.42 Y: -4.33 L. 101:11
        -- ※Z軸をYとして表示する等の調整が必要な場合はここで行う
        coordLabel.Text = string.format("X: %.2f Y: %.2f L. 101:11", pos.X, pos.Z)
    end
end)

-- 座標固定プロトコル
local function updatePositionMarker()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if activeMarker then
        activeMarker:Destroy()
    end

    local currentPos = char.HumanoidRootPart.Position

    local marker = Instance.new("Part")
    marker.Name = "Observation_Point"
    marker.Size = Vector3.new(1, 300, 1)
    marker.Position = currentPos
    marker.Anchored = true
    marker.CanCollide = false
    marker.BrickColor = BrickColor.new("Cyan")
    marker.Material = Enum.Material.Neon
    marker.Transparency = 0.5
    marker.Parent = game.Workspace
    
    activeMarker = marker
    
    -- ログ出力も指定フォーマットに準拠
    print(string.format("[!] 座標ロック完了: X: %.2f Y: %.2f L. 101:11", currentPos.X, currentPos.Z))
end

actionButton.MouseButton1Click:Connect(updatePositionMarker)
