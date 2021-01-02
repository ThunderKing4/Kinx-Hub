----------------------------------------------------------------
-- Kinx Lib
----------------------------------------------------------------
-- Essential Varz and Funcs

local lib = {}
local draggingslider = {};
local tabs = {}
local togglekeybind = Enum.KeyCode.RightShift;

----------------------------------------------------------------
-- Core Funcs

local function IsUsingSliderLib()
	for i,v in pairs(draggingslider) do
		if v then
			return v;
		end
	end
	return false;
end

local function DragifyLib(MainFrame)

	local dragging
	local dragInput
	local dragStart
	local startPos

	function update(input)
		if IsUsingSliderLib() then return; end
		Delta = input.Position - dragStart
		Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(.25), {Position = Position}):Play()
	end

	MainFrame.InputBegan:Connect(function(input)
		if IsUsingSliderLib() then return; end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	MainFrame.InputChanged:Connect(function(input)
		if IsUsingSliderLib() then return; end
		if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

local function ApplyFrameResizingLib(scrollingframe)
	local calc = scrollingframe:FindFirstChild("UIGridLayout") or scrollingframe:FindFirstChild("UIListLayout") or nil;
	local function update()
		pcall(function()
			local cS = calc.AbsoluteContentSize
			scrollingframe.CanvasSize = UDim2.new(0,scrollingframe.Size.X,0,cS.Y + 30)
		end)
	end
	calc.Changed:Connect(update)
	update()
end

local function addInstance(instance, properties)
	if instance and type(properties) == "table" then
		local ins = Instance.new(tostring(instance))
		for i,v in pairs(properties or {}) do
			ins[i] = v
		end
		return ins;
	else
		error("Invalid input for addInstance function.")
	end
end

----------------------------------------------------------------
-- Lib Funcs

function lib:NewLib(UIName)

    local screengui = addInstance("ScreenGui", {
        Parent = game.CoreGui
    });

    local MainFrame = addInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),
        AnchorPoint = Vector2.new(0.5,0.5),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 420, 0, 300),
		ClipsDescendants = true,
        Parent = screengui
	});
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.KeyCode == togglekeybind then
			if MainFrame.Position.X.Scale > 1 or MainFrame.Position.Y.Scale > 1 then
				MainFrame:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
			else
				MainFrame:TweenPosition(MainFrame.Position + UDim2.new(2, 0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
			end
		end
	end)
	DragifyLib(MainFrame);
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = MainFrame
	});

    local TopFrame = addInstance("Frame", {
        Name = "TopFrame",
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 420, 0, 38),
        Parent = MainFrame
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = TopFrame
	});
	addInstance("Frame", {
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		Size = UDim2.new(1, 0, 0, 5),
		Position = UDim2.new(0, 0, 1, -5),
		AnchorPoint = Vector2.new(0,0),
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = TopFrame
	});

    local libname = addInstance("TextLabel", {
        Name = "LibName",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0.0357142873, 0, 0.131210729, 0),
        Size = UDim2.new(0, 106, 0, 27),
        Font = Enum.Font.Fantasy,
        Text = UIName,
        TextColor3 = Color3.fromRGB(6, 255, 255),
        TextSize = 20.000,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopFrame
    });

    local TabFrame = addInstance("Frame", {
        Name = "TabFrame",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.126666665, 0),
        Size = UDim2.new(0, 115, 0, 262),
        Parent = MainFrame
	});
	addInstance("Frame", {
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Size = UDim2.new(0, 5, 0, 262),
		Position = UDim2.new(0, 110, 0.126666665, 0),
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = MainFrame
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = TabFrame
	});

    addInstance("UIGridLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        CellPadding = UDim2.new(0, 5, 0, 8),
        CellSize = UDim2.new(0, 85, 0, 30),
        Parent = TabFrame
    });
    addInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        Parent = TabFrame
    });

    return MainFrame;

end

function lib:NewSection(LibInstance, SectionName)
    local btn = addInstance("TextButton", {
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 50),
        Font = Enum.Font.DenkOne,
        Text = SectionName,
        TextColor3 = Color3.fromRGB(6, 255, 255),
        TextSize = 14.000,
        Parent = LibInstance.TabFrame
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = btn
	});

    local scrollingframe = addInstance("ScrollingFrame", {
        Name = "SectionFrame",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.fromRGB(93, 93, 93),
        Visible = false;
        Position = UDim2.new(0.273809522, 0, 0.126666665, 0),
        Size = UDim2.new(0, 305, 0, 262),
        ScrollBarThickness = 6,
        Parent = LibInstance
    });

    addInstance("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = scrollingframe
    });

    addInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 15),
		PaddingTop = UDim.new(0, 10),
        Parent = scrollingframe
    });

    ApplyFrameResizingLib(scrollingframe);
    table.insert(tabs, 1, scrollingframe)

    btn.MouseButton1Click:Connect(function()
        for i,v in pairs(tabs) do
            if v ~= scrollingframe then v.Visible = false else v.Visible = true end;
        end
    end)

    return scrollingframe;

