class_name JoiningMenu
extends Menu

export (NodePath) var _join_menu_node 

var _cancelled := false

onready var _join_menu = get_node(_join_menu_node)
onready var _status = $PanelContainer/VBoxContainer/Status
onready var _cancel = $PanelContainer/VBoxContainer/Cancel
onready var _back = $PanelContainer/VBoxContainer/Back


func _ready():
	GameState.connect("connection_succeeded", self, "_on_connected_successfully")
	GameState.connect("connection_failed", self, "_on_connected_failed")
	GameState.connect("connection_closed", self, "_on_connection_closed")
	GameState.connect("authentication_failed", self, "_on_authentication_failed")
	return


func _toggle_buttons(cancel: bool):
	_cancel.visible = cancel
	_back.visible = not cancel
	return


func _on_connected_successfully():
	# close menu once connected
	_switch_menu(null)
	return


func _on_connected_failed():
	_status.text = "Failed to connect to server!"
	_toggle_buttons(false)
	return


func _on_connection_closed():
	if not visible or not _cancelled:
		return
	_switch_menu(_join_menu)
	_cancelled = false
	return


func _on_authentication_failed():
	_status.text = "Failed to authenticate with server"
	_toggle_buttons(false)
	return


func _on_cancelled_pressed():
	# close connection
	_cancelled = true
	GameState.close_connection()
	return


func _on_back_pressed():
	_switch_menu(_join_menu)
	return


func _on_joining_server(address: String, port: int):
	var status_format = "Connecting to server at IP:%s:%s"
	var formatted_status = status_format % [address, port]
	_status.text = formatted_status
	_toggle_buttons(true)
	return
