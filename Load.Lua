local placeId = game.PlaceId


	if placeId == 2753915549 then --- Blox Fruit Old

		if game.CoreGui:FindFirstChild("Xenon Hub") then
			game.CoreGui:FindFirstChild("Xenon Hub"):Destroy()
		end

		-- init
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- services
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new

-- additional
local utility = {}

-- themes
local objects = {}
local themes = {
	Background = Color3.fromRGB(15,15,15), 
	Glow = Color3.fromRGB(0, 0, 0), 
	Accent = Color3.fromRGB(10, 10, 10), 
	LightContrast = Color3.fromRGB(20, 20, 20), 
	DarkContrast = Color3.fromRGB(10,10,10),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

do
	function utility:Create(instance, properties, children)
		local object = Instance.new(instance)

		for i, v in pairs(properties or {}) do
			object[i] = v

			if typeof(v) == "Color3" then -- save for theme changer later
				local theme = utility:Find(themes, v)

				if theme then
					objects[theme] = objects[theme] or {}
					objects[theme][i] = objects[theme][i] or setmetatable({}, {_mode = "k"})

					table.insert(objects[theme][i], object)
				end
			end
		end

		for i, module in pairs(children or {}) do
			module.Parent = object
		end

		return object
	end

	function utility:Tween(instance, properties, duration, ...)
		tween:Create(instance, tweeninfo(duration, ...), properties):Play()
	end

	function utility:Wait()
		run.RenderStepped:Wait()
		return true
	end

	function utility:Find(table, value) -- table.find doesn't work for dictionaries
		for i, v in  pairs(table) do
			if v == value then
				return i
			end
		end
	end

	function utility:Sort(pattern, values)
		local new = {}
		pattern = pattern:lower()

		if pattern == "" then
			return values
		end

		for i, value in pairs(values) do
			if tostring(value):lower():find(pattern) then
				table.insert(new, value)
			end
		end

		return new
	end

	function utility:Pop(object, shrink)
		local clone = object:Clone()

		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Size = clone.Size - UDim2.new(0, shrink, 0, shrink)
		clone.Position = UDim2.new(0.5, 0, 0.5, 0)

		clone.Parent = object
		clone:ClearAllChildren()

		object.ImageTransparency = 1
		utility:Tween(clone, {Size = object.Size}, 0.2)

		spawn(function()
			wait(0.2)

			object.ImageTransparency = 0
			clone:Destroy()
		end)

		return clone
	end

	function utility:InitializeKeybind()
		self.keybinds = {}
		self.ended = {}

		input.InputBegan:Connect(function(key)
			if self.keybinds[key.KeyCode] then
				for i, bind in pairs(self.keybinds[key.KeyCode]) do
					bind()
				end
			end
		end)

		input.InputEnded:Connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				for i, callback in pairs(self.ended) do
					callback()
				end
			end
		end)
	end

	function utility:BindToKey(key, callback)

		self.keybinds[key] = self.keybinds[key] or {}

		table.insert(self.keybinds[key], callback)

		return {
			UnBind = function()
				for i, bind in pairs(self.keybinds[key]) do
					if bind == callback then
						table.remove(self.keybinds[key], i)
					end
				end
			end
		}
	end

	function utility:KeyPressed() -- yield until next key is pressed
		local key = input.InputBegan:Wait()

		while key.UserInputType ~= Enum.UserInputType.Keyboard	 do
			key = input.InputBegan:Wait()
		end

		wait() -- overlapping connection

		return key
	end

	function utility:DraggingEnabled(frame, parent)

		parent = parent or frame

		-- stolen from wally or kiriot, kek
		local dragging = false
		local dragInput, mousePos, framePos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				mousePos = input.Position
				framePos = parent.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		input.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - mousePos
				parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			end
		end)

	end

	function utility:DraggingEnded(callback)
		table.insert(self.ended, callback)
	end

end

-- classes

local library = {} -- main
local page = {}
local section = {}

do
	library.__index = library
	page.__index = page
	section.__index = section

	-- new classes

	function library.new(title)
		local container = utility:Create("ScreenGui", {
			Name = title,
			Parent = game.CoreGui
		}, {
			utility:Create("ImageLabel", {
				Name = "Main",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.25, 0, 0.052435593, 0),
				Size = UDim2.new(0, 511, 0, 428),
				Image = "rbxassetid://4641149554",
				ImageColor3 = themes.Background,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(4, 4, 296, 296)
			}, {
				utility:Create("ImageLabel", {
					Name = "Glow",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -15, 0, -15),
					Size = UDim2.new(1, 30, 1, 30),
					ZIndex = 0,
					Image = "rbxassetid://5028857084",
					ImageColor3 = themes.Glow,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(24, 24, 276, 276)
				}),
				utility:Create("ImageLabel", {
					Name = "Pages",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Position = UDim2.new(0, 0, 0, 38),
					Size = UDim2.new(0, 126, 1, -38),
					ZIndex = 3,
					Image = "rbxassetid://5012534273",
					ImageColor3 = themes.DarkContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(4, 4, 296, 296)
				}, {
					utility:Create("ScrollingFrame", {
						Name = "Pages_Container",
						Active = true,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 10),
						Size = UDim2.new(1, 0, 1, -20),
						CanvasSize = UDim2.new(0, 0, 0, 314),
						ScrollBarThickness = 0
					}, {
						utility:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 10)
						})
					})
				}),
				utility:Create("ImageLabel", {
					Name = "TopBar",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, 38),
					ZIndex = 5,
					Image = "rbxassetid://4595286933",
					ImageColor3 = themes.Accent,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(4, 4, 296, 296)
				}, {
					utility:Create("TextLabel", { -- title
						Name = "Title",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0, 19),
						Size = UDim2.new(1, -46, 0, 16),
						ZIndex = 5,
						Font = Enum.Font.GothamBold,
						Text = title,
						TextColor3 = themes.TextColor,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			})
		})

		utility:InitializeKeybind()
		utility:DraggingEnabled(container.Main.TopBar, container.Main)

		return setmetatable({
			container = container,
			pagesContainer = container.Main.Pages.Pages_Container,
			pages = {}
		}, library)
	end

	function page.new(library, title, icon)
		local button = utility:Create("TextButton", {
			Name = title,
			Parent = library.pagesContainer,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 26),
			ZIndex = 3,
			AutoButtonColor = false,
			Font = Enum.Font.Gotham,
			Text = "",
			TextSize = 14
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 40, 0.5, 0),
				Size = UDim2.new(0, 76, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.65,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			icon and utility:Create("ImageLabel", {
				Name = "Icon", 
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0.5, 0),
				Size = UDim2.new(0, 16, 0, 16),
				ZIndex = 3,
				ImageColor3 = themes.TextColor,
				ImageTransparency = 0.64
			}) or {}
		})

		local container = utility:Create("ScrollingFrame", {
			Name = title,
			Parent = library.container.Main,
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 134, 0, 46),
			Size = UDim2.new(1, -142, 1, -56),
			CanvasSize = UDim2.new(0, 0, 0, 466),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = themes.DarkContrast,
			Visible = false
		}, {
			utility:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			})
		})

		return setmetatable({
			library = library,
			container = container,
			button = button,
			sections = {}
		}, page)
	end

	function section.new(page, title)
		local container = utility:Create("ImageLabel", {
			Name = title,
			Parent = page.container,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 0, 28),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.LightContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 296, 296),
			ClipsDescendants = true
		}, {
			utility:Create("Frame", {
				Name = "Container",
				Active = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 8, 0, 8),
				Size = UDim2.new(1, -16, 1, -16)
			}, {
				utility:Create("TextLabel", {
					Name = "Title",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 20),
					ZIndex = 2,
					Font = Enum.Font.GothamSemibold,
					Text = title,
					TextColor3 = themes.TextColor,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = 1
				}),
				utility:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				})
			})
		})

		return setmetatable({
			page = page,
			container = container.Container,
			colorpickers = {},
			modules = {},
			binds = {},
			lists = {},
		}, section) 
	end

	function library:addPage(...)

		local page = page.new(self, ...)
		local button = page.button

		table.insert(self.pages, page)

		button.MouseButton1Click:Connect(function()
			self:SelectPage(page, true)
		end)

		return page
	end

	function page:addSection(...)
		local section = section.new(self, ...)

		table.insert(self.sections, section)

		return section
	end

	-- functions

	function library:setTheme(theme, color3)
		themes[theme] = color3

		for property, objects in pairs(objects[theme]) do
			for i, object in pairs(objects) do
				if not object.Parent or (object.Name == "Button" and object.Parent.Name == "ColorPicker") then
					objects[i] = nil -- i can do this because weak tables :D
				else
					object[property] = color3
				end
			end
		end
	end

	function library:toggle()

		if self.toggling then
			return
		end

		self.toggling = true

		local container = self.container.Main
		local topbar = container.TopBar

		if self.position then
			utility:Tween(container, {
				Size = UDim2.new(0, 511, 0, 428),
				Position = self.position
			}, 0.2)
			wait(0.2)

			utility:Tween(topbar, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
			wait(0.2)

			container.ClipsDescendants = false
			self.position = nil
		else
			self.position = container.Position
			container.ClipsDescendants = true

			utility:Tween(topbar, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)
			wait(0.2)

			utility:Tween(container, {
				Size = UDim2.new(0, 511, 0, 0),
				Position = self.position + UDim2.new(0, 0, 0, 428)
			}, 0.2)
			wait(0.2)
		end

		self.toggling = false
	end

	-- new modules

	function library:Notify(title, text, callback)

		-- overwrite last notification
		if self.activeNotification then
			self.activeNotification = self.activeNotification()
		end

		-- standard create
		local notification = utility:Create("ImageLabel", {
			Name = "Notification",
			Parent = self.container,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 200, 0, 60),
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.Background,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(4, 4, 296, 296),
			ZIndex = 3,
			ClipsDescendants = true
		}, {
			utility:Create("ImageLabel", {
				Name = "Flash",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ImageColor3 = themes.TextColor,
				ZIndex = 5
			}),
			utility:Create("ImageLabel", {
				Name = "Glow",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -15, 0, -15),
				Size = UDim2.new(1, 30, 1, 30),
				ZIndex = 2,
				Image = "rbxassetid://5028857084",
				ImageColor3 = themes.Glow,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(24, 24, 276, 276)
			}),
			utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 8),
				Size = UDim2.new(1, -40, 0, 16),
				ZIndex = 4,
				Font = Enum.Font.GothamSemibold,
				TextColor3 = themes.TextColor,
				TextSize = 14.000,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("TextLabel", {
				Name = "Text",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 1, -24),
				Size = UDim2.new(1, -40, 0, 16),
				ZIndex = 4,
				Font = Enum.Font.Gotham,
				TextColor3 = themes.TextColor,
				TextSize = 12.000,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageButton", {
				Name = "Accept",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -26, 0, 8),
				Size = UDim2.new(0, 16, 0, 16),
				ImageColor3 = themes.TextColor,
				ZIndex = 4
			}),
			utility:Create("ImageButton", {
				Name = "Decline",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -26, 1, -24),
				Size = UDim2.new(0, 16, 0, 16),
				Image = "",
				ImageColor3 = themes.TextColor,
				ZIndex = 4
			})
		})

		-- dragging
		utility:DraggingEnabled(notification)

		-- position and size
		title = title or "Notification"
		text = text or ""

		notification.Title.Text = title
		notification.Text.Text = text

		local padding = 10
		local textSize = game:GetService("TextService"):GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(math.huge, 16))

		notification.Position = library.lastNotification or UDim2.new(0, padding, 1, -(notification.AbsoluteSize.Y + padding))
		notification.Size = UDim2.new(0, 0, 0, 60)

		utility:Tween(notification, {Size = UDim2.new(0, textSize.X + 70, 0, 60)}, 0.2)
		wait(0.2)

		notification.ClipsDescendants = false
		utility:Tween(notification.Flash, {
			Size = UDim2.new(0, 0, 0, 60),
			Position = UDim2.new(1, 0, 0, 0)
		}, 0.2)

		-- callbacks
		local active = true
		local close = function()

			if not active then
				return
			end

			active = false
			notification.ClipsDescendants = true

			library.lastNotification = notification.Position
			notification.Flash.Position = UDim2.new(0, 0, 0, 0)
			utility:Tween(notification.Flash, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)

			wait(0.2)
			utility:Tween(notification, {
				Size = UDim2.new(0, 0, 0, 60),
				Position = notification.Position + UDim2.new(0, textSize.X + 70, 0, 0)
			}, 0.2)

			wait(0.2)
			notification:Destroy()
		end

		self.activeNotification = close

		notification.Accept.MouseButton1Click:Connect(function()

			if not active then 
				return
			end

			if callback then
				callback(true)
			end

			close()
		end)

		notification.Decline.MouseButton1Click:Connect(function()

			if not active then 
				return
			end

			if callback then
				callback(false)
			end

			close()
		end)
	end

	function section:addButton(title, callback)
		local button = utility:Create("ImageButton", {
			Name = "Button",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012
			})
		})

		table.insert(self.modules, button)
		--self:Resize()

		local text = button.Title
		local debounce

		button.MouseButton1Click:Connect(function()

			if debounce then
				return
			end

			-- animation
			utility:Pop(button, 10)

			debounce = true
			text.TextSize = 0
			utility:Tween(button.Title, {TextSize = 14}, 0.2)

			wait(0.2)
			utility:Tween(button.Title, {TextSize = 12}, 0.2)

			if callback then
				callback(function(...)
					self:updateButton(button, ...)
				end)
			end

			debounce = false
		end)

		return button
	end

	function section:addToggle(title, default, callback)
		local toggle = utility:Create("ImageButton", {
			Name = "Toggle",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		},{
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(0.5, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageLabel", {
				Name = "Button",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -50, 0.5, -8),
				Size = UDim2.new(0, 40, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("ImageLabel", {
					Name = "Frame",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 2, 0.5, -6),
					Size = UDim2.new(1, -22, 1, -4),
					ZIndex = 2,
					Image = "rbxassetid://5028857472",
					ImageColor3 = themes.TextColor,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				})
			})
		})

		table.insert(self.modules, toggle)
		--self:Resize()

		local active = default
		local active = default
		self:updateToggle(toggle, nil, active)

		toggle.MouseButton1Click:Connect(function()
			active = not active
			self:updateToggle(toggle, nil, active)

			if callback then
				callback(active, function(...)
					self:updateToggle(toggle, ...)
				end)
			end
		end)

		return toggle
	end

	function section:addTextbox(title, default, callback)
		local textbox = utility:Create("ImageButton", {
			Name = "Textbox",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(0.5, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageLabel", {
				Name = "Button",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -110, 0.5, -8),
				Size = UDim2.new(0, 100, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("TextBox", {
					Name = "Textbox", 
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Position = UDim2.new(0, 5, 0, 0),
					Size = UDim2.new(1, -10, 1, 0),
					ZIndex = 3,
					Font = Enum.Font.GothamSemibold,
					Text = default or "",
					TextColor3 = themes.TextColor,
					TextSize = 11
				})
			})
		})

		table.insert(self.modules, textbox)
		--self:Resize()

		local button = textbox.Button
		local input = button.Textbox

		textbox.MouseButton1Click:Connect(function()

			if textbox.Button.Size ~= UDim2.new(0, 100, 0, 16) then
				return
			end

			utility:Tween(textbox.Button, {
				Size = UDim2.new(0, 200, 0, 16),
				Position = UDim2.new(1, -210, 0.5, -8)
			}, 0.2)

			wait()

			input.TextXAlignment = Enum.TextXAlignment.Left
			input:CaptureFocus()
		end)

		input:GetPropertyChangedSignal("Text"):Connect(function()

			if button.ImageTransparency == 0 and (button.Size == UDim2.new(0, 200, 0, 16) or button.Size == UDim2.new(0, 100, 0, 16)) then -- i know, i dont like this either
				utility:Pop(button, 10)
			end

			if callback then
				callback(input.Text, nil, function(...)
					self:updateTextbox(textbox, ...)
				end)
			end
		end)

		input.FocusLost:Connect(function()

			input.TextXAlignment = Enum.TextXAlignment.Center

			utility:Tween(textbox.Button, {
				Size = UDim2.new(0, 100, 0, 16),
				Position = UDim2.new(1, -110, 0.5, -8)
			}, 0.2)

			if callback then
				callback(input.Text, true, function(...)
					self:updateTextbox(textbox, ...)
				end)
			end
		end)

		return textbox
	end

	function section:addKeybind(title, default, callback, changedCallback)
		local keybind = utility:Create("ImageButton", {
			Name = "Keybind",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageLabel", {
				Name = "Button",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -110, 0.5, -8),
				Size = UDim2.new(0, 100, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.LightContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("TextLabel", {
					Name = "Text",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 3,
					Font = Enum.Font.GothamSemibold,
					Text = default and default.Name or "None",
					TextColor3 = themes.TextColor,
					TextSize = 11
				})
			})
		})

		table.insert(self.modules, keybind)
		--self:Resize()

		local text = keybind.Button.Text
		local button = keybind.Button

		local animate = function()
			if button.ImageTransparency == 0 then
				utility:Pop(button, 10)
			end
		end

		self.binds[keybind] = {callback = function()
			animate()

			if callback then
				callback(function(...)
					self:updateKeybind(keybind, ...)
				end)
			end
		end}

		if default and callback then
			self:updateKeybind(keybind, nil, default)
		end

		keybind.MouseButton1Click:Connect(function()

			animate()

			if self.binds[keybind].connection then -- unbind
				return self:updateKeybind(keybind)
			end

			if text.Text == "None" then -- new bind
				text.Text = "..."

				local key = utility:KeyPressed()

				self:updateKeybind(keybind, nil, key.KeyCode)
				animate()

				if changedCallback then
					changedCallback(key, function(...)
						self:updateKeybind(keybind, ...)
					end)
				end
			end
		end)

		return keybind
	end

	function section:addColorPicker(title, default, callback)
		local colorpicker = utility:Create("ImageButton", {
			Name = "ColorPicker",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		},{
			utility:Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, 1),
				Size = UDim2.new(0.5, 0, 1, 0),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageButton", {
				Name = "Button",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -50, 0.5, -7),
				Size = UDim2.new(0, 40, 0, 14),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			})
		})

		local tab = utility:Create("ImageLabel", {
			Name = "ColorPicker",
			Parent = self.page.library.container,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.75, 0, 0.400000006, 0),
			Selectable = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 162, 0, 169),
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.Background,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298),
			Visible = false,
		}, {
			utility:Create("ImageLabel", {
				Name = "Glow",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -15, 0, -15),
				Size = UDim2.new(1, 30, 1, 30),
				ZIndex = 0,
				Image = "rbxassetid://5028857084",
				ImageColor3 = themes.Glow,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(22, 22, 278, 278)
			}),
			utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 8),
				Size = UDim2.new(1, -40, 0, 16),
				ZIndex = 2,
				Font = Enum.Font.GothamSemibold,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("ImageButton", {
				Name = "Close",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -26, 0, 8),
				Size = UDim2.new(0, 16, 0, 16),
				ZIndex = 2,
				Image = "rbxassetid://5012538583",
				ImageColor3 = themes.TextColor
			}), 
			utility:Create("Frame", {
				Name = "Container",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 8, 0, 32),
				Size = UDim2.new(1, -18, 1, -40)
			}, {
				utility:Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6)
				}),
				utility:Create("ImageButton", {
					Name = "Canvas",
					BackgroundTransparency = 1,
					BorderColor3 = themes.LightContrast,
					Size = UDim2.new(1, 0, 0, 60),
					AutoButtonColor = false,
					Image = "rbxassetid://5108535320",
					ImageColor3 = Color3.fromRGB(255, 0, 0),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					utility:Create("ImageLabel", {
						Name = "White_Overlay",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 60),
						Image = "rbxassetid://5107152351",
						SliceCenter = Rect.new(2, 2, 298, 298)
					}),
					utility:Create("ImageLabel", {
						Name = "Black_Overlay",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 60),
						Image = "rbxassetid://5107152095",
						SliceCenter = Rect.new(2, 2, 298, 298)
					}),
					utility:Create("ImageLabel", {
						Name = "Cursor",
						BackgroundColor3 = themes.TextColor,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1.000,
						Size = UDim2.new(0, 10, 0, 10),
						Position = UDim2.new(0, 0, 0, 0),
						Image = "rbxassetid://5100115962",
						SliceCenter = Rect.new(2, 2, 298, 298)
					})
				}),
				utility:Create("ImageButton", {
					Name = "Color",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 4),
					Selectable = false,
					Size = UDim2.new(1, 0, 0, 16),
					ZIndex = 2,
					AutoButtonColor = false,
					Image = "rbxassetid://5028857472",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					utility:Create("Frame", {
						Name = "Select",
						BackgroundColor3 = themes.TextColor,
						BorderSizePixel = 1,
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.new(0, 2, 1, 0),
						ZIndex = 2
					}),
					utility:Create("UIGradient", { -- rainbow canvas
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), 
							ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), 
							ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), 
							ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), 
							ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)), 
							ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255)), 
							ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
						})
					})
				}),
				utility:Create("Frame", {
					Name = "Inputs",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 158),
					Size = UDim2.new(1, 0, 0, 16)
				}, {
					utility:Create("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 6)
					}),
					utility:Create("ImageLabel", {
						Name = "R",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(0.305, 0, 1, 0),
						ZIndex = 2,
						Image = "rbxassetid://5028857472",
						ImageColor3 = themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						utility:Create("TextLabel", {
							Name = "Text",
							BackgroundTransparency = 1,
							Size = UDim2.new(0.400000006, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "R:",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						}),
						utility:Create("TextBox", {
							Name = "Textbox",
							BackgroundTransparency = 1,
							Position = UDim2.new(0.300000012, 0, 0, 0),
							Size = UDim2.new(0.600000024, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							PlaceholderColor3 = themes.DarkContrast,
							Text = "255",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						})
					}),
					utility:Create("ImageLabel", {
						Name = "G",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(0.305, 0, 1, 0),
						ZIndex = 2,
						Image = "rbxassetid://5028857472",
						ImageColor3 = themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						utility:Create("TextLabel", {
							Name = "Text",
							BackgroundTransparency = 1,
							ZIndex = 2,
							Size = UDim2.new(0.400000006, 0, 1, 0),
							Font = Enum.Font.Gotham,
							Text = "G:",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						}),
						utility:Create("TextBox", {
							Name = "Textbox",
							BackgroundTransparency = 1,
							Position = UDim2.new(0.300000012, 0, 0, 0),
							Size = UDim2.new(0.600000024, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "255",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						})
					}),
					utility:Create("ImageLabel", {
						Name = "B",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(0.305, 0, 1, 0),
						ZIndex = 2,
						Image = "rbxassetid://5028857472",
						ImageColor3 = themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						utility:Create("TextLabel", {
							Name = "Text",
							BackgroundTransparency = 1,
							Size = UDim2.new(0.400000006, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "B:",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						}),
						utility:Create("TextBox", {
							Name = "Textbox",
							BackgroundTransparency = 1,
							Position = UDim2.new(0.300000012, 0, 0, 0),
							Size = UDim2.new(0.600000024, 0, 1, 0),
							ZIndex = 2,
							Font = Enum.Font.Gotham,
							Text = "255",
							TextColor3 = themes.TextColor,
							TextSize = 10.000
						})
					}),
				}),
				utility:Create("ImageButton", {
					Name = "Button",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 20),
					ZIndex = 2,
					Image = "rbxassetid://5028857472",
					ImageColor3 = themes.DarkContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					utility:Create("TextLabel", {
						Name = "Text",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 3,
						Font = Enum.Font.Gotham,
						Text = "Submit",
						TextColor3 = themes.TextColor,
						TextSize = 11.000
					})
				})
			})
		})

		utility:DraggingEnabled(tab)
		table.insert(self.modules, colorpicker)
		--self:Resize()

		local allowed = {
			[""] = true
		}

		local canvas = tab.Container.Canvas
		local color = tab.Container.Color

		local canvasSize, canvasPosition = canvas.AbsoluteSize, canvas.AbsolutePosition
		local colorSize, colorPosition = color.AbsoluteSize, color.AbsolutePosition

		local draggingColor, draggingCanvas

		local color3 = default or Color3.fromRGB(255, 255, 255)
		local hue, sat, brightness = 0, 0, 1
		local rgb = {
			r = 255,
			g = 255,
			b = 255
		}

		self.colorpickers[colorpicker] = {
			tab = tab,
			callback = function(prop, value)
				rgb[prop] = value
				hue, sat, brightness = Color3.toHSV(Color3.fromRGB(rgb.r, rgb.g, rgb.b))
			end
		}

		local callback = function(value)
			if callback then
				callback(value, function(...)
					self:updateColorPicker(colorpicker, ...)
				end)
			end
		end

		utility:DraggingEnded(function()
			draggingColor, draggingCanvas = false, false
		end)

		if default then
			self:updateColorPicker(colorpicker, nil, default)

			hue, sat, brightness = Color3.toHSV(default)
			default = Color3.fromHSV(hue, sat, brightness)

			for i, prop in pairs({"r", "g", "b"}) do
				rgb[prop] = default[prop:upper()] * 255
			end
		end

		for i, container in pairs(tab.Container.Inputs:GetChildren()) do -- i know what you are about to say, so shut up
			if container:IsA("ImageLabel") then
				local textbox = container.Textbox
				local focused

				textbox.Focused:Connect(function()
					focused = true
				end)

				textbox.FocusLost:Connect(function()
					focused = false

					if not tonumber(textbox.Text) then
						textbox.Text = math.floor(rgb[container.Name:lower()])
					end
				end)

				textbox:GetPropertyChangedSignal("Text"):Connect(function()
					local text = textbox.Text

					if not allowed[text] and not tonumber(text) then
						textbox.Text = text:sub(1, #text - 1)
					elseif focused and not allowed[text] then
						rgb[container.Name:lower()] = math.clamp(tonumber(textbox.Text), 0, 255)

						local color3 = Color3.fromRGB(rgb.r, rgb.g, rgb.b)
						hue, sat, brightness = Color3.toHSV(color3)

						self:updateColorPicker(colorpicker, nil, color3)
						callback(color3)
					end
				end)
			end
		end

		canvas.MouseButton1Down:Connect(function()
			draggingCanvas = true

			while draggingCanvas do

				local x, y = mouse.X, mouse.Y

				sat = math.clamp((x - canvasPosition.X) / canvasSize.X, 0, 1)
				brightness = 1 - math.clamp((y - canvasPosition.Y) / canvasSize.Y, 0, 1)

				color3 = Color3.fromHSV(hue, sat, brightness)

				for i, prop in pairs({"r", "g", "b"}) do
					rgb[prop] = color3[prop:upper()] * 255
				end

				self:updateColorPicker(colorpicker, nil, {hue, sat, brightness}) -- roblox is literally retarded
				utility:Tween(canvas.Cursor, {Position = UDim2.new(sat, 0, 1 - brightness, 0)}, 0.1) -- overwrite

				callback(color3)
				utility:Wait()
			end
		end)

		color.MouseButton1Down:Connect(function()
			draggingColor = true

			while draggingColor do

				hue = 1 - math.clamp(1 - ((mouse.X - colorPosition.X) / colorSize.X), 0, 1)
				color3 = Color3.fromHSV(hue, sat, brightness)

				for i, prop in pairs({"r", "g", "b"}) do
					rgb[prop] = color3[prop:upper()] * 255
				end

				local x = hue -- hue is updated
				self:updateColorPicker(colorpicker, nil, {hue, sat, brightness}) -- roblox is literally retarded
				utility:Tween(tab.Container.Color.Select, {Position = UDim2.new(x, 0, 0, 0)}, 0.1) -- overwrite

				callback(color3)
				utility:Wait()
			end
		end)

		-- click events
		local button = colorpicker.Button
		local toggle, debounce, animate

		lastColor = Color3.fromHSV(hue, sat, brightness)
		animate = function(visible, overwrite)

			if overwrite then

				if not toggle then
					return
				end

				if debounce then
					while debounce do
						utility:Wait()
					end
				end
			elseif not overwrite then
				if debounce then 
					return 
				end

				if button.ImageTransparency == 0 then
					utility:Pop(button, 10)
				end
			end

			toggle = visible
			debounce = true

			if visible then

				if self.page.library.activePicker and self.page.library.activePicker ~= animate then
					self.page.library.activePicker(nil, true)
				end

				self.page.library.activePicker = animate
				lastColor = Color3.fromHSV(hue, sat, brightness)

				local x1, x2 = button.AbsoluteSize.X / 2, 162--tab.AbsoluteSize.X
				local px, py = button.AbsolutePosition.X, button.AbsolutePosition.Y

				tab.ClipsDescendants = true
				tab.Visible = true
				tab.Size = UDim2.new(0, 0, 0, 0)

				tab.Position = UDim2.new(0, x1 + x2 + px, 0, py)
				utility:Tween(tab, {Size = UDim2.new(0, 162, 0, 169)}, 0.2)

				-- update size and position
				wait(0.2)
				tab.ClipsDescendants = false

				canvasSize, canvasPosition = canvas.AbsoluteSize, canvas.AbsolutePosition
				colorSize, colorPosition = color.AbsoluteSize, color.AbsolutePosition
			else
				utility:Tween(tab, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
				tab.ClipsDescendants = true

				wait(0.2)
				tab.Visible = false
			end

			debounce = false
		end

		local toggleTab = function()
			animate(not toggle)
		end

		button.MouseButton1Click:Connect(toggleTab)
		colorpicker.MouseButton1Click:Connect(toggleTab)

		tab.Container.Button.MouseButton1Click:Connect(function()
			animate()
		end)

		tab.Close.MouseButton1Click:Connect(function()
			self:updateColorPicker(colorpicker, nil, lastColor)
			animate()
		end)

		return colorpicker
	end

	function section:addSlider(title, default, min, max, callback)
		local slider = utility:Create("ImageButton", {
			Name = "Slider",
			Parent = self.container,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0.292817682, 0, 0.299145311, 0),
			Size = UDim2.new(1, 0, 0, 50),
			ZIndex = 2,
			Image = "rbxassetid://5028857472",
			ImageColor3 = themes.DarkContrast,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(2, 2, 298, 298)
		}, {
			utility:Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 6),
				Size = UDim2.new(0.5, 0, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.Gotham,
				Text = title,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextTransparency = 0.10000000149012,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			utility:Create("TextBox", {
				Name = "TextBox",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -30, 0, 6),
				Size = UDim2.new(0, 20, 0, 16),
				ZIndex = 3,
				Font = Enum.Font.GothamSemibold,
				Text = default or min,
				TextColor3 = themes.TextColor,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right
			}),
			utility:Create("TextLabel", {
				Name = "Slider",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 28),
				Size = UDim2.new(1, -20, 0, 16),
				ZIndex = 3,
				Text = "",
			}, {
				utility:Create("ImageLabel", {
					Name = "Bar",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 0, 4),
					ZIndex = 3,
					Image = "rbxassetid://5028857472",
					ImageColor3 = themes.LightContrast,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(2, 2, 298, 298)
				}, {
					utility:Create("ImageLabel", {
						Name = "Fill",
						BackgroundTransparency = 1,
						Size = UDim2.new(0.8, 0, 1, 0),
						ZIndex = 3,
						Image = "rbxassetid://5028857472",
						ImageColor3 = themes.TextColor,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(2, 2, 298, 298)
					}, {
						utility:Create("ImageLabel", {
							Name = "Circle",
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = 1.000,
							ImageColor3 = themes.TextColor,
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.new(0, 10, 0, 10),
							ZIndex = 3,
							Image = "rbxassetid://4608020054"
						})
					})
				})
			})
		})

		table.insert(self.modules, slider)
		--self:Resize()

		local allowed = {
			[""] = true,
			["-"] = true
		}

		local textbox = slider.TextBox
		local circle = slider.Slider.Bar.Fill.Circle

		local value = default or min
		local dragging, last

		local callback = function(value)
			if callback then
				callback(value, function(...)
					self:updateSlider(slider, ...)
				end)
			end
		end

		self:updateSlider(slider, nil, value, min, max)

		utility:DraggingEnded(function()
			dragging = false
		end)

		slider.MouseButton1Down:Connect(function(input)
			dragging = true

			while dragging do
				utility:Tween(circle, {ImageTransparency = 0}, 0.1)

				value = self:updateSlider(slider, nil, nil, min, max, value)
				callback(value)

				utility:Wait()
			end

			wait(0.5)
			utility:Tween(circle, {ImageTransparency = 1}, 0.2)
		end)

		textbox.FocusLost:Connect(function()
			if not tonumber(textbox.Text) then
				value = self:updateSlider(slider, nil, default or min, min, max)
				callback(value)
			end
		end)

		textbox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = textbox.Text

			if not allowed[text] and not tonumber(text) then
				textbox.Text = text:sub(1, #text - 1)
			elseif not allowed[text] then	
				value = self:updateSlider(slider, nil, tonumber(text) or value, min, max)
				callback(value)
			end
		end)

		return slider
	end

	function section:addDropdown(title, list, callback)
		local dropdown = utility:Create("Frame", {
			Name = "Dropdown",
			Parent = self.container,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 30),
			ClipsDescendants = true
		}, {
			utility:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			utility:Create("ImageLabel", {
				Name = "Search",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.DarkContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("TextBox", {
					Name = "TextBox",
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Position = UDim2.new(0, 10, 0.5, 1),
					Size = UDim2.new(1, -42, 1, 0),
					ZIndex = 3,
					Font = Enum.Font.Gotham,
					Text = title,
					TextColor3 = themes.TextColor,
					TextSize = 12,
					TextTransparency = 0.10000000149012,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				utility:Create("ImageButton", {
					Name = "Button",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -28, 0.5, -9),
					Size = UDim2.new(0, 18, 0, 18),
					ZIndex = 3,
					Image = "rbxassetid://5012539403",
					ImageColor3 = themes.TextColor,
					SliceCenter = Rect.new(2, 2, 298, 298)
				})
			}),
			utility:Create("ImageLabel", {
				Name = "List",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, -34),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.Background,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("ScrollingFrame", {
					Name = "Frame",
					Active = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 4, 0, 4),
					Size = UDim2.new(1, -8, 1, -8),
					CanvasPosition = Vector2.new(0, 28),
					CanvasSize = UDim2.new(0, 0, 0, 120),
					ZIndex = 2,
					ScrollBarThickness = 3,
					ScrollBarImageColor3 = themes.DarkContrast
				}, {
					utility:Create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					})
				})
			})
		})

		table.insert(self.modules, dropdown)
		--self:Resize()

		local search = dropdown.Search
		local focused

		list = list or {}

		search.Button.MouseButton1Click:Connect(function()
			if search.Button.Rotation == 0 then
				self:updateDropdown(dropdown, nil, list, callback)
			else
				self:updateDropdown(dropdown, nil, nil, callback)
			end
		end)

		search.TextBox.Focused:Connect(function()
			if search.Button.Rotation == 0 then
				self:updateDropdown(dropdown, nil, list, callback)
			end

			focused = true
		end)

		search.TextBox.FocusLost:Connect(function()
			focused = false
		end)

		search.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
			if focused then
				local list = utility:Sort(search.TextBox.Text, list)
				list = #list ~= 0 and list 

				self:updateDropdown(dropdown, nil, list, callback)
			end
		end)

		dropdown:GetPropertyChangedSignal("Size"):Connect(function()
			self:Resize()
		end)

		return dropdown
	end

	-- class functions

	function library:SelectPage(page, toggle)

		if toggle and self.focusedPage == page then -- already selected
			return
		end

		local button = page.button

		if toggle then
			-- page button
			button.Title.TextTransparency = 0
			button.Title.Font = Enum.Font.GothamSemibold

			if button:FindFirstChild("Icon") then
				button.Icon.ImageTransparency = 0
			end

			-- update selected page
			local focusedPage = self.focusedPage
			self.focusedPage = page

			if focusedPage then
				self:SelectPage(focusedPage)
			end

			-- sections
			local existingSections = focusedPage and #focusedPage.sections or 0
			local sectionsRequired = #page.sections - existingSections

			page:Resize()

			for i, section in pairs(page.sections) do
				section.container.Parent.ImageTransparency = 0
			end

			if sectionsRequired < 0 then -- "hides" some sections
				for i = existingSections, #page.sections + 1, -1 do
					local section = focusedPage.sections[i].container.Parent

					utility:Tween(section, {ImageTransparency = 1}, 0.1)
				end
			end

			wait(0.1)
			page.container.Visible = true

			if focusedPage then
				focusedPage.container.Visible = false
			end

			if sectionsRequired > 0 then -- "creates" more section
				for i = existingSections + 1, #page.sections do
					local section = page.sections[i].container.Parent

					section.ImageTransparency = 1
					utility:Tween(section, {ImageTransparency = 0}, 0.05)
				end
			end

			wait(0.05)

			for i, section in pairs(page.sections) do

				utility:Tween(section.container.Title, {TextTransparency = 0}, 0.1)
				section:Resize(true)

				wait(0.05)
			end

			wait(0.05)
			page:Resize(true)
		else
			-- page button
			button.Title.Font = Enum.Font.Gotham
			button.Title.TextTransparency = 0.65

			if button:FindFirstChild("Icon") then
				button.Icon.ImageTransparency = 0.65
			end

			-- sections
			for i, section in pairs(page.sections) do	
				utility:Tween(section.container.Parent, {Size = UDim2.new(1, -10, 0, 28)}, 0.1)
				utility:Tween(section.container.Title, {TextTransparency = 1}, 0.1)
			end

			wait(0.1)

			page.lastPosition = page.container.CanvasPosition.Y
			page:Resize()
		end
	end

	function page:Resize(scroll)
		local padding = 10
		local size = 0

		for i, section in pairs(self.sections) do
			size = size + section.container.Parent.AbsoluteSize.Y + padding
		end

		self.container.CanvasSize = UDim2.new(0, 0, 0, size)
		self.container.ScrollBarImageTransparency = size > self.container.AbsoluteSize.Y

		if scroll then
			utility:Tween(self.container, {CanvasPosition = Vector2.new(0, self.lastPosition or 0)}, 0.2)
		end
	end

	function section:Resize(smooth)

		if self.page.library.focusedPage ~= self.page then
			return
		end

		local padding = 4
		local size = (4 * padding) + self.container.Title.AbsoluteSize.Y -- offset

		for i, module in pairs(self.modules) do
			size = size + module.AbsoluteSize.Y + padding
		end

		if smooth then
			utility:Tween(self.container.Parent, {Size = UDim2.new(1, -10, 0, size)}, 0.05)
		else
			self.container.Parent.Size = UDim2.new(1, -10, 0, size)
			self.page:Resize()
		end
	end

	function section:getModule(info)

		if table.find(self.modules, info) then
			return info
		end

		for i, module in pairs(self.modules) do
			if (module:FindFirstChild("Title") or module:FindFirstChild("TextBox", true)).Text == info then
				return module
			end
		end

		error("No module found under "..tostring(info))
	end

	-- updates

	function section:updateButton(button, title)
		button = self:getModule(button)

		button.Title.Text = title
	end

	function section:updateToggle(toggle, title, value)
		toggle = self:getModule(toggle)

		local position = {
			In = UDim2.new(0, 2, 0.5, -6),
			Out = UDim2.new(0, 20, 0.5, -6)
		}

		local frame = toggle.Button.Frame
		value = value and "Out" or "In"

		if title then
			toggle.Title.Text = title
		end

		utility:Tween(frame, {
			Size = UDim2.new(1, -22, 1, -9),
			Position = position[value] + UDim2.new(0, 0, 0, 2.5)
		}, 0.2)

		wait(0.1)
		utility:Tween(frame, {
			Size = UDim2.new(1, -22, 1, -4),
			Position = position[value]
		}, 0.1)
	end

	function section:updateTextbox(textbox, title, value)
		textbox = self:getModule(textbox)

		if title then
			textbox.Title.Text = title
		end

		if value then
			textbox.Button.Textbox.Text = value
		end

	end

	function section:updateKeybind(keybind, title, key)
		keybind = self:getModule(keybind)

		local text = keybind.Button.Text
		local bind = self.binds[keybind]

		if title then
			keybind.Title.Text = title
		end

		if bind.connection then
			bind.connection = bind.connection:UnBind()
		end

		if key then
			self.binds[keybind].connection = utility:BindToKey(key, bind.callback)
			text.Text = key.Name
		else
			text.Text = "None"
		end
	end

	function section:updateColorPicker(colorpicker, title, color)
		colorpicker = self:getModule(colorpicker)

		local picker = self.colorpickers[colorpicker]
		local tab = picker.tab
		local callback = picker.callback

		if title then
			colorpicker.Title.Text = title
			tab.Title.Text = title
		end

		local color3
		local hue, sat, brightness

		if type(color) == "table" then -- roblox is literally retarded x2
			hue, sat, brightness = unpack(color)
			color3 = Color3.fromHSV(hue, sat, brightness)
		else
			color3 = color
			hue, sat, brightness = Color3.toHSV(color3)
		end

		utility:Tween(colorpicker.Button, {ImageColor3 = color3}, 0.5)
		utility:Tween(tab.Container.Color.Select, {Position = UDim2.new(hue, 0, 0, 0)}, 0.1)

		utility:Tween(tab.Container.Canvas, {ImageColor3 = Color3.fromHSV(hue, 1, 1)}, 0.5)
		utility:Tween(tab.Container.Canvas.Cursor, {Position = UDim2.new(sat, 0, 1 - brightness)}, 0.5)

		for i, container in pairs(tab.Container.Inputs:GetChildren()) do
			if container:IsA("ImageLabel") then
				local value = math.clamp(color3[container.Name], 0, 1) * 255

				container.Textbox.Text = math.floor(value)
				--callback(container.Name:lower(), value)
			end
		end
	end

	function section:updateSlider(slider, title, value, min, max, lvalue)
		slider = self:getModule(slider)

		if title then
			slider.Title.Text = title
		end

		local bar = slider.Slider.Bar
		local percent = (mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X

		if value then -- support negative ranges
			percent = (value - min) / (max - min)
		end

		percent = math.clamp(percent, 0, 1)
		value = value or math.floor(min + (max - min) * percent)

		slider.TextBox.Text = value
		utility:Tween(bar.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)

		if value ~= lvalue and slider.ImageTransparency == 0 then
			utility:Pop(slider, 10)
		end

		return value
	end

	function section:updateDropdown(dropdown, title, list, callback)
		dropdown = self:getModule(dropdown)

		if title then
			dropdown.Search.TextBox.Text = title
		end

		local entries = 0

		utility:Pop(dropdown.Search, 10)

		for i, button in pairs(dropdown.List.Frame:GetChildren()) do
			if button:IsA("ImageButton") then
				button:Destroy()
			end
		end

		for i, value in pairs(list or {}) do
			local button = utility:Create("ImageButton", {
				Parent = dropdown.List.Frame,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30),
				ZIndex = 2,
				Image = "rbxassetid://5028857472",
				ImageColor3 = themes.DarkContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(2, 2, 298, 298)
			}, {
				utility:Create("TextLabel", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -10, 1, 0),
					ZIndex = 3,
					Font = Enum.Font.Gotham,
					Text = value,
					TextColor3 = themes.TextColor,
					TextSize = 12,
					TextXAlignment = "Left",
					TextTransparency = 0.10000000149012
				})
			})

			button.MouseButton1Click:Connect(function()
				if callback then
					callback(value, function(...)
						self:updateDropdown(dropdown, ...)
					end)	
				end

				self:updateDropdown(dropdown, value, nil, callback)
			end)

			entries = entries + 1
		end

		local frame = dropdown.List.Frame

		utility:Tween(dropdown, {Size = UDim2.new(1, 0, 0, (entries == 0 and 30) or math.clamp(entries, 0, 3) * 34 + 38)}, 0.3)
		utility:Tween(dropdown.Search.Button, {Rotation = list and 180 or 0}, 0.3)

		if entries > 3 then

			for i, button in pairs(dropdown.List.Frame:GetChildren()) do
				if button:IsA("ImageButton") then
					button.Size = UDim2.new(1, -6, 0, 30)
				end
			end

			frame.CanvasSize = UDim2.new(0, 0, 0, (entries * 34) - 4)
			frame.ScrollBarImageTransparency = 0
		else
			frame.CanvasSize = UDim2.new(0, 0, 0, 0)
			frame.ScrollBarImageTransparency = 1
		end
	end
