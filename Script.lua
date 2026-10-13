-- CÓDIGO DA INTERFACE COMPLETA DO GUARDA (AIMBOT COM WALLCHECK + ESP COMPLETO)

-- 1. Serviços Principais do Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 2. Configurações Globais
local aimbotLigado = false
local espLigado = false
local fovRaio = 150
local tabelaEspAtivos = {} -- Armazena os painéis criados para não duplicar

-- 3. Criação do ScreenGui Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GuardaInterfaceGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Círculo Visual do FOV
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOV_Visual"
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovFrame.BackgroundTransparency = 0.95
fovFrame.Size = UDim2.new(0, fovRaio * 2, 0, fovRaio * 2)
fovFrame.Visible = false
fovFrame.Parent = screenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 50, 50)
fovStroke.Thickness = 1.5
fovStroke.Parent = fovFrame

-- 4. Janela Principal do GUI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(55, 65, 80)
frameStroke.Thickness = 1.5
frameStroke.Parent = mainFrame

-- Barra de Título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "SISTEMA TÁTICO DE DEFESA // FUNDAÇÃO SCP"
titleText.TextColor3 = Color3.fromRGB(220, 225, 235)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.Parent = titleBar

-- Botão Fechar (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -10, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = closeButton

-- Botão Reabrir
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 130, 0, 35)
openButton.Position = UDim2.new(0.5, 0, 0.95, 0)
openButton.AnchorPoint = Vector2.new(0.5, 1)
openButton.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
openButton.Text = "ABRIR INTERFACE"
openButton.TextColor3 = Color3.fromRGB(200, 200, 200)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 12
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

-- Container de Botões internos
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -30, 1, -60)
container.Position = UDim2.new(0, 15, 0, 50)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Botão AIMBOT
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Name = "AimbotToggle"
aimbotToggle.Size = UDim2.new(0, 200, 0, 45)
aimbotToggle.Position = UDim2.new(0, 0, 0, 10)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
aimbotToggle.Text = "AIMBOT: DESLIGADO"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
aimbotToggle.Font = Enum.Font.GothamBold
aimbotToggle.TextSize = 13
aimbotToggle.Parent = container

local toggleCorner1 = Instance.new("UICorner")
toggleCorner1.CornerRadius = UDim.new(0, 6)
toggleCorner1.Parent = aimbotToggle

-- Botão ESP
local espToggle = Instance.new("TextButton")
espToggle.Name = "EspToggle"
espToggle.Size = UDim2.new(0, 200, 0, 45)
espToggle.Position = UDim2.new(0, 0, 0, 65)
espToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
espToggle.Text = "VISÃO ESP: DESLIGADO"
espToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 13
espToggle.Parent = container

local toggleCorner2 = Instance.new("UICorner")
toggleCorner2.CornerRadius = UDim.new(0, 6)
toggleCorner2.Parent = espToggle

-- Caixa Reguladora do FOV
local fovInput = Instance.new("TextBox")
fovInput.Name = "FovInput"
fovInput.Size = UDim2.new(0, 200, 0, 45)
fovInput.Position = UDim2.new(0, 220, 0, 10)
fovInput.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
fovInput.Text = tostring(fovRaio)
fovInput.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInput.Font = Enum.Font.GothamBold
fovInput.TextSize = 14
fovInput.ClearTextOnFocus = false
fovInput.Parent = container

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovInput

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 0, 20)
fovLabel.Position = UDim2.new(0, 220, 0, 58)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "LARGURA DA MIRA (RAIO DO FOV)"
fovLabel.TextColor3 = Color3.fromRGB(140, 145, 155)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 10
fovLabel.Parent = container


-- 5. LÓGICA DO WALLCHECK (FILTRO DE LINHA DE VISÃO)
local function estaVisivel(origemPos, destinoPos, modeloInimigo)
local direcao = (destinoPos - origemPos)
local parametrosRaycast = RaycastParams.new()

