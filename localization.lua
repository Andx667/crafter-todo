-- Crafter Todo - Localization
-- English localization

CRAFTER_TODO_STRINGS = {
	["addon_name"] = "Crafter Todo",
	["open_window"] = "Open todo list",
	["close_window"] = "Close todo list",
	["add_todo"] = "Add Todo",
	["edit_todo"] = "Edit",
	["delete_todo"] = "Delete",
	["save_todo"] = "Save",
	["cancel"] = "Cancel",
	["new_todo"] = "New Todo",
	["plain_text"] = "Plain Text",
	["materials_list"] = "Materials List",
	["add_material"] = "Add Material",
	["remove_material"] = "Remove Material",
	["material_name"] = "Material Name",
	["quantity"] = "Quantity",
	["quantity_owned"] = "Owned",
	["todo_title"] = "Crafter Todo List",
	["no_todos"] = "No todos yet. Create one to get started!",
	["mark_complete"] = "Mark as Complete",
	["unmark_complete"] = "Mark as Incomplete",
}

function CRAFTER_TODO_GetString(key)
	return CRAFTER_TODO_STRINGS[key] or key
end
