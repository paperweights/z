class_name JoinMenu
extends Menu

export(NodePath) var _main_menu_node

var _address: String = "127.0.0.1"
var _port: int = 42069

onready var _main_menu: CenterContainer = get_node(_main_menu_node)
onready var _join_button: Button = $VBoxContainer/Join
onready var _line_edits = [
	$VBoxContainer/IpAddress/LineEdit,
	$VBoxContainer/Port/LineEdit,
	$VBoxContainer/ServerPassword/LineEdit,
	$VBoxContainer/Username/LineEdit,
	$VBoxContainer/Password/LineEdit,
]


func _ready():
	# set initial values
	_line_edits[0].text = _address
	_line_edits[1].text = str(_port)
	return


func _on_Join_pressed():
	# disable all input while joining
	_join_button.disabled = true
	$VBoxContainer/Back.disabled = true
	for line_edit in _line_edits:
		line_edit.editable = false
	return


func _on_Back_pressed():
	_switch_menu(_main_menu)
	return


func _on_port_changed(new_text: String):
	_port = int(new_text)
	_update_join()
	return


func _on_address_changed(new_text: String):
	_address = new_text
	_update_join()
	return


func _update_join():
	var disabled = false
	if not _address.is_valid_ip_address():
		disabled = true
	elif _port > PortLine.MAX_PORT or _port < PortLine.MIN_PORT:
		disabled = true
	_join_button.disabled = disabled