-- Configura o Raycast para ignorar o próprio jogador e o próprio monstro que estamos checando
local listaIgnorar = {localPlayer.Character, modeloInimigo, camera}
parametrosRaycast.FilterDescendantsInstances = listaIgnorar
parametrosRaycast.FilterType = Enum.RaycastFilterType.Exclude
parametrosRaycast.IgnoreWater = true

local resultado = Workspace:Raycast(origemPos, direcao, parametrosRaycast)

-- Se não atingiu nada no caminho, significa que a linha de visão está 100% limpa
if resultado == nil then
return true
end
return false
end

-- 6. LOCALIZADOR DE ALVOS (WORKSPACE + WALLCHECK)
local function obterAlvoMaisProximo()
local alvoProximo = nil
local menorDistanciaMouse = fovRaio
local telaCentro = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

for _, objeto in ipairs(Workspace:GetDescendants()) do
if objeto:IsA("Model") and string.sub(string.lower(objeto.Name), 1, 4) == "scp-" then
local pecaAlvo = objeto:FindFirstChild("Head") or objeto:FindFirstChild("HumanoidRootPart")
local humanoid = objeto:FindFirstChildOfClass("Humanoid")

if pecaAlvo and (not humanoid or humanoid.Health > 0) then
if localPlayer.Character and not objeto:IsAncestorOf(localPlayer.Character) then

local posicaoTela, visivelNaTela = camera:WorldToViewportPoint(pecaAlvo.Position)

if visivelNaTela then
local posicaoMouseAlvo = Vector2.new(posicaoTela.X, posicaoTela.Y)
local distanciaDoCentro = (posicaoMouseAlvo - telaCentro).Magnitude

-- Verifica se está dentro do círculo
if distanciaDoCentro < menorDistanciaMouse then
-- CRUCIAL: Só valida o alvo se ele passar no Wallcheck (Sem paredes no caminho!)
if estaVisivel(camera.CFrame.Position, pecaAlvo.Position, objeto) then
menorDistanciaMouse = distanciaDoCentro
alvoProximo = pecaAlvo
end
end
end
end
end
end
end
return alvoProximo
end

-- 7. SISTEMA DE VISÃO ESP (WALLHACK COM NOME, NÚMERO E VIDA)
local function criarEspParaModelo(modelo)
if tabelaEspAtivos[modelo] then return end -- Evita recriar o que já existe

local cabeca = modelo:FindFirstChild("Head") or modelo:FindFirstChild("HumanoidRootPart")
if not cabeca then return end

-- Painel flutuante que atravessa paredes e renderiza no topo
local billboard = Instance.new("BillboardGui")
billboard.Name = "SCP_ESP_TAG"
billboard.Size = UDim2.new(0, 160, 0, 60)
billboard.AlwaysOnTop = true -- Faz aparecer através das paredes!
billboard.ExtentsOffset = Vector3.new(0, 3, 0) -- Fica acima da cabeça do SCP
billboard.Adornee = cabeca
billboard.Parent = screenGui

local labelInfo = Instance.new("TextLabel")
labelInfo.Size = UDim2.new(1, 0, 0, 45)
labelInfo.BackgroundTransparency = 1
labelInfo.Font = Enum.Font.GothamBold
labelInfo.TextSize = 11
labelInfo.TextStrokeTransparency = 0.2 -- Borda preta no texto para legibilidade
labelInfo.TextColor3 = Color3.fromRGB(255, 60, 60)
labelInfo.Parent = billboard

tabelaEspAtivos[modelo] = billboard

