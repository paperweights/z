class_name ServerData
extends Reference

const SERVERS_PATH = 'user://servers/'
const CONFIG_PATH = 'config.ini'
# details section
const DETAILS_SECTION = 'details'
const PORT_KEY = 'port'
const PASSWORD_KEY = 'password'
# player section
const PLAYER_SECTION = 'player'
const OPEN_KEY = 'open'

var _server_path: String
var _server_config_path: String
var _server_config: ConfigFile

# get a list of all the servers
static func get_servers() -> PoolStringArray:
	print('Looking for servers')
	var servers = PoolStringArray()
	var directory = Directory.new()
	# make sure that servers directory exists
	if not directory.dir_exists(SERVERS_PATH):
		print('Created new servers folder')
		directory.make_dir_recursive(SERVERS_PATH)
	var status = directory.open(SERVERS_PATH)
	if status != OK:
		print("Failed to open server path: %s with status: %d" % [SERVERS_PATH, status])
		return servers
	directory.list_dir_begin(true, true)
	var file_name = directory.get_next()
	while file_name != "":
		print(file_name)
		if directory.current_is_dir():
			print("Found server: %s" % file_name)
			servers.push_back(file_name)
		file_name = directory.get_next()
	directory.list_dir_end()
	return servers


func create(name: String) -> bool:
	var directory = Directory.new()
	var server_path = SERVERS_PATH + name + '/'
	# make sure that a server with the same name doesn't already exist
	if directory.dir_exists(server_path):
		print('Server %s already exists' % name)
		return false
	# create a directory for the server
	directory.make_dir_recursive(server_path)
	print('Created server directory: %s' % server_path)
	# create a config file
	var config_path = server_path + CONFIG_PATH
	_server_config = ConfigFile.new()
	_server_config.save(config_path)
	_server_path = server_path
	_server_config_path = config_path
	return true


func set_config(port: int, password: String, open: bool):
	_server_config.set_value(DETAILS_SECTION, PORT_KEY, port)
	_server_config.set_value(DETAILS_SECTION, PASSWORD_KEY, password)
	_server_config.set_value(PLAYER_SECTION, OPEN_KEY, open)
	_server_config.save(_server_config_path)
