-- [[ BRAINROT HUB: CLOAK & FLY EDITION ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ลบ UI เก่า
if CoreGui:FindFirstChild("BrainrotCloak") then CoreGui.BrainrotCloak:Destroy() end

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "BrainrotCloak"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "GHOST MOD V5"
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- ตัวแปรสถานะ
local flying = false
local noclip = false
local flySpeed = 50

-- ฟังก์ชันสร้างปุ่ม
local function createBtn(text, y, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 210, 0, 45)
    b.Position = UDim2.new(0, 20, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.MouseButton1Click:Connect(callback)
    return b
end

-- 1. ระบบบินและลอยกลางอากาศ (Fly)
createBtn("Fly: OFF (ลอยกลางอากาศ)", 60, function(self)
    flying = not flying
    local char = LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if flying then
        self.Text = "Fly: ON"
        self.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9e4
        bg.CFrame = root.CFrame
        
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                bv.Velocity = ((Workspace.CurrentCamera.CFrame.LookVector * (hum.MoveDirection.Z > 0 and flySpeed or (hum.MoveDirection.Z < 0 and -flySpeed or 0))) + (Workspace.CurrentCamera.CFrame.RightVector * (hum.MoveDirection.X > 0 and flySpeed or (hum.MoveDirection.X < 0 and -flySpeed or 0))))
                if not flying then bv:Destroy() bg:Destroy() break end
            end
        end)
    else
        self.Text = "Fly: OFF"
        self.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- 2. ระบบทะลุบล็อก (Noclip)
createBtn("Noclip: OFF (ทะลุบล็อก)", 120, function(self)
    noclip = not noclip
    self.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    self.BackgroundColor3 = noclip and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(50, 50, 50)
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 3. ระบบผ้าคลุมล่องหน (Invisibility Cloak)
createBtn("Invis Cloak (ล่องหน)", 180, function()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1 -- ทำให้จางหาย 100%
            elseif v:IsA("Decal") or v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy() -- ลบส่วนประกอบอื่นทิ้งเพื่อให้คนอื่นมองไม่เห็นแน่นอน
            end
        end
        -- ลบชื่อเหนือหัว
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("Nametag") then
            char.Head.Nametag:Destroy()
        end
    end
end)

-- 4. วาร์ปกลับบ้าน (Smart Home)
createBtn("Teleport Home", 240, function()
    if LocalPlayer.Character then
        local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
        LocalPlayer.Character:PivotTo(spawn and spawn.CFrame + Vector3.new(0,5,0) or CFrame.new(0,50,0))
    end
end)

-- ปุ่มปิดเมนู
local toggle = Instance.new("TextButton", ScreenGui)
toggle.Size = UDim2.new(0, 80, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "Menu"
toggle.BackgroundColor3 = Color3.new(0,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
