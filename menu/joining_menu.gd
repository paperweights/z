class_name JoiningMenu
extends Menu

export (NodePath) var _join_menu_node 

onready var _join_menu = get_node(_join_menu_node)
onready var _status = $PanelContainer/VBoxContainer/Status


func _ready():
	GameState.connect("connection_succeeded", self, "_on_connected_successfully")
	GameState.connect("connection_failed", self, "_on_connected_failed")
	GameState.connect("connection_closed", self, "_on_connection_closed")
	return


func _on_connected_successfully():
	_switch_menu(null)
	return


func _on_connected_failed():
	_switch_menu(self)
	_status.text = "Failed to connect to server!"
	$PanelContainer/VBoxContainer/Cancel.visible = false
	$PanelContainer/VBoxContainer/Back.visible = true
	return


func _on_connection_closed():
	_switch_menu(_join_menu)
	return


func _on_cancelled_pressed():
	# close connection
	GameState.close_connection()
	return


func _on_back_pressed():
	_switch_menu(_join_menu)
	return


func _on_visibility_changed():
	if not visible:
		return
	var status_format = "Connecting to server at IP:%s:%s"
	var formatted_status = status_format % [GameState.peer.get_peer_address(1), GameState.peer.get_peer_port(1)]
	_status.text = formatted_status
	return
