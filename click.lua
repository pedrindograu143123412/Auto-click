-- AUTO CLICK HUB PREMIUM | FIX FINAL

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

-- ================== VARIÁVEIS ==================
local clicking = false
local clickDelay = 0.05
local clickPos = nil
local hideKey = Enum.KeyCode.RightShift
local listeningKey = false
local clickThread = nil

-- ================== GUI ==================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PremiumAutoClick"
gui.ResetOnSpawn = false

local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.new(0, 330, 0, 290)
shadow.Position = UDim2.new(0.5,-165,0.5,-145)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.4
shadow.ZIndex = 0
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,16)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 280)
main.Position = UDim2.new(0.5,-160,0.5,-140)
main.BackgroundColor3 = Color3.fromRGB(22,22,22)
main.Active = true
main.Draggable = true
main.ZIndex = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- ================== TÍTULO ==================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "AUTO CLICK PREMIUM"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

-- ================== STATUS ==================
local status = Instance.new("Frame", main)
status.Size = UDim2.new(0,14,0,14)
status.Position = UDim2.new(1,-30,0,13)
status.BackgroundColor3 = Color3.fromRGB(200,0,0)
status.BorderSizePixel = 0
Instance.new("UICorner", status).CornerRadius = UDim.new(1,0)

local function setStatus(color)
	TweenService:Create(
		status,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad),
		{BackgroundColor3 = color}
	):Play()
end

-- ================== BOTÕES ==================
local function createButton(text, pos, color)
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

local startBtn = createButton("INICIAR", UDim2.new(0.05,0,0,55), Color3.fromRGB(0,170,0))
local stopBtn  = createButton("PARAR",  UDim2.new(0.53,0,0,55), Color3.fromRGB(170,0,0))

-- ================== CPS ==================
local cps = Instance.new("TextBox", main)
cps.Size = UDim2.new(0.9,0,0,34)
cps.Position = UDim2.new(0.05,0,0,105)
cps.PlaceholderText = "CPS (ex: 20)"
cps.Font = Enum.Font.Gotham
cps.TextSize = 14
cps.BackgroundColor3 = Color3.fromRGB(35,35,35)
cps.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", cps).CornerRadius = UDim.new(0,10)

-- ================== POSIÇÃO ==================
local pick = Instance.new("TextButton", main)
pick.Size = UDim2.new(0.9,0,0,34)
pick.Position = UDim2.new(0.05,0,0,150)
pick.Text = "DEFINIR POSIÇÃO"
pick.Font = Enum.Font.GothamBold
pick.TextSize = 14
pick.BackgroundColor3 = Color3.fromRGB(55,55,55)
pick.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", pick).CornerRadius = UDim.new(0,10)

-- ================== KEY ==================
local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0.9,0,0,34)
keyBtn.Position = UDim2.new(0.05,0,0,195)
keyBtn.Text = "Tecla HUB: RightShift"
keyBtn.Font = Enum.Font.Gotham
keyBtn.TextSize = 13
keyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,10)

-- ================== CLICK LOOP REAL ==================
local function stopClick()
	clicking = false
	if clickThread then
		task.cancel(clickThread)
		clickThread = nil
	end
	setStatus(Color3.fromRGB(200,0,0))
end

local function startClick()
	if not clickPos then return end
	stopClick()

	local cpsValue = tonumber(cps.Text)
	if cpsValue and cpsValue > 0 then
		clickDelay = 1 / cpsValue
	end

	clicking = true
	setStatus(Color3.fromRGB(0,200,0))

	clickThread = task.spawn(function()
		while clicking do
			VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, true, game, 0)
			VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, false, game, 0)
			task.wait(clickDelay)
		end
	end)
end

-- ================== EVENTOS ==================
startBtn.MouseButton1Click:Connect(startClick)
stopBtn.MouseButton1Click:Connect(stopClick)

pick.MouseButton1Click:Connect(function()
	pick.Text = "CLIQUE PARA SALVAR..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			clickPos = UIS:GetMouseLocation()
			pick.Text = "POSIÇÃO SALVA ✔"
			conn:Disconnect()
		end
	end)
end)

keyBtn.MouseButton1Click:Connect(function()
	listeningKey = true
	keyBtn.Text = "PRESSIONE UMA TECLA..."
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if listeningKey then
		hideKey = input.KeyCode
		keyBtn.Text = "Tecla HUB: "..hideKey.Name
		listeningKey = false
		return
	end

	if input.KeyCode == hideKey then
		gui.Enabled = not gui.Enabled
	end
end)
