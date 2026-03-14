-- // BrainrotThief.lua - LocalScript (StarterPlayerScripts)
-- Features: Server-side invis (others can't see you), Fake name overhead, High jump + speed, Toggle GUI button

local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local TweenService        = game:GetService("TweenService")

local player              = Players.LocalPlayer
local playerGui           = player:WaitForChild("PlayerGui")

-- ────────────── CONFIG (แก้ตรงนี้ได้เลย) ──────────────
local CONFIG = {
    FAKE_NAME            = "Brainrot Thief",
    JUMP_POWER           = 150,
    WALK_SPEED           = 48,
    REMOTE_NAME          = "Brainrot_InvisToggle",
    GUI_BUTTON_TEXT_ON   = "ล่องหน ON",
    GUI_BUTTON_TEXT_OFF  = "ล่องหน OFF",
    GUI_POSITION         = UDim2.new(1, -180, 1, -90),  -- มุมขวาล่าง
}

-- สร้าง RemoteEvent ถ้ายังไม่มี
local remote = ReplicatedStorage:FindFirstChild(CONFIG.REMOTE_NAME)
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = CONFIG.REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

-- ────────────── ฟังก์ชันช่วย ──────────────
local function applyFakeName(head)
    local old = head:FindFirstChild("FakeNameTag")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FakeNameTag"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 240, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3.8, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = CONFIG.FAKE_NAME
    txt.TextColor3 = Color3.fromRGB(255, 70, 70)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBlack
    txt.TextStrokeTransparency = 0.6
    txt.TextStrokeColor3 = Color3.new(0,0,0)
    txt.Parent = bb

    bb.Parent = head
end

local function buffCharacter(humanoid)
    if humanoid then
        humanoid.JumpPower = CONFIG.JUMP_POWER
        humanoid.WalkSpeed = CONFIG.WALK_SPEED
    end
end

-- ────────────── ตั้งค่าตัวละครเมื่อเกิด ──────────────
local isInvisible = false

local function onCharacterAdded(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    local head     = char:WaitForChild("Head", 10)

    if not (humanoid and head) then return end

    buffCharacter(humanoid)
    applyFakeName(head)

    -- sync invis กับ server ใหม่ (ป้องกันบั๊กหลังตาย)
    remote:FireServer(isInvisible)
end

if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- ────────────── GUI ปุ่ม toggle ล่องหน ──────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotToggleUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 60)
frame.Position = CONFIG.GUI_POSITION
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.92, 0, 0.8, 0)
button.Position = UDim2.new(0.04, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(80, 50, 140)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Text = CONFIG.GUI_BUTTON_TEXT_OFF
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = button

local function updateButton()
    if isInvisible then
        button.Text = CONFIG.GUI_BUTTON_TEXT_ON
        button.BackgroundColor3 = Color3.fromRGB(140, 50, 80)
    else
        button.Text = CONFIG.GUI_BUTTON_TEXT_OFF
        button.BackgroundColor3 = Color3.fromRGB(80, 50, 140)
    end
end

local function toggleInvis()
    isInvisible = not isInvisible
    updateButton()
    remote:FireServer(isInvisible)
end

button.MouseButton1Click:Connect(toggleInvis)

-- sync จาก server (กรณี server บังคับรีเซ็ต)
remote.OnClientEvent:Connect(function(serverIsInvis)
    isInvisible = serverIsInvis
    updateButton()
end)

updateButton()

print("[BrainrotThief] พร้อมใช้งาน | ชื่อ: " .. CONFIG.FAKE_NAME .. " | Jump: " .. CONFIG.JUMP_POWER .. " | Speed: " .. CONFIG.WALK_SPEED)
