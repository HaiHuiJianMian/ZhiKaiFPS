local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GUI_NAME = "ZhiKaiPlayerStatus"

local Old = PlayerGui:FindFirstChild(GUI_NAME)
if Old then
    Old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = GUI_NAME
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(230, 118)
Main.Position = UDim2.fromOffset(18, 175)
Main.BackgroundColor3 = Color3.fromRGB(12, 14, 19)
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1
Stroke.Transparency = 0.2
Stroke.Color = Color3.fromRGB(80, 88, 108)
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 25)
Title.Position = UDim2.fromOffset(10, 7)
Title.BackgroundTransparency = 1
Title.Text = "玩家状态"
Title.TextColor3 = Color3.fromRGB(245, 247, 252)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local function makeLabel(y)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 24)
    Label.Position = UDim2.fromOffset(10, y)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(220, 224, 232)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Main
    return Label
end

local Health = makeLabel(32)
local Speed = makeLabel(56)
local PlayTime = makeLabel(80)

Health.Text = "生命值: -- / --"
Speed.Text = "步行速度: --"
PlayTime.Text = "游玩时间: 00:00:00"

local StartTime = os.clock()
local Humanoid

local function setupCharacter(Character)
    Humanoid = Character:WaitForChild("Humanoid")
end

if Player.Character then
    setupCharacter(Player.Character)
end

Player.CharacterAdded:Connect(setupCharacter)

local function formatTime(seconds)
    seconds = math.floor(seconds)

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

RunService.RenderStepped:Connect(function()
    if Humanoid and Humanoid.Parent then
        local CurrentHealth = math.max(0, math.floor(Humanoid.Health + 0.5))
        local MaxHealth = math.max(0, math.floor(Humanoid.MaxHealth + 0.5))
        local WalkSpeed = math.floor(Humanoid.WalkSpeed + 0.5)

        Health.Text = string.format("生命值: %d / %d", CurrentHealth, MaxHealth)
        Speed.Text = string.format("步行速度: %d", WalkSpeed)
    else
        Health.Text = "生命值: -- / --"
        Speed.Text = "步行速度: --"
    end

    PlayTime.Text = "游玩时间: " .. formatTime(os.clock() - StartTime)
end)
