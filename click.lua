-- AUTO CLICK HUB - FINAL FIXED (KEYBIND FUNCIONANDO)

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Player = game.Players.LocalPlayer

-- ================= CONFIG =================
local clicking = false
local clickDelay = 0.05
local clickPosition = nil

local hideKey = Enum.KeyCode.RightShift
local listeningForKey = false

local clickThread = nil

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoClickHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 260)
main.Position = UDim2.new(0.5, -150, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.Text = "AUTO CLICK HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Status Dot
local statusDot = Instance.new("Frame", main)
statusDot.Size = UDim2.new(0,12,0,12)
statusDot.Position = UDim2.new(1,-20,0,12)
statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

-- Start
local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0.45,0,0,35)
startBtn.Position = UDim2.new(0.05,0,0,50)
startBtn.Text = "INICIAR"
startBtn.Font = Enum.Font.GothamBold
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
startBtn.TextColor3 = Color3.new(1,1,1)

-- Stop
local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0.45,0,0,35)
stopBtn.Position = UDim2.new(0.5,0,0,50)
stopBtn.Text = "PARAR"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)

-- CPS
local cpsBox = Instance.new("TextBox", main)
cpsBox.Size = UDim2.new(0.9,0,0,30)
cpsBox.Position = UDim2.new(0.05,0,0,100)
cpsBox.PlaceholderText = "CPS (ex: 20)"
cpsBox.Font = Enum.Font.Gotham

-- Pick Position
local pickBtn = Instance.new("TextButton", main)
pickBtn.Size = UDim2.new(0.9,0,0,30)
pickBtn.Position = UDim2.new(0.05,0,0,140)
pickBtn.Text = "ESCOLHER POSIÇÃO"
pickBtn.Font = Enum.Font.GothamBold
pickBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
pickBtn.TextColor3 = Color3.new(1,1,1)

-- Change Keybind
local keyBtn = Instance.new("TextButton", main)
keyBtn.Size = UDim2.new(0.9,0,0,30)
keyBtn.Position = UDim2.new(0.05,0,0,180)
keyBtn.Text = "Tecla do HUB: RightShift"
keyBtn.Font = Enum.Font.Gotham
keyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyBtn.TextColor3 = Color3.new(1,1,1)

-- ================= FUNCTIONS =================

-- CLICK LOOP
local function startClickLoop()
	if clickThread then return end
	clickThread = task.spawn(function()
		while clicking do
			if clickPosition then
				VIM:SendMouseButtonEvent(
					clickPosition.X, clickPosition.Y, 0, true, game, 0
				)
				VIM:SendMouseButtonEvent(
					clickPosition.X, clickPosition.Y, 0, false, game, 0
				)
			end
			task.wait(clickDelay)
		end
		clickThread = nil
	end)
end

-- Start
startBtn.MouseButton1Click:Connect(function()
	if tonumber(cpsBox.Text) then
		clickDelay = 1 / tonumber(cpsBox.Text)
	end
	if not clickPosition then return end
	clicking = true
	statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
	startClickLoop()
end)

-- Stop
stopBtn.MouseButton1Click:Connect(function()
	clicking = false
	statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
end)

-- Pick position (FIXO)
pickBtn.MouseButton1Click:Connect(function()
	pickBtn.Text = "CLIQUE NA TELA..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			clickPosition = UIS:GetMouseLocation()
			pickBtn.Text = "POSIÇÃO DEFINIDA ✔"
			conn:Disconnect()
		end
	end)
end)

-- Change keybind
keyBtn.MouseButton1Click:Connect(function()
	listeningForKey = true
	keyBtn.Text = "Pressione uma tecla..."
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	-- Captura nova tecla
	if listeningForKey then
		hideKey = input.KeyCode
		keyBtn.Text = "Tecla do HUB: "..hideKey.Name
		listeningForKey = false
		return
	end

	-- Hide / Show HUB
	if input.KeyCode == hideKey then
		gui.Enabled = not gui.Enabled
	end
end)
