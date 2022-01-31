class_name ServerData
extends Reference

const SERVERS_PATH = 'user://servers/'
const CONFIG_PATH = 'config.ini'
const PLAYER_DATA_PATH = 'players.json'
# details section
const DETAILS_SECTION = 'details'
const PORT_KEY = 'port'
const PASSWORD_KEY = 'password'
# player section
const PLAYER_SECTION = 'player'
const OPEN_KEY = 'open'
const MAX_PLAYERS_KEY = 'max_players'

# data
var _server_config: ConfigFile
var _player_data: PlayerData
# paths
var _server_path: String
var _server_config_path: String

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
		if directory.current_is_dir():
			print("Found server: %s" % file_name)
			servers.push_back(file_name)
		file_name = directory.get_next()
	directory.list_dir_end()
	return servers


static func get_server_path(name: String) -> String:
	return SERVERS_PATH + name + '/'


static func get_config_path(server_path: String) -> String:
	return server_path + CONFIG_PATH


static func get_player_data_path(server_path: String) -> String:
	return server_path + PLAYER_DATA_PATH


func get_server_password() -> String:
	return _server_config.get_value(DETAILS_SECTION, PASSWORD_KEY, "")


func get_port() -> int:
	return _server_config.get_value(DETAILS_SECTION, PORT_KEY, 1)


func get_max_players() -> int:
	return _server_config.get_value(PLAYER_SECTION, MAX_PLAYERS_KEY, 1)


func is_open() -> bool:
	return _server_config.get_value(DETAILS_SECTION, OPEN_KEY, true)


func create(name: String) -> bool:
	var directory = Directory.new()
	var server_path = get_server_path(name)
	# make sure that a server with the same name doesn't already exist
	if directory.dir_exists(server_path):
		print('Server %s already exists' % name)
		return false
	# create a directory for the server
	directory.make_dir_recursive(server_path)
	print('Created server directory: %s' % server_path)
	# create a config file
	var config_path = get_config_path(server_path)
	_server_config = ConfigFile.new()
	_server_config.save(config_path)
	_server_path = server_path
	_server_config_path = config_path
	# create player data
	var player_data_path = get_player_data_path(server_path)
	_player_data = PlayerData.new()
	_player_data.save_data(player_data_path)
	return true


func load_data(name: String) -> bool:
	var server_path = get_server_path(name)
	var directory = Directory.new()
	if not directory.dir_exists(server_path):
		print("Server data %s doesn't exist" % name)
		return false
	# load sever config
	var config_path = get_config_path(server_path)
	_server_config = ConfigFile.new()
	_server_config.load(config_path)
	# load player data
	var player_data_path = get_player_data_path(server_path)
	_player_data = PlayerData.new()
	_player_data.load_data(player_data_path)
	return true


func set_config(port: int, password: String, open: bool, max_players: int):
	_server_config.set_value(DETAILS_SECTION, PORT_KEY, port)
	_server_config.set_value(DETAILS_SECTION, PASSWORD_KEY, password)
	_server_config.set_value(PLAYER_SECTION, OPEN_KEY, open)
	_server_config.set_value(PLAYER_SECTION, MAX_PLAYERS_KEY, max_players)
	_server_config.save(_server_config_path)
