-- Crafter Todo - Core Addon Logic

CRAFTER_TODO_CORE = {
	frame = nil,
	isInitialized = false,
}

-- Initialize the addon
function CRAFTER_TODO_CORE:Initialize()
	if self.isInitialized then
		return
	end
	
	-- Initialize data
	CRAFTER_TODO:InitializeData()
	
	-- Create minimap button
	if CRAFTER_TODO:GetShowMinimapButton() then
		CRAFTER_TODO_UI:CreateMinimapButton()
	end
	
	-- Register events
	local frame = CreateFrame("Frame", "CrafterTodoEventFrame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_LOGOUT")
	frame:RegisterEvent("BAG_UPDATE")
	frame:RegisterEvent("ITEM_LOCK_CHANGED")
	
	-- Set event handler
	frame:SetScript("OnEvent", function(self, event, ...)
		CRAFTER_TODO_CORE:OnEvent(event, ...)
	end)
	
	self.frame = frame
	self.isInitialized = true
	
	print("|cff00ff00Crafter Todo|r loaded! Use |cff00ff00/ctt|r for commands.")
end

-- Handle addon events
function CRAFTER_TODO_CORE:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		if addonName == "CrafterTodo" then
			self:Initialize()
		end
	elseif event == "PLAYER_LOGOUT" then
		-- Saved variables are automatically saved by WoW
	elseif event == "BAG_UPDATE" or event == "ITEM_LOCK_CHANGED" then
		-- Update item counts in materials
		CRAFTER_TODO_CORE:UpdateItemCounts()
	end
end

-- Update item counts for materials in todos
function CRAFTER_TODO_CORE:UpdateItemCounts()
	local todos = CRAFTER_TODO:GetAllTodos()
	for _, todo in ipairs(todos) do
		if todo.type == "materials" then
			for i, material in ipairs(todo.materials) do
				if material.itemId and material.itemId > 0 then
					local count = GetItemCount(material.itemId, false)
					material.owned = count
				end
			end
		end
	end
	
	-- Refresh UI if visible
	if CRAFTER_TODO_UI.isVisible then
		CRAFTER_TODO_UI:RefreshTodoList()
	end
end

-- Slash command handler
SLASH_CRAFTERTODO1 = "/ctt"
SLASH_CRAFTERTODO2 = "/craftertodo"

SlashCmdList["CRAFTERTODO"] = function(msg)
	local command = string.lower(msg or "")
	
	if command == "" or command == "toggle" then
		CRAFTER_TODO_UI:ToggleMainWindow()
	elseif command == "show" then
		CRAFTER_TODO_UI:ShowWindow()
	elseif command == "hide" then
		CRAFTER_TODO_UI:HideWindow()
	elseif command == "minimap" or command == "button" then
		local show = CRAFTER_TODO:GetShowMinimapButton()
		CRAFTER_TODO:SetShowMinimapButton(not show)
		if not show then
			print("|cff00ff00Minimap button shown|r")
		else
			print("|cff00ff00Minimap button hidden|r")
		end
	elseif command == "help" then
		print("|cff00ff00Crafter Todo Commands:|r")
		print("  |cff00ff00/ctt|r - Toggle todo window")
		print("  |cff00ff00/ctt show|r - Show todo window")
		print("  |cff00ff00/ctt hide|r - Hide todo window")
		print("  |cff00ff00/ctt minimap|r - Toggle minimap button")
		print("  |cff00ff00/ctt help|r - Show this help")
	else
		print("|cffff0000Unknown command:|r " .. msg)
		print("Use |cff00ff00/ctt help|r for commands.")
	end
end

-- Confirmation dialogs
StaticPopupDialogs["CRAFTER_TODO_CONFIRM_DELETE"] = {
	text = "Delete todo '%s'?",
	button1 = "Delete",
	button2 = "Cancel",
	OnAccept = function(self, data)
		CRAFTER_TODO:DeleteTodo(data)
		CRAFTER_TODO_UI:RefreshTodoList()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["CRAFTER_TODO_CONFIRM_CLEAR"] = {
	text = "Clear all todos? This cannot be undone.",
	button1 = "Clear All",
	button2 = "Cancel",
	OnAccept = function(self)
		while #CRAFTER_TODO.db.todos > 0 do
			table.remove(CRAFTER_TODO.db.todos, 1)
		end
		CRAFTER_TODO_UI:RefreshTodoList()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

-- Hook into item linking for shift-click functionality
local originalSetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip_SetHyperlink(link)
	if IsShiftKeyDown() and CRAFTER_TODO_UI.isVisible then
		-- Parse item from link
		local itemId = tonumber(string.match(link, "item:(%d+)"))
		local itemName = GetItemInfo(link)
		
		if itemId and itemName then
			-- Show quick add dialog
			local selectedTodo = CRAFTER_TODO:GetTodo(CRAFTER_TODO_UI.selectedTodoId)
			if selectedTodo and selectedTodo.type == "materials" then
				CRAFTER_TODO:AddMaterial(selectedTodo.id, itemName, 1, itemId)
				CRAFTER_TODO_UI:RefreshTodoList()
				print(string.format("|cff00ff00Added %s to current todo|r", itemName))
			else
				print("|cffff0000Please select a materials-type todo first|r")
			end
		end
		return
	end
	
	if originalSetHyperlink then
		originalSetHyperlink(link)
	end
end

-- Initialize addon when WoW loads
if GetAddOnEnablement("player", "CrafterTodo") then
	-- Addon should auto-load
else
	-- Manual initialization if needed
	CRAFTER_TODO_CORE:Initialize()
end
