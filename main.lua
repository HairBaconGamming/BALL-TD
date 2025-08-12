-- Lấy các dịch vụ cần thiết
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Người chơi và Giao diện người chơi cục bộ
local localPlayer = players.LocalPlayer
local playerGui = localPlayer.PlayerGui

-- Thiết lập các vị trí và hướng cố định (CFrame)
local targetCharacterCF = CFrame.new(-3.60833001, 8.23878479, 1086.20959, 0.554133475, 1.06071141e-07, 0.832427859, -3.82406036e-08, 1, -1.01967686e-07, -0.832427859, 2.46711629e-08, 0.554133475)
local targetCameraCF = CFrame.new(-3.31953573, 135.794174, 1108.43481, 0.99991554, -0.0127955256, 0.00225620484, 0, 0.173648804, 0.98480773, -0.0129929176, -0.984724581, 0.173634157)

-- Lấy Camera và Nhân vật
local currentCamera = workspace.CurrentCamera
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Tìm nút "Boss Rush"
local difficultyFrame = playerGui:WaitForChild("MainGui"):WaitForChild("Difficulty"):WaitForChild("Holder")
local difficultyBtn

-- Đợi cho đến khi cửa sổ game được kích hoạt
while not isrbxactive() do
	task.wait()
end

task.wait(5) -- Đợi 5 giây

-- Tìm và nhấp vào nút "Boss Rush"
for _, v in pairs(difficultyFrame:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "Difficulty" and v.Difficulty.Text == "Boss Rush" then
		difficultyBtn = v
		break
	end
end

if difficultyBtn then
	mousemoveabs(difficultyBtn.AbsolutePosition.X + 50, difficultyBtn.AbsolutePosition.Y + 50)
	task.wait(0.05)
	mouse1click()
	task.wait(0.5)
end

-- Cố định nhân vật và camera
humanoidRootPart.Anchored = true -- Giữ nhân vật không bị ảnh hưởng bởi trọng lực
currentCamera.CameraType = Enum.CameraType.Scriptable -- Cho phép kịch bản điều khiển camera

if character and humanoidRootPart then
	humanoidRootPart.CFrame = targetCharacterCF
end
currentCamera.CFrame = targetCameraCF
