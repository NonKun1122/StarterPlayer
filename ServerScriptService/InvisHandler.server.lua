-- ServerScriptService / InvisHandler.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local REMOTE_NAME = "Brainrot_InvisToggle"  -- ต้องตรงกับ client
local remote = ReplicatedStorage:WaitForChild(REMOTE_NAME)

remote.OnServerEvent:Connect(function(player, shouldInvisible)
    local char = player.Character
    if not char then return end

    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            if v.Name \~= "HumanoidRootPart" then
                v.Transparency = shouldInvisible and 1 or 0
                v.LocalTransparencyModifier = shouldInvisible and 1 or 0  -- ช่วยบางกรณี
            end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SpecialMesh") then
            v.Transparency = shouldInvisible and 1 or 0
        end
    end

    -- ส่งกลับไป client เพื่อ sync UI
    remote:FireClient(player, shouldInvisible)
end)

-- รีเซ็ตตอนเกิดใหม่ (ป้องกันบั๊กล่องหนถาวร)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        remote:FireClient(p, false)
    end)
end)
