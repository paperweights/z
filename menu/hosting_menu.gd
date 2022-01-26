class_name HostingMenu
extends Menu

export (NodePath) var _main_menu_node

onready var _main_menu: CenterContainer = get_node(_main_menu_node)


func _ready():
	GameState.connect("connection_closed", self, "_on_connection_closed")
	return


func _on_connection_closed():
	# only switch to the main menu when connection is closed
	_switch_menu(_main_menu)
	return


func _on_stop_pressed():
	GameState.close_connection()
	return
