class_name HostMenu
extends Menu

export(NodePath) var _main_menu_node
export(NodePath) var _hosting_menu_node

var _port: int = GameState.DEFAULT_PORT
var _max_players: int = 10

onready var _main_menu: CenterContainer = get_node(_main_menu_node)
onready var _hosting_menu: CenterContainer = get_node(_hosting_menu_node)
onready var _host_button: Button = $PanelContainer/VBoxContainer/Host


func _ready():
	$PanelContainer/VBoxContainer/Port/LineEdit.text = str(_port)
	return


func _on_host_pressed():
	GameState.host_game(_port, _max_players)
	_switch_menu(_hosting_menu)
	return


func _update_host():
	var disabled = false
	if _port > GameState.MAX_PORT or _port < GameState.MIN_PORT:
		disabled = true
	_host_button.disabled = disabled
	return


func _on_LineEdit_changed(new_text: String):
	_port = int(new_text)
	_update_host()
	return


func _on_Back_pressed():
	_switch_menu(_main_menu)
	return
