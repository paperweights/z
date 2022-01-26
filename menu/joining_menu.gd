class_name JoiningMenu
extends Menu

export (NodePath) var _join_menu_node 

onready var _join_menu = get_node(_join_menu_node)
onready var _status = $PanelContainer/VBoxContainer/Status


func _ready():
	GameState.connect("connection_succeeded", self, "_on_connected_successfully")
	GameState.connect("connection_failed", self, "_on_connected_failed")
	return


func _on_connected_successfully():
	visible = false
	return


func _on_connected_failed():
	visible = true
	_status.text = "Failed to connect to server!"
	$PanelContainer/VBoxContainer/Cancel.visible = false
	$PanelContainer/VBoxContainer/Back.visible = true
	return


func _on_cancelled_pressed():
	return


func _on_back_pressed():
	_switch_menu(_join_menu)
	return