end

function lib:SetActive(Section)
    Section.Visible = true
end

function lib:NewButton(section, value, func)
    func = func or function() end
    local button = addInstance("TextButton", {
		Text = value,
		TextSize = 14,
        BorderSizePixel = 0,
        TextColor3 = Color3.fromRGB(6, 255, 255),
        Size = UDim2.new(0, 278,0, 33),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Font = Enum.Font.DenkOne,
        Parent = section
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = button
	});

    button.MouseButton1Click:Connect(func)

    return button;
end

function lib:NewCheckBox(section, value, status, func)
    local f = addInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 278, 0, 33),
        Parent = section
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = f
	});
    local tl = addInstance("TextLabel", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.147482008, 88, 1, 0),
        Font = Enum.Font.DenkOne,
        Text = value,
        TextColor3 = Color3.fromRGB(6, 255, 255),
        TextSize = 14.000,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f
    });
    local toggle = addInstance("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
        Position = UDim2.new(0.930000007, 0, 0.5, 0),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.DenkOne,
        Text = "",
        TextColor3 = Color3.fromRGB(6, 255, 255),
        TextSize = 14.000,
        Parent = f
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = toggle
	});

    local state = status
	if state then
		toggle.BackgroundColor3 = Color3.fromRGB(6, 255, 255)
	end
	toggle.MouseButton1Click:Connect(function()
		state = not state;
		if state then
			game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(6, 255, 255)}):Play()
		else
			game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
		end
		spawn(function()
			pcall(function()
				func(state)
			end)
		end)
    end)
    
    return f;
end

function lib:NewSlider(section, value, default, min, max, func)
	
	default = math.clamp(default, min, max) or min

	local Frame = addInstance("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 278, 0, 62),
		Parent = section
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,5),
		Parent = Frame
	});
	local SliderFrame = addInstance("Frame", {
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		Position = UDim2.new(0.0599999726, 0, 0.677419364, 0),
		Size = UDim2.new(0, 251, 0, 4),
		Parent = Frame
	});
	local Indicator = addInstance("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(6, 255, 255),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		Parent = SliderFrame
	});
	local IndicatorTrail = addInstance("Frame", {
		Name = "Indicator",
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(6, 255, 255),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		Parent = SliderFrame
	});
	addInstance("TextLabel", {
		Name = "Value",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(0, 153, 0, 35),
		Text = "Slider",
		TextColor3 = Color3.fromRGB(6, 255, 255),
		TextSize = 14.000,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.DenkOne,
		Parent = Frame
	});
	local ValueDisplay = addInstance("TextLabel", {
		Name = "ValueDisplayer",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 219, 0, 0),
		Size = UDim2.new(0, 48, 0, 35),
		Text = "50",
		TextColor3 = Color3.fromRGB(6, 255, 255),
		TextSize = 14.000,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.DenkOne,
		Parent = Frame
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,8),
		Parent = Indicator
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,8),
		Parent = IndicatorTrail
	});
	addInstance("UICorner", {
		CornerRadius = UDim.new(0,8),
		Parent = SliderFrame
	});

	ValueDisplay.Text = default
	Indicator.Position = UDim2.new((default - min)/(max - min), 0, 0.5, 0)
	IndicatorTrail.Size = UDim2.new((default - min)/(max - min), 0, 0.5, 0)

	local function slide(input, ind, trail)
		local pos = UDim2.new(math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1), 0, 0.5, 0)
		ind:TweenPosition(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		trail:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		local s = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
		spawn(function()
			pcall(function()
				ValueDisplay.Text = tostring(s)
				func(s)
			end)
		end)
	end

	Indicator.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			slide(input, Indicator, IndicatorTrail)
			draggingslider[Indicator] = true
		end
	end)

	Indicator.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingslider[Indicator] = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if draggingslider[Indicator] and input.UserInputType == Enum.UserInputType.MouseMovement then
			slide(input, Indicator, IndicatorTrail)		
		end
	end)

end

----------------------------------------------------------------
-- Return Lib

return lib;
