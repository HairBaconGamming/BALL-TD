-- Dịch vụ Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Lấy Material UI
local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/HairBaconGamming/Gamming-Material-HUB/main/Main.lua"))()
local Main = Material:Load({
    Title = "Macro Controller",
    SmothDrag = true,
    Key = Enum.KeyCode.RightShift, -- Ấn RightShift để ẩn/hiện UI
})

-- Tab Macro
local MacroTab = Main:New({
    Title = "Macro",
    ImageId = 0
})

-- Dữ liệu macro
local isRecording = false
local macroData = {}

-- Hàm ghi macro
local function startRecording()
    isRecording = true
    macroData = {}
    print("Macro recording started.")
end

local function stopRecording()
    isRecording = false
    print("Macro recording stopped. Frames:", #macroData)
end

-- Hàm phát macro
local function playMacro()
    print("Playing macro...")
    for _, entry in ipairs(macroData) do
        task.wait(entry.delay)
        if entry.type == "camera" then
            camera.CFrame = entry.cframe
        elseif entry.type == "key" then
            VirtualInputManager:SendKeyEvent(true, entry.key, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, entry.key, false, game)
        elseif entry.type == "mouse" then
            mousemoveabs(entry.x, entry.y)
            if entry.click then mouse1click() end
        end
    end
    print("Macro finished.")
end

-- Nút Record
local RecordBtn = MacroTab:Button({
    Title = "Start Recording",
    Callback = function()
        if isRecording then
            stopRecording()
            RecordBtn:SetTitle("Start Recording")
        else
            startRecording()
            RecordBtn:SetTitle("Stop Recording")
        end
    end
})

-- Nút Play
local PlayBtn = MacroTab:Button({
    Title = "Play Macro",
    Callback = function()
        if not isRecording and #macroData > 0 then
            playMacro()
        end
    end
})

-- Toggle để cố định camera scriptable
local CameraToggle = MacroTab:Toggle({
    Title = "Lock Camera Scriptable",
    Enabled = false,
    Callback = function(enabled)
        if enabled then
            camera.CameraType = Enum.CameraType.Scriptable
        else
            camera.CameraType = Enum.CameraType.Custom
        end
        return enabled
    end
})

-- Ghi liên tục camera mỗi frame khi đang record
RunService.RenderStepped:Connect(function(dt)
    if isRecording then
        table.insert(macroData, {
            type = "camera",
            cframe = camera.CFrame,
            delay = dt
        })
    end
end)

-- Ghi phím bấm
UserInputService.InputBegan:Connect(function(input, gp)
    if isRecording and input.UserInputType == Enum.UserInputType.Keyboard then
        table.insert(macroData, {
            type = "key",
            key = input.KeyCode,
            delay = 0
        })
    end
end)

-- Ghi chuột click trái
UserInputService.InputBegan:Connect(function(input, gp)
    if isRecording and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = UserInputService:GetMouseLocation()
        table.insert(macroData, {
            type = "mouse",
            x = pos.X,
            y = pos.Y,
            click = true,
            delay = 0
        })
    end
end)

-- Cố định nhân vật nếu cần
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
humanoidRootPart.Anchored = true
