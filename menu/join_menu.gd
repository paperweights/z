class_name JoinMenu
extends Menu

signal edit_server(server_name)

export(NodePath) var _main_menu_node
export(NodePath) var _server_info_menu_node

var _config: ConfigFile = ConfigFile.new()
var _selected_server: int

onready var _main_menu: CenterContainer = get_node(_main_menu_node)
onready var _server_info_menu: CenterContainer = get_node(_server_info_menu_node)
onready var _servers: ItemList = $PanelContainer/VBoxContainer/Servers


func _on_visibility_changed():
	if not visible:
		return
	_refresh_servers()
	_toggle_buttons(true)
	return


func _refresh_servers():
	_servers.clear()
	_config.load(ServerInfoMenu.SERVER_INFO_CONFIG)
	for server in _config.get_sections():
		_servers.add_item(server)
	return


func _toggle_buttons(disabled: bool):
	$PanelContainer/VBoxContainer/HBoxContainer/Join.disabled = disabled
	$PanelContainer/VBoxContainer/HBoxContainer/Edit.disabled = disabled
	$PanelContainer/VBoxContainer/HBoxContainer/Delete.disabled = disabled
	return


func _on_join_pressed():
	print('Joining Server')
	var section = _servers.get_item_text(_selected_server)
	var address = _config.get_value(section, ServerInfoMenu.ADDRESS_KEY)
	var port = _config.get_value(section, ServerInfoMenu.PORT_KEY)
	GameState.join_game(address, port)
	return


func _on_add_pressed():
	_switch_menu(_server_info_menu)
	return


func _on_server_added():
	_refresh_servers()
	return


func _on_server_selected(index: int):
	_toggle_buttons(false)
	_selected_server = index
	return


func _on_edit_pressed():
	_switch_menu(_server_info_menu)
	var server_name = _servers.get_item_text(_selected_server)
	emit_signal("edit_server", server_name)
	return


func _on_delete_pressed():
	# delete config from file
	_config.erase_section(_servers.get_item_text(_selected_server))
	_config.save(ServerInfoMenu.SERVER_INFO_CONFIG)
	# remove it from item list
	_servers.remove_item(_selected_server)
	if _servers.get_item_count() == 0:
		_toggle_buttons(true)
	return


func _on_back_pressed():
	_switch_menu(_main_menu)
	return
