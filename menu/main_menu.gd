class_name MainMenu
extends Menu

export(NodePath) var _join_menu_node
export(NodePath) var _host_menu_node
export(NodePath) var _options_menu_node

onready var _join_menu: CenterContainer = get_node(_join_menu_node)
onready var _host_menu: CenterContainer = get_node(_host_menu_node)
onready var _options_menu: CenterContainer = get_node(_options_menu_node)


func _on_Join_pressed():
	_switch_menu(_join_menu)
	return


func _on_Host_pressed():
	_switch_menu(_host_menu)
	return


func _on_Options_pressed():
	_switch_menu(_options_menu)
	return


func _on_Quit_pressed():
	get_tree().quit()
	return
