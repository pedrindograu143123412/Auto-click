-- AUTO CLICK PREMIUM | FIX DEFINITIVO

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ================= VARIÁVEIS =================
local clicking = false
local clickPos = nil
local cps = 20
local hideKey = Enum.KeyCode.LeftControl
local clickConnection = nil

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoClickPremium"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Shadow (NÃO draggable)
local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.new(0, 340, 0, 270)
shadow.Position = UDim2.new(0.5,-170,0.5,-135)
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.45
shadow.ZIndex = 0
shadow.Active = false
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,18)

-- Main
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 250)
main.Position = UDim2.new(0.5,-160,0.5,-125)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.ZIndex = 1
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- Shadow follow (SEM bug)
main:GetPropertyChangedSignal("Position"):Connect(function()
	shadow.Position = main.Position + UDim2.fromOffset(8,8)
end)

-- ================= TÍTULO =================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "AUTO CLICK PREMIUM"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Status
local status = Instance.new("Frame", main)
status.Size = UDim2.new(0,12,0,12)
status.Position = UDim2.new(1,-28,0,14)
status.BackgroundColor3 = Color3.fromRGB(180,0,0)
status.BorderSizePixel = 0
Instance.new("UICorner", status).CornerRadius = UDim.new(1,0)

local function setStatus(color)
	TweenService:Create(
		status,
		TweenInfo.new(0.2),
		{BackgroundColor3 = color}
	):Play()
end

-- ================= BOTÕES =================
local function button(text, pos, color)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.42,0,0,38)
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local startBtn = button("INICIAR", UDim2.new(0.05,0,0,50), Color3.fromRGB(0,170,0))
local stopBtn  = button("PARAR",  UDim2.new(0.53,0,0,50), Color3.fromRGB(170,0,0))

-- CPS
local cpsBox = Instance.new("TextBox", main)
cpsBox.Size = UDim2.new(0.9,0,0,34)
cpsBox.Position = UDim2.new(0.05,0,0,100)
cpsBox.Text = "20"
cpsBox.Font = Enum.Font.Gotham
cpsBox.TextSize = 14
cpsBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
cpsBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", cpsBox).CornerRadius = UDim.new(0,10)

-- Posição
local pickBtn = Instance.new("TextButton", main)
pickBtn.Size = UDim2.new(0.9,0,0,34)
pickBtn.Position = UDim2.new(0.05,0,0,145)
pickBtn.Text = "ESCOLHER POSIÇÃO"
pickBtn.Font = Enum.Font.GothamBold
pickBtn.TextSize = 14
pickBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
pickBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", pickBtn).CornerRadius = UDim.new(0,10)

-- Key
local keyLabel = Instance.new("TextLabel", main)
keyLabel.Size = UDim2.new(1,0,0,25)
keyLabel.Position = UDim2.new(0,0,1,-28)
keyLabel.Text = "Tecla HUB: LeftControl"
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 12
keyLabel.TextColor3 = Color3.fromRGB(200,200,200)
keyLabel.BackgroundTransparency = 1

-- ================= CLICK REAL =================
local function stopClick()
	clicking = false
	if clickConnection then
		clickConnection:Disconnect()
		clickConnection = nil
	end
	setStatus(Color3.fromRGB(180,0,0))
end

local function startClick()
	if not clickPos then return end
	stopClick()

	cps = tonumber(cpsBox.Text) or 20
	local delay = 1 / math.clamp(cps, 1, 100)

	clicking = true
	setStatus(Color3.fromRGB(0,200,0))

	local last = 0
	clickConnection = RunService.Heartbeat:Connect(function(dt)
		last += dt
		if last >= delay then
			last = 0
			VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, true, game, 0)
			VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, false, game, 0)
		end
	end)
end

-- ================= EVENTOS =================
startBtn.MouseButton1Click:Connect(startClick)
stopBtn.MouseButton1Click:Connect(stopClick)

pickBtn.MouseButton1Click:Connect(function()
	pickBtn.Text = "CLIQUE PARA SALVAR..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			clickPos = UIS:GetMouseLocation()
			pickBtn.Text = "POSIÇÃO SALVA ✔"
			conn:Disconnect()
		end
	end)
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == hideKey then
		gui.Enabled = not gui.Enabled
	end
end)