-- Conexão para atualizar as informações e remover se o SCP morrer/sumir
local conexaoAtualizacao
conexaoAtualizacao = RunService.Heartbeat:Connect(function()
if not modelo:IsDescendantOf(Workspace) or not espLigado then

billboard:Destroy()
tabelaEspAtivos[modelo] = nil
conexaoAtualizacao:Disconnect()
return
end
local hum = modelo:FindFirstChildOfClass("Humanoid")
local vidaAtual = hum and math.floor(hum.Health) or "???"
local vidaMaxima = hum and math.floor(hum.MaxHealth) or "???"
-- Descobre se algum player real está controlando esse SCP
local nomeDono = "SISTEMA (NPC)"
local jogadorDono = Players:GetPlayerFromCharacter(modelo)
if jogadorDono then
nomeDono = jogadorDono.Name
end
-- Botão ANTI-LAG
local antiLagToggle = Instance.new("TextButton")
antiLagToggle.Name = "AntiLagToggle"
antiLagToggle.Size = UDim2.new(0, 200, 0, 45)
antiLagToggle.Position = UDim2.new(0, 0, 0, 120) -- Alinhado abaixo do ESP
antiLagToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
antiLagToggle.Text = "ANTI-LAG: DESLIGADO"
antiLagToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
antiLagToggle.Font = Enum.Font.GothamBold
antiLagToggle.TextSize = 13
antiLagToggle.Parent = container

local toggleCorner3 = Instance.new("UICorner")
toggleCorner3.CornerRadius = UDim.new(0, 6)
toggleCorner3.Parent = antiLagToggle

-- Botão NOCLIP
local noclipToggle = Instance.new("TextButton")
noclipToggle.Name = "NoclipToggle"
noclipToggle.Size = UDim2.new(0, 200, 0, 45)
noclipToggle.Position = UDim2.new(0, 0, 0, 175) -- Alinhado abaixo do Anti-Lag
noclipToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
noclipToggle.Text = "NOCLIP: DESLIGADO"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.TextSize = 13
noclipToggle.Parent = container

local toggleCorner4 = Instance.new("UICorner")
toggleCorner4.CornerRadius = UDim.new(0, 6)
toggleCorner4.Parent = noclipToggle


-- Atualiza o painel visual
labelInfo.Text = string.upper(modelo.Name) .. "\n" ..
"CONTROLADO POR: " .. nomeDono .. "\n" ..
"VIDA: " .. vidaAtual .. " / " .. vidaMaxima
end)
end
-- Varre o mapa aplicando o ESP
local function gerenciarEspGeral()
if not espLigado then return end
for _, objeto in ipairs(Workspace:GetDescendants()) do
if objeto:IsA("Model") and string.sub(string.lower(objeto.Name), 1, 4) == "scp-" then
criarEspParaModelo(objeto)
end
end
end
-- 8. LOOPS DE EXECUÇÃO CONSTANTE
RunService.RenderStepped:Connect(function()
local centroX = camera.ViewportSize.X / 2
local centroY = camera.ViewportSize.Y / 2
fovFrame.Position = UDim2.new(0, centroX, 0, centroY)
-- Executa o Aimbot Bruto
if aimbotLigado then
fovFrame.Visible = true
local alvo = obterAlvoMaisProximo()
if alvo then
camera.CFrame = CFrame.new(camera.CFrame.Position, alvo.Position)
end
else
fovFrame.Visible = false
end
-- Executa a varredura do ESP
if espLigado then
gerenciarEspGeral()
end
end)
-- 9. CONFIGURAÇÃO DE INTERAÇÃO DOS BOTÕES
aimbotToggle.MouseButton1Click:Connect(function()
aimbotLigado = not aimbotLigado
if aimbotLigado then
aimbotToggle.Text = "AIMBOT: LIGADO"
aimbotToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
else
aimbotToggle.Text = "AIMBOT: DESLIGADO"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
end
end)
espToggle.MouseButton1Click:Connect(function()
espLigado = not espLigado
if espLigado then
espToggle.Text = "VISÃO ESP: LIGADO"
espToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
else
espToggle.Text = "VISÃO ESP: DESLIGADO"
espToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
-- Limpa os painéis da tela ao desligar
for mod, bGui in pairs(tabelaEspAtivos) do
bGui:Destroy()
end
tabelaEspAtivos = {}
end
end)
fovInput.FocusLost:Connect(function()
local novoValor = tonumber(fovInput.Text)
if novoValor then
fovRaio = novoValor
fovFrame.Size = UDim2.new(0, novoValor * 2, 0, novoValor * 2)
else
fovInput.Text = tostring(fovRaio)
end
end)
-- SISTEMA DE MINIMIZAR INTERFACE
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
closeButton.MouseButton1Click:Connect(function()
local minimizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
minimizeTween:Play()
titleText.Visible = false
closeButton.Visible = false
container.Visible = false
minimizeTween.Completed:Connect(function() mainFrame.Visible = false openButton.Visible = true end)
end)
openButton.MouseButton1Click:Connect(function()
openButton.Visible = false
mainFrame.Visible = true
titleText.Visible = true
closeButton.Visible = true
container.Visible = true
local restoreTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 300), BackgroundTransparency = 0})
restoreTween:Play()
end)
closeButton.MouseEnter:Connect(function() closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40) closeButton.TextColor3 = Color3.fromRGB(255, 255, 255) end)
closeButton.MouseLeave:Connect(function() closeButton.BackgroundColor3 = Color3.fromRGB(45, 25, 25) closeButton.TextColor3 = Color3.fromRGB(255, 100, 100) end)
-- ==========================================
-- LÓGICA DO ANTI-LAG E NOCLIP
-- ==========================================

