extends Menu

export (NodePath) var _host_menu_node

var _name: String
var _port: int
var _password: String
var _open: bool

onready var _host_menu: CenterContainer = get_node(_host_menu_node)
onready var _done_button: Button = $PanelContainer/VBoxContainer/Done


func _reset_values():
	_name = ""
	_port = GameState.DEFAULT_PORT
	_password = ""
	_open = false


func _refresh_done():
	var disabled = false
	if _name == "":
		disabled = true
	if _port == 0:
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


func _on_open_toggled(button_pressed: bool):
	_open = button_pressed


func _on_done_pressed():
	var server_data = ServerData.new()
	var created = server_data.create(_name)
	if not created:
		print("Failed to create server data: %s" % _name)
		return
	server_data.set_config(_port, _password, _open)
	_reset_values()
	_switch_menu(_host_menu)


func _on_back_pressed():
	_switch_menu(_host_menu)


func _on_visibility_changed():
	if visible:
		_reset_values()
