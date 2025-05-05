local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

local Window = Fluent:CreateWindow({
    Title = "FakeLag GUI " .. Fluent.Version,
    SubTitle = "por xAI",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Principal = Window:AddTab({ Title = "Principal", Icon = "zap" }),
    Visuais = Window:AddTab({ Title = "Visuais", Icon = "eye" }),
    Configuracoes = Window:AddTab({ Title = "Configurações", Icon = "settings" })
}

local Options = Fluent.Options

local FakeLag = false
local waitTime = 0.05
local delayTime = 0.4
local effectColor = Color3.fromRGB(96, 205, 255)
local effectTransparency = 0
local isPlatformStand = false
local canStandUp = false
local fallSpeed = 50
local toggleKeybind = Enum.KeyCode.F

local FakeLagSection = Tabs.Principal:AddSection("Controles de FakeLag")

FakeLagSection:AddParagraph({
    Title = "Sistema de FakeLag",
    Content = "Controle a simulação de rede e efeitos de movimento do personagem.\nConfigure os tempos e ative o efeito abaixo."
})

local FakeLagToggle = FakeLagSection:AddToggle("FakeLagToggle", {
    Title = "FakeLag",
    Description = "Simula lag de rede ancorando o personagem",
    Default = false,
    Callback = function(state)
        FakeLag = state
        Fluent:Notify({
            Title = "FakeLag",
            Content = "FakeLag agora está " .. (state and "LIGADO" or "DESLIGADO"),
            Duration = 4
        })
    end
})

local WaitTimeSlider = FakeLagSection:AddSlider("WaitTimeSlider", {
    Title = "Tempo de Espera",
    Description = "Intervalo entre verificações de FakeLag (segundos)",
    Default = 0.05,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Callback = function(value)
        waitTime = value
        Fluent:Notify({
            Title = "Tempo de Espera Atualizado",
            Content = "Tempo de espera definido para " .. string.format("%.2f", value) .. " segundos",
            Duration = 3
        })
    end
})

local DelayTimeSlider = FakeLagSection:AddSlider("DelayTimeSlider", {
    Title = "Tempo de Atraso",
    Description = "Duração do efeito FakeLag (segundos)",
    Default = 0.4,
    Min = 0.1,
    Max = 2,
    Rounding = 2,
    Callback = function(value)
        delayTime = value
        Fluent:Notify({
            Title = "Tempo de Atraso Atualizado",
            Content = "Tempo de atraso definido para " .. string.format("%.2f", value) .. " segundos",
            Duration = 3
        })
    end
})

local FakeLagKeybind = FakeLagSection:AddKeybind("FakeLagKeybind", {
    Title = "Tecla de Ativação do FakeLag",
    Description = "Tecla para ativar/desativar FakeLag",
    Mode = "Toggle",
    Default = "F",
    Callback = function(value)
        FakeLagToggle:SetValue(not FakeLag)
    end,
    ChangedCallback = function(new)
        toggleKeybind = new
        Fluent:Notify({
            Title = "Tecla Atualizada",
            Content = "Tecla de ativação do FakeLag definida para " .. tostring(new),
            Duration = 3
        })
    end
})

coroutine.wrap(function()
    while wait(waitTime) do
        if FakeLag then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Anchored = true
                wait(delayTime)
                character.HumanoidRootPart.Anchored = false
            end
        end
    end
end)()

local FallingSection = Tabs.Principal:AddSection("Controles de Queda")

local FallingButton = FallingSection:AddButton({
    Title = "Ativar/Desativar Queda",
    Description = "Ativa/desativa o efeito de queda",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if not isPlatformStand then
                humanoid.PlatformStand = true
                humanoid:Move(Vector3.new(0, -fallSpeed, 0))
                canStandUp = true
                isPlatformStand = true
                Fluent:Notify({
                    Title = "Queda",
                    Content = "Efeito de queda ativado",
                    Duration = 3
                })
            elseif canStandUp then
                humanoid.PlatformStand = false
                isPlatformStand = false
                canStandUp = false
                Fluent:Notify({
                    Title = "Queda",
                    Content = "Efeito de queda desativado",
                    Duration = 3
                })
            end
        end
    end
})

local FallSpeedSlider = FallingSection:AddSlider("FallSpeedSlider", {
    Title = "Velocidade de Queda",
    Description = "Velocidade do efeito de queda",
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        fallSpeed = value
        Fluent:Notify({
            Title = "Velocidade de Queda Atualizada",
            Content = "Velocidade de queda definida para " .. value,
            Duration = 3
        })
    end
})

local VisualsSection = Tabs.Visuais:AddSection("Configurações de Efeitos Visuais")

local EffectColorPicker = VisualsSection:AddColorpicker("EffectColorPicker", {
    Title = "Cor do Efeito",
    Description = "Cor para feedback visual",
    Default = Color3.fromRGB(96, 205, 255),
    Callback = function(value)
        effectColor = value
        Fluent:Notify({
            Title = "Cor Atualizada",
            Content = "Cor do efeito alterada",
            Duration = 3
        })
    end
})

local TransparencyColorPicker = VisualsSection:AddColorpicker("TransparencyColorPicker", {
    Title = "Transparência do Efeito",
    Description = "Transparência para efeitos visuais",
    Transparency = 0,
    Default = Color3.fromRGB(96, 205, 255),
    Callback = function(value, transparency)
        effectTransparency = transparency
        Fluent:Notify({
            Title = "Transparência Atualizada",
            Content = "Transparência do efeito definida para " .. string.format("%.2f", transparency),
            Duration = 3
        })
    end
})

local ThemeDropdown = VisualsSection:AddDropdown("ThemeDropdown", {
    Title = "Tema da Interface",
    Description = "Altere o tema da interface",
    Values = {"Escuro", "Claro", "Aqua", "Ametista", "Rosa", "Mais Escuro"},
    Multi = false,
    Default = "Escuro",
    Callback = function(value)
        local themeMap = {
            Escuro = "Dark",
            Claro = "Light",
            Aqua = "Aqua",
            Ametista = "Amethyst",
            Rosa = "Rose",
            ["Mais Escuro"] = "Darker"
        }
        Fluent:ToggleTransparency(false)
        Fluent:ToggleAcrylic(value == "Escuro" or value == "Mais Escuro")
        Window:SetTheme(themeMap[value])
        Fluent:Notify({
            Title = "Tema Alterado",
            Content = "Tema da interface definido para " .. value,
            Duration = 3
        })
    end
})

local SettingsSection = Tabs.Configuracoes:AddSection("Gerenciamento da Interface")

SettingsSection:AddButton({
    Title = "Redefinir Configurações",
    Description = "Redefine todas as configurações para o padrão",
    Callback = function()
        Window:Dialog({
            Title = "Confirmar Redefinição",
            Content = "Tem certeza que deseja redefinir todas as configurações?",
            Buttons = {
                {
                    Title = "Confirmar",
                    Callback = function()
                        FakeLagToggle:SetValue(false)
                        WaitTimeSlider:SetValue(0.05)
                        DelayTimeSlider:SetValue(0.4)
                        FallSpeedSlider:SetValue(50)
                        EffectColorPicker:SetValueRGB(Color3.fromRGB(96, 205, 255))
                        TransparencyColorPicker:SetValue({96, 205, 255}, 0)
                        ThemeDropdown:SetValue("Escuro")
                        FakeLagKeybind:SetValue("F", "Toggle")
                        SaveManager:Save("FakeLagConfig")
                        Fluent:Notify({
                            Title = "Configurações Redefinidas",
                            Content = "Todas as configurações foram redefinidas para o padrão",
                            Duration = 5
                        })
                    end
                },
                {
                    Title = "Cancelar",
                    Callback = function()
                        Fluent:Notify({
                            Title = "Redefinição Cancelada",
                            Content = "A redefinição das configurações foi cancelada",
                            Duration = 3
                        })
                    end
                }
            }
        })
    end
})

SettingsSection:AddButton({
    Title = "Destruir Interface",
    Description = "Fecha e remove a interface",
    Callback = function()
        Window:Dialog({
            Title = "Confirmar Destruição",
            Content = "Tem certeza que deseja destruir a interface?",
            Buttons = {
                {
                    Title = "Confirmar",
                    Callback = function()
                        Fluent:Destroy()
                        Fluent:Notify({
                            Title = "Interface Destruída",
                            Content = "A interface FakeLag foi fechada",
                            Duration = 3
                        })
                    end
                },
                {
                    Title = "Cancelar",
                    Callback = function()
                        Fluent:Notify({
                            Title = "Destruição Cancelada",
                            Content = "A destruição da interface foi cancelada",
                            Duration = 3
                        })
                    end
                }
            }
        })
    end
})

InterfaceManager:BuildInterfaceSection(Tabs.Configuracoes)
SaveManager:BuildConfigSection(Tabs.Configuracoes)

SaveManager:Ignore({
    FakeLagToggle,
    WaitTimeSlider,
    DelayTimeSlider,
    FallSpeedSlider,
    EffectColorPicker,
    TransparencyColorPicker,
    ThemeDropdown,
    FakeLagKeybind
})

SaveManager:LoadAutoloadConfig()

local function createVisualFeedback()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = player.Character.HumanoidRootPart.Position
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = effectTransparency
        part.BrickColor = BrickColor.new(effectColor)
        part.Parent = workspace
        game:GetService("Debris"):AddItem(part, 1)
    end
end

FakeLagToggle:OnChanged(function()
    if FakeLag then
        createVisualFeedback()
    end
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Bem-vindo ao FakeLag GUI",
    Content = "Use as abas para configurar o FakeLag e efeitos visuais.\nAs configurações são salvas automaticamente!",
    Duration = 6
})