local antiLagLigado = false
local noclipLigado = false

-- Variáveis para restaurar as texturas originais do jogo se o Anti-Lag for desligado
local texturasSalvas = {}

-- Função de Anti-Lag (Remove texturas pesadas do mapa para subir o FPS instantaneamente)
local function alternarAntiLag()
antiLagLigado = not antiLagLigado

if antiLagLigado then
antiLagToggle.Text = "ANTI-LAG: LIGADO"
antiLagToggle.TextColor3 = Color3.fromRGB(100, 255, 100)

-- Varre o mapa deixando os blocos lisos e removendo efeitos visuais pesados
for _, objeto in ipairs(Workspace:GetDescendants()) do
if objeto:IsA("Texture") or objeto:IsA("Decal") or objeto:IsA("Sky") then
objeto.Texture = "" -- Limpa imagens pesadas coladas nas paredes
elseif objeto:IsA("BasePart") and not objeto:IsA("MeshPart") then
-- Guarda o material antigo para poder restaurar depois
if not texturasSalvas[objeto] then
texturasSalvas[objeto] = objeto.Material
end
objeto.Material = Enum.Material.SmoothPlastic
elseif objeto:IsA("ParticleEmitter") or objeto:IsA("Trail") or objeto:IsA("Smoke") or objeto:IsA("Sparkles") then
objeto.Enabled = false -- Desliga fumaças e partículas que pesam a GPU
end
end
else
antiLagToggle.Text = "ANTI-LAG: DESLIGADO"
antiLagToggle.TextColor3 = Color3.fromRGB(255, 100, 100)

-- Restaura os materiais originais do cenário
for objeto, materialAntigo in pairs(texturasSalvas) do
if objeto and objeto.Parent then
objeto.Material = materialAntigo
end
end
texturasSalvas = {}

-- Reativa as partículas do ambiente
for _, objeto in ipairs(Workspace:GetDescendants()) do
if objeto:IsA("ParticleEmitter") or objeto:IsA("Trail") or objeto:IsA("Smoke") or objeto:IsA("Sparkles") then
objeto.Enabled = true
end
end
end
end

-- Ativador do clique do Anti-Lag
antiLagToggle.MouseButton1Click:Connect(alternarAntiLag)


-- Função de Noclip (Desativa colisões do seu personagem para atravessar portas/paredes)
noclipToggle.MouseButton1Click:Connect(function()
noclipLigado = not noclipLigado
if noclipLigado then
noclipToggle.Text = "NOCLIP: LIGADO"
noclipToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
else
noclipToggle.Text = "NOCLIP: DESLIGADO"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
end
end)

-- Loop constante do Noclip (Precisa rodar a cada frame para o Roblox não reativar as colisões sozinho)
RunService.Stepped:Connect(function()
if noclipLigado and localPlayer.Character then
for _, parte in ipairs(localPlayer.Character:GetDescendants()) do
if parte:IsA("BasePart") and parte.CanCollide == true then
parte.CanCollide = false
end
end
end
end)


