-- // Brainrot Cheat - LocalScript (วางใน StarterPlayerScripts)
-- ล่องหนแบบ Server + GUI ปุ่ม + ชื่อปลอม + กระโดดสูง/วิ่งเร็ว

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid", 8)

-- ──────────────────────────────────────────────
--  ตั้งค่าต่าง ๆ (แก้ตรงนี้ได้เลย)
-- ──────────────────────────────────────────────

local FAKE_NAME          = "Brainrot Thief"       -- ชื่อปลอมที่แสดงเหนือหัว
local JUMP_POWER         = 150
local WALK_SPEED         = 50
local INVISIBLE_COLOR    = Color3.fromRGB(180, 0, 255)   -- สีตัวเมื่อล่องหน (ถ้าอยากให้มี hint)

-- ชื่อ RemoteEvent (ต้องตรงกับฝั่ง Server ด้วย)
local REMOTE_NAME        = "ToggleInvisibility"

-- ──────────────────────────────────────────────
--  สร้าง RemoteEvent ถ้ายังไม่มี (เพื่อความสะดวก)
-- ──────────────────────────────────────────────

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = REMOTE_NAME
    remote.Parent = ReplicatedStorage
end

-- ──────────────────────────────────────────────
--  ฟังก์ชันตั้งค่าตัวละครเมื่อเกิดใหม่
-- ──────────────────────────────────────────────

local function setupCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid", 8)
    if not humanoid then return end

    humanoid.JumpPower = JUMP_POWER
    humanoid.WalkSpeed = WALK_SPEED

    -- ชื่อปลอมเหนือหัว
    local head = char:WaitForChild("Head")
    local existing = head:FindFirstChild("FakeName")
    if existing then existing:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FakeName"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = FAKE_NAME
    label.TextColor3 = Color3.fromRGB(255, 80, 80)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Parent = bb

    bb.Parent = head
end

-- เรียกใช้ตอนตัวละครโหลดครั้งแรก
if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

-- ──────────────────────────────────────────────
--  สร้าง GUI ปุ่มล่องหน
-- ──────────────────────────────────────────────

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 140, 0, 60)
frame.Position = UDim2.new(0.5, -70, 0.92, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -12, 1, -12)
button.Position = UDim2.new(0, 6, 0, 6)
button.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Text = "ล่องหน (OFF)"
button.Parent = frame

local uiCornerBtn = Instance.new("UICorner")
uiCornerBtn.CornerRadius = UDim.new(0, 10)
uiCornerBtn.Parent = button

-- ตัวแปรสถานะ
local isInvisible = false

local function updateButton()
    if isInvisible then
        button.Text = "ล่องหน (ON)"
        button.BackgroundColor3 = Color3.fromRGB(180, 60, 100)
    else
        button.Text = "ล่องหน (OFF)"
        button.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
    end
end

-- ฟังก์ชัน toggle + ส่งไป server
local function toggleInvisibility()
    isInvisible = not isInvisible
    updateButton()

    -- ส่งไป server ให้จัดการ transparency จริง
    remote:FireServer(isInvisible)
end

button.MouseButton1Click:Connect(toggleInvisibility)

-- ทางเลือก: กดปุ่ม E ก็ toggle ได้ (ถ้าอยากใช้ทั้งปุ่มและคีย์บอร์ด)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        toggleInvisibility()
    end
end)

-- ──────────────────────────────────────────────
--  รับสถานะจาก server (กรณี reset หรือ sync)
-- ──────────────────────────────────────────────

remote.OnClientEvent:Connect(function(serverIsInvisible)
    isInvisible = serverIsInvisible
    updateButton()
end)

print("[Brainrot Cheat] พร้อมใช้งาน → ปุ่มล่องหน / กด E")