end


		local L9s0 = library.new("Blox fruit GUI")

                          local M9s0 = L9s0:addPage("Auto Farm", 7010566435)

		local M9s01 = L9s0:addPage("Playes", 7061402283)

		local M9s02 = L9s0:addPage("Teleports", 7061398829)

		local M9s03 = L9s0:addPage("Game", 7061409730)

		local M9s04 = L9s0:addPage("Auto Stats", 7061136295)

                          local M9s05 = L9s0:addPage("Dungeon", 7064509895)
                          
                          local M9s06 = L9s0:addPage("Misc Fruit", 7066507885)
                          
                          local M9s07 = L9s0:addPage("Settings", 7066507885)
                          
                          local M9s08 = L9s0:addPage("Theme", 7066507885)


		local S9s0 = M9s0:addSection("Auto Farm")

		local S9s01 = M9s04:addSection("Auto Stats")

		local S9s02 = M9s02:addSection("Teleports")

		local S9s03I = M9s0:addSection("Auto Boss")

		local S9s03IIII = M9s05:addSection("Auto Raids")

		local S9s03III = M9s0:addSection("Auto Farm Ectoplasm")

		local S9s03II = M9s01:addSection("Players")

		local S9s03 = M9s06:addSection("Functions")

		local S9s04 = M9s06:addSection("GUI")

		local S9s05 = M9s07:addSection("Settings")

		local S9s06 = M9s03:addSection("Others Functions")

		local S9s07 = M9s03:addSection("Buy Item")

		local S9s08 = M9s08:addSection("GUI")

                          local S9s08 = M9s08:addSection("Discord")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")
 

		local games = {
			[4442272183] = {
				Title = "Blox Fruits",
				Icons = "C",
				Welcome = function()
					return tostring(
						"<Color=White>Welcome " ..
							"<Color=Green>" ..
							game:GetService("Players").LocalPlayer.Name .. "!" .. " \n<Color=lblue>To สคริปกูเองพึ่งทำเสร็จ"
					)
				end
			}
		}

		if games[game.PlaceId] then
			if games[game.PlaceId].Title == "Blox Fruits" then
				local function notify(types, ...)
					if types == "Notify" then
						require(game.ReplicatedStorage.Notification).new(...):Display()
					end
				end
				notify("Notify", games[game.PlaceId].Welcome())
			end
		end

		local placeId = game.PlaceId
		Magnet = true
		if placeId == 2753915549 then
			OldWorld = true
		elseif placeId == 4442272183 then
			NewWorld = true
		end

		function Click()
			game:GetService'VirtualUser':CaptureController()
			game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer
		local VirtualUser = game:GetService('VirtualUser')

		Wapon = {}
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
			if v:IsA("Tool") then
				table.insert(Wapon ,v.Name)
			end
		end
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do  
			if v:IsA("Tool") then
				table.insert(Wapon, v.Name)
			end
		end

		game:GetService("RunService").Heartbeat:Connect(
		function()
			if AFM or FramBoss or FramAllBoss then
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
				end
			end
		end)

		function CheckQuestBoss()
			if SelectBoss == "Diamond [Lv. 750] [Boss]" then
				MsBoss = "Diamond [Lv. 750] [Boss]"
				NaemQuestBoss = "Area1Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
				CFrameBoss = CFrame.new(-1736.26587, 198.627731, -236.412857, -0.997808516, 0, -0.0661673471, 0, 1, 0, 0.0661673471, 0, -0.997808516)
			elseif SelectBoss == "Jeremy [Lv. 850] [Boss]" then
				MsBoss = "Jeremy [Lv. 850] [Boss]"
				NaemQuestBoss = "Area2Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
				CFrameBoss = CFrame.new(2203.76953, 448.966034, 752.731079, -0.0217453763, 0, -0.999763548, 0, 1, 0, 0.999763548, 0, -0.0217453763)
			elseif SelectBoss == "Fajita [Lv. 925] [Boss]" then
				MsBoss = "Fajita [Lv. 925] [Boss]"
				NaemQuestBoss = "MarineQuest3"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
				CFrameBoss = CFrame.new(-2297.40332, 115.449463, -3946.53833, 0.961227536, -1.46645796e-09, -0.275756449, -2.3212845e-09, 1, -1.34094433e-08, 0.275756449, 1.35296352e-08, 0.961227536)
			elseif SelectBoss == "Don Swan [Lv. 1000] [Boss]" then
				MsBoss = "Don Swan [Lv. 1000] [Boss]"
				CFrameBoss = CFrame.new(2288.802, 15.1870775, 863.034607, 0.99974072, -8.41247214e-08, -0.0227668174, 8.4774733e-08, 1, 2.75850098e-08, 0.0227668174, -2.95079072e-08, 0.99974072)
			elseif SelectBoss == "Smoke Admiral [Lv. 1150] [Boss]" then
				MsBoss = "Smoke Admiral [Lv. 1150] [Boss]"
				NaemQuestBoss = "IceSideQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-6059.96191, 15.9868021, -4904.7373, -0.444992423, -3.0874483e-09, 0.895534337, -3.64098796e-08, 1, -1.4644522e-08, -0.895534337, -3.91229982e-08, -0.444992423)
				CFrameBoss = CFrame.new(-5115.72754, 23.7664986, -5338.2207, 0.251453817, 1.48345061e-08, -0.967869282, 4.02796978e-08, 1, 2.57916977e-08, 0.967869282, -4.54708946e-08, 0.251453817)
			elseif SelectBoss == "Cursed Captain [Lv. 1325] [Raid Boss]" then
				MsBoss = "Cursed Captain [Lv. 1325] [Raid Boss]"
				CFrameBoss = CFrame.new(916.928589, 181.092773, 33422, -0.999505103, 9.26310495e-09, 0.0314563364, 8.42916226e-09, 1, -2.6643713e-08, -0.0314563364, -2.63653774e-08, -0.999505103)
			elseif SelectBoss == "Darkbeard [Lv. 1000] [Raid Boss]" then
				MsBoss = "Darkbeard [Lv. 1000] [Raid Boss]"
				CFrameBoss = CFrame.new(3876.00366, 24.6882591, -3820.21777, -0.976951957, 4.97356325e-08, 0.213458836, 4.57335361e-08, 1, -2.36868622e-08, -0.213458836, -1.33787044e-08, -0.976951957)
			elseif SelectBoss == "Order [Lv. 1250] [Raid Boss]" then
				MsBoss = "Order [Lv. 1250] [Raid Boss]"
				CFrameBoss = CFrame.new(-6221.15039, 16.2351036, -5045.23584, -0.380726993, 7.41463495e-08, 0.924687505, 5.85604774e-08, 1, -5.60738549e-08, -0.924687505, 3.28013137e-08, -0.380726993)
			elseif SelectBoss == "Awakened Ice Admiral [Lv. 1400] [Boss]" then
				MsBoss = "Awakened Ice Admiral [Lv. 1400] [Boss]"
				NaemQuestBoss = "FrostQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(5669.33203, 28.2118053, -6481.55908, 0.921275556, -1.25320829e-08, 0.388910472, 4.72230788e-08, 1, -7.96414241e-08, -0.388910472, 9.17372489e-08, 0.921275556)
				CFrameBoss = CFrame.new(6407.33936, 340.223785, -6892.521, 0.49051559, -5.25310213e-08, -0.871432424, -2.76146022e-08, 1, -7.58250565e-08, 0.871432424, 6.12576301e-08, 0.49051559)
			elseif SelectBoss == "Tide Keeper [Lv. 1475] [Boss]" then
				MsBoss = "Tide Keeper [Lv. 1475] [Boss]"
				NaemQuestBoss = "ForgottenQuest"             
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-3053.89648, 236.881363, -10148.2324, -0.985987961, -3.58504737e-09, 0.16681771, -3.07832915e-09, 1, 3.29612559e-09, -0.16681771, 2.73641976e-09, -0.985987961)
				CFrameBoss = CFrame.new(-3570.18652, 123.328949, -11555.9072, 0.465199202, -1.3857326e-08, 0.885206044, 4.0332897e-09, 1, 1.35347511e-08, -0.885206044, -2.72606271e-09, 0.465199202)
				-- Old World
			elseif SelectBoss == "Saber Expert [Lv. 200] [Boss]" then
				MsBoss = "Saber Expert [Lv. 200] [Boss]"
				CFrameBoss = CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636, -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094)
			elseif SelectBoss == "The Saw [Lv. 100] [Boss]" then
				MsBoss = "The Saw [Lv. 100] [Boss]"
				CFrameBoss = CFrame.new(-683.519897, 13.8534927, 1610.87854, -0.290192783, 6.88365773e-08, 0.956968188, 6.98413629e-08, 1, -5.07531119e-08, -0.956968188, 5.21077759e-08, -0.290192783)
			elseif SelectBoss == "The Gorilla King [Lv. 25] [Boss]" then
				MsBoss = "The Gorilla King [Lv. 25] [Boss]"
				NaemQuestBoss = "JungleQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
				CFrameBoss = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519, -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)
			elseif SelectBoss == "Bobby [Lv. 55] [Boss]" then
				MsBoss = "Bobby [Lv. 55] [Boss]"
				NaemQuestBoss = "BuggyQuest1"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
				CFrameBoss = CFrame.new(-1147.65173, 32.5966301, 4156.02588, 0.956680477, -1.77109952e-10, -0.29113996, 5.16530874e-10, 1, 1.08897802e-09, 0.29113996, -1.19218679e-09, 0.956680477)
			elseif SelectBoss == "Yeti [Lv. 110] [Boss]" then
				MsBoss = "Yeti [Lv. 110] [Boss]"
				NaemQuestBoss = "SnowQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(1384.90247, 87.3078308, -1296.6825, 0.280209213, 2.72035177e-08, -0.959938943, -6.75690828e-08, 1, 8.6151708e-09, 0.959938943, 6.24481444e-08, 0.280209213)
				CFrameBoss = CFrame.new(1221.7356, 138.046906, -1488.84082, 0.349343032, -9.49245944e-08, 0.936994851, 6.29478194e-08, 1, 7.7838429e-08, -0.936994851, 3.17894653e-08, 0.349343032)
			elseif SelectBoss == "Mob Leader [Lv. 120] [Boss]" then
				MsBoss = "Mob Leader [Lv. 120] [Boss]"
				CFrameBoss = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564, -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.928248107)
				--The Gorilla King [Lv. 25] [Boss]
			elseif SelectBoss == "Vice Admiral [Lv. 130] [Boss]" then
				MsBoss = "Vice Admiral [Lv. 130] [Boss]"
				NaemQuestBoss = "MarineQuest2"
				LevelQuestBoss = 2
				CFrameQuestBoss = CFrame.new(-5035.42285, 28.6520386, 4324.50293, -0.0611100644, -8.08395768e-08, 0.998130739, -1.57416586e-08, 1, 8.00271849e-08, -0.998130739, -1.08217701e-08, -0.0611100644)
				CFrameBoss = CFrame.new(-5078.45898, 99.6520691, 4402.1665, -0.555574954, -9.88630566e-11, 0.831466436, -6.35508286e-08, 1, -4.23449258e-08, -0.831466436, -7.63661632e-08, -0.555574954)
			elseif SelectBoss == "Warden [Lv. 175] [Boss]" then
				MsBoss = "Warden [Lv. 175] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 1
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Chief Warden [Lv. 200] [Boss]" then
				MsBoss = "Chief Warden [Lv. 200] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 2
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Swan [Lv. 225] [Boss]" then
				MsBoss = "Swan [Lv. 225] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Magma Admiral [Lv. 350] [Boss]" then
				MsBoss = "Magma Admiral [Lv. 350] [Boss]"
				NaemQuestBoss = "MagmaQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-5317.07666, 12.2721891, 8517.41699, 0.51175487, -2.65508806e-08, -0.859131515, -3.91131572e-08, 1, -5.42026761e-08, 0.859131515, 6.13418294e-08, 0.51175487)
				CFrameBoss = CFrame.new(-5530.12646, 22.8769703, 8859.91309, 0.857838571, 2.23414389e-08, 0.513919294, 1.53689133e-08, 1, -6.91265853e-08, -0.513919294, 6.71978384e-08, 0.857838571)
			elseif SelectBoss == "Fishman Lord [Lv. 425] [Boss]" then
				MsBoss = "Fishman Lord [Lv. 425] [Boss]"
				NaemQuestBoss = "FishmanQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(61123.0859, 18.5066795, 1570.18018, 0.927145958, 1.0624845e-07, 0.374700129, -6.98219367e-08, 1, -1.10790765e-07, -0.374700129, 7.65569368e-08, 0.927145958)
				CFrameBoss = CFrame.new(61351.7773, 31.0306778, 1113.31409, 0.999974668, 0, -0.00714713801, 0, 1.00000012, 0, 0.00714714266, 0, 0.999974549)
			elseif SelectBoss == "Wysper [Lv. 500] [Boss]" then
				MsBoss = "Wysper [Lv. 500] [Boss]"
				NaemQuestBoss = "SkyExp1Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-7862.94629, 5545.52832, -379.833954, 0.462944925, 1.45838088e-08, -0.886386991, 1.0534996e-08, 1, 2.19553424e-08, 0.886386991, -1.95022007e-08, 0.462944925)
				CFrameBoss = CFrame.new(-7925.48389, 5550.76074, -636.178345, 0.716468513, -1.22915289e-09, 0.697619379, 3.37381434e-09, 1, -1.70304748e-09, -0.697619379, 3.57381835e-09, 0.716468513)
			elseif SelectBoss == "Thunder God [Lv. 575] [Boss]" then
				MsBoss = "Thunder God [Lv. 575] [Boss]"
				NaemQuestBoss = "SkyExp2Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-7902.78613, 5635.99902, -1411.98706, -0.0361216255, -1.16895912e-07, 0.999347389, 1.44533963e-09, 1, 1.17024491e-07, -0.999347389, 5.6715117e-09, -0.0361216255)
				CFrameBoss = CFrame.new(-7917.53613, 5616.61377, -2277.78564, 0.965189934, 4.80563429e-08, -0.261550069, -6.73089886e-08, 1, -6.46515304e-08, 0.261550069, 8.00056768e-08, 0.965189934)
			elseif SelectBoss == "Cyborg [Lv. 675] [Boss]" then
				MsBoss = "Cyborg [Lv. 675] [Boss]"
				NaemQuestBoss = "FountainQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(5253.54834, 38.5361786, 4050.45166, -0.0112687312, -9.93677887e-08, -0.999936521, 2.55291371e-10, 1, -9.93769547e-08, 0.999936521, -1.37512213e-09, -0.0112687312)
				CFrameBoss = CFrame.new(6041.82813, 52.7112198, 3907.45142, -0.563162148, 1.73805248e-09, -0.826346457, -5.94632716e-08, 1, 4.26280238e-08, 0.826346457, 7.31437524e-08, -0.563162148)
			end
		end

		local Boss = {}
		for i, v in pairs(game.ReplicatedStorage:GetChildren()) do
			if string.find(v.Name, "Boss") then
				if v.Name == "Ice Admiral [Lv. 700] [Boss]" then
				else
					table.insert(Boss, v.Name)
				end
			end
		end
		for i, v in pairs(game.workspace.Enemies:GetChildren()) do
			if string.find(v.Name, "Boss") then
				if v.Name == "Ice Admiral [Lv. 700] [Boss]" then
				else
					table.insert(Boss, v.Name)
				end
			end
		end

		local BossName = S9s03I:addDropdown("Select Boss",Boss,function(Value)
			SelectBoss = Value
			Don = false
		end)

		local SelectWeaponBoss = "" 
		local SelectWeaponKillBoss = S9s03I:addDropdown("Select Weapon Kill Boss",Wapon,function(Value)
			SelectToolWeaponBoss = Value
		end)

		function AutoFramBoss()
			CheckQuestBoss()
			if SelectBoss == "Don Swan [Lv. 1000] [Boss]" or SelectBoss == "Cursed Captain [Lv. 1325] [Raid Boss]" or SelectBoss == "Saber Expert [Lv. 200] [Boss]" or SelectBoss == "Mob Leader [Lv. 120] [Boss]" or SelectBoss == "Darkbeard [Lv. 1000] [Raid Boss]" then
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
							repeat
								pcall(function() wait() 
									EquipWeapon(SelectToolWeaponBoss)
									if HideHitBlox then
										v.HumanoidRootPart.Transparency = 1
									else
										v.HumanoidRootPart.Transparency = 0.75
									end
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 17, 5)
									game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
									VirtualUser:CaptureController()
									VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								end)
							until not FramBoss or not v.Parent or v.Humanoid.Health <= 0
						end
					end
				else
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			elseif SelectBoss == "Order [Lv. 1250] [Raid Boss]" then
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
							repeat 
								pcall(function() wait() 
									EquipWeapon(SelectToolWeaponBoss)
									if HideHitBlox then
										v.HumanoidRootPart.Transparency = 1
									else
										v.HumanoidRootPart.Transparency = 0.75
									end
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 25)
									game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
									VirtualUser:CaptureController()
									VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								end)
							until not FramBoss or not v.Parent or v.Humanoid.Health <= 0
						end
					end
				else
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			else
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) or game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) then
					if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
						print()
						CheckQuestBoss()
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuestBoss
						wait(1.5)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuestBoss, LevelQuestBoss)
						wait(1)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
					elseif game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == true then
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
								repeat
									pcall(function() wait() 
										EquipWeapon(SelectToolWeaponBoss)
										if HideHitBlox then
											v.HumanoidRootPart.Transparency = 1
										else
											v.HumanoidRootPart.Transparency = 0.75
										end
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 17, 5)
										game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
										VirtualUser:CaptureController()
										VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
									end)
								until not FramBoss or not v.Parent or v.Humanoid.Health <= 0 or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false
							end
						end
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
					end
				end
			end
		end

		S9s03I:addToggle("Auto Farm Boss",false,function(Value)
			local args = {
				[1] = "AbandonQuest"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			FramBoss = Value
			MsBoss = ""
			while FramBoss do wait()
				AutoFramBoss()
			end
		end)

		PlayerName = {}
		for i,v in pairs(game.Players:GetChildren()) do  
			table.insert(PlayerName ,v.Name)
		end
		SelectedKillPlayer = ""
		local Player = S9s03II:addDropdown("Selected Player",PlayerName,function(plys) --true/false, replaces the current title "Dropdown" with the option that t
			SelectedKillPlayer = plys
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if KillPlayer then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)

		S9s03II:addToggle("Kill Player",false,function(bool)
			KillPlayer = bool
			if KillPlayer == false then
				game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.Size = Vector3.new(1, 1, 1)
				local args = {
					[1] = "Buso"
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

			L9s0:Notify("NOTIFICATION", "Pickup a Weapon")

			while KillPlayer do wait(60)

				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
				game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.Size = Vector3.new(60,60,60)
				game:GetService'VirtualUser':CaptureController()
				game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
			end
		end)

		S9s03II:addToggle("Spectate Player",false,function(bool)
			Sp = bool
			local plr1 = game.Players.LocalPlayer.Character.Humanoid
			local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
			repeat wait(.1)
				game.Workspace.Camera.CameraSubject = plr2.Character.Humanoid
			until Sp == false 
			game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		end)

		S9s03II:addButton("Teleport Player",function()
			local plr1 = game.Players.LocalPlayer.Character
			local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
			plr1.HumanoidRootPart.CFrame = plr2.Character.HumanoidRootPart.CFrame
		end)

		S9s0:addToggle("Auto Farm",false,function(vu)
			if SelectToolWeapon == "" and vu then

				L9s0:Notify("NOTIFICATION", "Select Weapon First")

			else
				local args = {
					[1] = "AbandonQuest"
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				AFM = vu
				AFMMain = vu 
			end	
		end)

		function CheckQuest()
			local MyLevel = game.Players.LocalPlayer.Data.Level.Value
			if OldWorld then
				if MyLevel == 1 or MyLevel <= 9 then -- Bandit
					Ms = "Bandit [Lv. 5]"
					NaemQuest = "BanditQuest1"
					LevelQuest = 1
					NameMon = "Bandit"
					CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905, -0.942978859, -3.33851502e-09, 0.332852632, 7.04340497e-09, 1, 2.99841325e-08, -0.332852632, 3.06188177e-08, -0.942978859)
					CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516, -0.929782331, 6.60215846e-08, -0.368109822, 3.9077392e-08, 1, 8.06501603e-08, 0.368109822, 6.06023249e-08, -0.929782331)
				elseif MyLevel == 10 or MyLevel <= 14 then -- Monkey
					Ms = "Monkey [Lv. 14]"
					NaemQuest = "JungleQuest"
					LevelQuest = 1
					NameMon = "Monkey"
					CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
					CFrameMon = CFrame.new(-1402.74609, 98.5633316, 90.6417007, 0.836947978, 0, 0.547282517, -0, 1, -0, -0.547282517, 0, 0.836947978)
				elseif MyLevel == 15 or MyLevel <= 29 then -- Gorilla
					Ms = "Gorilla [Lv. 20]"
					NaemQuest = "JungleQuest"
					LevelQuest = 2
					NameMon = "Gorilla"
					CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
					CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519, -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)
				elseif MyLevel == 30 or MyLevel <= 39 then -- Pirate
					Ms = "Pirate [Lv. 35]"
					NaemQuest = "BuggyQuest1"
					LevelQuest = 1
					NameMon = "Pirate"
					CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
					CFrameMon = CFrame.new(-1219.32324, 4.75205183, 3915.63452, -0.966492832, -6.91238853e-08, 0.25669381, -5.21195496e-08, 1, 7.3047012e-08, -0.25669381, 5.72206496e-08, -0.966492832)
				elseif MyLevel == 40 or MyLevel <= 59 then -- Brute
					Ms = "Brute [Lv. 45]"
					NaemQuest = "BuggyQuest1"
					LevelQuest = 2
					NameMon = "Brute"
					CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
					CFrameMon = CFrame.new(-1146.49646, 96.0936813, 4312.1333, -0.978175163, -1.53222057e-08, 0.207781896, -3.33316912e-08, 1, -8.31738873e-08, -0.207781896, -8.82843523e-08, -0.978175163)
				elseif MyLevel == 60 or MyLevel <= 74 then -- Desert Bandit
					Ms = "Desert Bandit [Lv. 60]"
					NaemQuest = "DesertQuest"
					LevelQuest = 1
					NameMon = "Desert Bandit"
					CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
					CFrameMon = CFrame.new(932.788818, 6.4503746, 4488.24609, -0.998625934, 3.08948351e-08, 0.0524050146, 2.79967303e-08, 1, -5.60361286e-08, -0.0524050146, -5.44919629e-08, -0.998625934)
				elseif MyLevel == 75 or MyLevel <= 89 then -- Desert Officre
					Ms = "Desert Officer [Lv. 70]"
					NaemQuest = "DesertQuest"
					LevelQuest = 2
					NameMon = "Desert Officer"
					CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
					CFrameMon = CFrame.new(1580.03198, 4.61375761, 4366.86426, 0.135744005, -6.44280718e-08, -0.990743816, 4.35738308e-08, 1, -5.90598574e-08, 0.990743816, -3.51534837e-08, 0.135744005)
				elseif MyLevel == 90 or MyLevel <= 99 then -- Snow Bandits
					Ms = "Snow Bandit [Lv. 90]"
					NaemQuest = "SnowQuest"
					LevelQuest = 1
					NameMon = "Snow Bandits"
					CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)
					CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)
				elseif MyLevel == 100 or MyLevel <= 119 then -- Snowman
					Ms = "Snowman [Lv. 100]"
					NaemQuest = "SnowQuest"
					LevelQuest = 2
					NameMon = "Snowman"
					CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)
					CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)
				elseif MyLevel == 120 or MyLevel <= 149 then -- Chief Petty Officer
					Ms = "Chief Petty Officer [Lv. 120]"
					NaemQuest = "MarineQuest2"
					LevelQuest = 1
					NameMon = "Chief Petty Officer"
					CFrameQuest = CFrame.new(-5035.0835, 28.6520386, 4325.29443, 0.0243340395, -7.08064647e-08, 0.999703884, -6.36926814e-08, 1, 7.23777944e-08, -0.999703884, -6.54350671e-08, 0.0243340395)
					CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516, 0.273695946, -5.40380647e-08, -0.96181643, 4.37720793e-08, 1, -4.37274998e-08, 0.96181643, -3.01326679e-08, 0.273695946)
				elseif MyLevel == 150 or MyLevel <= 174 then -- Sky Bandit
					Ms = "Sky Bandit [Lv. 150]"
					NaemQuest = "SkyQuest"
					LevelQuest = 1
					NameMon = "Sky Bandit"
					CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)
					CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353, -0.994874597, -8.61311236e-08, -0.101116329, -9.10836206e-08, 1, 4.43614923e-08, 0.101116329, 5.33441664e-08, -0.994874597)
				elseif MyLevel == 175 or MyLevel <= 224 then -- Dark Master
					Ms = "Dark Master [Lv. 175]"
					NaemQuest = "SkyQuest"
					LevelQuest = 2
					NameMon = "Dark Master"
					CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)
					CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456, -0.925375521, 1.12086873e-08, 0.379051805, -1.05115507e-08, 1, -5.52320891e-08, -0.379051805, -5.50948407e-08, -0.925375521)
				elseif MyLevel == 225 or MyLevel <= 274 then -- Toga Warrior
					Ms = "Toga Warrior [Lv. 225]"
					NaemQuest = "ColosseumQuest"
					LevelQuest = 1
					NameMon = "Toga Warrior"
					CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
					CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474, 0.984437346, 4.10396339e-08, 0.175734788, -3.62286876e-08, 1, -3.05844168e-08, -0.175734788, 2.3741821e-08, 0.984437346)
				elseif MyLevel == 275 or MyLevel <= 299 then -- Gladiato
					Ms = "Gladiator [Lv. 275]"
					NaemQuest = "ColosseumQuest"
					LevelQuest = 2
					NameMon = "Gladiato"
					CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
					CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309, 0.464524001, 6.21005611e-08, 0.885560572, -4.80449414e-09, 1, -6.76054768e-08, -0.885560572, 2.71497012e-08, 0.464524001)
				elseif MyLevel == 300 or MyLevel <= 329 then -- Military Soldier
					Ms = "Military Soldier [Lv. 300]"
					NaemQuest = "MagmaQuest"
					LevelQuest = 1
					NameMon = "Military Soldier"
					CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
					CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984)
				elseif MyLevel == 300 or MyLevel <= 374 then -- Military Spy
					Ms = "Military Spy [Lv. 330]"
					NaemQuest = "MagmaQuest"
					LevelQuest = 2
					NameMon = "Military Spy"
					CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
					CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293, -0.188358366, -1.84706277e-08, 0.982100308, -1.23782129e-07, 1, -4.93306951e-09, -0.982100308, -1.22495649e-07, -0.188358366)
				elseif MyLevel == 375 or MyLevel <= 399 then -- Fishman Warrior
					Ms = "Fishman Warrior [Lv. 375]"
					NaemQuest = "FishmanQuest"
					LevelQuest = 1
					NameMon = "Fishman Warrior"
					CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)
					CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.91687, -0.0817126185, 8.90751153e-08, 0.996655822, 2.00889794e-08, 1, -8.77269599e-08, -0.996655822, 1.28533992e-08, -0.0817126185)
				elseif MyLevel == 400 or MyLevel <= 449 then -- Fishman Commando
					Ms = "Fishman Commando [Lv. 400]"
					NaemQuest = "FishmanQuest"
					LevelQuest = 2
					NameMon = "Fishman Commando"
					CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)
					CFrameMon = CFrame.new(61885.5039, 18.4828243, 1504.17896, 0.577502489, 0, -0.816389024, -0, 1.00000012, -0, 0.816389024, 0, 0.577502489)
				elseif MyLevel == 450 or MyLevel <= 474 then -- God's Guards
					Ms = "God's Guard [Lv. 450]"
					NaemQuest = "SkyExp1Quest"
					LevelQuest = 1
					NameMon = "God's Guards"
					CFrameQuest = CFrame.new(-4721.71436, 845.277161, -1954.20105, -0.999277651, -5.56969759e-09, 0.0380011722, -4.14751478e-09, 1, 3.75035256e-08, -0.0380011722, 3.73188307e-08, -0.999277651)
					CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.92542, -0.93441087, -6.77488776e-09, -0.356197298, 1.12145182e-08, 1, -4.84390199e-08, 0.356197298, -4.92565206e-08, -0.93441087)
				elseif MyLevel == 475 or MyLevel <= 524 then -- Shandas
					Ms = "Shanda [Lv. 475]"
					NaemQuest = "SkyExp1Quest"
					LevelQuest = 2
					NameMon = "Shandas"
					CFrameQuest = CFrame.new(-7863.63672, 5545.49316, -379.826324, 0.362120807, -1.98046344e-08, -0.93213129, 4.05822291e-08, 1, -5.48095125e-09, 0.93213129, -3.58431969e-08, 0.362120807)
					CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509, 0.150056243, 1.79768236e-08, -0.988677442, 6.67798661e-09, 1, 1.91962481e-08, 0.988677442, -9.48289181e-09, 0.150056243)
				elseif MyLevel == 525 or MyLevel <= 549 then -- Royal Squad
					Ms = "Royal Squad [Lv. 525]"
					NaemQuest = "SkyExp2Quest"
					LevelQuest = 1
					NameMon = "Royal Squad"
					CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)
					CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729, 0.561947823, 7.69527464e-09, -0.827172697, -4.24974544e-09, 1, 6.41599973e-09, 0.827172697, -9.01838604e-11, 0.561947823)
				elseif MyLevel == 550 or MyLevel <= 624 then -- Royal Soldier
					Ms = "Royal Soldier [Lv. 550]"
					NaemQuest = "SkyExp2Quest"
					LevelQuest = 2
					NameMon = "Royal Soldier"
					CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)
					CFrameMon = CFrame.new(-7864.44775, 5661.94092, -1708.22351, 0.998389959, 2.28686137e-09, -0.0567218624, 1.99431383e-09, 1, 7.54200258e-08, 0.0567218624, -7.54117195e-08, 0.998389959)
				elseif MyLevel == 625 or MyLevel <= 649 then -- Galley Pirate
					Ms = "Galley Pirate [Lv. 625]"
					NaemQuest = "FountainQuest"
					LevelQuest = 1
					NameMon = "Galley Pirate"
					CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)
					CFrameMon = CFrame.new(5595.06982, 41.5013695, 3961.47095, -0.992138803, -2.11610267e-08, -0.125142589, -1.34249509e-08, 1, -6.26613996e-08, 0.125142589, -6.04887518e-08, -0.992138803)
				elseif MyLevel >= 650 then -- Galley Captain
					Ms = "Galley Captain [Lv. 650]"
					NaemQuest = "FountainQuest"
					LevelQuest = 2
					NameMon = "Galley Captain"
					CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)
					CFrameMon = CFrame.new(5658.5752, 38.5361786, 4928.93506, -0.996873081, 2.12391046e-06, -0.0790185928, 2.16989656e-06, 1, -4.96097414e-07, 0.0790185928, -6.66008248e-07, -0.996873081)
				end
			end
			if NewWorld then
				if MyLevel == 700 or MyLevel <= 724 then -- Raider [Lv. 700]
					Ms = "Raider [Lv. 700]"
					NaemQuest = "Area1Quest"
					LevelQuest = 1
					NameMon = "Raider"
					CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
					CFrameMon = CFrame.new(-737.026123, 39.1748352, 2392.57959, 0.272128761, 0, -0.962260842, -0, 1, -0, 0.962260842, 0, 0.272128761)
				elseif MyLevel == 725 or MyLevel <= 774 then -- Mercenary [Lv. 725]
					Ms = "Mercenary [Lv. 725]"
					NaemQuest = "Area1Quest"
					LevelQuest = 2
					NameMon = "Mercenary"
					CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
					CFrameMon = CFrame.new(-973.731995, 95.8733215, 1836.46936, 0.999135971, 2.02326991e-08, -0.0415605344, -1.90767793e-08, 1, 2.82094952e-08, 0.0415605344, -2.73922804e-08, 0.999135971)
				elseif MyLevel == 775 or MyLevel <= 799 then -- Swan Pirate [Lv. 775]
					Ms = "Swan Pirate [Lv. 775]"
					NaemQuest = "Area2Quest"
					LevelQuest = 1
					NameMon = "Swan Pirate"
					CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
					CFrameMon = CFrame.new(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468)
				elseif MyLevel == 800 or MyLevel <= 874 then -- Factory Staff [Lv. 800]
					Ms = "Factory Staff [Lv. 800]"
					NaemQuest = "Area2Quest"
					LevelQuest = 2
					NameMon = "Factory Staff"
					CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
					CFrameMon = CFrame.new(296.786499, 72.9948196, -57.1298141, -0.876037002, -5.32364979e-08, 0.482243896, -3.87658332e-08, 1, 3.99718729e-08, -0.482243896, 1.63222538e-08, -0.876037002)
				elseif MyLevel == 875 or MyLevel <= 899 then -- Marine Lieutenant [Lv. 875]
					Ms = "Marine Lieutenant [Lv. 875]"
					NaemQuest = "MarineQuest3"
					LevelQuest = 1
					NameMon = "Marine Lieutenant"
					CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
					CFrameMon = CFrame.new(-2913.26367, 73.0011826, -2971.64282, 0.910507619, 0, 0.413492233, 0, 1.00000012, 0, -0.413492233, 0, 0.910507619)
				elseif MyLevel == 900 or MyLevel <= 949 then -- Marine Captain [Lv. 900]
					Ms = "Marine Captain [Lv. 900]"
					NaemQuest = "MarineQuest3"
					LevelQuest = 2
					NameMon = "Marine Captain"
					CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
					CFrameMon = CFrame.new(-1868.67688, 73.0011826, -3321.66333, -0.971402287, 1.06502087e-08, 0.237439692, 3.68856199e-08, 1, 1.06050372e-07, -0.237439692, 1.11775684e-07, -0.971402287)
				elseif MyLevel == 950 or MyLevel <= 974 then -- Zombie [Lv. 950]
					Ms = "Zombie [Lv. 950]"
					NaemQuest = "ZombieQuest"
					LevelQuest = 1
					NameMon = "Zombie"
					CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)
					CFrameMon = CFrame.new(-5634.83838, 126.067039, -697.665039, -0.992770672, 6.77618939e-09, 0.120025545, 1.65461245e-08, 1, 8.04023372e-08, -0.120025545, 8.18070234e-08, -0.992770672)
				elseif MyLevel == 975 or MyLevel <= 999 then -- Vampire [Lv. 975]
					Ms = "Vampire [Lv. 975]"
					NaemQuest = "ZombieQuest"
					LevelQuest = 2
					NameMon = "Vampire"
					CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)
					CFrameMon = CFrame.new(-6030.32031, 6.4377408, -1313.5564, -0.856965423, 3.9138893e-08, -0.515373945, -1.12178942e-08, 1, 9.45958547e-08, 0.515373945, 8.68467822e-08, -0.856965423)
				elseif MyLevel == 1000 or MyLevel <= 1049 then -- Snow Trooper [Lv. 1000] **
					Ms = "Snow Trooper [Lv. 1000]"
					NaemQuest = "SnowMountainQuest"
					LevelQuest = 1
					NameMon = "Snow Trooper"
					CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)
					CFrameMon = CFrame.new(535.893433, 401.457062, -5329.6958, -0.999524176, 0, 0.0308452044, 0, 1, -0, -0.0308452044, 0, -0.999524176)
				elseif MyLevel == 1050 or MyLevel <= 1099 then -- Winter Warrior [Lv. 1050]
					Ms = "Winter Warrior [Lv. 1050]"
					NaemQuest = "SnowMountainQuest"
					LevelQuest = 2
					NameMon = "Winter Warrior"
					CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)
					CFrameMon = CFrame.new(1223.7417, 454.575226, -5170.02148, 0.473996818, 2.56845354e-08, 0.880526543, -5.62456428e-08, 1, 1.10811016e-09, -0.880526543, -5.00510211e-08, 0.473996818)
				elseif MyLevel == 1100 or MyLevel <= 1124 then -- Lab Subordinate [Lv. 1100]
					Ms = "Lab Subordinate [Lv. 1100]"
					NaemQuest = "IceSideQuest"
					LevelQuest = 1
					NameMon = "Lab Subordinate"
					CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)
					CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721, -0.569419742, -2.49055017e-08, 0.822046936, -6.96206541e-08, 1, -1.79282633e-08, -0.822046936, -6.74401548e-08, -0.569419742)
				elseif MyLevel == 1125 or MyLevel <= 1174 then -- Horned Warrior [Lv. 1125]
					Ms = "Horned Warrior [Lv. 1125]"
					NaemQuest = "IceSideQuest"
					LevelQuest = 2
					NameMon = "Horned Warrior"
					CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)
					CFrameMon = CFrame.new(-6400.85889, 24.7645149, -5818.63574, -0.964845479, 8.65926566e-08, -0.262817472, 3.98261392e-07, 1, -1.13260398e-06, 0.262817472, -1.19745812e-06, -0.964845479)
				elseif MyLevel == 1175 or MyLevel <= 1199 then -- Magma Ninja [Lv. 1175]
					Ms = "Magma Ninja [Lv. 1175]"
					NaemQuest = "FireSideQuest"
					LevelQuest = 1
					NameMon = "Magma Ninja"
					CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)
					CFrameMon = CFrame.new(-5496.65576, 58.6890411, -5929.76855, -0.885073781, 0, -0.465450764, 0, 1.00000012, -0, 0.465450764, 0, -0.885073781)
				elseif MyLevel == 1200 or MyLevel <= 1249 then -- Lava Pirate [Lv. 1200]
					Ms = "Lava Pirate [Lv. 1200]"
					NaemQuest = "FireSideQuest"
					LevelQuest = 2
					NameMon = "Lava Pirate"
					CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)
					CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633, -0.196780294, 0, 0.98044765, 0, 1.00000012, -0, -0.98044765, 0, -0.196780294)
				elseif MyLevel == 1250 or MyLevel <= 1274 then -- Ship Deckhand [Lv. 1250]
					Ms = "Ship Deckhand [Lv. 1250]"
					NaemQuest = "ShipQuest1"
					LevelQuest = 1
					NameMon = "Ship Deckhand"
					CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)
					CFrameMon = CFrame.new(1163.80872, 138.288452, 33058.4258, -0.998580813, 5.49076979e-08, -0.0532564968, 5.57436763e-08, 1, -1.42118655e-08, 0.0532564968, -1.71604082e-08, -0.998580813)
				elseif MyLevel == 1275 or MyLevel <= 1299 then -- Ship Engineer [Lv. 1275]
					Ms = "Ship Engineer [Lv. 1275]"
					NaemQuest = "ShipQuest1"
					LevelQuest = 2
					NameMon = "Ship Engineer"
					CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)
					CFrameMon = CFrame.new(916.666504, 44.0920448, 32917.207, -0.99746871, -4.85034697e-08, -0.0711069331, -4.8925461e-08, 1, 4.19294288e-09, 0.0711069331, 7.66126895e-09, -0.99746871)
				elseif MyLevel == 1300 or MyLevel <= 1324 then -- Ship Steward [Lv. 1300]
					Ms = "Ship Steward [Lv. 1300]"
					NaemQuest = "ShipQuest2"
					LevelQuest = 1
					NameMon = "Ship Steward"
					CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
					CFrameMon = CFrame.new(918.743286, 129.591064, 33443.4609, -0.999792814, -1.7070947e-07, -0.020350717, -1.72559169e-07, 1, 8.91351277e-08, 0.020350717, 9.2628369e-08, -0.999792814)
				elseif MyLevel == 1325 or MyLevel <= 1349 then -- Ship Officer [Lv. 1325]
					Ms = "Ship Officer [Lv. 1325]"
					NaemQuest = "ShipQuest2"
					LevelQuest = 2
					NameMon = "Ship Officer"
					CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
					CFrameMon = CFrame.new(786.051941, 181.474106, 33303.2969, 0.999285698, -5.32193063e-08, 0.0377905183, 5.68968588e-08, 1, -9.62386864e-08, -0.0377905183, 9.83201005e-08, 0.999285698)
				elseif MyLevel == 1350 or MyLevel <= 1374 then -- Arctic Warrior [Lv. 1350]
					Ms = "Arctic Warrior [Lv. 1350]"
					NaemQuest = "FrostQuest"
					LevelQuest = 1
					NameMon = "Arctic Warrior"
					CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)
					CFrameMon = CFrame.new(5995.07471, 57.3188477, -6183.47314, 0.702747107, -1.53454167e-07, -0.711440146, -1.08168464e-07, 1, -3.22542007e-07, 0.711440146, 3.03620908e-07, 0.702747107)
				elseif MyLevel == 1375 or MyLevel <= 1424 then -- Snow Lurker [Lv. 1375]
					Ms = "Snow Lurker [Lv. 1375]"
					NaemQuest = "FrostQuest"
					LevelQuest = 2
					NameMon = "Snow Lurker"
					CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)
					CFrameMon = CFrame.new(5518.00684, 60.5559731, -6828.80518, -0.650781393, -3.64292951e-08, 0.759265184, -4.07668654e-09, 1, 4.44854642e-08, -0.759265184, 2.58550248e-08, -0.650781393)
				elseif MyLevel == 1425 or MyLevel <= 1449 then -- Sea Soldier [Lv. 1425]
					Ms = "Sea Soldier [Lv. 1425]"
					NaemQuest = "ForgottenQuest"
					LevelQuest = 1
					NameMon = "Sea Soldier"
					CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)
					CFrameMon = CFrame.new(-3029.78467, 66.944252, -9777.38184, -0.998552859, 1.09555076e-08, 0.0537791774, 7.79564235e-09, 1, -5.89660658e-08, -0.0537791774, -5.84614881e-08, -0.998552859)
				elseif MyLevel >= 1450 then -- Water Fighter [Lv. 1450]
					Ms = "Water Fighter [Lv. 1450]"
					NaemQuest = "ForgottenQuest"
					LevelQuest = 2
					NameMon = "Water Fighter"
					CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)
					CFrameMon = CFrame.new(-3262.00098, 298.699615, -10553.6943, -0.233570755, -4.57538185e-08, 0.972339869, -5.80986068e-08, 1, 3.30992194e-08, -0.972339869, -4.87605725e-08, -0.233570755)
				end
			end
		end
		CheckQuest()

		spawn(function()
			while wait() do
				if AFM then
					autofarm()
				end
			end
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if AFM or Observation or AutoNew or Factory or Superhuman or DeathStep or Mastery or GunMastery or FramBoss or FramAllBoss or AutoBartilo or AutoNear or AutoRengoku or AutoSharkman or AutoFramEctoplasm then
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
				end
			end
		end
		)

		local LocalPlayer = game:GetService("Players").LocalPlayer
		local VirtualUser = game:GetService('VirtualUser')
		function autofarm()
			if AFM then
				if LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					StatrMagnet = false
					CheckQuest()
					print()
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
					wait(1.1)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuest, LevelQuest)
				elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
					CheckQuest()
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
					if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
						pcall(
							function()
								for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									CheckQuest()  
									if v.Name == Ms then
										repeat wait()
											EquipWeapon(SelectToolWeapon)
											if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
												if string.find(LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
													if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
														local args = {
															[1] = "Buso"
														}
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
													end
													game:GetService'VirtualUser':CaptureController()
													game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
													game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
													if HideHitBlox then
														v.HumanoidRootPart.Transparency = 1
													else
														v.HumanoidRootPart.Transparency = 0.75
													end
													v.HumanoidRootPart.CanCollide = false
													v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
													if Magnet then 
														if setsimulationradius then 
															setsimulationradius(1e+1598, 1e+1599)
														end
														PosMon = v.HumanoidRootPart.CFrame
														StatrMagnet = true
													end
													v.HumanoidRootPart.CanCollide = false
												else
													StatrMagnet = false
													CheckQuest()
													print()
													LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
													wait(1.5)
													game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuest, LevelQuest)
												end  
											else
												CheckQuest() 
												game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
											end 
										until not v.Parent or v.Humanoid.Health <= 0 or AFM == false or LocalPlayer.PlayerGui.Main.Quest.Visible == false
										StatrMagnet = false
										CheckQuest() 
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
									end
								end
							end
						)
					else
						CheckQuest()
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
					end 
				end
			end
		end

		SelectToolWeapon = ""
		function EquipWeapon(ToolSe)
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				wait(.4)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
			end
		end

		local SelectWeapona = S9s0:addDropdown("Select Weapon First",Wapon,function(Value)
			SelectToolWeapon = Value
			SelectToolWeaponOld = Value
		end)

		S9s0:addToggle("Auto Factory",false,function(vu)
			Factory = vu
			while Factory do wait()
				if game.Workspace.Enemies:FindFirstChild("Core") then
					Core = true
					AFM = false
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if Core and v.Name == "Core" and v.Humanoid.Health > 0 then
							repeat wait(.1)
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
								EquipWeapon(SelectToolWeapon)
								game:GetService'VirtualUser':CaptureController()
								game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
							until not Core or v.Humanoid.Health <= 0  or Factory == false
						end
					end
				elseif game.ReplicatedStorage:FindFirstChild("Core") then
					Core = true
					AFM = false
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
				elseif AFMMain then
					Core = false
					AFM = true
				end
			end
		end)

		S9s0:addToggle("Auto SuperHuman",false,function(vu)
			Superhuman = vu
			while Superhuman do wait()
				if Superhuman then
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
						local args = {
							[1] = "BuyBlackLeg"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end   
					if game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") then
						SelectToolWeapon = "Superhuman"
					end  
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") or game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value <= 299 then
							SelectToolWeapon = "Black Leg"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value <= 299 then
							SelectToolWeapon = "Electro"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value <= 299 then
							SelectToolWeapon = "Fishman Karate"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value <= 299 then
							SelectToolWeapon = "Dragon Claw"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 then
							local args = {
								[1] = "BuyElectro"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 then
							local args = {
								[1] = "BuyElectro"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 then
							local args = {
								[1] = "BuyFishmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 then
							local args = {
								[1] = "BuyFishmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300 then
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "1"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300 then
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "1"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 then
							local args = {
								[1] = "BuySuperhuman"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 then
							local args = {
								[1] = "BuySuperhuman"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end 
					end
				end
			end
		end)

		S9s0:addToggle("Auto Buy Legendary Sword",false,function(Value)
			LegebdarySword = Value    
			while LegebdarySword do wait()
				if LegebdarySword then
					local args = {
						[1] = "LegendarySwordDealer",
						[2] = "2"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				end 
			end
		end)

		WaponAccessories = {}
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
			if v:IsA("Tool") then 
				if v.ToolTip == "Wear" then    
					table.insert(WaponAccessories, v.Name)
				end
			end
		end
		SelectTooAccessories = ""
		S9s0:addToggle("Auto Accessories",false,function(Value)

			if SelectTooAccessories == "" and Value then

				L9s0:Notify("NOTIFICATION", "Select Weapon First")
			else
				AutoAccessories = Value 
			end
		end)

		spawn(function()
			while wait() do
				if AutoAccessories then
					CheckAccessories = game.Players.LocalPlayer.Character 
					if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
						if CheckAccessories:FindFirstChild("CoolShades") or CheckAccessories:FindFirstChild("BlackSpikeyCape") or CheckAccessories:FindFirstChild("BlueSpikeyCape") or CheckAccessories:FindFirstChild("RedSpikeyCape") or CheckAccessories:FindFirstChild("Chopper") or CheckAccessories:FindFirstChild("MarineCape") or CheckAccessories:FindFirstChild("GhoulMask") or CheckAccessories:FindFirstChild("MarineCap") or CheckAccessories:FindFirstChild("PinkCape") or CheckAccessories:FindFirstChild("SaboTopHat") or CheckAccessories:FindFirstChild("SwanGlasses") or CheckAccessories:FindFirstChild("UsoapHat") or CheckAccessories:FindFirstChild("Corrida") or CheckAccessories:FindFirstChild("ZebraCap") or CheckAccessories:FindFirstChild("TomoeRing") or CheckAccessories:FindFirstChild("BlackCape") or CheckAccessories:FindFirstChild("SwordsmanHat") or CheckAccessories:FindFirstChild("SantaHat") or CheckAccessories:FindFirstChild("ElfHat") or CheckAccessories:FindFirstChild("DarkCoat") then
						else
							EquipWeapon(SelectTooAccessories)
							wait(0.1)
							game:GetService'VirtualUser':CaptureController()
							game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
							wait(0.1)
							if game.Players.LocalPlayer.Character:FindFirstChild(SelectTooAccessories) then
								game.Players.LocalPlayer.Character:FindFirstChild(SelectTooAccessories).Parent = game.Players.LocalPlayer:FindFirstChild("Backpack")
							end
							wait(1)
						end
					end
				end
			end
		end)

		local SelectAccessories = S9s0:addDropdown("Select Accesories ",WaponAccessories,function(Value)
			SelectTooAccessories = Value
		end)

		function isnil(thing)
			return (thing == nil)
		end
		local function round(n)
			return math.floor(tonumber(n) + 0.5)
		end
		Number = math.random(1, 1000000)
		Distance = 500

		spawn(function()
			while wait(.1) do
				if NextIsland then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
					if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame*CFrame.new(0,40,0)
					elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame*CFrame.new(0,40,0)
					elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame*CFrame.new(0,40,0)
					elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame*CFrame.new(0,40,0)
					elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame*CFrame.new(0,40,0)
					end
				end
			end
		end)

		S9s0:addToggle("Auto Next Island",false,function(value)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end

		end)

		spawn(function()
			while wait(.1) do
				if RaidsArua then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if RaidsArua and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 500 then
							pcall(function()
								repeat wait(.1)
									if setsimulationradius then
										setsimulationradius(1e+1598, 1e+1599)
									end
									v.HumanoidRootPart.Transparency = 0.75
									v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.Health = 0
								until not RaidsArua or not v.Parent or v.Humanoid.Health <= 0
							end)
						end
					end
				end
			end
		end)


		spawn(function()
			while wait() do
				if AFM and StatrMagnet and Magnet then
					CheckQuest()
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if v.Name == "Factory Staff [Lv. 800]" and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 200 then
								wait()
								if HideHitBlox then
									v.HumanoidRootPart.Transparency = 1
								else
									v.HumanoidRootPart.Transparency = 0.75
								end
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								v.HumanoidRootPart.CFrame = PosMon
							elseif v.Name == Ms and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 400 then
								wait()
								if HideHitBlox then
									v.HumanoidRootPart.Transparency = 1
								else
									v.HumanoidRootPart.Transparency = 0.75
								end
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								v.HumanoidRootPart.CFrame = PosMon
							end
						end
					end
				end 
			end
		end)

		melee = false
		S9s01:addToggle("Melee",false,function(Value)
			melee = Value  
		end)
		defense = false
		S9s01:addToggle("Defense",false,function(Value)
			defense = Value
		end)
		sword = false
		S9s01:addToggle("Sword",false,function(Value)
			sword = Value
		end)
		gun = false
		S9s01:addToggle("Gun",false,function(Value)
			gun = Value
		end)
		demonfruit = false
		S9s01:addToggle("Devil Fruit",false,function(Value)
			demonfruit = Value
		end)
		PointStats = 1
		S9s01:addSlider("Point ",1,1,10,PointStats,function(a)
			PointStats = a
		end)

		spawn(function()
			while wait() do
				if game.Players.localPlayer.Data.Points.Value >= PointStats then
					if melee then
						local args = {
							[1] = "AddPoint",
							[2] = "Melee",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if defense then
						local args = {
							[1] = "AddPoint",
							[2] = "Defense",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if sword then
						local args = {
							[1] = "AddPoint",
							[2] = "Sword",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if gun then
						local args = {
							[1] = "AddPoint",
							[2] = "Gun",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if demonfruit then
						local args = {
							[1] = "AddPoint",
							[2] = "Demon Fruit",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			end
		end)

		S9s02:addToggle("Ctrl + Click = TP ",false,function(vu)
			CTRL = vu
		end)

		local Plr = game:GetService("Players").LocalPlayer
		local Mouse = Plr:GetMouse()
		Mouse.Button1Down:connect(
			function()
				if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
					return
				end
				if not Mouse.Target then
					return
				end
				if CTRL then
					Plr.Character:MoveTo(Mouse.Hit.p)
				end
			end)

		S9s02:addButton("Current Quest",function()
			CheckQuest()
			wait(0.25)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
		end)

		if game.PlaceId == 2753915549 then

			S9s02:addButton("Teleport to New World",function()
				local args = {
					[1] = "Dressrosa" -- OLD WORLD to NEW WORLD
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)

			S9s02:addButton("Start Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1071.2832, 16.3085976, 1426.86792)
			end)
			S9s02:addButton("Marine Start",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2573.3374, 6.88881969, 2046.99817)
			end)
			S9s02:addButton("Middle Town",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-655.824158, 7.88708115, 1436.67908)
			end)
			S9s02:addButton("Jungle",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1249.77222, 11.8870859, 341.356476)
			end)
			S9s02:addButton("Pirate Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1122.34998, 4.78708982, 3855.91992)
			end)
			S9s02:addButton("Desert",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1094.14587, 6.47350502, 4192.88721)
			end)
			S9s02:addButton("Frozen Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1198.00928, 27.0074959, -1211.73376)
			end)
			S9s02:addButton("MarineFord",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4505.375, 20.687294, 4260.55908)
			end)
			S9s02:addButton("Colosseum",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1428.35474, 7.38933945, -3014.37305)
			end)
			S9s02:addButton("Sky 1st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4970.21875, 717.707275, -2622.35449)
			end)
			S9s02:addButton("Sky 2st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4813.0249, 903.708557, -1912.69055)
			end)
			S9s02:addButton("Sky 3st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7952.31006, 5545.52832, -320.704956)
			end)
			S9s02:addButton("Prison",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4854.16455, 5.68742752, 740.194641)
			end)
			S9s02:addButton("Magma Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5231.75879, 8.61593437, 8467.87695)
			end)
			S9s02:addButton("UndeyWater City",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(61163.8516, 11.7796879, 1819.78418)
			end)
			S9s02:addButton("Fountain City",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5132.7124, 4.53632832, 4037.8562)
			end)
			S9s02:addButton("House Cyborg's",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6262.72559, 71.3003616, 3998.23047)
			end)
			S9s02:addButton("Shank's Room",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1442.16553, 29.8788261, -28.3547478)
			end)
			S9s02:addButton("Mob Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2850.20068, 7.39224768, 5354.99268)
			end)
		end

		if game.PlaceId == 4442272183 then

			S9s02:addButton("Teleport to Old World",function()
				local args = {
					[1] = "Dressrosa" -- NEW WORLD to OLD WORLD
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)

			S9s02:addButton("Teleport to SeaBeatsts",function()
				for i,v in pairs(game.Workspace.SeaBeasts:GetChildren()) do
					if v:FindFirstChild("HumanoidRootPart") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,100,0)
					end
				end
			end)

			S9s02:addButton("First Spot",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(82.9490662, 18.0710983, 2834.98779)
			end)

			S9s02:addButton("Kingdom of Rose",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["_WorldOrigin"].Locations["Kingdom of Rose"].CFrame
			end)

			S9s02:addButton("Dark Areas",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["_WorldOrigin"].Locations["Dark Arena"].CFrame
			end)

			S9s02:addButton("Flamingo Mansion",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-390.096313, 331.886475, 673.464966)
			end)

			S9s02:addButton("Flamingo Room",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2302.19019, 15.1778421, 663.811035)
			end)

			S9s02:addButton("Green bit",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2372.14697, 72.9919434, -3166.51416)
			end)

			S9s02:addButton("Cafe",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385.250916, 73.0458984, 297.388397)
			end)

			S9s02:addButton("Factory",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(430.42569, 210.019623, -432.504791)
			end)

			S9s02:addButton("Colosseum",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.58191, 44.5890656, 1360.30652)
			end)

			S9s02:addButton("Ghost Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5571.84424, 195.182297, -795.432922)
			end)

			S9s02:addButton("Ghost Island 2nd",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5931.77979, 5.19706631, -1189.6908)
			end)

			S9s02:addButton("Snow Mountain",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1384.68298, 453.569031, -4990.09766)
			end)

			S9s02:addButton("Hot and Cold",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6026.96484, 14.7461271, -5071.96338)
			end)

			S9s02:addButton("Magma Side",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5478.39209, 15.9775667, -5246.9126)
			end)

			S9s02:addButton("Cursed Ship",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(902.059143, 124.752518, 33071.8125)
			end)

			S9s02:addButton("Frosted Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5400.40381, 28.21698, -6236.99219)
			end)

			S9s02:addButton("Forgotten Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3043.31543, 238.881271, -10191.5791)
			end)

			S9s02:addButton("Usoopp Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4748.78857, 8.35370827, 2849.57959)
			end)

			S9s02:addButton("Raids Low",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5554.95313, 329.075623, -5930.31396)
			end)

			S9s02:addButton("Minisky Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-260.358917, 49325.7031, -35259.3008)
			end)
		end
		function isnil(thing)
			return (thing == nil)
		end
		local function round(n)
			return math.floor(tonumber(n) + 0.5)
		end
		Number = math.random(1, 1000000)
		function UpdatePlayerChams()
			for i,v in pairs(game:GetService'Players':GetChildren()) do
				pcall(function()
					if not isnil(v.Character) then
						if ESPPlayer then
							if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v.Character.Head)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v.Character.Head
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								if v.Team == game.Players.LocalPlayer.Team then
									name.TextColor3 = Color3.new(0.196078, 0.196078, 0.196078)
								else
									name.TextColor3 = Color3.new(1, 0.333333, 0.498039)
								end
							else
								v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
							end
						else
							if v.Character.Head:FindFirstChild('NameEsp'..Number) then
								v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end
				end)
			end
		end
		function UpdateChestChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if string.find(v.Name,"Chest") then
						if ChestESP then
							if string.find(v.Name,"Chest") then
								if not v:FindFirstChild('NameEsp'..Number) then
									local bill = Instance.new('BillboardGui',v)
									bill.Name = 'NameEsp'..Number
									bill.ExtentsOffset = Vector3.new(0, 1, 0)
									bill.Size = UDim2.new(1,200,1,30)
									bill.Adornee = v
									bill.AlwaysOnTop = true
									local name = Instance.new('TextLabel',bill)
									name.Font = "SourceSansBold"
									name.FontSize = "Size14"
									name.TextWrapped = true
									name.Size = UDim2.new(1,0,1,0)
									name.TextYAlignment = 'Top'
									name.BackgroundTransparency = 1
									name.TextStrokeTransparency = 0.5
									if v.Name == "Chest1" then
										name.TextColor3 = Color3.fromRGB(109, 109, 109)
										name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
									if v.Name == "Chest2" then
										name.TextColor3 = Color3.fromRGB(173, 158, 21)
										name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
									if v.Name == "Chest3" then
										name.TextColor3 = Color3.fromRGB(85, 255, 255)
										name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
								else
									v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
								end
							end
						else
							if v:FindFirstChild('NameEsp'..Number) then
								v:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end
				end)
			end
		end
		function UpdateDevilChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if DevilFruitESP then
						if string.find(v.Name, "Fruit") then   
							if not v.Handle:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v.Handle)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v.Handle
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								name.TextColor3 = Color3.fromRGB(255, 0, 0)
								name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
							else
								v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
							end
						end
					else
						if v.Handle:FindFirstChild('NameEsp'..Number) then
							v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
						end
					end
				end)
			end
		end
		function UpdateFlowerChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if v.Name == "Flower2" or v.Name == "Flower1" then
						if FlowerESP then 
							if not v:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								name.TextColor3 = Color3.fromRGB(255, 0, 0)
								if v.Name == "Flower1" then 
									name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									name.TextColor3 = Color3.fromRGB(0, 0, 255)
								end
								if v.Name == "Flower2" then
									name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									name.TextColor3 = Color3.fromRGB(255, 0, 0)
								end
							else
								v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
							end
						else
							if v:FindFirstChild('NameEsp'..Number) then
								v:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end   
				end)
			end
		end

		S9s03:addToggle("Esp Player ",false,function(a)
			ESPPlayer = a
			while ESPPlayer do wait()
				UpdatePlayerChams()
			end
		end)

		S9s03:addToggle("Esp Chest ",false,function(a)
			ChestESP = a
			while ChestESP do wait()
				UpdateChestChams() 
			end
		end)

		S9s03:addToggle("Esp Devil Fruit ",false,function(a)
			DevilFruitESP = a
			while DevilFruitESP do wait()
				UpdateDevilChams() 
			end
		end)

		if game.PlaceId == 4442272183 then

			S9s03:addToggle("Esp Flower ",false,function(a)
				FlowerESP = a
				while FlowerESP do wait()
					UpdateFlowerChams() 
				end
			end)
		end

		S9s03:addButton("Join Team Pirate",function()
			local args = {
				[1] = "SetTeam",
				[2] = "Pirates"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
			local args = {
				[1] = "BartiloQuestProgress"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s03:addButton("Join Team Marine",function()
			local args = {
				[1] = "SetTeam",
				[2] = "Marines"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BartiloQuestProgress"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		local LocalPlayer = game:GetService'Players'.LocalPlayer
		local originalstam = LocalPlayer.Character.Energy.Value
		function infinitestam()
			LocalPlayer.Character.Energy.Changed:connect(function()
				if InfinitsEnergy then
					LocalPlayer.Character.Energy.Value = originalstam
				end 
			end)
		end
		spawn(function()
			while wait(.1) do
				if InfinitsEnergy then
					wait(0.3)
					originalstam = LocalPlayer.Character.Energy.Value
					infinitestam()
				end
			end
		end)
		nododgecool = false
		function NoDodgeCool()
			if nododgecool then
				for i,v in next, getgc() do
					if game.Players.LocalPlayer.Character.Dodge then
						if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
							for i2,v2 in next, getupvalues(v) do
								if tostring(v2) == "0.4" then
									repeat wait(.1)
										setupvalue(v,i2,0)
									until not nododgecool
								end
							end
						end
					end
				end
			end
		end

		S9s04:addToggle("Dodge No Cooldown",false,function(Value)
			nododgecool = Value
			NoDodgeCool()
		end)

		S9s04:addToggle("infinitiy Energy",false,function(value)

			InfinitsEnergy = value
			originalstam = LocalPlayer.Character.Energy.Value

		end)

		Fly = false
		function activatefly()
			local mouse=game.Players.LocalPlayer:GetMouse''
			localplayer=game.Players.LocalPlayer
			game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			local torso = game.Players.LocalPlayer.Character.HumanoidRootPart
			local speedSET=25
			local keys={a=false,d=false,w=false,s=false}
			local e1
			local e2
			local function start()
				local pos = Instance.new("BodyPosition",torso)
				local gyro = Instance.new("BodyGyro",torso)
				pos.Name="EPIXPOS"
				pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
				pos.position = torso.Position
				gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
				gyro.cframe = torso.CFrame
				repeat
					wait()
					localplayer.Character.Humanoid.PlatformStand=true
					local new=gyro.cframe - gyro.cframe.p + pos.position
					if not keys.w and not keys.s and not keys.a and not keys.d then
						speed=1
					end
					if keys.w then
						new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.s then
						new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.d then
						new = new * CFrame.new(speed,0,0)
						speed=speed+speedSET
					end
					if keys.a then
						new = new * CFrame.new(-speed,0,0)
						speed=speed+speedSET
					end
					if speed>speedSET then
						speed=speedSET
					end
					pos.position=new.p
					if keys.w then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*15),0,0)
					elseif keys.s then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*15),0,0)
					else
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame
					end
				until not Fly
				if gyro then 
					gyro:Destroy() 
				end
				if pos then 
					pos:Destroy() 
				end
				flying=false
				localplayer.Character.Humanoid.PlatformStand=false
				speed=0
			end
			e1=mouse.KeyDown:connect(function(key)
				if not torso or not torso.Parent then 
					flying=false e1:disconnect() e2:disconnect() return 
				end
				if key=="w" then
					keys.w=true
				elseif key=="s" then
					keys.s=true
				elseif key=="a" then
					keys.a=true
				elseif key=="d" then
					keys.d=true
				end
			end)
			e2=mouse.KeyUp:connect(function(key)
				if key=="w" then
					keys.w=false
				elseif key=="s" then
					keys.s=false
				elseif key=="a" then
					keys.a=false
				elseif key=="d" then
					keys.d=false
				end
			end)
			start()
		end

		S9s04:addToggle("Fly",false,function(Value)
			Fly = Value
			activatefly()
		end)

		S9s04:addToggle("No Clip",false,function(value)
			NoClip = value
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if NoClip or Observation then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)

		S9s04:addToggle("Teleport Devil Fruit",false,function(value)
			TeleportDF = value
			pcall(function()
				while TeleportDF do wait()
					for i,v in pairs(game.Workspace:GetChildren()) do
						if string.find(v.Name, "Fruit") then 
							v.Handle.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		end)

		S9s05:addButton("Rejoin",function()
			local ts = game:GetService("TeleportService")
			local p = game:GetService("Players").LocalPlayer
			ts:Teleport(game.PlaceId, p)
		end)
		local function HttpGet(url)
			return game:GetService("HttpService"):JSONDecode(htgetf(url))
		end

		S9s05:addButton("Server Hop",function()
			local PlaceID = game.PlaceId
			local AllIDs = {}
			local foundAnything = ""
			local actualHour = os.date("!*t").hour
			local Deleted = false
			function TPReturner()
				local Site;
				if foundAnything == "" then
					Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
				else
					Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
				end
				local ID = ""
				if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
					foundAnything = Site.nextPageCursor
				end
				local num = 0;
				for i,v in pairs(Site.data) do
					local Possible = true
					ID = tostring(v.id)
					if tonumber(v.maxPlayers) > tonumber(v.playing) then
						for _,Existing in pairs(AllIDs) do
							if num ~= 0 then
								if ID == tostring(Existing) then
									Possible = false
								end
							else
								if tonumber(actualHour) ~= tonumber(Existing) then
									local delFile = pcall(function()
										-- delfile("NotSameServers.json")
										AllIDs = {}
										table.insert(AllIDs, actualHour)
									end)
								end
							end
							num = num + 1
						end
						if Possible == true then
							table.insert(AllIDs, ID)
							wait()
							pcall(function()
								-- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
								wait()
								game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
							end)
							wait(4)
						end
					end
				end
			end
			function Teleport() 
				while wait() do
					pcall(function()
						TPReturner()
						if foundAnything ~= "" then
							TPReturner()
						end
					end)
				end
			end
			Teleport()
		end)

		S9s05:addKeybind("Hide UI", Enum.KeyCode.Insert, function()
			L9s0:toggle()
		end, function()

		end)

		S9s05:addButton("RTX Graphic",function()

			getgenv().mode = "Autumn" -- Choose from Summer and Autumn




			local a = game.Lighting
			a.Ambient = Color3.fromRGB(33, 33, 33)
			a.Brightness = 6.67
			a.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
			a.ColorShift_Top = Color3.fromRGB(255, 247, 237)
			a.EnvironmentDiffuseScale = 0.105
			a.EnvironmentSpecularScale = 0.522
			a.GlobalShadows = true
			a.OutdoorAmbient = Color3.fromRGB(51, 54, 67)
			a.ShadowSoftness = 0.04
			a.GeographicLatitude = -15.525
			a.ExposureCompensation = 0.75
			local b = Instance.new("BloomEffect", a)
			b.Enabled = true
			b.Intensity = 0.04
			b.Size = 1900
			b.Threshold = 0.915
			local c = Instance.new("ColorCorrectionEffect", a)
			c.Brightness = 0.176
			c.Contrast = 0.39
			c.Enabled = true
			c.Saturation = 0.2
			c.TintColor = Color3.fromRGB(217, 145, 57)
			if getgenv().mode == "Summer" then
				c.TintColor = Color3.fromRGB(255, 220, 148)
			elseif getgenv().mode == "Autumn" then
				c.TintColor = Color3.fromRGB(217, 145, 57)
			else
				warn("No mode selected!")
				print("Please select a mode")
				b:Destroy()
				c:Destroy()
			end
			local d = Instance.new("DepthOfFieldEffect", a)
			d.Enabled = true
			d.FarIntensity = 0.077
			d.FocusDistance = 21.54
			d.InFocusRadius = 20.77
			d.NearIntensity = 0.277
			local e = Instance.new("ColorCorrectionEffect", a)
			e.Brightness = 0
			e.Contrast = -0.07
			e.Saturation = 0
			e.Enabled = true
			e.TintColor = Color3.fromRGB(255, 247, 239)
			local e2 = Instance.new("ColorCorrectionEffect", a)
			e2.Brightness = 0.2
			e2.Contrast = 0.45
			e2.Saturation = -0.1
			e2.Enabled = true
			e2.TintColor = Color3.fromRGB(255, 255, 255)
			local s = Instance.new("SunRaysEffect", a)
			s.Enabled = true
			s.Intensity = 0.01
			s.Spread = 0.146

		end)

		S9s05:addToggle("Anit AFK",false,function(vu)
			local vu = game:GetService("VirtualUser")
			game:GetService("Players").LocalPlayer.Idled:connect(function()
				vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
				wait(1)
				vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
			end)
		end)

		S9s05:addToggle("Hide HitBlox",true,function(Value)
			HideHitBlox = Value  
		end)

		S9s06:addButton("Open Devil Shop",function()
			local args = {
				[1] = "GetFruits"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.FruitShop.Visible = true
		end)

		S9s06:addButton("Open Inventory",function()
			local args = {
				[1] = "getInventoryWeapons"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.Inventory.Visible = true
		end)

		S9s06:addButton("Open Color Haki",function()
			game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
		end)

		S9s06:addButton("Open Title Name",function()
			local args = {
				[1] = "getTitles"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
		end)

		S9s07:addButton("SkyJump ($10,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Geppo"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Buso Haki ($25,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Buso"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Observation haki ($750,000 Beli)",function()
			local args = {
				[1] = "KenTalk",
				[2] = "Buy"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Soru ($100,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Soru"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Black Leg",function()
			local args = {
				[1] = "BuyBlackLeg"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Electra",function()
			local args = {
				[1] = "BuyElectro"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Fishman Karate",function()
			local args = {
				[1] = "BuyFishmanKarate"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Dragon Claw",function()
			local args = {
				[1] = "BlackbeardReward",
				[2] = "DragonClaw",
				[3] = "1"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BlackbeardReward",
				[2] = "DragonClaw",
				[3] = "2"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Superhuman",function()
			local args = {
				[1] = "BuySuperhuman"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Death Step",function()
			local args = {
				[1] = "BuyDeathStep"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Shakman Karate",function()
			local args = {
				[1] = "BuySharkmanKarate",
				[2] = true
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BuySharkmanKarate"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s08:addButton("Copy Link Discord",function()

			setclipboard("https://discord.gg/4sM2KwJBh4")
		end)

		S9s08:addButton("Credit",function()

			L9s0:Notify("CREDIT ", "9s0 Hub")
			wait(2.5)
			L9s0:Notify("CREDIT ", "Free Script 9s0 Hub")
		end)


	end

	if placeId == 4442272183 then --- Blox Fruit New World


		if game.CoreGui:FindFirstChild("9s0 Hub - Blox Fruit (New World)") then
			game.CoreGui:FindFirstChild("9s0 Hub - Blox Fruit (New World)"):Destroy()
		end

		local library = loadstring(game:HttpGet("https://gist.githubusercontent.com/SaintGGH/47793e459824d440227cb9fade415897/raw/0e29e31f77a4e51d353b39743659c9ce24dad4ee/ADG.md"))()

		local L9s0 = library.new("Blox fruit GUI")

                          local M9s0 = L9s0:addPage("Auto Farm", 7010566435)

		local M9s01 = L9s0:addPage("Playes", 7061402283)

		local M9s02 = L9s0:addPage("Teleports", 7061398829)

		local M9s03 = L9s0:addPage("Game", 7061409730)

		local M9s04 = L9s0:addPage("Auto Stats", 7061136295)

                          local M9s05 = L9s0:addPage("Dungeon", 7064509895)
                          
                          local M9s06 = L9s0:addPage("Misc Fruit", 7066507885)
                          
                          local M9s07 = L9s0:addPage("Settings", 7066507885)
                          
                          local M9s08 = L9s0:addPage("Theme", 7066507885)


		local S9s0 = M9s0:addSection("Auto Farm")

		local S9s01 = M9s04:addSection("Auto Stats")

		local S9s02 = M9s02:addSection("Teleports")

		local S9s03I = M9s0:addSection("Auto Boss")

		local S9s03IIII = M9s05:addSection("Auto Raids")

		local S9s03III = M9s0:addSection("Auto Farm Ectoplasm")

		local S9s03II = M9s01:addSection("Players")

		local S9s03 = M9s06:addSection("Functions")

		local S9s04 = M9s06:addSection("GUI")

		local S9s05 = M9s07:addSection("Settings")

		local S9s06 = M9s03:addSection("Others Functions")

		local S9s07 = M9s03:addSection("Buy Item")

		local S9s08 = M9s08:addSection("GUI")

                          local S9s08 = M9s08:addSection("Discord")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")

                          local S9s07 = M9s03:addSection("No up")


		local games = {
			[4442272183] = {
				Title = "Blox Fruits",
				Icons = "C",
				Welcome = function()
					return tostring(
						"<Color=White>Welcome " ..
							"<Color=Green>" ..
							game:GetService("Players").LocalPlayer.Name .. "!" .. " \n<Color=Yellow> โปรกูเองไอสัส"
					)
				end
			}
		}

		if games[game.PlaceId] then
			if games[game.PlaceId].Title == "Blox Fruits" then
				local function notify(types, ...)
					if types == "Notify" then
						require(game.ReplicatedStorage.Notification).new(...):Display()
					end
				end
				notify("Notify", games[game.PlaceId].Welcome())
			end
		end

		local placeId = game.PlaceId
		Magnet = true
		if placeId == 2753915549 then
			OldWorld = true
		elseif placeId == 4442272183 then
			NewWorld = true
		end

		function Click()
			game:GetService'VirtualUser':CaptureController()
			game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer
		local VirtualUser = game:GetService('VirtualUser')

		Wapon = {}
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
			if v:IsA("Tool") then
				table.insert(Wapon ,v.Name)
			end
		end
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do  
			if v:IsA("Tool") then
				table.insert(Wapon, v.Name)
			end
		end

		game:GetService("RunService").Heartbeat:Connect(
		function()
			if AFM or FramBoss or FramAllBoss then
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
				end
			end
		end)

		function CheckQuestBoss()
			if SelectBoss == "Diamond [Lv. 750] [Boss]" then
				MsBoss = "Diamond [Lv. 750] [Boss]"
				NaemQuestBoss = "Area1Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
				CFrameBoss = CFrame.new(-1736.26587, 198.627731, -236.412857, -0.997808516, 0, -0.0661673471, 0, 1, 0, 0.0661673471, 0, -0.997808516)
			elseif SelectBoss == "Jeremy [Lv. 850] [Boss]" then
				MsBoss = "Jeremy [Lv. 850] [Boss]"
				NaemQuestBoss = "Area2Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
				CFrameBoss = CFrame.new(2203.76953, 448.966034, 752.731079, -0.0217453763, 0, -0.999763548, 0, 1, 0, 0.999763548, 0, -0.0217453763)
			elseif SelectBoss == "Fajita [Lv. 925] [Boss]" then
				MsBoss = "Fajita [Lv. 925] [Boss]"
				NaemQuestBoss = "MarineQuest3"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
				CFrameBoss = CFrame.new(-2297.40332, 115.449463, -3946.53833, 0.961227536, -1.46645796e-09, -0.275756449, -2.3212845e-09, 1, -1.34094433e-08, 0.275756449, 1.35296352e-08, 0.961227536)
			elseif SelectBoss == "Don Swan [Lv. 1000] [Boss]" then
				MsBoss = "Don Swan [Lv. 1000] [Boss]"
				CFrameBoss = CFrame.new(2288.802, 15.1870775, 863.034607, 0.99974072, -8.41247214e-08, -0.0227668174, 8.4774733e-08, 1, 2.75850098e-08, 0.0227668174, -2.95079072e-08, 0.99974072)
			elseif SelectBoss == "Smoke Admiral [Lv. 1150] [Boss]" then
				MsBoss = "Smoke Admiral [Lv. 1150] [Boss]"
				NaemQuestBoss = "IceSideQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-6059.96191, 15.9868021, -4904.7373, -0.444992423, -3.0874483e-09, 0.895534337, -3.64098796e-08, 1, -1.4644522e-08, -0.895534337, -3.91229982e-08, -0.444992423)
				CFrameBoss = CFrame.new(-5115.72754, 23.7664986, -5338.2207, 0.251453817, 1.48345061e-08, -0.967869282, 4.02796978e-08, 1, 2.57916977e-08, 0.967869282, -4.54708946e-08, 0.251453817)
			elseif SelectBoss == "Cursed Captain [Lv. 1325] [Raid Boss]" then
				MsBoss = "Cursed Captain [Lv. 1325] [Raid Boss]"
				CFrameBoss = CFrame.new(916.928589, 181.092773, 33422, -0.999505103, 9.26310495e-09, 0.0314563364, 8.42916226e-09, 1, -2.6643713e-08, -0.0314563364, -2.63653774e-08, -0.999505103)
			elseif SelectBoss == "Darkbeard [Lv. 1000] [Raid Boss]" then
				MsBoss = "Darkbeard [Lv. 1000] [Raid Boss]"
				CFrameBoss = CFrame.new(3876.00366, 24.6882591, -3820.21777, -0.976951957, 4.97356325e-08, 0.213458836, 4.57335361e-08, 1, -2.36868622e-08, -0.213458836, -1.33787044e-08, -0.976951957)
			elseif SelectBoss == "Order [Lv. 1250] [Raid Boss]" then
				MsBoss = "Order [Lv. 1250] [Raid Boss]"
				CFrameBoss = CFrame.new(-6221.15039, 16.2351036, -5045.23584, -0.380726993, 7.41463495e-08, 0.924687505, 5.85604774e-08, 1, -5.60738549e-08, -0.924687505, 3.28013137e-08, -0.380726993)
			elseif SelectBoss == "Awakened Ice Admiral [Lv. 1400] [Boss]" then
				MsBoss = "Awakened Ice Admiral [Lv. 1400] [Boss]"
				NaemQuestBoss = "FrostQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(5669.33203, 28.2118053, -6481.55908, 0.921275556, -1.25320829e-08, 0.388910472, 4.72230788e-08, 1, -7.96414241e-08, -0.388910472, 9.17372489e-08, 0.921275556)
				CFrameBoss = CFrame.new(6407.33936, 340.223785, -6892.521, 0.49051559, -5.25310213e-08, -0.871432424, -2.76146022e-08, 1, -7.58250565e-08, 0.871432424, 6.12576301e-08, 0.49051559)
			elseif SelectBoss == "Tide Keeper [Lv. 1475] [Boss]" then
				MsBoss = "Tide Keeper [Lv. 1475] [Boss]"
				NaemQuestBoss = "ForgottenQuest"             
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-3053.89648, 236.881363, -10148.2324, -0.985987961, -3.58504737e-09, 0.16681771, -3.07832915e-09, 1, 3.29612559e-09, -0.16681771, 2.73641976e-09, -0.985987961)
				CFrameBoss = CFrame.new(-3570.18652, 123.328949, -11555.9072, 0.465199202, -1.3857326e-08, 0.885206044, 4.0332897e-09, 1, 1.35347511e-08, -0.885206044, -2.72606271e-09, 0.465199202)
				-- Old World
			elseif SelectBoss == "Saber Expert [Lv. 200] [Boss]" then
				MsBoss = "Saber Expert [Lv. 200] [Boss]"
				CFrameBoss = CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636, -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094)
			elseif SelectBoss == "The Saw [Lv. 100] [Boss]" then
				MsBoss = "The Saw [Lv. 100] [Boss]"
				CFrameBoss = CFrame.new(-683.519897, 13.8534927, 1610.87854, -0.290192783, 6.88365773e-08, 0.956968188, 6.98413629e-08, 1, -5.07531119e-08, -0.956968188, 5.21077759e-08, -0.290192783)
			elseif SelectBoss == "The Gorilla King [Lv. 25] [Boss]" then
				MsBoss = "The Gorilla King [Lv. 25] [Boss]"
				NaemQuestBoss = "JungleQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
				CFrameBoss = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519, -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)
			elseif SelectBoss == "Bobby [Lv. 55] [Boss]" then
				MsBoss = "Bobby [Lv. 55] [Boss]"
				NaemQuestBoss = "BuggyQuest1"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
				CFrameBoss = CFrame.new(-1147.65173, 32.5966301, 4156.02588, 0.956680477, -1.77109952e-10, -0.29113996, 5.16530874e-10, 1, 1.08897802e-09, 0.29113996, -1.19218679e-09, 0.956680477)
			elseif SelectBoss == "Yeti [Lv. 110] [Boss]" then
				MsBoss = "Yeti [Lv. 110] [Boss]"
				NaemQuestBoss = "SnowQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(1384.90247, 87.3078308, -1296.6825, 0.280209213, 2.72035177e-08, -0.959938943, -6.75690828e-08, 1, 8.6151708e-09, 0.959938943, 6.24481444e-08, 0.280209213)
				CFrameBoss = CFrame.new(1221.7356, 138.046906, -1488.84082, 0.349343032, -9.49245944e-08, 0.936994851, 6.29478194e-08, 1, 7.7838429e-08, -0.936994851, 3.17894653e-08, 0.349343032)
			elseif SelectBoss == "Mob Leader [Lv. 120] [Boss]" then
				MsBoss = "Mob Leader [Lv. 120] [Boss]"
				CFrameBoss = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564, -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.928248107)
				--The Gorilla King [Lv. 25] [Boss]
			elseif SelectBoss == "Vice Admiral [Lv. 130] [Boss]" then
				MsBoss = "Vice Admiral [Lv. 130] [Boss]"
				NaemQuestBoss = "MarineQuest2"
				LevelQuestBoss = 2
				CFrameQuestBoss = CFrame.new(-5035.42285, 28.6520386, 4324.50293, -0.0611100644, -8.08395768e-08, 0.998130739, -1.57416586e-08, 1, 8.00271849e-08, -0.998130739, -1.08217701e-08, -0.0611100644)
				CFrameBoss = CFrame.new(-5078.45898, 99.6520691, 4402.1665, -0.555574954, -9.88630566e-11, 0.831466436, -6.35508286e-08, 1, -4.23449258e-08, -0.831466436, -7.63661632e-08, -0.555574954)
			elseif SelectBoss == "Warden [Lv. 175] [Boss]" then
				MsBoss = "Warden [Lv. 175] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 1
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Chief Warden [Lv. 200] [Boss]" then
				MsBoss = "Chief Warden [Lv. 200] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 2
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Swan [Lv. 225] [Boss]" then
				MsBoss = "Swan [Lv. 225] [Boss]"
				NaemQuestBoss = "ImpelQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(4851.35059, 5.68744135, 743.251282, -0.538484037, -6.68303741e-08, -0.842635691, 1.38001752e-08, 1, -8.81300792e-08, 0.842635691, -5.90851599e-08, -0.538484037)
				CFrameBoss = CFrame.new(5232.5625, 5.26856995, 747.506897, 0.943829298, -4.5439414e-08, 0.330433697, 3.47818627e-08, 1, 3.81658154e-08, -0.330433697, -2.45289105e-08, 0.943829298)
			elseif SelectBoss == "Magma Admiral [Lv. 350] [Boss]" then
				MsBoss = "Magma Admiral [Lv. 350] [Boss]"
				NaemQuestBoss = "MagmaQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-5317.07666, 12.2721891, 8517.41699, 0.51175487, -2.65508806e-08, -0.859131515, -3.91131572e-08, 1, -5.42026761e-08, 0.859131515, 6.13418294e-08, 0.51175487)
				CFrameBoss = CFrame.new(-5530.12646, 22.8769703, 8859.91309, 0.857838571, 2.23414389e-08, 0.513919294, 1.53689133e-08, 1, -6.91265853e-08, -0.513919294, 6.71978384e-08, 0.857838571)
			elseif SelectBoss == "Fishman Lord [Lv. 425] [Boss]" then
				MsBoss = "Fishman Lord [Lv. 425] [Boss]"
				NaemQuestBoss = "FishmanQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(61123.0859, 18.5066795, 1570.18018, 0.927145958, 1.0624845e-07, 0.374700129, -6.98219367e-08, 1, -1.10790765e-07, -0.374700129, 7.65569368e-08, 0.927145958)
				CFrameBoss = CFrame.new(61351.7773, 31.0306778, 1113.31409, 0.999974668, 0, -0.00714713801, 0, 1.00000012, 0, 0.00714714266, 0, 0.999974549)
			elseif SelectBoss == "Wysper [Lv. 500] [Boss]" then
				MsBoss = "Wysper [Lv. 500] [Boss]"
				NaemQuestBoss = "SkyExp1Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-7862.94629, 5545.52832, -379.833954, 0.462944925, 1.45838088e-08, -0.886386991, 1.0534996e-08, 1, 2.19553424e-08, 0.886386991, -1.95022007e-08, 0.462944925)
				CFrameBoss = CFrame.new(-7925.48389, 5550.76074, -636.178345, 0.716468513, -1.22915289e-09, 0.697619379, 3.37381434e-09, 1, -1.70304748e-09, -0.697619379, 3.57381835e-09, 0.716468513)
			elseif SelectBoss == "Thunder God [Lv. 575] [Boss]" then
				MsBoss = "Thunder God [Lv. 575] [Boss]"
				NaemQuestBoss = "SkyExp2Quest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(-7902.78613, 5635.99902, -1411.98706, -0.0361216255, -1.16895912e-07, 0.999347389, 1.44533963e-09, 1, 1.17024491e-07, -0.999347389, 5.6715117e-09, -0.0361216255)
				CFrameBoss = CFrame.new(-7917.53613, 5616.61377, -2277.78564, 0.965189934, 4.80563429e-08, -0.261550069, -6.73089886e-08, 1, -6.46515304e-08, 0.261550069, 8.00056768e-08, 0.965189934)
			elseif SelectBoss == "Cyborg [Lv. 675] [Boss]" then
				MsBoss = "Cyborg [Lv. 675] [Boss]"
				NaemQuestBoss = "FountainQuest"
				LevelQuestBoss = 3
				CFrameQuestBoss = CFrame.new(5253.54834, 38.5361786, 4050.45166, -0.0112687312, -9.93677887e-08, -0.999936521, 2.55291371e-10, 1, -9.93769547e-08, 0.999936521, -1.37512213e-09, -0.0112687312)
				CFrameBoss = CFrame.new(6041.82813, 52.7112198, 3907.45142, -0.563162148, 1.73805248e-09, -0.826346457, -5.94632716e-08, 1, 4.26280238e-08, 0.826346457, 7.31437524e-08, -0.563162148)
			end
		end

		local Boss = {}
		for i, v in pairs(game.ReplicatedStorage:GetChildren()) do
			if string.find(v.Name, "Boss") then
				if v.Name == "Ice Admiral [Lv. 700] [Boss]" then
				else
					table.insert(Boss, v.Name)
				end
			end
		end
		for i, v in pairs(game.workspace.Enemies:GetChildren()) do
			if string.find(v.Name, "Boss") then
				if v.Name == "Ice Admiral [Lv. 700] [Boss]" then
				else
					table.insert(Boss, v.Name)
				end
			end
		end

		local BossName = S9s03I:addDropdown("Select Boss",Boss,function(Value)
			SelectBoss = Value
			Don = false
		end)

		local SelectWeaponBoss = "" 
		local SelectWeaponKillBoss = S9s03I:addDropdown("Select Weapon Kill Boss",Wapon,function(Value)
			SelectToolWeaponBoss = Value
		end)

		function AutoFramBoss()
			CheckQuestBoss()
			if SelectBoss == "Don Swan [Lv. 1000] [Boss]" or SelectBoss == "Cursed Captain [Lv. 1325] [Raid Boss]" or SelectBoss == "Saber Expert [Lv. 200] [Boss]" or SelectBoss == "Mob Leader [Lv. 120] [Boss]" or SelectBoss == "Darkbeard [Lv. 1000] [Raid Boss]" then
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
							repeat
								pcall(function() wait() 
									EquipWeapon(SelectToolWeaponBoss)
									if HideHitBlox then
										v.HumanoidRootPart.Transparency = 1
									else
										v.HumanoidRootPart.Transparency = 0.75
									end
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 17, 5)
									game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
									VirtualUser:CaptureController()
									VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								end)
							until not FramBoss or not v.Parent or v.Humanoid.Health <= 0
						end
					end
				else
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			elseif SelectBoss == "Order [Lv. 1250] [Raid Boss]" then
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
							repeat 
								pcall(function() wait() 
									EquipWeapon(SelectToolWeaponBoss)
									if HideHitBlox then
										v.HumanoidRootPart.Transparency = 1
									else
										v.HumanoidRootPart.Transparency = 0.75
									end
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 25)
									game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
									VirtualUser:CaptureController()
									VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								end)
							until not FramBoss or not v.Parent or v.Humanoid.Health <= 0
						end
					end
				else
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			else
				if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) or game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) then
					if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
						print()
						CheckQuestBoss()
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuestBoss
						wait(1.5)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuestBoss, LevelQuestBoss)
						wait(1)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
					elseif game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == true then
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if FramBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MsBoss then
								repeat
									pcall(function() wait() 
										EquipWeapon(SelectToolWeaponBoss)
										if HideHitBlox then
											v.HumanoidRootPart.Transparency = 1
										else
											v.HumanoidRootPart.Transparency = 0.75
										end
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 17, 5)
										game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
										VirtualUser:CaptureController()
										VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
									end)
								until not FramBoss or not v.Parent or v.Humanoid.Health <= 0 or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false
							end
						end
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
					end
				end
			end
		end

		S9s03I:addToggle("Auto Farm Boss",false,function(Value)
			local args = {
				[1] = "AbandonQuest"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			FramBoss = Value
			MsBoss = ""
			while FramBoss do wait()
				AutoFramBoss()
			end
		end)

		PlayerName = {}
		for i,v in pairs(game.Players:GetChildren()) do  
			table.insert(PlayerName ,v.Name)
		end
		SelectedKillPlayer = ""
		local Player = S9s03II:addDropdown("Selected Player",PlayerName,function(plys) --true/false, replaces the current title "Dropdown" with the option that t
			SelectedKillPlayer = plys
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if KillPlayer then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)

		S9s03II:addToggle("Kill Player",false,function(bool)
			KillPlayer = bool
			if KillPlayer == false then
				game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
				local args = {
					[1] = "Buso"
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

			L9s0:Notify("NOTIFICATION", "Pickup a Weapon")

			while KillPlayer do wait()

				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.CFrame * CFrame.new(0,15,0)
				game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.Size = Vector3.new(60,60,60)
				game:GetService'VirtualUser':CaptureController()
				game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
			end
		end)

		S9s03II:addToggle("Spectate Player",false,function(bool)
			Sp = bool
			local plr1 = game.Players.LocalPlayer.Character.Humanoid
			local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
			repeat wait(.1)
				game.Workspace.Camera.CameraSubject = plr2.Character.Humanoid
			until Sp == false 
			game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		end)

		S9s03II:addButton("Teleport Player",function()
			local plr1 = game.Players.LocalPlayer.Character
			local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
			plr1.HumanoidRootPart.CFrame = plr2.Character.HumanoidRootPart.CFrame
		end)

		S9s0:addToggle("Auto Farm",false,function(vu)
			if SelectToolWeapon == "" and vu then

				L9s0:Notify("NOTIFICATION", "Select Weapon First")

			else
				local args = {
					[1] = "AbandonQuest"
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				AFM = vu
				AFMMain = vu 
			end	
		end)

		function CheckQuest()
			local MyLevel = game.Players.LocalPlayer.Data.Level.Value
			if OldWorld then
				if MyLevel == 1 or MyLevel <= 9 then -- Bandit
					Ms = "Bandit [Lv. 5]"
					NaemQuest = "BanditQuest1"
					LevelQuest = 1
					NameMon = "Bandit"
					CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905, -0.942978859, -3.33851502e-09, 0.332852632, 7.04340497e-09, 1, 2.99841325e-08, -0.332852632, 3.06188177e-08, -0.942978859)
					CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516, -0.929782331, 6.60215846e-08, -0.368109822, 3.9077392e-08, 1, 8.06501603e-08, 0.368109822, 6.06023249e-08, -0.929782331)
				elseif MyLevel == 10 or MyLevel <= 14 then -- Monkey
					Ms = "Monkey [Lv. 14]"
					NaemQuest = "JungleQuest"
					LevelQuest = 1
					NameMon = "Monkey"
					CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
					CFrameMon = CFrame.new(-1402.74609, 98.5633316, 90.6417007, 0.836947978, 0, 0.547282517, -0, 1, -0, -0.547282517, 0, 0.836947978)
				elseif MyLevel == 15 or MyLevel <= 29 then -- Gorilla
					Ms = "Gorilla [Lv. 20]"
					NaemQuest = "JungleQuest"
					LevelQuest = 2
					NameMon = "Gorilla"
					CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)
					CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519, -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)
				elseif MyLevel == 30 or MyLevel <= 39 then -- Pirate
					Ms = "Pirate [Lv. 35]"
					NaemQuest = "BuggyQuest1"
					LevelQuest = 1
					NameMon = "Pirate"
					CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
					CFrameMon = CFrame.new(-1219.32324, 4.75205183, 3915.63452, -0.966492832, -6.91238853e-08, 0.25669381, -5.21195496e-08, 1, 7.3047012e-08, -0.25669381, 5.72206496e-08, -0.966492832)
				elseif MyLevel == 40 or MyLevel <= 59 then -- Brute
					Ms = "Brute [Lv. 45]"
					NaemQuest = "BuggyQuest1"
					LevelQuest = 2
					NameMon = "Brute"
					CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)
					CFrameMon = CFrame.new(-1146.49646, 96.0936813, 4312.1333, -0.978175163, -1.53222057e-08, 0.207781896, -3.33316912e-08, 1, -8.31738873e-08, -0.207781896, -8.82843523e-08, -0.978175163)
				elseif MyLevel == 60 or MyLevel <= 74 then -- Desert Bandit
					Ms = "Desert Bandit [Lv. 60]"
					NaemQuest = "DesertQuest"
					LevelQuest = 1
					NameMon = "Desert Bandit"
					CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
					CFrameMon = CFrame.new(932.788818, 6.4503746, 4488.24609, -0.998625934, 3.08948351e-08, 0.0524050146, 2.79967303e-08, 1, -5.60361286e-08, -0.0524050146, -5.44919629e-08, -0.998625934)
				elseif MyLevel == 75 or MyLevel <= 89 then -- Desert Officre
					Ms = "Desert Officer [Lv. 70]"
					NaemQuest = "DesertQuest"
					LevelQuest = 2
					NameMon = "Desert Officer"
					CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)
					CFrameMon = CFrame.new(1580.03198, 4.61375761, 4366.86426, 0.135744005, -6.44280718e-08, -0.990743816, 4.35738308e-08, 1, -5.90598574e-08, 0.990743816, -3.51534837e-08, 0.135744005)
				elseif MyLevel == 90 or MyLevel <= 99 then -- Snow Bandits
					Ms = "Snow Bandit [Lv. 90]"
					NaemQuest = "SnowQuest"
					LevelQuest = 1
					NameMon = "Snow Bandits"
					CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)
					CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)
				elseif MyLevel == 100 or MyLevel <= 119 then -- Snowman
					Ms = "Snowman [Lv. 100]"
					NaemQuest = "SnowQuest"
					LevelQuest = 2
					NameMon = "Snowman"
					CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)
					CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)
				elseif MyLevel == 120 or MyLevel <= 149 then -- Chief Petty Officer
					Ms = "Chief Petty Officer [Lv. 120]"
					NaemQuest = "MarineQuest2"
					LevelQuest = 1
					NameMon = "Chief Petty Officer"
					CFrameQuest = CFrame.new(-5035.0835, 28.6520386, 4325.29443, 0.0243340395, -7.08064647e-08, 0.999703884, -6.36926814e-08, 1, 7.23777944e-08, -0.999703884, -6.54350671e-08, 0.0243340395)
					CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516, 0.273695946, -5.40380647e-08, -0.96181643, 4.37720793e-08, 1, -4.37274998e-08, 0.96181643, -3.01326679e-08, 0.273695946)
				elseif MyLevel == 150 or MyLevel <= 174 then -- Sky Bandit
					Ms = "Sky Bandit [Lv. 150]"
					NaemQuest = "SkyQuest"
					LevelQuest = 1
					NameMon = "Sky Bandit"
					CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)
					CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353, -0.994874597, -8.61311236e-08, -0.101116329, -9.10836206e-08, 1, 4.43614923e-08, 0.101116329, 5.33441664e-08, -0.994874597)
				elseif MyLevel == 175 or MyLevel <= 224 then -- Dark Master
					Ms = "Dark Master [Lv. 175]"
					NaemQuest = "SkyQuest"
					LevelQuest = 2
					NameMon = "Dark Master"
					CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)
					CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456, -0.925375521, 1.12086873e-08, 0.379051805, -1.05115507e-08, 1, -5.52320891e-08, -0.379051805, -5.50948407e-08, -0.925375521)
				elseif MyLevel == 225 or MyLevel <= 274 then -- Toga Warrior
					Ms = "Toga Warrior [Lv. 225]"
					NaemQuest = "ColosseumQuest"
					LevelQuest = 1
					NameMon = "Toga Warrior"
					CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
					CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474, 0.984437346, 4.10396339e-08, 0.175734788, -3.62286876e-08, 1, -3.05844168e-08, -0.175734788, 2.3741821e-08, 0.984437346)
				elseif MyLevel == 275 or MyLevel <= 299 then -- Gladiato
					Ms = "Gladiator [Lv. 275]"
					NaemQuest = "ColosseumQuest"
					LevelQuest = 2
					NameMon = "Gladiato"
					CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)
					CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309, 0.464524001, 6.21005611e-08, 0.885560572, -4.80449414e-09, 1, -6.76054768e-08, -0.885560572, 2.71497012e-08, 0.464524001)
				elseif MyLevel == 300 or MyLevel <= 329 then -- Military Soldier
					Ms = "Military Soldier [Lv. 300]"
					NaemQuest = "MagmaQuest"
					LevelQuest = 1
					NameMon = "Military Soldier"
					CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
					CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984)
				elseif MyLevel == 300 or MyLevel <= 374 then -- Military Spy
					Ms = "Military Spy [Lv. 330]"
					NaemQuest = "MagmaQuest"
					LevelQuest = 2
					NameMon = "Military Spy"
					CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)
					CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293, -0.188358366, -1.84706277e-08, 0.982100308, -1.23782129e-07, 1, -4.93306951e-09, -0.982100308, -1.22495649e-07, -0.188358366)
				elseif MyLevel == 375 or MyLevel <= 399 then -- Fishman Warrior
					Ms = "Fishman Warrior [Lv. 375]"
					NaemQuest = "FishmanQuest"
					LevelQuest = 1
					NameMon = "Fishman Warrior"
					CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)
					CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.91687, -0.0817126185, 8.90751153e-08, 0.996655822, 2.00889794e-08, 1, -8.77269599e-08, -0.996655822, 1.28533992e-08, -0.0817126185)
				elseif MyLevel == 400 or MyLevel <= 449 then -- Fishman Commando
					Ms = "Fishman Commando [Lv. 400]"
					NaemQuest = "FishmanQuest"
					LevelQuest = 2
					NameMon = "Fishman Commando"
					CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)
					CFrameMon = CFrame.new(61885.5039, 18.4828243, 1504.17896, 0.577502489, 0, -0.816389024, -0, 1.00000012, -0, 0.816389024, 0, 0.577502489)
				elseif MyLevel == 450 or MyLevel <= 474 then -- God's Guards
					Ms = "God's Guard [Lv. 450]"
					NaemQuest = "SkyExp1Quest"
					LevelQuest = 1
					NameMon = "God's Guards"
					CFrameQuest = CFrame.new(-4721.71436, 845.277161, -1954.20105, -0.999277651, -5.56969759e-09, 0.0380011722, -4.14751478e-09, 1, 3.75035256e-08, -0.0380011722, 3.73188307e-08, -0.999277651)
					CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.92542, -0.93441087, -6.77488776e-09, -0.356197298, 1.12145182e-08, 1, -4.84390199e-08, 0.356197298, -4.92565206e-08, -0.93441087)
				elseif MyLevel == 475 or MyLevel <= 524 then -- Shandas
					Ms = "Shanda [Lv. 475]"
					NaemQuest = "SkyExp1Quest"
					LevelQuest = 2
					NameMon = "Shandas"
					CFrameQuest = CFrame.new(-7863.63672, 5545.49316, -379.826324, 0.362120807, -1.98046344e-08, -0.93213129, 4.05822291e-08, 1, -5.48095125e-09, 0.93213129, -3.58431969e-08, 0.362120807)
					CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509, 0.150056243, 1.79768236e-08, -0.988677442, 6.67798661e-09, 1, 1.91962481e-08, 0.988677442, -9.48289181e-09, 0.150056243)
				elseif MyLevel == 525 or MyLevel <= 549 then -- Royal Squad
					Ms = "Royal Squad [Lv. 525]"
					NaemQuest = "SkyExp2Quest"
					LevelQuest = 1
					NameMon = "Royal Squad"
					CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)
					CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729, 0.561947823, 7.69527464e-09, -0.827172697, -4.24974544e-09, 1, 6.41599973e-09, 0.827172697, -9.01838604e-11, 0.561947823)
				elseif MyLevel == 550 or MyLevel <= 624 then -- Royal Soldier
					Ms = "Royal Soldier [Lv. 550]"
					NaemQuest = "SkyExp2Quest"
					LevelQuest = 2
					NameMon = "Royal Soldier"
					CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)
					CFrameMon = CFrame.new(-7864.44775, 5661.94092, -1708.22351, 0.998389959, 2.28686137e-09, -0.0567218624, 1.99431383e-09, 1, 7.54200258e-08, 0.0567218624, -7.54117195e-08, 0.998389959)
				elseif MyLevel == 625 or MyLevel <= 649 then -- Galley Pirate
					Ms = "Galley Pirate [Lv. 625]"
					NaemQuest = "FountainQuest"
					LevelQuest = 1
					NameMon = "Galley Pirate"
					CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)
					CFrameMon = CFrame.new(5595.06982, 41.5013695, 3961.47095, -0.992138803, -2.11610267e-08, -0.125142589, -1.34249509e-08, 1, -6.26613996e-08, 0.125142589, -6.04887518e-08, -0.992138803)
				elseif MyLevel >= 650 then -- Galley Captain
					Ms = "Galley Captain [Lv. 650]"
					NaemQuest = "FountainQuest"
					LevelQuest = 2
					NameMon = "Galley Captain"
					CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)
					CFrameMon = CFrame.new(5658.5752, 38.5361786, 4928.93506, -0.996873081, 2.12391046e-06, -0.0790185928, 2.16989656e-06, 1, -4.96097414e-07, 0.0790185928, -6.66008248e-07, -0.996873081)
				end
			end
			if NewWorld then
				if MyLevel == 700 or MyLevel <= 724 then -- Raider [Lv. 700]
					Ms = "Raider [Lv. 700]"
					NaemQuest = "Area1Quest"
					LevelQuest = 1
					NameMon = "Raider"
					CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
					CFrameMon = CFrame.new(-737.026123, 39.1748352, 2392.57959, 0.272128761, 0, -0.962260842, -0, 1, -0, 0.962260842, 0, 0.272128761)
				elseif MyLevel == 725 or MyLevel <= 774 then -- Mercenary [Lv. 725]
					Ms = "Mercenary [Lv. 725]"
					NaemQuest = "Area1Quest"
					LevelQuest = 2
					NameMon = "Mercenary"
					CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)
					CFrameMon = CFrame.new(-973.731995, 95.8733215, 1836.46936, 0.999135971, 2.02326991e-08, -0.0415605344, -1.90767793e-08, 1, 2.82094952e-08, 0.0415605344, -2.73922804e-08, 0.999135971)
				elseif MyLevel == 775 or MyLevel <= 799 then -- Swan Pirate [Lv. 775]
					Ms = "Swan Pirate [Lv. 775]"
					NaemQuest = "Area2Quest"
					LevelQuest = 1
					NameMon = "Swan Pirate"
					CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
					CFrameMon = CFrame.new(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468)
				elseif MyLevel == 800 or MyLevel <= 874 then -- Factory Staff [Lv. 800]
					Ms = "Factory Staff [Lv. 800]"
					NaemQuest = "Area2Quest"
					LevelQuest = 2
					NameMon = "Factory Staff"
					CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
					CFrameMon = CFrame.new(296.786499, 72.9948196, -57.1298141, -0.876037002, -5.32364979e-08, 0.482243896, -3.87658332e-08, 1, 3.99718729e-08, -0.482243896, 1.63222538e-08, -0.876037002)
				elseif MyLevel == 875 or MyLevel <= 899 then -- Marine Lieutenant [Lv. 875]
					Ms = "Marine Lieutenant [Lv. 875]"
					NaemQuest = "MarineQuest3"
					LevelQuest = 1
					NameMon = "Marine Lieutenant"
					CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
					CFrameMon = CFrame.new(-2913.26367, 73.0011826, -2971.64282, 0.910507619, 0, 0.413492233, 0, 1.00000012, 0, -0.413492233, 0, 0.910507619)
				elseif MyLevel == 900 or MyLevel <= 949 then -- Marine Captain [Lv. 900]
					Ms = "Marine Captain [Lv. 900]"
					NaemQuest = "MarineQuest3"
					LevelQuest = 2
					NameMon = "Marine Captain"
					CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)
					CFrameMon = CFrame.new(-1868.67688, 73.0011826, -3321.66333, -0.971402287, 1.06502087e-08, 0.237439692, 3.68856199e-08, 1, 1.06050372e-07, -0.237439692, 1.11775684e-07, -0.971402287)
				elseif MyLevel == 950 or MyLevel <= 974 then -- Zombie [Lv. 950]
					Ms = "Zombie [Lv. 950]"
					NaemQuest = "ZombieQuest"
					LevelQuest = 1
					NameMon = "Zombie"
					CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)
					CFrameMon = CFrame.new(-5634.83838, 126.067039, -697.665039, -0.992770672, 6.77618939e-09, 0.120025545, 1.65461245e-08, 1, 8.04023372e-08, -0.120025545, 8.18070234e-08, -0.992770672)
				elseif MyLevel == 975 or MyLevel <= 999 then -- Vampire [Lv. 975]
					Ms = "Vampire [Lv. 975]"
					NaemQuest = "ZombieQuest"
					LevelQuest = 2
					NameMon = "Vampire"
					CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)
					CFrameMon = CFrame.new(-6030.32031, 6.4377408, -1313.5564, -0.856965423, 3.9138893e-08, -0.515373945, -1.12178942e-08, 1, 9.45958547e-08, 0.515373945, 8.68467822e-08, -0.856965423)
				elseif MyLevel == 1000 or MyLevel <= 1049 then -- Snow Trooper [Lv. 1000] **
					Ms = "Snow Trooper [Lv. 1000]"
					NaemQuest = "SnowMountainQuest"
					LevelQuest = 1
					NameMon = "Snow Trooper"
					CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)
					CFrameMon = CFrame.new(535.893433, 401.457062, -5329.6958, -0.999524176, 0, 0.0308452044, 0, 1, -0, -0.0308452044, 0, -0.999524176)
				elseif MyLevel == 1050 or MyLevel <= 1099 then -- Winter Warrior [Lv. 1050]
					Ms = "Winter Warrior [Lv. 1050]"
					NaemQuest = "SnowMountainQuest"
					LevelQuest = 2
					NameMon = "Winter Warrior"
					CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)
					CFrameMon = CFrame.new(1223.7417, 454.575226, -5170.02148, 0.473996818, 2.56845354e-08, 0.880526543, -5.62456428e-08, 1, 1.10811016e-09, -0.880526543, -5.00510211e-08, 0.473996818)
				elseif MyLevel == 1100 or MyLevel <= 1124 then -- Lab Subordinate [Lv. 1100]
					Ms = "Lab Subordinate [Lv. 1100]"
					NaemQuest = "IceSideQuest"
					LevelQuest = 1
					NameMon = "Lab Subordinate"
					CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)
					CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721, -0.569419742, -2.49055017e-08, 0.822046936, -6.96206541e-08, 1, -1.79282633e-08, -0.822046936, -6.74401548e-08, -0.569419742)
				elseif MyLevel == 1125 or MyLevel <= 1174 then -- Horned Warrior [Lv. 1125]
					Ms = "Horned Warrior [Lv. 1125]"
					NaemQuest = "IceSideQuest"
					LevelQuest = 2
					NameMon = "Horned Warrior"
					CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)
					CFrameMon = CFrame.new(-6400.85889, 24.7645149, -5818.63574, -0.964845479, 8.65926566e-08, -0.262817472, 3.98261392e-07, 1, -1.13260398e-06, 0.262817472, -1.19745812e-06, -0.964845479)
				elseif MyLevel == 1175 or MyLevel <= 1199 then -- Magma Ninja [Lv. 1175]
					Ms = "Magma Ninja [Lv. 1175]"
					NaemQuest = "FireSideQuest"
					LevelQuest = 1
					NameMon = "Magma Ninja"
					CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)
					CFrameMon = CFrame.new(-5496.65576, 58.6890411, -5929.76855, -0.885073781, 0, -0.465450764, 0, 1.00000012, -0, 0.465450764, 0, -0.885073781)
				elseif MyLevel == 1200 or MyLevel <= 1249 then -- Lava Pirate [Lv. 1200]
					Ms = "Lava Pirate [Lv. 1200]"
					NaemQuest = "FireSideQuest"
					LevelQuest = 2
					NameMon = "Lava Pirate"
					CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)
					CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633, -0.196780294, 0, 0.98044765, 0, 1.00000012, -0, -0.98044765, 0, -0.196780294)
				elseif MyLevel == 1250 or MyLevel <= 1274 then -- Ship Deckhand [Lv. 1250]
					Ms = "Ship Deckhand [Lv. 1250]"
					NaemQuest = "ShipQuest1"
					LevelQuest = 1
					NameMon = "Ship Deckhand"
					CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)
					CFrameMon = CFrame.new(1163.80872, 138.288452, 33058.4258, -0.998580813, 5.49076979e-08, -0.0532564968, 5.57436763e-08, 1, -1.42118655e-08, 0.0532564968, -1.71604082e-08, -0.998580813)
				elseif MyLevel == 1275 or MyLevel <= 1299 then -- Ship Engineer [Lv. 1275]
					Ms = "Ship Engineer [Lv. 1275]"
					NaemQuest = "ShipQuest1"
					LevelQuest = 2
					NameMon = "Ship Engineer"
					CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)
					CFrameMon = CFrame.new(916.666504, 44.0920448, 32917.207, -0.99746871, -4.85034697e-08, -0.0711069331, -4.8925461e-08, 1, 4.19294288e-09, 0.0711069331, 7.66126895e-09, -0.99746871)
				elseif MyLevel == 1300 or MyLevel <= 1324 then -- Ship Steward [Lv. 1300]
					Ms = "Ship Steward [Lv. 1300]"
					NaemQuest = "ShipQuest2"
					LevelQuest = 1
					NameMon = "Ship Steward"
					CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
					CFrameMon = CFrame.new(918.743286, 129.591064, 33443.4609, -0.999792814, -1.7070947e-07, -0.020350717, -1.72559169e-07, 1, 8.91351277e-08, 0.020350717, 9.2628369e-08, -0.999792814)
				elseif MyLevel == 1325 or MyLevel <= 1349 then -- Ship Officer [Lv. 1325]
					Ms = "Ship Officer [Lv. 1325]"
					NaemQuest = "ShipQuest2"
					LevelQuest = 2
					NameMon = "Ship Officer"
					CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)
					CFrameMon = CFrame.new(786.051941, 181.474106, 33303.2969, 0.999285698, -5.32193063e-08, 0.0377905183, 5.68968588e-08, 1, -9.62386864e-08, -0.0377905183, 9.83201005e-08, 0.999285698)
				elseif MyLevel == 1350 or MyLevel <= 1374 then -- Arctic Warrior [Lv. 1350]
					Ms = "Arctic Warrior [Lv. 1350]"
					NaemQuest = "FrostQuest"
					LevelQuest = 1
					NameMon = "Arctic Warrior"
					CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)
					CFrameMon = CFrame.new(5995.07471, 57.3188477, -6183.47314, 0.702747107, -1.53454167e-07, -0.711440146, -1.08168464e-07, 1, -3.22542007e-07, 0.711440146, 3.03620908e-07, 0.702747107)
				elseif MyLevel == 1375 or MyLevel <= 1424 then -- Snow Lurker [Lv. 1375]
					Ms = "Snow Lurker [Lv. 1375]"
					NaemQuest = "FrostQuest"
					LevelQuest = 2
					NameMon = "Snow Lurker"
					CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)
					CFrameMon = CFrame.new(5518.00684, 60.5559731, -6828.80518, -0.650781393, -3.64292951e-08, 0.759265184, -4.07668654e-09, 1, 4.44854642e-08, -0.759265184, 2.58550248e-08, -0.650781393)
				elseif MyLevel == 1425 or MyLevel <= 1449 then -- Sea Soldier [Lv. 1425]
					Ms = "Sea Soldier [Lv. 1425]"
					NaemQuest = "ForgottenQuest"
					LevelQuest = 1
					NameMon = "Sea Soldier"
					CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)
					CFrameMon = CFrame.new(-3029.78467, 66.944252, -9777.38184, -0.998552859, 1.09555076e-08, 0.0537791774, 7.79564235e-09, 1, -5.89660658e-08, -0.0537791774, -5.84614881e-08, -0.998552859)
				elseif MyLevel >= 1450 then -- Water Fighter [Lv. 1450]
					Ms = "Water Fighter [Lv. 1450]"
					NaemQuest = "ForgottenQuest"
					LevelQuest = 2
					NameMon = "Water Fighter"
					CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)
					CFrameMon = CFrame.new(-3262.00098, 298.699615, -10553.6943, -0.233570755, -4.57538185e-08, 0.972339869, -5.80986068e-08, 1, 3.30992194e-08, -0.972339869, -4.87605725e-08, -0.233570755)
				end
			end
		end
		CheckQuest()

		spawn(function()
			while wait() do
				if AFM then
					autofarm()
				end
			end
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if AFM or Observation or AutoNew or Factory or Superhuman or DeathStep or Mastery or GunMastery or FramBoss or FramAllBoss or AutoBartilo or AutoNear or AutoRengoku or AutoSharkman or AutoFramEctoplasm then
				if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
				end
			end
		end
		)

		local LocalPlayer = game:GetService("Players").LocalPlayer
		local VirtualUser = game:GetService('VirtualUser')
		function autofarm()
			if AFM then
				if LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					StatrMagnet = false
					CheckQuest()
					print()
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
					wait(1.1)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuest, LevelQuest)
				elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
					CheckQuest()
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
					if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
						pcall(
							function()
								for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									CheckQuest()  
									if v.Name == Ms then
										repeat wait()
											EquipWeapon(SelectToolWeapon)
											if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
												if string.find(LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
													if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
														local args = {
															[1] = "Buso"
														}
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
													end
													game:GetService'VirtualUser':CaptureController()
													game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
													game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
													if HideHitBlox then
														v.HumanoidRootPart.Transparency = 1
													else
														v.HumanoidRootPart.Transparency = 0.75
													end
													v.HumanoidRootPart.CanCollide = false
													v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
													if Magnet then 
														if setsimulationradius then 
															setsimulationradius(1e+1598, 1e+1599)
														end
														PosMon = v.HumanoidRootPart.CFrame
														StatrMagnet = true
													end
													v.HumanoidRootPart.CanCollide = false
												else
													StatrMagnet = false
													CheckQuest()
													print()
													LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
													wait(1.5)
													game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NaemQuest, LevelQuest)
												end  
											else
												CheckQuest() 
												game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
											end 
										until not v.Parent or v.Humanoid.Health <= 0 or AFM == false or LocalPlayer.PlayerGui.Main.Quest.Visible == false
										StatrMagnet = false
										CheckQuest() 
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
									end
								end
							end
						)
					else
						CheckQuest()
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
					end 
				end
			end
		end

		SelectToolWeapon = ""
		function EquipWeapon(ToolSe)
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				wait(.4)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
			end
		end

		local SelectWeapona = S9s0:addDropdown("Select Weapon First",Wapon,function(Value)
			SelectToolWeapon = Value
			SelectToolWeaponOld = Value
		end)

		S9s0:addToggle("Auto Factory",false,function(vu)
			Factory = vu
			while Factory do wait()
				if game.Workspace.Enemies:FindFirstChild("Core") then
					Core = true
					AFM = false
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if Core and v.Name == "Core" and v.Humanoid.Health > 0 then
							repeat wait(.1)
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
								EquipWeapon(SelectToolWeapon)
								game:GetService'VirtualUser':CaptureController()
								game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
							until not Core or v.Humanoid.Health <= 0  or Factory == false
						end
					end
				elseif game.ReplicatedStorage:FindFirstChild("Core") then
					Core = true
					AFM = false
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
				elseif AFMMain then
					Core = false
					AFM = true
				end
			end
		end)

		S9s0:addToggle("Auto SuperHuman",false,function(vu)
			Superhuman = vu
			while Superhuman do wait()
				if Superhuman then
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
						local args = {
							[1] = "BuyBlackLeg"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end   
					if game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") then
						SelectToolWeapon = "Superhuman"
					end  
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") or game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value <= 299 then
							SelectToolWeapon = "Black Leg"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value <= 299 then
							SelectToolWeapon = "Electro"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value <= 299 then
							SelectToolWeapon = "Fishman Karate"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value <= 299 then
							SelectToolWeapon = "Dragon Claw"
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 then
							local args = {
								[1] = "BuyElectro"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 then
							local args = {
								[1] = "BuyElectro"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 then
							local args = {
								[1] = "BuyFishmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 then
							local args = {
								[1] = "BuyFishmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300 then
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "1"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300 then
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "1"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
						end
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 then
							local args = {
								[1] = "BuySuperhuman"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
						if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 then
							local args = {
								[1] = "BuySuperhuman"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end 
					end
				end
			end
		end)

		S9s0:addToggle("Auto Buy Legendary Sword",false,function(Value)
			LegebdarySword = Value    
			while LegebdarySword do wait()
				if LegebdarySword then
					local args = {
						[1] = "LegendarySwordDealer",
						[2] = "2"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				end 
			end
		end)

		WaponAccessories = {}
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
			if v:IsA("Tool") then 
				if v.ToolTip == "Wear" then    
					table.insert(WaponAccessories, v.Name)
				end
			end
		end
		SelectTooAccessories = ""
		S9s0:addToggle("Auto Accessories",false,function(Value)

			if SelectTooAccessories == "" and Value then

				L9s0:Notify("NOTIFICATION", "Select Weapon First")
			else
				AutoAccessories = Value 
			end
		end)

		spawn(function()
			while wait() do
				if AutoAccessories then
					CheckAccessories = game.Players.LocalPlayer.Character 
					if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
						if CheckAccessories:FindFirstChild("CoolShades") or CheckAccessories:FindFirstChild("BlackSpikeyCape") or CheckAccessories:FindFirstChild("BlueSpikeyCape") or CheckAccessories:FindFirstChild("RedSpikeyCape") or CheckAccessories:FindFirstChild("Chopper") or CheckAccessories:FindFirstChild("MarineCape") or CheckAccessories:FindFirstChild("GhoulMask") or CheckAccessories:FindFirstChild("MarineCap") or CheckAccessories:FindFirstChild("PinkCape") or CheckAccessories:FindFirstChild("SaboTopHat") or CheckAccessories:FindFirstChild("SwanGlasses") or CheckAccessories:FindFirstChild("UsoapHat") or CheckAccessories:FindFirstChild("Corrida") or CheckAccessories:FindFirstChild("ZebraCap") or CheckAccessories:FindFirstChild("TomoeRing") or CheckAccessories:FindFirstChild("BlackCape") or CheckAccessories:FindFirstChild("SwordsmanHat") or CheckAccessories:FindFirstChild("SantaHat") or CheckAccessories:FindFirstChild("ElfHat") or CheckAccessories:FindFirstChild("DarkCoat") then
						else
							EquipWeapon(SelectTooAccessories)
							wait(0.1)
							game:GetService'VirtualUser':CaptureController()
							game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
							wait(0.1)
							if game.Players.LocalPlayer.Character:FindFirstChild(SelectTooAccessories) then
								game.Players.LocalPlayer.Character:FindFirstChild(SelectTooAccessories).Parent = game.Players.LocalPlayer:FindFirstChild("Backpack")
							end
							wait(1)
						end
					end
				end
			end
		end)

		local SelectAccessories = S9s0:addDropdown("Select Accesories ",WaponAccessories,function(Value)
			SelectTooAccessories = Value
		end)

		function isnil(thing)
			return (thing == nil)
		end
		local function round(n)
			return math.floor(tonumber(n) + 0.5)
		end
		Number = math.random(1, 1000000)
		Distance = 500

		spawn(function()
			while wait(.1) do
				if NextIsland then
					game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
					if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
						if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame*CFrame.new(0,40,0)
						elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame*CFrame.new(0,40,0)
						elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame*CFrame.new(0,40,0)
						elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame*CFrame.new(0,40,0)
						elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame*CFrame.new(0,40,0)
						end
					else
						game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6438.73535, 250.645355, -4501.50684)
					end 
				end
			end
		end)

		S9s03IIII:addToggle("Auto Raid Flame",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Flame"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value

		end)
		S9s03IIII:addToggle("Auto Raid Ice",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Ice"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)
		S9s03IIII:addToggle("Auto Raid Quake",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Quake"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)
		S9s03IIII:addToggle("Auto Raid Light",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Light"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)
		S9s03IIII:addToggle("Auto Raid Dark",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Dark"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)
		S9s03IIII:addToggle("Auto Raid String",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "String"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)
		S9s03IIII:addToggle("Auto Raid Rumble",false,function(value)
			local A_1 = "RaidsNpc"
			local A_2 = "Select"
			local A_3 = "Rumble"
			local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
			Event:InvokeServer(A_1, A_2, A_3)
			wait(1)
			fireclickdetector(game.Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)

			if NewWorld then
				NextIsland = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			RaidsArua = value
		end)

		S9s0:addButton("Dungeon",function()
			if NewWorld then
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6438.73535, 250.645355, -4501.50684)
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)

		S9s0:addToggle("Auto Awakener",false,function(value)
			if NewWorld then
				Awakener = value
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)

		S9s0:addButton("Awakening Room",function()
			if NewWorld then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(266.227783, 1.39509034, 1857.00732)
			elseif OldWorld then
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)
		spawn(function()
			while wait(.1) do
				if Awakener then
					local args = {
						[1] = "Awakener",
						[2] = "Check"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					local args = {
						[1] = "Awakener",
						[2] = "Awaken"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				end
			end
		end)

		spawn(function()
			while wait(.1) do
				if RaidsArua then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if RaidsArua and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 500 then
							pcall(function()
								repeat wait(.1)
									if setsimulationradius then
										setsimulationradius(1e+1598, 1e+1599)
									end
									v.HumanoidRootPart.Transparency = 0.75
									v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.Health = 0
								until not RaidsArua or not v.Parent or v.Humanoid.Health <= 0
							end)
						end
					end
				end
			end
		end)

		local args = {
			[1] = "getInventoryWeapons"
		}
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		for i,v in pairs(game.Players.LocalPlayer.PlayerGui.Main.Inventory.Container:GetDescendants()) do
			if v.Name == "Ghoul Mask" then
				AssGhoulMask = true
			end
			if v.Name == "Midnight Blade" then
				AssMidnightBlade = true
			end
			if v.Name == "Bizarre Rifle" then
				AssBizarreRifle = true
			end
		end

		S9s03III:addToggle("Auto Fram Ectoplasm",false,function(A)
			if NewWorld then
				AutoFramEctoplasm = A
			else
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
			while AutoFramEctoplasm do wait()
				if AutoFramEctoplasm then
					if game.Workspace.Enemies:FindFirstChild("Ship Deckhand [Lv. 1250]") or game.Workspace.Enemies:FindFirstChild("Ship Engineer [Lv. 1275]") or game.Workspace.Enemies:FindFirstChild("Ship Steward [Lv. 1300]") or game.Workspace.Enemies:FindFirstChild("Ship Officer [Lv. 1325]") then
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if string.find(v.Name, "Ship") then
								repeat wait()
									if string.find(v.Name, "Ship") then
										if setsimulationradius then 
											setsimulationradius(1e+1598, 1e+1599)
										end
										EquipWeapon(EctoplasmWeaponSelect)
										game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
										VirtualUser:CaptureController()
										VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
										-- µÕàÍ§
										PosMonEctoplasm = v.HumanoidRootPart.CFrame
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
										StatrMagnetEctoplasm = true
									else
										StatrMagnetEctoplasm = false
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(920.14447, 129.581833, 33442.168, -0.999913812, 0, -0.0131403487, 0, 1, 0, 0.0131403487, 0, -0.999913812)
									end
								until game.Players.LocalPlayer.Backpack:FindFirstChild("Hidden Key") or AutoFramEctoplasm == false or not v.Parent or v.Humanoid.Health <= 0
								StatrMagnetEctoplasm = false
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(920.14447, 129.581833, 33442.168, -0.999913812, 0, -0.0131403487, 0, 1, 0, 0.0131403487, 0, -0.999913812)
							end
						end
					else
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(902.059143, 124.752518, 33071.8125)
					end
				end
			end
		end)

		local EctoplasmWeapon = S9s03III:addDropdown("Select Weapon",Wapon,function(Value)
			EctoplasmWeaponSelect = Value
		end)

		S9s03III:addToggle("Auto Buy Bizarre Rifle",false,function(A)
			if NewWorld then
				AutoBuyBizarreRifle = A
				while AutoBuyBizarreRifle do wait()
					if AssBizarreRifle then
					else
						local args = {
							[1] = "Ectoplasm",
							[2] = "Buy",
							[3] = 1
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			else
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)
		S9s03III:addToggle("Auto Buy Ghoul Mask",false,function(A)
			if NewWorld then
				AutoBuyGhoulMask = A
				while AutoBuyGhoulMask do wait()
					if AssGhoulMask then

					else
						local args = {
							[1] = "Ectoplasm",
							[2] = "Buy",
							[3] = 2
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			else
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)
		S9s03III:addToggle("Auto Buy Midnight Blade",false,function(A)
			if NewWorld then
				AutoBuyMidnightBlade = A
				while AutoBuyMidnightBlade do wait()
					if AssMidnightBlade then

					else
						local args = {
							[1] = "Ectoplasm",
							[2] = "Buy",
							[3] = 3
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			else
				L9s0:Notify("NOTIFICATION", "Only New World")
			end
		end)

		spawn(function()
			while wait() do
				if AFM and StatrMagnet and Magnet then
					CheckQuest()
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if v.Name == "Factory Staff [Lv. 800]" and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 200 then
								wait()
								if HideHitBlox then
									v.HumanoidRootPart.Transparency = 1
								else
									v.HumanoidRootPart.Transparency = 0.75
								end
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								v.HumanoidRootPart.CFrame = PosMon
							elseif v.Name == Ms and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 400 then
								wait()
								if HideHitBlox then
									v.HumanoidRootPart.Transparency = 1
								else
									v.HumanoidRootPart.Transparency = 0.75
								end
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
								v.HumanoidRootPart.CFrame = PosMon
							end
						end
					end
				end
				if AutoFramEctoplasm and StatrMagnetEctoplasm and Magnet then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if string.find(v.Name, "Ship") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
								if HideHitBlox then
									v.HumanoidRootPart.Transparency = 1
								else
									v.HumanoidRootPart.Transparency = 0.75
								end
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								v.HumanoidRootPart.CFrame = PosMonEctoplasm
							end
						end
					end
				end
			end
		end)

		melee = false
		S9s01:addToggle("Melee",false,function(Value)
			melee = Value  
		end)
		defense = false
		S9s01:addToggle("Defense",false,function(Value)
			defense = Value
		end)
		sword = false
		S9s01:addToggle("Sword",false,function(Value)
			sword = Value
		end)
		gun = false
		S9s01:addToggle("Gun",false,function(Value)
			gun = Value
		end)
		demonfruit = false
		S9s01:addToggle("Devil Fruit",false,function(Value)
			demonfruit = Value
		end)
		PointStats = 1
		S9s01:addSlider("Point ",1,1,10,PointStats,function(a)
			PointStats = a
		end)

		spawn(function()
			while wait() do
				if game.Players.localPlayer.Data.Points.Value >= PointStats then
					if melee then
						local args = {
							[1] = "AddPoint",
							[2] = "Melee",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if defense then
						local args = {
							[1] = "AddPoint",
							[2] = "Defense",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if sword then
						local args = {
							[1] = "AddPoint",
							[2] = "Sword",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if gun then
						local args = {
							[1] = "AddPoint",
							[2] = "Gun",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end 
					if demonfruit then
						local args = {
							[1] = "AddPoint",
							[2] = "Demon Fruit",
							[3] = PointStats
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			end
		end)

		S9s02:addToggle("Ctrl + Click = TP ",false,function(vu)
			CTRL = vu
		end)

		local Plr = game:GetService("Players").LocalPlayer
		local Mouse = Plr:GetMouse()
		Mouse.Button1Down:connect(
			function()
				if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
					return
				end
				if not Mouse.Target then
					return
				end
				if CTRL then
					Plr.Character:MoveTo(Mouse.Hit.p)
				end
			end)

		S9s02:addButton("Current Quest",function()
			CheckQuest()
			wait(0.25)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
		end)

		if game.PlaceId == 2753915549 then

			S9s02:addButton("Teleport to New World",function()
				local args = {
					[1] = "TravelMain" -- OLD WORLD to NEW WORLD
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)

			S9s02:addButton("Start Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1071.2832, 16.3085976, 1426.86792)
			end)
			S9s02:addButton("Marine Start",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2573.3374, 6.88881969, 2046.99817)
			end)
			S9s02:addButton("Middle Town",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-655.824158, 7.88708115, 1436.67908)
			end)
			S9s02:addButton("Jungle",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1249.77222, 11.8870859, 341.356476)
			end)
			S9s02:addButton("Pirate Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1122.34998, 4.78708982, 3855.91992)
			end)
			S9s02:addButton("Desert",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1094.14587, 6.47350502, 4192.88721)
			end)
			S9s02:addButton("Frozen Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1198.00928, 27.0074959, -1211.73376)
			end)
			S9s02:addButton("MarineFord",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4505.375, 20.687294, 4260.55908)
			end)
			S9s02:addButton("Colosseum",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1428.35474, 7.38933945, -3014.37305)
			end)
			S9s02:addButton("Sky 1st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4970.21875, 717.707275, -2622.35449)
			end)
			S9s02:addButton("Sky 2st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4813.0249, 903.708557, -1912.69055)
			end)
			S9s02:addButton("Sky 3st Floor",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7952.31006, 5545.52832, -320.704956)
			end)
			S9s02:addButton("Prison",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4854.16455, 5.68742752, 740.194641)
			end)
			S9s02:addButton("Magma Village",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5231.75879, 8.61593437, 8467.87695)
			end)
			S9s02:addButton("UndeyWater City",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(61163.8516, 11.7796879, 1819.78418)
			end)
			S9s02:addButton("Fountain City",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5132.7124, 4.53632832, 4037.8562)
			end)
			S9s02:addButton("House Cyborg's",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6262.72559, 71.3003616, 3998.23047)
			end)
			S9s02:addButton("Shank's Room",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1442.16553, 29.8788261, -28.3547478)
			end)
			S9s02:addButton("Mob Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2850.20068, 7.39224768, 5354.99268)
			end)
		end

		if game.PlaceId == 4442272183 then

			S9s02:addButton("Teleport to Old World",function()
				local args = {
					[1] = "TravelDressrosa" -- NEW WORLD to OLD WORLD
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)

			S9s02:addButton("Teleport to SeaBeatsts",function()
				for i,v in pairs(game.Workspace.SeaBeasts:GetChildren()) do
					if v:FindFirstChild("HumanoidRootPart") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,100,0)
					end
				end
			end)

			S9s02:addButton("First Spot",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(82.9490662, 18.0710983, 2834.98779)
			end)

			S9s02:addButton("Kingdom of Rose",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["_WorldOrigin"].Locations["Kingdom of Rose"].CFrame
			end)

			S9s02:addButton("Dark Areas",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["_WorldOrigin"].Locations["Dark Arena"].CFrame
			end)

			S9s02:addButton("Flamingo Mansion",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-390.096313, 331.886475, 673.464966)
			end)

			S9s02:addButton("Flamingo Room",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2302.19019, 15.1778421, 663.811035)
			end)

			S9s02:addButton("Green bit",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2372.14697, 72.9919434, -3166.51416)
			end)

			S9s02:addButton("Cafe",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385.250916, 73.0458984, 297.388397)
			end)

			S9s02:addButton("Factory",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(430.42569, 210.019623, -432.504791)
			end)

			S9s02:addButton("Colosseum",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.58191, 44.5890656, 1360.30652)
			end)

			S9s02:addButton("Ghost Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5571.84424, 195.182297, -795.432922)
			end)

			S9s02:addButton("Ghost Island 2nd",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5931.77979, 5.19706631, -1189.6908)
			end)

			S9s02:addButton("Snow Mountain",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1384.68298, 453.569031, -4990.09766)
			end)

			S9s02:addButton("Hot and Cold",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6026.96484, 14.7461271, -5071.96338)
			end)

			S9s02:addButton("Magma Side",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5478.39209, 15.9775667, -5246.9126)
			end)

			S9s02:addButton("Cursed Ship",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(902.059143, 124.752518, 33071.8125)
			end)

			S9s02:addButton("Frosted Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5400.40381, 28.21698, -6236.99219)
			end)

			S9s02:addButton("Forgotten Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3043.31543, 238.881271, -10191.5791)
			end)

			S9s02:addButton("Usoopp Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4748.78857, 8.35370827, 2849.57959)
			end)

			S9s02:addButton("Raids Low",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5554.95313, 329.075623, -5930.31396)
			end)

			S9s02:addButton("Minisky Island",function()
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-260.358917, 49325.7031, -35259.3008)
			end)
		end
		function isnil(thing)
			return (thing == nil)
		end
		local function round(n)
			return math.floor(tonumber(n) + 0.5)
		end
		Number = math.random(1, 1000000)
		function UpdatePlayerChams()
			for i,v in pairs(game:GetService'Players':GetChildren()) do
				pcall(function()
					if not isnil(v.Character) then
						if ESPPlayer then
							if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v.Character.Head)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v.Character.Head
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								if v.Team == game.Players.LocalPlayer.Team then
									name.TextColor3 = Color3.new(0.196078, 0.196078, 0.196078)
								else
									name.TextColor3 = Color3.new(1, 0.333333, 0.498039)
								end
							else
								v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
							end
						else
							if v.Character.Head:FindFirstChild('NameEsp'..Number) then
								v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end
				end)
			end
		end
		function UpdateChestChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if string.find(v.Name,"Chest") then
						if ChestESP then
							if string.find(v.Name,"Chest") then
								if not v:FindFirstChild('NameEsp'..Number) then
									local bill = Instance.new('BillboardGui',v)
									bill.Name = 'NameEsp'..Number
									bill.ExtentsOffset = Vector3.new(0, 1, 0)
									bill.Size = UDim2.new(1,200,1,30)
									bill.Adornee = v
									bill.AlwaysOnTop = true
									local name = Instance.new('TextLabel',bill)
									name.Font = "SourceSansBold"
									name.FontSize = "Size14"
									name.TextWrapped = true
									name.Size = UDim2.new(1,0,1,0)
									name.TextYAlignment = 'Top'
									name.BackgroundTransparency = 1
									name.TextStrokeTransparency = 0.5
									if v.Name == "Chest1" then
										name.TextColor3 = Color3.fromRGB(109, 109, 109)
										name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
									if v.Name == "Chest2" then
										name.TextColor3 = Color3.fromRGB(173, 158, 21)
										name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
									if v.Name == "Chest3" then
										name.TextColor3 = Color3.fromRGB(85, 255, 255)
										name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									end
								else
									v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
								end
							end
						else
							if v:FindFirstChild('NameEsp'..Number) then
								v:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end
				end)
			end
		end
		function UpdateDevilChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if DevilFruitESP then
						if string.find(v.Name, "Fruit") then   
							if not v.Handle:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v.Handle)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v.Handle
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								name.TextColor3 = Color3.fromRGB(255, 0, 0)
								name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
							else
								v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
							end
						end
					else
						if v.Handle:FindFirstChild('NameEsp'..Number) then
							v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
						end
					end
				end)
			end
		end
		function UpdateFlowerChams() 
			for i,v in pairs(game.Workspace:GetChildren()) do
				pcall(function()
					if v.Name == "Flower2" or v.Name == "Flower1" then
						if FlowerESP then 
							if not v:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								name.TextColor3 = Color3.fromRGB(255, 0, 0)
								if v.Name == "Flower1" then 
									name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									name.TextColor3 = Color3.fromRGB(0, 0, 255)
								end
								if v.Name == "Flower2" then
									name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
									name.TextColor3 = Color3.fromRGB(255, 0, 0)
								end
							else
								v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
							end
						else
							if v:FindFirstChild('NameEsp'..Number) then
								v:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end   
				end)
			end
		end

		S9s03:addToggle("Esp Player ",false,function(a)
			ESPPlayer = a
			while ESPPlayer do wait()
				UpdatePlayerChams()
			end
		end)

		S9s03:addToggle("Esp Chest ",false,function(a)
			ChestESP = a
			while ChestESP do wait()
				UpdateChestChams() 
			end
		end)

		S9s03:addToggle("Esp Devil Fruit ",false,function(a)
			DevilFruitESP = a
			while DevilFruitESP do wait()
				UpdateDevilChams() 
			end
		end)

		if game.PlaceId == 4442272183 then

			S9s03:addToggle("Esp Flower ",false,function(a)
				FlowerESP = a
				while FlowerESP do wait()
					UpdateFlowerChams() 
				end
			end)
		end

		S9s03:addButton("Join Team Pirate",function()
			local args = {
				[1] = "SetTeam",
				[2] = "Pirates"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
			local args = {
				[1] = "BartiloQuestProgress"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s03:addButton("Join Team Marine",function()
			local args = {
				[1] = "SetTeam",
				[2] = "Marines"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BartiloQuestProgress"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "Buso"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		local LocalPlayer = game:GetService'Players'.LocalPlayer
		local originalstam = LocalPlayer.Character.Energy.Value
		function infinitestam()
			LocalPlayer.Character.Energy.Changed:connect(function()
				if InfinitsEnergy then
					LocalPlayer.Character.Energy.Value = originalstam
				end 
			end)
		end
		spawn(function()
			while wait(.1) do
				if InfinitsEnergy then
					wait(0.3)
					originalstam = LocalPlayer.Character.Energy.Value
					infinitestam()
				end
			end
		end)
		nododgecool = false
		function NoDodgeCool()
			if nododgecool then
				for i,v in next, getgc() do
					if game.Players.LocalPlayer.Character.Dodge then
						if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
							for i2,v2 in next, getupvalues(v) do
								if tostring(v2) == "0.4" then
									repeat wait(.1)
										setupvalue(v,i2,0)
									until not nododgecool
								end
							end
						end
					end
				end
			end
		end

		S9s04:addToggle("Dodge No Cooldown",false,function(Value)
			nododgecool = Value
			NoDodgeCool()
		end)

		S9s04:addToggle("infinitiy Energy",false,function(value)

			InfinitsEnergy = value
			originalstam = LocalPlayer.Character.Energy.Value

		end)

		Fly = false
		function activatefly()
			local mouse=game.Players.LocalPlayer:GetMouse''
			localplayer=game.Players.LocalPlayer
			game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			local torso = game.Players.LocalPlayer.Character.HumanoidRootPart
			local speedSET=25
			local keys={a=false,d=false,w=false,s=false}
			local e1
			local e2
			local function start()
				local pos = Instance.new("BodyPosition",torso)
				local gyro = Instance.new("BodyGyro",torso)
				pos.Name="EPIXPOS"
				pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
				pos.position = torso.Position
				gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
				gyro.cframe = torso.CFrame
				repeat
					wait()
					localplayer.Character.Humanoid.PlatformStand=true
					local new=gyro.cframe - gyro.cframe.p + pos.position
					if not keys.w and not keys.s and not keys.a and not keys.d then
						speed=1
					end
					if keys.w then
						new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.s then
						new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.d then
						new = new * CFrame.new(speed,0,0)
						speed=speed+speedSET
					end
					if keys.a then
						new = new * CFrame.new(-speed,0,0)
						speed=speed+speedSET
					end
					if speed>speedSET then
						speed=speedSET
					end
					pos.position=new.p
					if keys.w then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*15),0,0)
					elseif keys.s then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*15),0,0)
					else
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame
					end
				until not Fly
				if gyro then 
					gyro:Destroy() 
				end
				if pos then 
					pos:Destroy() 
				end
				flying=false
				localplayer.Character.Humanoid.PlatformStand=false
				speed=0
			end
			e1=mouse.KeyDown:connect(function(key)
				if not torso or not torso.Parent then 
					flying=false e1:disconnect() e2:disconnect() return 
				end
				if key=="w" then
					keys.w=true
				elseif key=="s" then
					keys.s=true
				elseif key=="a" then
					keys.a=true
				elseif key=="d" then
					keys.d=true
				end
			end)
			e2=mouse.KeyUp:connect(function(key)
				if key=="w" then
					keys.w=false
				elseif key=="s" then
					keys.s=false
				elseif key=="a" then
					keys.a=false
				elseif key=="d" then
					keys.d=false
				end
			end)
			start()
		end

		S9s04:addToggle("Fly",false,function(Value)
			Fly = Value
			activatefly()
		end)

		S9s04:addToggle("No Clip",false,function(value)
			NoClip = value
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if NoClip or Observation then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)

		S9s04:addToggle("Teleport Devil Fruit",false,function(value)
			TeleportDF = value
			pcall(function()
				while TeleportDF do wait()
					for i,v in pairs(game.Workspace:GetChildren()) do
						if string.find(v.Name, "Fruit") then 
							v.Handle.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				end
			end)
		end)

		S9s05:addButton("Rejoin",function()
			local ts = game:GetService("TeleportService")
			local p = game:GetService("Players").LocalPlayer
			ts:Teleport(game.PlaceId, p)
		end)
		local function HttpGet(url)
			return game:GetService("HttpService"):JSONDecode(htgetf(url))
		end

		S9s05:addButton("Server Hop",function()
			local PlaceID = game.PlaceId
			local AllIDs = {}
			local foundAnything = ""
			local actualHour = os.date("!*t").hour
			local Deleted = false
			function TPReturner()
				local Site;
				if foundAnything == "" then
					Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
				else
					Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
				end
				local ID = ""
				if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
					foundAnything = Site.nextPageCursor
				end
				local num = 0;
				for i,v in pairs(Site.data) do
					local Possible = true
					ID = tostring(v.id)
					if tonumber(v.maxPlayers) > tonumber(v.playing) then
						for _,Existing in pairs(AllIDs) do
							if num ~= 0 then
								if ID == tostring(Existing) then
									Possible = false
								end
							else
								if tonumber(actualHour) ~= tonumber(Existing) then
									local delFile = pcall(function()
										-- delfile("NotSameServers.json")
										AllIDs = {}
										table.insert(AllIDs, actualHour)
									end)
								end
							end
							num = num + 1
						end
						if Possible == true then
							table.insert(AllIDs, ID)
							wait()
							pcall(function()
								-- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
								wait()
								game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
							end)
							wait(4)
						end
					end
				end
			end
			function Teleport() 
				while wait() do
					pcall(function()
						TPReturner()
						if foundAnything ~= "" then
							TPReturner()
						end
					end)
				end
			end
			Teleport()
		end)

		S9s05:addKeybind("Hide UI", Enum.KeyCode.Insert, function()
			L9s0:toggle()
		end, function()

		end)

		S9s05:addButton("RTX Graphic",function()

			getgenv().mode = "Autumn" -- Choose from Summer and Autumn




			local a = game.Lighting
			a.Ambient = Color3.fromRGB(33, 33, 33)
			a.Brightness = 6.67
			a.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
			a.ColorShift_Top = Color3.fromRGB(255, 247, 237)
			a.EnvironmentDiffuseScale = 0.105
			a.EnvironmentSpecularScale = 0.522
			a.GlobalShadows = true
			a.OutdoorAmbient = Color3.fromRGB(51, 54, 67)
			a.ShadowSoftness = 0.04
			a.GeographicLatitude = -15.525
			a.ExposureCompensation = 0.75
			local b = Instance.new("BloomEffect", a)
			b.Enabled = true
			b.Intensity = 0.04
			b.Size = 1900
			b.Threshold = 0.915
			local c = Instance.new("ColorCorrectionEffect", a)
			c.Brightness = 0.176
			c.Contrast = 0.39
			c.Enabled = true
			c.Saturation = 0.2
			c.TintColor = Color3.fromRGB(217, 145, 57)
			if getgenv().mode == "Summer" then
				c.TintColor = Color3.fromRGB(255, 220, 148)
			elseif getgenv().mode == "Autumn" then
				c.TintColor = Color3.fromRGB(217, 145, 57)
			else
				warn("No mode selected!")
				print("Please select a mode")
				b:Destroy()
				c:Destroy()
			end
			local d = Instance.new("DepthOfFieldEffect", a)
			d.Enabled = true
			d.FarIntensity = 0.077
			d.FocusDistance = 21.54
			d.InFocusRadius = 20.77
			d.NearIntensity = 0.277
			local e = Instance.new("ColorCorrectionEffect", a)
			e.Brightness = 0
			e.Contrast = -0.07
			e.Saturation = 0
			e.Enabled = true
			e.TintColor = Color3.fromRGB(255, 247, 239)
			local e2 = Instance.new("ColorCorrectionEffect", a)
			e2.Brightness = 0.2
			e2.Contrast = 0.45
			e2.Saturation = -0.1
			e2.Enabled = true
			e2.TintColor = Color3.fromRGB(255, 255, 255)
			local s = Instance.new("SunRaysEffect", a)
			s.Enabled = true
			s.Intensity = 0.01
			s.Spread = 0.146

		end)

		S9s05:addToggle("Anit AFK",false,function(vu)
			local vu = game:GetService("VirtualUser")
			game:GetService("Players").LocalPlayer.Idled:connect(function()
				vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
				wait(1)
				vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
			end)
		end)

		S9s05:addToggle("Hide HitBlox",true,function(Value)
			HideHitBlox = Value  
		end)

		S9s06:addButton("Open Devil Shop",function()
			local args = {
				[1] = "GetFruits"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.FruitShop.Visible = true
		end)

		S9s06:addButton("Open Inventory",function()
			local args = {
				[1] = "getInventoryWeapons"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.Inventory.Visible = true
		end)

		S9s06:addButton("Open Color Haki",function()
			game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
		end)

		S9s06:addButton("Open Title Name",function()
			local args = {
				[1] = "getTitles"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
		end)

		S9s07:addButton("SkyJump ($10,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Geppo"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Buso Haki ($25,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Buso"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Observation haki ($750,000 Beli)",function()
			local args = {
				[1] = "KenTalk",
				[2] = "Buy"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Soru ($100,000 Beli)",function()
			local args = {
				[1] = "BuyHaki",
				[2] = "Soru"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Black Leg",function()
			local args = {
				[1] = "BuyBlackLeg"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Electra",function()
			local args = {
				[1] = "BuyElectro"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Fishman Karate",function()
			local args = {
				[1] = "BuyFishmanKarate"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Dragon Claw",function()
			local args = {
				[1] = "BlackbeardReward",
				[2] = "DragonClaw",
				[3] = "1"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BlackbeardReward",
				[2] = "DragonClaw",
				[3] = "2"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Superhuman",function()
			local args = {
				[1] = "BuySuperhuman"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Death Step",function()
			local args = {
				[1] = "BuyDeathStep"
			}

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)

		S9s07:addButton("Shakman Karate",function()
			local args = {
				[1] = "BuySharkmanKarate",
				[2] = true
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			local args = {
				[1] = "BuySharkmanKarate"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end)
		S9s07:addToggle("Auto Buy Haki Color",false,function(value)

			_G.buy = value

			while _G.buy do
				wait()

				local A_1 = "ColorsDealer"
				local A_2 = "1"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "2"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "3"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "4"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "5"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "6"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "7"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "8"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "9"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "10"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "11"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "12"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

				local A_1 = "ColorsDealer"
				local A_2 = "13"
				local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
				Event:InvokeServer(A_1, A_2)

			end

		end)

		S9s08:addButton("Copy Link Discord",function()

			setclipboard("https://discord.gg/4sM2KwJBh4")
		end)

		S9s08:addButton("Credit",function()

			L9s0:Notify("CREDIT ", "9s0 Hub")
			wait(2.5)
			L9s0:Notify("CREDIT ", "Free Script 9s0 Hub")
		end)
	end

	if placeId == 189707 then --- Natural Disaster Survival

		if game.CoreGui:FindFirstChild("9s0 Hub - Natural Disaster Survival") then
			game.CoreGui:FindFirstChild("9s0 Hub - Natural Disaster Survival"):Destroy()
		end

		local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/9s0/uif/main/README.md"))()

		local L9s0 = library.new("9s0 Hub - Natural Disaster Survival")

		local M9s0 = L9s0:addPage("Main", 7010566435)

		local M9s01 = L9s0:addPage("Credit", 7061136295)

		local S9s0 = M9s0:addSection("Local Player")

		local S9s01 = M9s0:addSection("Functions")

		local S9s02 = M9s0:addSection("Players")

		local S9s03 = M9s0:addSection("Settings")

		local S9s04 = M9s01:addSection("Credit")

		S9s0:addButton("Teleport To Island",function()

			game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-128.31632995605, 47.399990081787, 6.9434204101563)

			L9s0:Notify("NOTIFICATION", "Teleport To Island Succsses")

		end)

		S9s0:addButton("Teleport To Spawn",function()

			game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-279.13610839844, 179.49995422363, 341.51739501953)
			L9s0:Notify("NOTIFICATION", "Teleport To Spawn Succsses")

		end)

		S9s0:addToggle("Auto Win",false,function(warp)

			_G.Warp = warp


			while _G.Warp do
				wait(5)
				game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-279.13610839844, 179.49995422363, 341.51739501953)
			end
		end)

		S9s01:addToggle("Voting Map",false,function(Voting)

			game.Players.LocalPlayer.PlayerGui.MainGui.MapVotePage.Visible = Voting

		end)

		S9s01:addButton("No Fall Damage",function()

			local playername = game.Players.LocalPlayer.Name

			while true do
				for _,c in pairs(game.Workspace:GetDescendants()) do
					if c.Name == playername and c.Parent == Workspace then
						for _,c in pairs(c:GetDescendants()) do
							if c.Name == ("FallDamageScript") then
								c:Destroy()

								L9s0:Notify("NOTIFICATION", "No Fall Damage Has Been Delete")
							end
						end
					end
				end
				wait()
			end


		end)

		Fly = false
		function activatefly()
			local mouse=game.Players.LocalPlayer:GetMouse''
			localplayer=game.Players.LocalPlayer
			game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
			local torso = game.Players.LocalPlayer.Character.HumanoidRootPart
			local speedSET=25
			local keys={a=false,d=false,w=false,s=false}
			local e1
			local e2
			local function start()
				local pos = Instance.new("BodyPosition",torso)
				local gyro = Instance.new("BodyGyro",torso)
				pos.Name="EPIXPOS"
				pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
				pos.position = torso.Position
				gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
				gyro.cframe = torso.CFrame
				repeat
					wait()
					localplayer.Character.Humanoid.PlatformStand=true
					local new=gyro.cframe - gyro.cframe.p + pos.position
					if not keys.w and not keys.s and not keys.a and not keys.d then
						speed=1
					end
					if keys.w then
						new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.s then
						new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
						speed=speed+speedSET
					end
					if keys.d then
						new = new * CFrame.new(speed,0,0)
						speed=speed+speedSET
					end
					if keys.a then
						new = new * CFrame.new(-speed,0,0)
						speed=speed+speedSET
					end
					if speed>speedSET then
						speed=speedSET
					end
					pos.position=new.p
					if keys.w then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*15),0,0)
					elseif keys.s then
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*15),0,0)
					else
						gyro.cframe = workspace.CurrentCamera.CoordinateFrame
					end
				until not Fly
				if gyro then 
					gyro:Destroy() 
				end
				if pos then 
					pos:Destroy() 
				end
				flying=false
				localplayer.Character.Humanoid.PlatformStand=false
				speed=0
			end
			e1=mouse.KeyDown:connect(function(key)
				if not torso or not torso.Parent then 
					flying=false e1:disconnect() e2:disconnect() return 
				end
				if key=="w" then
					keys.w=true
				elseif key=="s" then
					keys.s=true
				elseif key=="a" then
					keys.a=true
				elseif key=="d" then
					keys.d=true
				end
			end)
			e2=mouse.KeyUp:connect(function(key)
				if key=="w" then
					keys.w=false
				elseif key=="s" then
					keys.s=false
				elseif key=="a" then
					keys.a=false
				elseif key=="d" then
					keys.d=false
				end
			end)
			start()
		end

		S9s0:addToggle("Fly (Active No Fall Damage First)",false,function(Value)

			Fly = Value
			activatefly()

		end)

		S9s0:addToggle("No Clip",false,function(value)
			NoClip = value
		end)
		game:GetService("RunService").Heartbeat:Connect(
		function()
			if NoClip or Observation then
				game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
			end
		end)

		S9s02:addToggle("Esp - Player",false,function(ESP)

			ESPPlayer = ESP
			while ESPPlayer do wait()
				UpdatePlayerChams()
			end

		end)

		function isnil(thing)
			return (thing == nil)
		end
		local function round(n)
			return math.floor(tonumber(n) + 0.5)
		end
		Number = math.random(1, 1000000)
		function UpdatePlayerChams()
			for i,v in pairs(game:GetService'Players':GetChildren()) do
				pcall(function()
					if not isnil(v.Character) then
						if ESPPlayer then
							if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
								local bill = Instance.new('BillboardGui',v.Character.Head)
								bill.Name = 'NameEsp'..Number
								bill.ExtentsOffset = Vector3.new(0, 1, 0)
								bill.Size = UDim2.new(1,200,1,30)
								bill.Adornee = v.Character.Head
								bill.AlwaysOnTop = true
								local name = Instance.new('TextLabel',bill)
								name.Font = "SourceSansBold"
								name.FontSize = "Size14"
								name.TextWrapped = true
								name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
								name.Size = UDim2.new(1,0,1,0)
								name.TextYAlignment = 'Top'
								name.BackgroundTransparency = 1
								name.TextStrokeTransparency = 0.5
								if v.Team == game.Players.LocalPlayer.Team then
									name.TextColor3 = Color3.new(0.196078, 0.196078, 0.196078)
								else
									name.TextColor3 = Color3.new(1, 0.333333, 0.498039)
								end
							else
								v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
							end
						else
							if v.Character.Head:FindFirstChild('NameEsp'..Number) then
								v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
							end
						end
					end
				end)
			end
		end

		S9s03:addKeybind("Hide UI", Enum.KeyCode.Insert, function()
			L9s0:toggle()
		end, function()

		end)

		S9s03:addButton("RTX Graphic",function()

			getgenv().mode = "Autumn" -- Choose from Summer and Autumn




			local a = game.Lighting
			a.Ambient = Color3.fromRGB(33, 33, 33)
			a.Brightness = 6.67
			a.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
			a.ColorShift_Top = Color3.fromRGB(255, 247, 237)
			a.EnvironmentDiffuseScale = 0.105
			a.EnvironmentSpecularScale = 0.522
			a.GlobalShadows = true
			a.OutdoorAmbient = Color3.fromRGB(51, 54, 67)
			a.ShadowSoftness = 0.04
			a.GeographicLatitude = -15.525
			a.ExposureCompensation = 0.75
			local b = Instance.new("BloomEffect", a)
			b.Enabled = true
			b.Intensity = 0.04
			b.Size = 1900
			b.Threshold = 0.915
			local c = Instance.new("ColorCorrectionEffect", a)
			c.Brightness = 0.176
			c.Contrast = 0.39
			c.Enabled = true
			c.Saturation = 0.2
			c.TintColor = Color3.fromRGB(217, 145, 57)
			if getgenv().mode == "Summer" then
				c.TintColor = Color3.fromRGB(255, 220, 148)
			elseif getgenv().mode == "Autumn" then
				c.TintColor = Color3.fromRGB(217, 145, 57)
			else
				warn("No mode selected!")
				print("Please select a mode")
				b:Destroy()
				c:Destroy()
			end
			local d = Instance.new("DepthOfFieldEffect", a)
			d.Enabled = true
			d.FarIntensity = 0.077
			d.FocusDistance = 21.54
			d.InFocusRadius = 20.77
			d.NearIntensity = 0.277
			local e = Instance.new("ColorCorrectionEffect", a)
			e.Brightness = 0
			e.Contrast = -0.07
			e.Saturation = 0
			e.Enabled = true
			e.TintColor = Color3.fromRGB(255, 247, 239)
			local e2 = Instance.new("ColorCorrectionEffect", a)
			e2.Brightness = 0.2
			e2.Contrast = 0.45
			e2.Saturation = -0.1
			e2.Enabled = true
			e2.TintColor = Color3.fromRGB(255, 255, 255)
			local s = Instance.new("SunRaysEffect", a)
			s.Enabled = true
			s.Intensity = 0.01
			s.Spread = 0.146

		end)

		S9s04:addButton("Copy Link Discord",function()

			setclipboard("https://discord.gg/4sM2KwJBh4")
		end)

		S9s04:addButton("Credit",function()

			L9s0:Notify("CREDIT ", "MEnon Hub")
			wait(2.5)
			L9s0:Notify("CREDIT ", "Buy Script MEnon Hub Hub")
		end)

	end
