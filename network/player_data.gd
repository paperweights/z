class_name PlayerData
extends Reference

const ITERATIONS = 8

var _data: Dictionary


func load_data(path: String) -> int:
	# open the file for reading
	var status: int
	var data_file = File.new()
	status = data_file.open(path, File.READ)
	if status != OK:
		print("Failed to open player data at: %s" % path)
		return status
	# parse the contents of the file as json
	var data_text = data_file.get_as_text()
	data_file.close()
	# make sure json is valid
	var json_result = JSON.parse(data_text)
	if json_result.error != OK:
		print("Failed to parse player data at line: %s\n%s" % [json_result.error_line, json_result.error_string])
		return json_result.error
	# make sure json data is a dictionary
	if typeof(json_result.result) != TYPE_DICTIONARY:
		print("Player data is invalid")
		return ERR_INVALID_DATA
	# set data
	_data = json_result.result
	return OK


func save_data(path: String) -> int:
	# turn data into a string
	var string = JSON.print(_data, '\t', true)
	# open the file for writing
	var status: int
	var data_file = File.new()
	status = data_file.open(path, File.WRITE)
	if status != OK:
		print("Failed to open player data at: %s" % path)
		return status
	data_file.store_string(string)
	data_file.close()
	return OK


func add_player(name: String, password: String) -> int:
	if _data.has(name):
		print("Player %s already exists!" % name)
		return ERR_ALREADY_EXISTS
	# TODO: salt and hash the password before storing it
	_data[name] = {
		"password": password,
	}
	return OK
