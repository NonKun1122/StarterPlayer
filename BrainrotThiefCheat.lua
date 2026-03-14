-- สร้าง GUI ใน CoreGui (สำหรับ Executor) หรือ PlayerGui (สำหรับรันใน Studio)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ลบ UI เก่าทิ้งถ้ามีการรันซ้ำ
if CoreGui:FindFirstChild("BrainrotMenu") then
    CoreGui.BrainrotMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui -- ถ้าใช้ใน Roblox Studio ให้เปลี่ยนเป็น player.PlayerGui

-- ปุ่มสำหรับเปิด/ปิด UI (ปุ่มเล็กๆ บนหน้าจอ)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 40)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.Text = "เปิด UI"
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextSize = 18
OpenButton.Parent = ScreenGui

-- กรอบ UI หลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true -- ทำให้ลาก UI ได้
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Brainrot Hub"
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = MainFrame

-- ฟังก์ชันสร้างปุ่มใน Menu
local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = MainFrame
    return btn
end

local btnSpeedJump = createButton("วิ่งเร็ว + กระโดดสูง (เปิด)", 60)
local btnInvis = createButton("ล่องหน (Client)", 110)
local btnFakeName = createButton("ปลอมชื่อตัวละคร", 160)
local btnTPHome = createButton("วาร์ปกลับบ้าน", 210)
local btnClose = createButton("ปิด UI", 280)
btnClose.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

-- ตัวแปรเก็บสถานะ
local isBoosted = false
local isInvis = false

-- ระบบเปิด/ปิด UI
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
btnClose.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 1. วิ่งเร็ว + กระโดดสูง
btnSpeedJump.MouseButton1Click:Connect(function()
    isBoosted = not isBoosted
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if isBoosted then
            char.Humanoid.WalkSpeed = 100 -- ปรับความเร็ววิ่งตรงนี้
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = 150 -- ปรับความสูงกระโดดตรงนี้
            btnSpeedJump.Text = "วิ่งเร็ว + กระโดดสูง (ปิด)"
            btnSpeedJump.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        else
            char.Humanoid.WalkSpeed = 16 -- ค่าเริ่มต้น Roblox
            char.Humanoid.JumpPower = 50 -- ค่าเริ่มต้น Roblox
            btnSpeedJump.Text = "วิ่งเร็ว + กระโดดสูง (เปิด)"
            btnSpeedJump.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)

-- 2. ล่องหน (Transparency)
btnInvis.MouseButton1Click:Connect(function()
    isInvis = not isInvis
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = isInvis and 1 or 0
                end
            end
        end
        if isInvis then
            btnInvis.Text = "ยกเลิกล่องหน"
            btnInvis.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        else
            btnInvis.Text = "ล่องหน (Client)"
            btnInvis.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)

-- 3. ปลอมชื่อตัวละคร
btnFakeName.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        -- เปลี่ยนชื่อเหนือหัว (เปลี่ยนได้แค่ในจอเราเท่านั้น)
        char.Humanoid.DisplayName = "ผู้เล่นปริศนา" 
        btnFakeName.Text = "เปลี่ยนชื่อแล้ว!"
        task.wait(2)
        btnFakeName.Text = "ปลอมชื่อตัวละคร"
    end
end)

-- 4. วาร์ปกลับบ้าน (แก้ไขพิกัด X, Y, Z ได้เลย)
btnTPHome.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- เปลี่ยน 0, 50, 0 เป็นพิกัดจุดเกิดหรือบ้านในแมพของคุณ
        local homePosition = CFrame.new(0, 50, 0) 
        char:PivotTo(homePosition)
    end
end)
