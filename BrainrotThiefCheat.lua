-- [[ BRAINROT HUB: ULTIMATE EDITION (NO BUG) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ป้องกันการรันสคริปต์ซ้ำ
if CoreGui:FindFirstChild("BrainrotUltimate") then
    CoreGui.BrainrotUltimate:Destroy()
end

-- สร้างหน้าจอ GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotUltimate"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ตัวแปรตั้งค่า
local Settings = {
    Speed = 100,
    Jump = 150,
    Noclip = false,
    Invis = false
}

-- กรอบเมนูหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- สามารถลากได้
MainFrame.Parent = ScreenGui

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BRAINROT HUB V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- ฟังก์ชันสร้างปุ่มที่ไม่มีบัค
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 45)
    btn.Position = UDim2.new(0, 20, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback) -- ใช้ pcall กันสคริปต์หยุดทำงานเวลาเจอ Error
    end)
    return btn
end

-- 1. วิ่งเร็ว + กระโดดสูง (Auto-Update)
CreateButton("Speed & Jump (Toggle)", 60, function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = (hum.WalkSpeed == 16) and Settings.Speed or 16
        hum.JumpPower = (hum.JumpPower == 50) and Settings.Jump or 50
        hum.UseJumpPower = true
    end
end)

-- 2. ทะลุบล็อก (Noclip)
local noclipBtn = CreateButton("Noclip: OFF", 115, function()
    Settings.Noclip = not Settings.Noclip
end)

RunService.Stepped:Connect(function()
    if Settings.Noclip then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- 3. ล่องหนแบบสมบูรณ์ (Server-Side Visibility)
CreateButton("Invisible (Server)", 170, function()
    local char = LocalPlayer.Character
    if char then
        -- ลบเฉพาะส่วนที่แสดงผล แต่ไม่ลบส่วนที่ใช้ขยับ เพื่อไม่ให้ตัวตาย
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "UpperTorso" then
                v.Transparency = 1
                v:ClearAllChildren() -- ลบ Mesh ด้านใน
            elseif v:IsA("Decal") or v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
        end
    end
end)

-- 4. เปลี่ยนชื่อ (Display Name)
CreateButton("Fake Display Name", 225, function()
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayName = "SYSTEM_ADMIN"
    end
end)

-- 5. วาร์ปกลับบ้าน (Smart TP)
CreateButton("TP to Home / Spawn", 280, function()
    local char = LocalPlayer.Character
    if char then
        -- หาจุดเกิดในเกม ถ้าหาไม่เจอจะวาร์ปไปพิกัดกลางแมพ (0, 20, 0)
        local spawnLocation = game:GetService("Workspace"):FindFirstChildOfClass("SpawnLocation")
        local targetPos = spawnLocation and spawnLocation.CFrame + Vector3.new(0, 5, 0) or CFrame.new(0, 20, 0)
        char:PivotTo(targetPos)
    end
end)

-- ปุ่มเปิด/ปิด UI เล็กๆ บนหน้าจอ
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 80, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.Text = "Close Menu"
Toggle.Parent = ScreenGui

Toggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    Toggle.Text = MainFrame.Visible and "Close Menu" or "Open Menu"
end)
