class_name HostMenu
extends Menu

signal edit_host(server)

export(NodePath) var _main_menu_node
export(NodePath) var _hosting_menu_node
export(NodePath) var _host_edit_menu_node

var _server: int

onready var _main_menu: CenterContainer = get_node(_main_menu_node)
onready var _hosting_menu: CenterContainer = get_node(_hosting_menu_node)
onready var _host_edit_menu: CenterContainer = get_node(_host_edit_menu_node)
onready var _servers: ItemList = $PanelContainer/VBoxContainer/Servers
onready var _buttons = [
	$PanelContainer/VBoxContainer/HBoxContainer/Host,
	$PanelContainer/VBoxContainer/HBoxContainer/Edit,
	$PanelContainer/VBoxContainer/HBoxContainer/Delete,
]


func _get_server_name() -> String:
	return _servers.get_item_text(_server)


func _refresh_servers():
	_servers.clear()
	var servers = ServerData.get_servers()
	for server in servers:
		_servers.add_item(server)


func _toggle_buttons(disabled: bool):
	for button in _buttons:
		button.disabled = disabled
	return


func _on_server_selected(index: int):
	_server = index
	_toggle_buttons(false)


func _on_add_pressed():
	_switch_menu(_host_edit_menu)


func _on_host_pressed():
	var server_data = ServerData.new()
	server_data.load_data(_get_server_name())
	GameState.host_game(server_data)
	_switch_menu(_hosting_menu)


func _on_edit_pressed():
	_switch_menu(_host_edit_menu)
	emit_signal("edit_host", _get_server_name())


func _on_Back_pressed():
	_switch_menu(_main_menu)


func _on_visibility_changed():
	if visible:
		_refresh_servers()
		_toggle_buttons(true)
