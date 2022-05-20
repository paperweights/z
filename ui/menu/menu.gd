class_name Menu
extends CenterContainer


func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")


func _switch_menu(menu: CenterContainer):
	visible = false
	menu.visible = true
	return


func _on_visibility_changed():
	return
