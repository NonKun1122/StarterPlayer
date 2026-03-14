-- [[ BRAINROT HUB: COMPLETE EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- ลบ UI เก่าหากมีการรันซ้ำ
if CoreGui:FindFirstChild("BrainrotComplete") then
    CoreGui.BrainrotComplete:Destroy()
end

-- สร้างหน้าจอหลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotComplete"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true

-- ปุ่มเปิด/ปิด Menu (เล็กๆ ด้านบน)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "เปิด/ปิด Menu"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui

-- ตัวแปรสถานะ
local noclipEnabled = false
local speedJumpEnabled = false
local invisEnabled = false

-- กรอบเมนูหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔥 BRAINROT HUB 🔥"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- ฟังก์ชันสร้างปุ่มในเมนู
local function createButton(name, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 210, 0, 45)
    btn.Position = UDim2.new(0.5, -105, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. ฟังก์ชัน: วิ่งเร็ว + กระโดดสูง
createButton("Speed & High Jump", 60, Color3.fromRGB(60, 60, 60), function()
    speedJumpEnabled = not speedJumpEnabled
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedJumpEnabled then
            char.Humanoid.WalkSpeed = 120
            char.Humanoid.JumpPower = 180
            char.Humanoid.UseJumpPower = true
        else
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 50
        end
    end
end)

-- 2. ฟังก์ชัน: ทะลุบล็อก (Noclip)
createButton("Noclip (ทะลุบล็อก)", 115, Color3.fromRGB(60, 60, 60), function()
    noclipEnabled = not noclipEnabled
end)

-- Loop สำหรับ Noclip (ทำงานตลอดเวลาถ้าเปิด)
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. ฟังก์ชัน: ล่องหนแบบ Server (ลบส่วนประกอบที่ทำให้มองเห็น)
createButton("Server Invisible (ลบตัว)", 170, Color3.fromRGB(60, 60, 60), function()
    local char = player.Character
    if char then
        -- ลบ Mesh และส่วนประกอบอื่นๆ เพื่อให้ตัวโปร่งใสในสายตาคนอื่น
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v:Destroy() 
            elseif v:IsA("Decal") or v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
        end
        print("ตัวละครล่องหนแล้ว (คนอื่นจะไม่เห็นชิ้นส่วนของคุณ)")
    end
end)

-- 4. ฟังก์ชัน: ปลอมชื่อ (Display Name)
createButton("Fake Name (เปลี่ยนชื่อ)", 225, Color3.fromRGB(60, 60, 60), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.DisplayName = "Admin_Ghost_99"
    end
end)

-- 5. ฟังก์ชัน: วาร์ปกลับบ้าน (Spawn Point)
createButton("Teleport Home", 280, Color3.fromRGB(40, 100, 40), function()
    if player.Character then
        -- ใช้ MoveTo เพื่อวาร์ปไปยังตำแหน่ง Spawn พื้นฐาน หรือตำแหน่งที่กำหนด
        local spawnPos = Vector3.new(0, 20, 0) -- แก้ไขพิกัดบ้านตรงนี้
        player.Character:MoveTo(spawnPos)
    end
end)

-- ปุ่มปิด UI
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- จัดการเวลาตัวละครตายแล้วเกิดใหม่ (Reset สถาณะ)
player.CharacterAdded:Connect(function(char)
    noclipEnabled = false
    speedJumpEnabled = false
end)
