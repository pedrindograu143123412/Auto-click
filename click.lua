--[[ 
  Auto Click Hub - Profissional
  Click infinito sem mover mouse
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ================= VARIÁVEIS =================
local clicking = false
local clickDelay = 0.1
local hideKey = Enum.KeyCode.RightShift
local guiVisible = true

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoClickHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 260)
main.Position = UDim2.new(0.5, -180, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- ================= TÍTULO =================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Auto Click Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- ================= ABAS =================
local tabButtons = Instance.new("Frame", main)
tabButtons.Size = UDim2.new(1, -20, 0, 30)
tabButtons.Position = UDim2.new(0, 10, 0, 45)
tabButtons.BackgroundTransparency = 1

local clickTabBtn = Instance.new("TextButton", tabButtons)
clickTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
clickTabBtn.Text = "Auto Click"
clickTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
clickTabBtn.TextColor3 = Color3.new(1,1,1)
clickTabBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", clickTabBtn)

local settingsTabBtn = Instance.new("TextButton", tabButtons)
settingsTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
settingsTabBtn.Position = UDim2.new(0.5, 5, 0, 0)
settingsTabBtn.Text = "Config"
settingsTabBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
settingsTabBtn.TextColor3 = Color3.new(1,1,1)
settingsTabBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", settingsTabBtn)

-- ================= CONTEÚDO =================
local clickTab = Instance.new("Frame", main)
clickTab.Size = UDim2.new(1, -20, 1, -90)
clickTab.Position = UDim2.new(0, 10, 0, 85)
clickTab.BackgroundTransparency = 1

local settingsTab = clickTab:Clone()
settingsTab.Parent = main
settingsTab.Visible = false

-- ================= AUTO CLICK TAB =================
local speedBox = Instance.new("TextBox", clickTab)
speedBox.Size = UDim2.new(1, 0, 0, 35)
speedBox.PlaceholderText = "Velocidade (ms)"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
Instance.new("UICorner", speedBox)

local startBtn = Instance.new("TextButton", clickTab)
startBtn.Size = UDim2.new(1, 0, 0, 40)
startBtn.Position = UDim2.new(0, 0, 0, 50)
startBtn.Text = "▶ CONTINUAR"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", startBtn)

local stopBtn = Instance.new("TextButton", clickTab)
stopBtn.Size = UDim2.new(1, 0, 0, 40)
stopBtn.Position = UDim2.new(0, 0, 0, 100)
stopBtn.Text = "■ PARAR"
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", stopBtn)

-- ================= CONFIG TAB =================
local keyLabel = Instance.new("TextLabel", settingsTab)
keyLabel.Size = UDim2.new(1, 0, 0, 40)
keyLabel.Text = "Tecla para esconder Hub:"
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextColor3 = Color3.new(1,1,1)
keyLabel.BackgroundTransparency = 1

local keyBind = Instance.new("TextLabel", settingsTab)
keyBind.Size = UDim2.new(1, 0, 0, 40)
keyBind.Position = UDim2.new(0, 0, 0, 45)
keyBind.Text = hideKey.Name
keyBind.Font = Enum.Font.GothamBold
keyBind.TextColor3 = Color3.fromRGB(0,170,255)
keyBind.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", keyBind)

-- ================= FUNÇÕES =================
speedBox.FocusLost:Connect(function()
	local ms = tonumber(speedBox.Text)
	if ms and ms > 0 then
		clickDelay = ms / 1000
	end
end)

startBtn.MouseButton1Click:Connect(function()
	clicking = true
end)

stopBtn.MouseButton1Click:Connect(function()
	clicking = false
end)

clickTabBtn.MouseButton1Click:Connect(function()
	clickTab.Visible = true
	settingsTab.Visible = false
end)

settingsTabBtn.MouseButton1Click:Connect(function()
	clickTab.Visible = false
	settingsTab.Visible = true
end)

-- ================= CLICK LOOP (SEM MOVER MOUSE) =================
task.spawn(function()
	while true do
		if clicking then
			VirtualInputManager:SendMouseButtonEvent(
				0, 0, 0, true, game, 0
			)
			VirtualInputManager:SendMouseButtonEvent(
				0, 0, 0, false, game, 0
			)
			task.wait(clickDelay)
		else
			task.wait(0.1)
		end
	end
end)

-- ================= KEYBIND ESCONDER HUB =================
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == hideKey then
		guiVisible = not guiVisible
		gui.Enabled = guiVisible
	end
end)
