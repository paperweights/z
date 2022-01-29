class_name LoginData
extends Reference

var _server_password: String
var _username: String
var _password: String


func _init(server_password: String, username: String, password: String):
	_server_password = server_password
	_username = username
	_password = password

func clear():
	_server_password = ""
	_username = ""
	_password = ""
