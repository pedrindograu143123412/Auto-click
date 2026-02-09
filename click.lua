-- AUTO CLICKER GUI
-- Coloque como LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local clicking = false
local clickDelay = 0.1 -- 100ms padrão
local clickPosition = nil

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0, 20, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Auto Clicker"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Velocidade
local speedBox = Instance.new("TextBox", frame)
speedBox.PlaceholderText = "Velocidade (ms)"
speedBox.Size = UDim2.new(1,-20,0,35)
speedBox.Position = UDim2.new(0,10,0,50)
speedBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
Instance.new("UICorner", speedBox)

-- Botão escolher local
local setPos = Instance.new("TextButton", frame)
setPos.Text = "Escolher local do clique"
setPos.Size = UDim2.new(1,-20,0,35)
setPos.Position = UDim2.new(0,10,0,95)
setPos.BackgroundColor3 = Color3.fromRGB(60,60,60)
setPos.TextColor3 = Color3.new(1,1,1)
setPos.Font = Enum.Font.Gotham
setPos.TextSize = 14
Instance.new("UICorner", setPos)

-- Botão ligar
local toggle = Instance.new("TextButton", frame)
toggle.Text = "INICIAR"
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,145)
toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
Instance.new("UICorner", toggle)

-- Funções
speedBox.FocusLost:Connect(function()
	local ms = tonumber(speedBox.Text)
	if ms and ms > 0 then
		clickDelay = ms / 1000
	end
end)

setPos.MouseButton1Click:Connect(function()
	setPos.Text = "Clique em qualquer lugar..."
	local conn
	conn = mouse.Button1Down:Connect(function()
		clickPosition = Vector2.new(mouse.X, mouse.Y)
		setPos.Text = "Local definido ✔"
		conn:Disconnect()
	end)
end)

toggle.MouseButton1Click:Connect(function()
	clicking = not clicking

	if clicking then
		toggle.Text = "PARAR"
		toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)

		task.spawn(function()
			while clicking do
				if clickPosition then
					mousemoveabs(clickPosition.X, clickPosition.Y)
					mouse1click()
				end
				task.wait(clickDelay)
			end
		end)
	else
		toggle.Text = "INICIAR"
		toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	end
end)
