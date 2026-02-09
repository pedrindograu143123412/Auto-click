-- AUTO CLICK PREMIUM FINAL

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- =========================
-- VARIÁVEIS
-- =========================
local running = false
local delayMS = 20
local clickPos = nil
local hubVisible = true
local hubKey = Enum.KeyCode.LeftControl
local rainbow = false

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(360, 320)
main.Position = UDim2.fromScale(0.05, 0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 14)

-- TÍTULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "AUTO CLICK PREMIUM"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- STATUS
local statusDot = Instance.new("Frame", title)
statusDot.Size = UDim2.fromOffset(12,12)
statusDot.Position = UDim2.new(1,-20,0.5,-6)
statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

-- =========================
-- BOTÕES
-- =========================
local function createButton(text, posY, color)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.4,0,0,36)
    b.Position = UDim2.new(0.05,0,0,posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local startBtn = createButton("INICIAR", 60, Color3.fromRGB(0,170,0))
local stopBtn  = createButton("PARAR", 60, Color3.fromRGB(170,0,0))
stopBtn.Position = UDim2.new(0.55,0,0,60)

-- VELOCIDADE
local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.new(0.9,0,0,32)
speedBox.Position = UDim2.new(0.05,0,0,110)
speedBox.PlaceholderText = "Velocidade em MS (ex: 20)"
speedBox.Text = "20"
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.BorderSizePixel = 0
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,6)

-- POSIÇÃO
local savePos = createButton("POSIÇÃO SALVA", 155, Color3.fromRGB(60,60,60))
savePos.Size = UDim2.new(0.9,0,0,36)

-- TECLA HUB
local keyBtn = createButton("Tecla HUB: LeftControl", 200, Color3.fromRGB(50,50,50))
keyBtn.Size = UDim2.new(0.9,0,0,36)

-- =========================
-- VISUAL TAB
-- =========================
local visualBtn = createButton("VISUAL", 245, Color3.fromRGB(80,80,80))
visualBtn.Size = UDim2.new(0.9,0,0,36)

visualBtn.MouseButton1Click:Connect(function()
    rainbow = not rainbow
end)

-- =========================
-- FUNCIONALIDADE
-- =========================
savePos.MouseButton1Click:Connect(function()
    clickPos = UIS:GetMouseLocation()
end)

startBtn.MouseButton1Click:Connect(function()
    if not clickPos then return end
    delayMS = tonumber(speedBox.Text) or 20
    running = true
    statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)

    task.spawn(function()
        while running do
            VIM:SendMouseButtonEvent(
                clickPos.X,
                clickPos.Y,
                0,
                true,
                game,
                0
            )
            VIM:SendMouseButtonEvent(
                clickPos.X,
                clickPos.Y,
                0,
                false,
                game,
                0
            )
            task.wait(delayMS/1000)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    statusDot.BackgroundColor3 = Color3.fromRGB(255,0,0)
end)

-- TECLA HUB
keyBtn.MouseButton1Click:Connect(function()
    keyBtn.Text = "Pressione uma tecla..."
    local conn
    conn = UIS.InputBegan:Connect(function(i)
        if i.KeyCode ~= Enum.KeyCode.Unknown then
            hubKey = i.KeyCode
            keyBtn.Text = "Tecla HUB: "..i.KeyCode.Name
            conn:Disconnect()
        end
    end)
end)

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == hubKey then
        hubVisible = not hubVisible
        main.Visible = hubVisible
    end
end)

-- RAINBOW
RunService.RenderStepped:Connect(function()
    if rainbow then
        main.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,1,1)
    end
end)
