class_name HostMenu
extends Menu

signal edit_host(server)

export(NodePath) var _main_menu_node
export(NodePath) var _hosting_menu_node
export(NodePath) var _host_edit_menu_node

var _port: int = GameState.DEFAULT_PORT
var _max_players: int = 10

onready var _main_menu: CenterContainer = get_node(_main_menu_node)
onready var _hosting_menu: CenterContainer = get_node(_hosting_menu_node)
onready var _host_edit_menu: CenterContainer = get_node(_host_edit_menu_node)
onready var _servers: ItemList = $PanelContainer/VBoxContainer/Servers


func _refresh_servers():
	_servers.clear()
	var servers = ServerData.get_servers()
	for server in servers:
		_servers.add_item(server)
	return


func _on_add_pressed():
	_switch_menu(_host_edit_menu)
	return


func _on_host_pressed():
	GameState.host_game(_port, _max_players)
	_switch_menu(_hosting_menu)
	return


func _on_Back_pressed():
	_switch_menu(_main_menu)
	return


func _on_visibility_changed():
	if visible:
		_refresh_servers()
