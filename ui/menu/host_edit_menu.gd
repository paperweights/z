extends Menu

export (NodePath) var _host_menu_node

# used for moving the the old folder when editing name
var _edit_server: String

var _name: String
var _port: int
var _password: String
var _max_players: int
var _open: bool

onready var _host_menu: CenterContainer = get_node(_host_menu_node)
onready var _done_button: Button = $PanelContainer/VBoxContainer/Done


func _reset_values():
	_name = ""
	_port = GameState.DEFAULT_PORT
	_password = ""
	_max_players = 1
	_open = false
	_update_inputs()


func _update_inputs():
	$PanelContainer/VBoxContainer/Name/LineEdit.text = _name
	$PanelContainer/VBoxContainer/Port/LineEdit.text = str(_port)
	$PanelContainer/VBoxContainer/Password/LineEdit.text = _password
	$PanelContainer/VBoxContainer/MaxPlayers/LineEdit.text = str(_max_players)
	$PanelContainer/VBoxContainer/Open/CheckBox.pressed = _open


func _refresh_done():
	var disabled = false
	if _name == "" \
			or _port == 0 \
			or _max_players <= 0 or _max_players > GameState.MAX_PLAYERS:
		disabled = true
	_done_button.disabled = disabled


func _on_name_changed(new_text: String):
	_name = new_text
	_refresh_done()


func _on_port_changed(new_text: String):
	_port = int(new_text)
	_refresh_done()


func _on_password_changed(new_text: String):
	_password = new_text


func _on_max_players_changed(new_text: String):
	_max_players = int(new_text)
	_refresh_done()


func _on_open_toggled(button_pressed: bool):
	_open = button_pressed


func _on_done_pressed():
	var server_data = ServerData.new()
	var created = server_data.create(_name)
	if not created:
		print("Failed to create server data: %s" % _name)
		return
	server_data.set_config(_port, _password, _open, _max_players)
	_reset_values()
	_edit_server = ""
	_switch_menu(_host_menu)


func _on_back_pressed():
	_switch_menu(_host_menu)


func _on_visibility_changed():
	if visible:
		_reset_values()


func _on_edit_host(server: String):
	_edit_server = server
	var server_data = ServerData.new()
	server_data.load_data(server)
	_name = server
	_port = server_data.get_port()
	_password = server_data.get_server_password()
	_max_players = server_data.get_max_players()
	_open = server_data.is_open()
	_update_inputs()
