local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Linux = {
    Theme = {
        Background = Color3.fromRGB(24, 24, 24),
        Element = Color3.fromRGB(28, 28, 28),
        Accent = Color3.fromRGB(80, 120, 255),
        Text = Color3.fromRGB(180, 180, 180),
        Toggle = Color3.fromRGB(40, 40, 40),
        TabInactive = Color3.fromRGB(28, 28, 28),
        DropdownOption = Color3.fromRGB(30, 30, 30)
    }
}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then
        return
    end

    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 200 or 300
    local notificationHeight = config.SubContent and 80 or 60
    local startPosX = isMobile and 10 or 20

    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Linux.Theme.Background,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 10),
        ZIndex = 100
    })

    Linux.Instance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 8)
    })

    Linux.Instance("UIStroke", {
        Parent = Notification,
        Color = Linux.Theme.Element,
        Thickness = 1,
        Transparency = 0.5
    })

    local Shadow = Linux.Instance("ImageLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 99
    })

    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.SourceSansBold,
        Text = config.Title or "Notification",
        TextColor3 = Linux.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    local ContentLabel = Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        Font = Enum.Font.SourceSans,
        Text = config.Content or "Content",
        TextColor3 = Linux.Theme.Text,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    if config.SubContent then
        local SubContentLabel = Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 45),
            Font = Enum.Font.SourceSans,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101
        })
    end

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 10)}):Play()

    if config.Duration then
        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 10)}):Play()
            task.wait(0.5)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end

    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })

    ProtectGui(LinuxUI)

    local FakeUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    FakeUI.Name = "FakeUI"
    FakeUI.Enabled = false
    FakeUI.ResetOnSpawn = false

    local tabWidth = config.TabWidth or 110

    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(300, 500)) or (config.SizePC or UDim2.fromOffset(550, 355))

    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Linux.Theme.Background,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1
    })

    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 8)
    })

    Linux.Instance("UIStroke", {
        Parent = Main,
        Color = Linux.Theme.Element,
        Thickness = 1,
        Transparency = 0.5
    })

    local Shadow = Linux.Instance("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 0
    })

    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 2
    })

    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 8)
    })

    local Gradient = Linux.Instance("UIGradient", {
        Parent = TopBar,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Linux.Theme.Element),
            ColorSequenceKeypoint.new(1, Linux.Theme.Background)
        }),
        Rotation = 90
    })

    local Title = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2
    })

    local MinimizeButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -54, 0, 3),
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
    })

    local MinimizeIcon = Linux.Instance("ImageLabel", {
        Parent = MinimizeButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10734895698",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3
    })

    local CloseButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -24, 0, 3),
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
    })

    local CloseIcon = Linux.Instance("ImageLabel", {
        Parent = CloseButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3
    })

    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, tabWidth, 1, -30),
        ZIndex = 2
    })

    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ZIndex = 2
    })

    local TabLayout = Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local TabPadding = Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    })

    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, tabWidth, 0, 30),
        Size = UDim2.new(1, -tabWidth, 1, -30),
        ZIndex = 1
    })

    local isMinimized = false
    local originalSize = Main.Size
    local originalPos = Main.Position
    local isHidden = false

    MinimizeButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if not isMinimized then
            TweenService:Create(Main, tweenInfo, {Size = UDim2.new(0, 200, 0, 30), Position = UDim2.new(0.5, -100, 0, 0)}):Play()
            TabsBar.Visible = false
            Content.Visible = false
            MinimizeIcon.Image = "rbxassetid://10734886735"
            isMinimized = true
        else
            TweenService:Create(Main, tweenInfo, {Size = originalSize, Position = originalPos}):Play()
            TabsBar.Visible = true
            Content.Visible = true
            MinimizeIcon.Image = "rbxassetid://10734895698"
            isMinimized = false
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        LinuxUI:Destroy()
        FakeUI:Destroy()
    end)

    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)

    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil
    local tabOrder = 0

    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder

        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Linux.Theme.TabInactive,
            Size = UDim2.new(1, -8, 0, 32),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Linux.Theme.Text,
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })

        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 6)
        })

        Linux.Instance("UIStroke", {
            Parent = TabBtn,
            Color = Linux.Theme.Element,
            Thickness = 1,
            Transparency = 0.5
        })

        local Gradient = Linux.Instance("UIGradient", {
            Parent = TabBtn,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Linux.Theme.TabInactive),
                ColorSequenceKeypoint.new(1, Linux.Theme.Background)
            }),
            Rotation = 90
        })

        local Shadow = Linux.Instance("ImageLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, -5),
            Image = "rbxassetid://1316045217",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.9,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(10, 10, 118, 118),
            ZIndex = 1
        })

        local TabIcon
        if config.Icon and config.Icon.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 8, 0.5, -9),
                Image = config.Icon.Image or "rbxassetid://10747384394",
                ImageColor3 = Color3.fromRGB(150, 150, 150),
                ZIndex = 2
            })
        end

        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, config.Icon and config.Icon.Enabled and -30 or -12, 1, 0),
            Position = UDim2.new(0, config.Icon and config.Icon.Enabled and 30 or 12, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local TabContent = Linux.Instance("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Visible = false,
            ZIndex = 1
        })

        local TabTitle = Linux.Instance("TextLabel", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -12, 0, 30),
            Position = UDim2.new(0, 6, 0, 0),
            Font = Enum.Font.SourceSansBold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local ElementContainer = Linux.Instance("Frame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            ZIndex = 1
        })

        local ContentLayout = Linux.Instance("UIListLayout", {
            Parent = ElementContainer,
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local ContentPadding = Linux.Instance("UIPadding", {
            Parent = ElementContainer,
            PaddingLeft = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6)
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.Text.TextColor3 = Color3.fromRGB(150, 150, 150)
                if tab.Icon then
                    tab.Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
            end
            TabContent.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            CurrentTab = tabIndex
        end)

        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.TabInactive}):Play()
            end
        end)

        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent
        }

        if not CurrentTab then
            TabContent.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            CurrentTab = tabIndex
        end

        local TabElements = {}
        local elementOrder = 0

        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            local BtnFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = BtnFrame,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = BtnFrame,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1,
                AutoButtonColor = false
            })

            local BtnPadding = Linux.Instance("UIPadding", {
                Parent = Btn,
                PaddingLeft = UDim.new(0, 8)
            })

            local BtnIcon = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -24, 0.5, -8),
                Image = "rbxassetid://10709791437",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 1
            })

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Accent}):Play()
                spawn(function() Linux:SafeCallback(config.Callback) end)
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            return Btn
        end

        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            local Toggle = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Toggle,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 0, 34),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ToggleBox = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 44, 0, 22),
                Position = UDim2.new(1, -52, 0.5, -11),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = ToggleBox,
                CornerRadius = UDim.new(1, 0)
            })

            Linux.Instance("UIStroke", {
                Parent = ToggleBox,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local ToggleFill = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = ToggleFill,
                CornerRadius = UDim.new(1, 0)
            })

            local Knob = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0, 2),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            Linux.Instance("UIStroke", {
                Parent = Knob,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local State = config.Default or false

            local function UpdateToggle()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if State then
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Accent, Size = UDim2.new(1, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -20, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Toggle, Size = UDim2.new(0, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end

            UpdateToggle()

            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    State = not State
                    UpdateToggle()
                    spawn(function() Linux:SafeCallback(config.Callback, State) end)
                end
            end)

            Toggle.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Toggle.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            return Toggle
        end

        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            local Dropdown = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Dropdown,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 1
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -44, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -24, 0.5, -8),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 2
            })

            local DropFrame = Linux.Instance("ScrollingFrame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                LayoutOrder = elementOrder + 1
            })

            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = DropFrame,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local DropLayout = Linux.Instance("UIListLayout", {
                Parent = DropFrame,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            local DropPadding = Linux.Instance("UIPadding", {
                Parent = DropFrame,
                PaddingLeft = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 6)
            })

            local Options = config.Options or {}
            local IsOpen = false
            local SelectedValue = config.Default or (Options[1] or "None")

            local function UpdateDropSize()
                local optionHeight = 28
                local paddingBetween = 2
                local paddingTop = 6
                local maxHeight = 150
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions - 1) * paddingBetween + paddingTop
                local finalHeight = math.min(calculatedHeight, maxHeight)
                if finalHeight < 0 then finalHeight = 0 end

                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if IsOpen then
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -6, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -6, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                end
                task.wait(0.2)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end

            local function PopulateOptions()
                for _, child in pairs(DropFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                if IsOpen then
                    for _, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = DropFrame,
                            BackgroundColor3Culprit = Linux.Theme.DropdownOption,
                            Size = UDim2.new(1, -6, 0, 28),
                            Font = Enum.Font.SourceSans,
                            Text = tostring(opt),
                            TextColor3 = opt == SelectedValue and Linux.Theme.Accent or Linux.Theme.Text,
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 3,
                            AutoButtonColor = false
                        })

                        Linux.Instance("UICorner", {
                            Parent = OptBtn,
                            CornerRadius = UDim.new(0, 6)
                        })

                        Linux.Instance("UIStroke", {
                            Parent = OptBtn,
                            Color = Linux.Theme.Element,
                            Thickness = 1,
                            Transparency = 0.5
                        })

                        OptBtn.MouseButton1Click:Connect(function()
                            SelectedValue = opt
                            Selected.Text = tostring(opt)
                            for _, btn in pairs(DropFrame:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.TextColor3 = btn.Text == tostring(opt) and Linux.Theme.Accent or Linux.Theme.Text
                                end
                            end
                            spawn(function() Linux:SafeCallback(config.Callback, opt) end)
                        end)

                        OptBtn.MouseEnter:Connect(function()
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.DropdownOption, 0.8)}):Play()
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.DropdownOption}):Play()
                        end)
                    end
                end
                UpdateDropSize()
            end

            if #Options > 0 then
                PopulateOptions()
            end

            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                end
            end)

            Dropdown.MouseEnter:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Dropdown.MouseLeave:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValue = config.Default or (Options[1] or "None")
                Selected.Text = tostring(SelectedValue)
                PopulateOptions()
            end

            local function SetValue(value)
                if table.find(Options, value) then
                    SelectedValue = value
                    Selected.Text = tostring(value)
                    for _, btn in pairs(DropFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Text == tostring(value) and Linux.Theme.Accent or Linux.Theme.Text
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, value) end)
                end
            end

            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return SelectedValue end
            }
        end

        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            local Slider = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 44),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Slider,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 20),
                Position = UDim2.new(0, 8, 0, 4),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, -6, 0, 20),
                Position = UDim2.new(0.6, 0, 0, 4),
                Font = Enum.Font.SourceSans,
                Text = tostring(config.Default or config.Min or 0),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 1
            })

            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(1, -12, 0, 8),
                Position = UDim2.new(0, 6, 0, 30),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })

            Linux.Instance("UIStroke", {
                Parent = SliderBar,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = FillBar,
                CornerRadius = UDim.new(1, 0)
            })

            local Knob = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 250),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 0, 0, -3),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            Linux.Instance("UIStroke", {
                Parent = Knob,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Value = Default

            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                Value = Min + (Max - Min) * relativePos
                Value = math.floor(Value + 0.5)
                Knob.Position = UDim2.new(relativePos, -7, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            local draggingSlider = false

            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)

            Slider.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)

            Slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            Slider.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Slider.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetValue(newValue)
                newValue = math.clamp(newValue, Min, Max)
                Value = math.floor(newValue + 0.5)
                local relativePos = (Value - Min) / (Max - Min)
                Knob.Position = UDim2.new(relativePos, -7, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            SetValue(Default)

            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Value end
            }
        end

        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            local Input = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Input,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Input,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0.5, -12, 0, 22),
                Position = UDim2.new(0.5, 6, 0.5, -11),
                Font = Enum.Font.SourceSans,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Text Here",
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = TextBox,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = TextBox,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local MaxLength = 50

            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end

            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                CheckTextBounds()
            end)

            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    UpdateInput()
                end
            end)

            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                end
            end)

            Input.MouseEnter:Connect(function()
                TweenService:Create(Input, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Input.MouseLeave:Connect(function()
                TweenService:Create(Input, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end

            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end

        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            local LabelFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = LabelFrame,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = LabelFrame,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Text or "Label",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            LabelFrame.MouseEnter:Connect(function()
                TweenService:Create(LabelFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            LabelFrame.MouseLeave:Connect(function()
                TweenService:Create(LabelFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetText(newText)
                LabelText.Text = tostring(newText)
            end

            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end

        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            local Section = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -6, 0, 28),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            local SectionText = Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                Font = Enum.Font.SourceSansBold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            return Section
        end

        function TabElements.Keybind(config)
            elementOrder = elementOrder + 1
            local Keybind = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Keybind,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Keybind,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local KeyBox = Linux.Instance("TextButton", {
                Parent = Keybind,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 64, 0, 22),
                Position = UDim2.new(1, -70, 0.5, -11),
                Font = Enum.Font.SourceSans,
                Text = config.Default and tostring(config.Default) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextScaled = true,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClipsDescendants = true,
                ZIndex = 2,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {
                Parent = KeyBox,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = KeyBox,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Mode = config.Mode or "Hold"
            local CurrentKey = config.Default or nil
            local IsBinding = false
            local ToggleState = false
            local IsHolding = false

            local function UpdateKeyText()
                KeyBox.Text = CurrentKey and tostring(CurrentKey) or "None"
            end

            local function ExecuteCallback(state)
                if Mode == "Hold" then
                    spawn(function() Linux:SafeCallback(config.Callback, state) end)
                elseif Mode == "Toggle" then
                    if state then
                        ToggleState = not ToggleState
                        spawn(function() Linux:SafeCallback(config.Callback, ToggleState) end)
                    end
                elseif Mode == "Always" then
                    if ToggleState then
                        spawn(function() Linux:SafeCallback(config.Callback, true) end)
                    end
                end
            end

            KeyBox.MouseButton1Click:Connect(function()
                if not IsBinding then
                    IsBinding = true
                    KeyBox.Text = "..."
                end
            end)

            KeyBox.MouseButton2Click:Connect(function()
                CurrentKey = nil
                IsBinding = false
                UpdateKeyText()
            end)

            InputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if IsBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CurrentKey = Enum.UserInputType.MouseButton1
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        CurrentKey = Enum.UserInputType.MouseButton2
                        IsBinding = false
                        UpdateKeyText()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                        CurrentKey = Enum.UserInputType.MouseButton3
                        IsBinding = false
                        UpdateKeyText()
                    end
                elseif CurrentKey then
                    if (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                        IsHolding = true
                        ExecuteCallback(true)
                    end
                end
            end)

            InputService.InputEnded:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if CurrentKey and (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                    IsHolding = false
                    if Mode == "Hold" then
                        ExecuteCallback(false)
                    end
                end
            end)

            if Mode == "Always" then
                spawn(function()
                    while true do
                        if ToggleState then
                            ExecuteCallback(true)
                        end
                        wait()
                    end
                end)
            end

            Keybind.MouseEnter:Connect(function()
                TweenService:Create(Keybind, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            Keybind.MouseLeave:Connect(function()
                TweenService:Create(Keybind, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetKey(newKey)
                CurrentKey = newKey
                UpdateKeyText()
            end

            local function GetKey()
                return CurrentKey
            end

            local function SetMode(newMode)
                Mode = newMode
                ToggleState = false
                IsHolding = false
            end

            UpdateKeyText()

            return {
                Instance = Keybind,
                SetKey = SetKey,
                GetKey = GetKey,
                SetMode = SetMode
            }
        end

        function TabElements.ColorPicker(config)
            elementOrder = elementOrder + 1
            local ColorPicker = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 94),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = ColorPicker,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = ColorPicker,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 0, 20),
                Position = UDim2.new(0, 6, 0, 6),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Palette = Linux.Instance("ImageButton", {
                Parent = ColorPicker,
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Size = UDim2.new(1, -12, 0, 64),
                Position = UDim2.new(0, 6, 0, 26),
                Image = "rbxassetid://698052001",
                ZIndex = 1,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {
                Parent = Palette,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = Palette,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local PaletteKnob = Linux.Instance("Frame", {
                Parent = Palette,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(1, -5, 1, -5),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = PaletteKnob,
                CornerRadius = UDim.new(1, 0)
            })

            Linux.Instance("UIStroke", {
                Parent = PaletteKnob,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Hue = 0
            local Saturation = 1
            local Value = 1

            local function UpdateColor()
                local color = Color3.fromHSV(Hue, Saturation, Value)
                Palette.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
                spawn(function() Linux:SafeCallback(config.Callback, color) end)
            end

            local draggingPalette = false
            Palette.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingPalette = true
                    local posX = input.Position.X
                    local posY = input.Position.Y
                    local paletteSize = Palette.AbsoluteSize
                    local relativeX = math.clamp((posX - Palette.AbsolutePosition.X) / paletteSize.X, 0, 1)
                    local relativeY = math.clamp((posY - Palette.AbsolutePosition.Y) / paletteSize.Y, 0, 1)
                    Saturation = relativeX
                    Value = 1 - relativeY
                    PaletteKnob.Position = UDim2.new(relativeX, -5, relativeY, -5)
                    UpdateColor()
                end
            end)

            Palette.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingPalette then
                    local posX = input.Position.X
                    local posY = input.Position.Y
                    local paletteSize = Palette.AbsoluteSize
                    local relativeX = math.clamp((posX - Palette.AbsolutePosition.X) / paletteSize.X, 0, 1)
                    local relativeY = math.clamp((posY - Palette.AbsolutePosition.Y) / paletteSize.Y, 0, 1)
                    Saturation = relativeX
                    Value = 1 - relativeY
                    PaletteKnob.Position = UDim2.new(relativeX, -5, relativeY, -5)
                    UpdateColor()
                end
            end)

            Palette.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingPalette = false
                end
            end)

            ColorPicker.MouseEnter:Connect(function()
                TweenService:Create(ColorPicker, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            ColorPicker.MouseLeave:Connect(function()
                TweenService:Create(ColorPicker, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetColor(newColor)
                local h, s, v = newColor:ToHSV()
                Saturation = s
                Value = v
                PaletteKnob.Position = UDim2.new(Saturation, -5, 1 - Value, -5)
                UpdateColor()
            end

            local function GetColor()
                return Color3.fromHSV(Hue, Saturation, Value)
            end

            UpdateColor()

            return {
                Instance = ColorPicker,
                SetColor = SetColor,
                GetColor = GetColor
            }
        end

        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            local ParagraphFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -6, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = ParagraphFrame,
                CornerRadius = UDim.new(0, 6)
            })

            Linux.Instance("UIStroke", {
                Parent = ParagraphFrame,
                Color = Linux.Theme.Element,
                Thickness = 1,
                Transparency = 0.5
            })

            local Shadow = Linux.Instance("ImageLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(0, -5, 0, -5),
                Image = "rbxassetid://1316045217",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.9,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(10, 10, 118, 118),
                ZIndex = 0
            })

            local ParagraphTitle = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 0, 16),
                Position = UDim2.new(0, 6, 0, 0),
                Font = Enum.Font.SourceSansBold,
                Text = config.Title or "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ParagraphContent = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 0, 0),
                Position = UDim2.new(0, 6, 0, 18),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Enum.Font.SourceSans,
                Text = config.Content or "Description",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                ZIndex = 1
            })

            local FramePadding = Linux.Instance("UIPadding", {
                Parent = ParagraphFrame,
                PaddingTop = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6)
            })

            ParagraphFrame.MouseEnter:Connect(function()
                TweenService:Create(ParagraphFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Accent:lerp(Linux.Theme.Element, 0.8)}):Play()
            end)

            ParagraphFrame.MouseLeave:Connect(function()
                TweenService:Create(ParagraphFrame, TweenInfo.new(0.2), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            local function SetTitle(newTitle)
                ParagraphTitle.Text = tostring(newTitle)
            end

            local function GetTitle()
                return ParagraphTitle.Text
            end

            local function SetContent(newContent)
                ParagraphContent.Text = tostring(newContent)
            end

            local function GetContent()
                return ParagraphContent.Text
            end

            return {
                Instance = ParagraphFrame,
                SetTitle = SetTitle,
                GetTitle = GetTitle,
                SetContent = SetContent,
                GetContent = GetContent
            }
        end

        local TabElementsProxy = setmetatable({}, {
            __index = function(_, key)
                return TabElements[key]
            end,
            __newindex = function() end
        })

        for k, v in pairs(TabElements) do
            TabElementsProxy[k] = v
        end

        return TabElementsProxy
    end

    return LinuxLib
end

return Linux
