-- AUTO CLICK HUB PROFISSIONAL
-- by ChatGPT 😎

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- CONFIG
local clicking = false
local clickDelay = 0.05
local clickPos = nil
local hideKey = Enum.KeyCode.RightControl

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoClickHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 220)
main.Position = UDim2.new(0.5, -150, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Título
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "AUTO CLICK HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Status Dot
local statusDot = Instance.new("Frame", main)
statusDot.Size = UDim2.new(0,12,0,12)
statusDot.Position = UDim2.new(1,-20,0,12)
statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

-- Start Button
local start = Instance.new("TextButton", main)
start.Size = UDim2.new(0.45,0,0,35)
start.Position = UDim2.new(0.05,0,0,50)
start.Text = "INICIAR"
start.Font = Enum.Font.GothamBold
start.TextSize = 14
start.BackgroundColor3 = Color3.fromRGB(0,170,0)
start.TextColor3 = Color3.new(1,1,1)

-- Stop Button
local stop = Instance.new("TextButton", main)
stop.Size = UDim2.new(0.45,0,0,35)
stop.Position = UDim2.new(0.5,0,0,50)
stop.Text = "PARAR"
stop.Font = Enum.Font.GothamBold
stop.TextSize = 14
stop.BackgroundColor3 = Color3.fromRGB(170,0,0)
stop.TextColor3 = Color3.new(1,1,1)

-- CPS Box
local cpsBox = Instance.new("TextBox", main)
cpsBox.Size = UDim2.new(0.9,0,0,30)
cpsBox.Position = UDim2.new(0.05,0,0,100)
cpsBox.PlaceholderText = "Velocidade (ex: 20 CPS)"
cpsBox.Text = ""
cpsBox.Font = Enum.Font.Gotham
cpsBox.TextSize = 14

-- Pick Position
local pick = Instance.new("TextButton", main)
pick.Size = UDim2.new(0.9,0,0,30)
pick.Position = UDim2.new(0.05,0,0,140)
pick.Text = "ESCOLHER POSIÇÃO DO CLICK"
pick.Font = Enum.Font.GothamBold
pick.TextSize = 13
pick.BackgroundColor3 = Color3.fromRGB(60,60,60)
pick.TextColor3 = Color3.new(1,1,1)

-- Keybind Info
local keyInfo = Instance.new("TextLabel", main)
keyInfo.Size = UDim2.new(1,0,0,25)
keyInfo.Position = UDim2.new(0,0,1,-25)
keyInfo.BackgroundTransparency = 1
keyInfo.Text = "Tecla para esconder: RightCtrl"
keyInfo.TextColor3 = Color3.fromRGB(200,200,200)
keyInfo.Font = Enum.Font.Gotham
keyInfo.TextSize = 12

-- CLICK LOOP
task.spawn(function()
	while true do
		if clicking and clickPos then
			VIM:SendMouseButtonEvent(
				clickPos.X, clickPos.Y, 0, true, game, 0
			)
			VIM:SendMouseButtonEvent(
				clickPos.X, clickPos.Y, 0, false, game, 0
			)
		end
		task.wait(clickDelay)
	end
end)

-- FUNÇÕES
start.MouseButton1Click:Connect(function()
	if tonumber(cpsBox.Text) then
		clickDelay = 1 / tonumber(cpsBox.Text)
	end
	clicking = true
	statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
end)

stop.MouseButton1Click:Connect(function()
	clicking = false
	statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
end)

pick.MouseButton1Click:Connect(function()
	pick.Text = "CLIQUE NA TELA..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			clickPos = UIS:GetMouseLocation()
			pick.Text = "POSIÇÃO DEFINIDA ✔"
			conn:Disconnect()
		end
	end)
end)

-- HIDE HUB
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == hideKey then
		gui.Enabled = not gui.Enabled
	end
end)
