local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Space Hub | Arsenal", HidePremium = false, IntroEnabled = false, SaveConfig = true, IntroText = "SpaceHub", IntroIcon = "rbxassetid://4483362748", Icon = "rbxassetid://4483362748", ConfigFolder = "Loader"})

-- Funções e Variáveis Globais
local capturedData = {}

local function captureAnyCall(namecall, ...)
    local methodName = getnamecallmethod()
    local args = {...}

    table.insert(capturedData, {
        method = methodName,
        args = args,
        time = os.time()
    })

    return namecall(...)
end

-- Hooking
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(...)
    return captureAnyCall(oldNamecall, ...)
end
setreadonly(mt, true)

-- Função para exibir os dados capturados
function displayCapturedData()
    local displayString = ""
    for _, event in ipairs(capturedData) do
        local argsString = table.concat(event.args, ", ")
        displayString = displayString .. string.format("[%s] %s(%s)\n", os.date('%H:%M:%S', event.time), event.method, argsString)
    end
    return displayString
end

-- Tabs
local Aimbot = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483362748",
    PremiumOnly = false
})
local gunmods = Window:MakeTab({
    Name = "Gun Mods",
    Icon = "rbxassetid://4384396122",
    PremiumOnly = false
})
local Player = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4335480896",
    PremiumOnly = false
})
local LiveData = Window:MakeTab({
    Name = "Live Data",
    Icon = "rbxassetid://6026568227",
    PremiumOnly = false
})

-- Adicionando Componentes ao Menu
LiveData:AddLabel({
    Name = "Eventos Capturados",
    Content = "Nenhum evento capturado ainda.",
    Refresh = true,
    Callback = function(label)
        label:SetContent(displayCapturedData())
    end
})

-- Exemplo de Captura e Exibição de Dados em Tempo Real
LiveData:AddButton({
	Name = "Atualizar Eventos",
	Callback = function()
        -- Atualiza manualmente os eventos capturados
        local label = LiveData:GetLabel("Eventos Capturados")
        label:SetContent(displayCapturedData())
  	end    
})

-- Outros botões e sliders do seu script original...


      		local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local sc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local Down = false
local Inset = GuiService:GetGuiInset()

--// Options \\--
getgenv().Options = {
    Enabled = true,
    TeamCheck = true,
    Triggerbot = true,
    Smoothness = true,
    AimPart = "Head",
    FOV = 150
}

--// Functions \\--
local gc = function()
	local nearest = math.huge
	local nearplr
	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild(Options.AimPart) then
			if Options.TeamCheck then
				if game:GetService("Players").LocalPlayer.Team ~= v.Team then
                    local pos = Camera:WorldToScreenPoint(v.Character[Options.AimPart].Position)
                    local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + Inset.Y - sc.Y) ^ 2)
                    if diff < nearest and diff < Options.FOV then
                        nearest = diff
                        nearplr = v
                    end
                end
			else
				local pos = Camera:WorldToScreenPoint(v.Character[Options.AimPart].Position)
				local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + Inset.Y - sc.Y) ^ 2)
				if diff < nearest and diff < Options.FOV then
					nearest = diff
					nearplr = v
                end
			end
		end
	end
	return nearplr
end -- google chrome made this but i modified it for it to use teamcheck

function Circle()
    local circ = Drawing.new('Circle')
    circ.Transparency = 1
    circ.Thickness = 1.5
    circ.Visible = true
    circ.Color = Color3.fromRGB(255,255,255)
	circ.Filled = false
	circ.NumSides = 150
    circ.Radius = Options.FOV
    return circ
end

curc = Circle()

--// Main \\--
UserInputService.InputBegan:Connect(function( input )
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Down = true
	end
end)

UserInputService.InputEnded:Connect(function( input )
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Down = false
    end
end)

RunService.RenderStepped:Connect(function( ... )
    if Options.Enabled then
        if Down then
            if gc() ~= nil and gc().Character:FindFirstChild(Options.AimPart) then
                if Options.Smoothness then
                    pcall(function( ... )
                        local Info = TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
                        game:GetService("TweenService"):Create(Camera,Info,{
                            CFrame = CFrame.new(Camera.CFrame.p,gc().Character[Options.AimPart].CFrame.p)
                        }):Play()
                    end)
                else
                    pcall(function()
                        Camera.CFrame = CFrame.new(Camera.CFrame.p,gc().Character[Options.AimPart].CFrame.p)
                    end)
                end
            end
        end
        curc.Visible = true
        curc.Position = Vector2.new(Mouse.X, Mouse.Y+Inset.Y)
        curc.Radius = Options.FOV
    else
        -- do nothing except remove the fov
        curc.Visible = false
    end
end)
  	end    
})

