class_name ServerInfoMenu
extends Menu

signal server_added()

const SERVER_INFO_CONFIG = "user://servers.ini"
const ADDRESS_KEY = "address"
const PORT_KEY = "port"
const SERVER_PASSWORD_KEY = "server_password"
const USERNAME_KEY = "username"
const PASSWORD_KEY = "password"

export(NodePath) var _join_menu_node

var _config := ConfigFile.new()
var _name: String
var _address: String
var _port: int
var _server_password: String
var _username: String
var _password: String

onready var _join_menu: CenterContainer = get_node(_join_menu_node)
onready var _done_button: Button = $PanelContainer/VBoxContainer/Done


func _refresh_lines():
	$PanelContainer/VBoxContainer/Name/LineEdit.text = _name
	$PanelContainer/VBoxContainer/IpAddress/LineEdit.text = _address
	$PanelContainer/VBoxContainer/Port/LineEdit.text = str(_port)
	$PanelContainer/VBoxContainer/ServerPassword/LineEdit.text = _server_password
	$PanelContainer/VBoxContainer/Username/LineEdit.text = _username
	$PanelContainer/VBoxContainer/Password/LineEdit.text = _password
	return


func _refresh_done():
	var disabled = false
	if _name == '':
		disabled = true
	elif not _address.is_valid_ip_address():
		disabled = true
	elif _port < GameState.MIN_PORT or _port > GameState.MAX_PORT:
		disabled = true
	_done_button.disabled = disabled
	return


func _on_done_pressed():
	_config.load(SERVER_INFO_CONFIG)
	_config.set_value(_name, ADDRESS_KEY, _address)
	_config.set_value(_name, PORT_KEY, _port)
	_config.set_value(_name, SERVER_PASSWORD_KEY, _server_password)
	_config.set_value(_name, USERNAME_KEY, _username)
	_config.set_value(_name, PASSWORD_KEY, _password)
	_config.save(SERVER_INFO_CONFIG)
	emit_signal("server_added")
	_switch_menu(_join_menu)
	return


func _on_name_changed(new_text: String):
	_name = new_text
	_refresh_done()
	return


func _on_address_changed(new_text: String):
	_address = new_text
	_refresh_done()
	return


func _on_port_changed(new_text: String):
	_port = int(new_text)
	_refresh_done()
	return


func _on_server_password_changed(new_text: String):
	_server_password = new_text
	return


func _on_username_changed(new_text: String):
	_username = new_text
	return


func _on_password_changed(new_text: String):
	_password = new_text
	return


func _on_edit_server(server_name: String):
	_name = server_name
	_config.load(SERVER_INFO_CONFIG)
	_address = _config.get_value(_name, ADDRESS_KEY, "127.0.0.1")
	_port = _config.get_value(_name, PORT_KEY, 42069)
	_server_password = _config.get_value(_name, SERVER_PASSWORD_KEY, "")
	_username = _config.get_value(_name, USERNAME_KEY, "")
	_password = _config.get_value(_name, PASSWORD_KEY, "")
	_refresh_done()
	_refresh_lines()
	return


func _on_back_pressed():
	_switch_menu(_join_menu)
	return


func _on_visibility_changed():
	if not visible:
		return
	# reset values to default
	_name = ""
	_address = "127.0.0.1"
	_port = 42069
	_server_password = ""
	_username = ""
	_password = ""
	_refresh_done()
	_refresh_lines()
	return
