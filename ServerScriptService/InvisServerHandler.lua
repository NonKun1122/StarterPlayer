-- ServerScriptService / InvisServerHandler.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local REMOTE_NAME = "Brainrot_InvisToggle"
local remote = ReplicatedStorage:WaitForChild(REMOTE_NAME)

remote.OnServerEvent:Connect(function(player, wantInvisible)
    local char = player.Character
    if not char then return end

    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            if obj.Name \~= "HumanoidRootPart" then
                obj.Transparency = wantInvisible and 1 or 0
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SpecialMesh") then
            obj.Transparency = wantInvisible and 1 or 0
        end
    end

    -- ส่งสถานะกลับ client เพื่อ sync UI
    remote:FireClient(player, wantInvisible)
end)

-- รีเซ็ต invis เมื่อตัวละครเกิดใหม่ (ป้องกันติดบั๊ก)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        remote:FireClient(p, false)
    end)
end)