gunmods:AddButton({
	Name = "No Recoil",
	Callback = function()
        while true do
            wait(5)
            
            getgenv().Toggle = true
            getgenv().ValueCheck = true
            local FunctionCount = 0
            local ValueCount = 0
            
            local hookrecoil = function(func)
                local hookrecoil; hookrecoil = hookfunction(func, function(...)
                    local args = {...}
                    if getgenv().Toggle then
                        return 0 or nil
                    end
                    return hookrecoil(unpack(args))
                end)
            end
            
            for _, func in next, getgc(true) do
                if typeof(func) == "function" and string.find(string.lower(debug.getinfo(func).name), "recoil") then
                    FunctionCount = FunctionCount + 1
                    hookrecoil(func)
                elseif typeof(func) == "table" then
                    for i, v in next, func do
                        if typeof(v) == "function" and string.find(string.lower(debug.getinfo(v).name), "recoil") then
                            FunctionCount = FunctionCount + 1
                            hookrecoil(v)
                        elseif getgenv().ValueCheck and typeof(i) == "string" and string.find(i, "%a+") and rawget(func, i) then
                            for char in string.gmatch(i, "%a+") do
                                if string.find(string.lower(char), "recoil") then
                                    ValueCount = ValueCount + 1
                                    if typeof(v) == "number" then
                                        rawset(func, i, 0)
                                    elseif typeof(v) == "string" and tonumber(v) then
                                        rawset(func, i, "0")
                                    elseif typeof(v) == "Vector3" then
                                        rawset(func, i, Vector3.new(0,0,0))
                                    elseif typeof(v) == "CFrame" then
                                        rawset(func, i, CFrame.new(0,0,0))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            end
  	end    
})
gunmods:AddButton({
	Name = "One Shot Everybody",
	Callback = function()
        local settings = {repeatamount = 4, inclusions = {"SayMessageRequest"}}

        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        
        local function isincluded(uh)
           for i,o in next, settings.inclusions do
               if uh.Name == o then
                   return true
               end
           end
           return false
        end
        
        mt.__namecall = function(uh, ...)
           local args = {...}
           local method = getnamecallmethod()
           if method == "FireServer" or method == "InvokeServer" and isincluded(uh) then
               for i = 1,settings.repeatamount do
                   old(uh, ...)
               end
           end
           return old(uh, ...)
        end
        
        setreadonly(mt, true)
  	end    
})
gunmods:AddButton({
	Name = "Inf Ammo",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
            if c.Name == "Ammo" or c.Name == "StoredAmmo" then
            c.Value = 300 -- don't set this above 300 or else your guns wont work
         
            end
            end
            end
  	end    
})
gunmods:AddButton({
	Name = "Instant Reload",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
            if c.Name == "AReload" or c.Name == "RecoilControl" or c.Name == "EReload" or c.Name == "SReload" or c.Name == "ReloadTime" or c.Name == "EquipTime" then
            c.Value = 0
           
            end
        end
            end
  	end    
})
gunmods:AddButton({
	Name = "Inf Range",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
           
            if c.Name == "Range" then
            c.Value = 9e9
           
            end
            end
            end
  	end    
})
gunmods:AddButton({
	Name = "Full Auto",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
           
           
            if c.Name == "Auto" then
            c.Value = true
            
            
            end
            end
            end
  	end    
})
gunmods:AddButton({
	Name = "DMG Mode",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
           
           
           
            
            if c.Name == "DMG" then
            c.Value = 1010
            
            end
            end
            end
  	end    
})
gunmods:AddButton({
	Name = "Rapid Fire",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
           
           
           
            
          
            if c.Name == "FireRate" or c.Name == "BFireRate" then
            c.Value = 0.05 -- don't set this lower than 0.02 or else your game will crash
            
            end
            end
            end
  	end    
})
gunmods:AddButton({
	Name = "Spread Mods",
	Callback = function()
        for i,v in next, game.ReplicatedStorage.Weapons:GetChildren() do
            for i,c in next, v:GetChildren() do -- for some reason, using GetDescendants dsent let you modify weapon ammo, so I do this instead
            for i,x in next, getconnections(c.Changed) do
            x:Disable() -- probably not needed
            end
           
           
           
           
            
        if c.Name == "Spread" then
            c.Value = 0
            elseif c.Name == "MaxSpread" then
            c.Value = 0
            
            end
            end
            end
  	end    
})



Player:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(155, 66, 245),
    Increment = 1,
    ValueName = "Walk Speed",
    Callback = function(ws)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws
    end    
})
Player:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(155, 66, 245),
    Increment = 1,
    ValueName = "Jump Power",
    Callback = function(jp)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp
    end    
})