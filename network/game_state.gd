extends Node

# signals to update gui
signal connection_succeeded()
signal connection_failed()
signal connection_closed()
signal authentication_failed()

# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const MIN_PORT = 1
const MAX_PORT = 49151
const DEFAULT_PORT = 42069
const MAX_PLAYERS = 4095

var peer: NetworkedMultiplayerENet
# client data
var _server_password: String
var _username: String
var _password: String
# hosting data
var _server_data: ServerData


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	return


func host_game(server_data: ServerData) -> int:
	_server_data = server_data
	var port = _server_data.get_port()
	var max_players = _server_data.get_max_players()
	print("Hosting server at port: %d" % port)
	peer = NetworkedMultiplayerENet.new()
	var status = peer.create_server(port, max_players)
	print("Hosting server status: %d" % status)
	if status != OK:
		return status
	get_tree().set_network_peer(peer)
	return status


func join_game(address: String, port: int, server_password: String,
		username: String, password: String) -> int:
	print("Connecting to server at IP: %s:%d" % [address, port])
	peer = NetworkedMultiplayerENet.new()
	var status = peer.create_client(address, port)
	if status:
		print("Failed to connect with status: %d" % status)
		return status
	get_tree().set_network_peer(peer)
	_server_password = server_password
	_username = username
	_password = password
	return status


func close_connection():
	print("Closing connection")
	peer.close_connection()
	get_tree().set_network_peer(null)
	emit_signal("connection_closed")
	return


func _player_connected(id: int):
	print("Player: %d connected with IP:%s%d" % [id, peer.get_peer_address(id), peer.get_peer_port(id)])
	return


func _player_disconnected(id: int):
	print("Player: %d disconnected!" % id)
	return


func _server_disconnected():
	print("Server disconnected")
	return


func _connected_ok():
	print("Connected to the server successfully")
	# try to authenticate with server
	rpc_id(1, "login_request", _server_password, _username, _password)
	return


func _connected_fail():
	print("Failed to connect to server")
	close_connection()
	emit_signal("connection_failed")
	return


remote func login_request(server_password: String, username: String,
		password: String):
	var player = get_tree().get_rpc_sender_id()
	print("Authenticating player: %d" % player)
	var result = true
	# validate login data
	# make sure server password matches
	if server_password != _server_data.get_server_password().sha256_text():
		print("Server password is incorrect!")
		result = false
	# check if player exists
	print("Authentication result: %s" % result)
	rpc_id(player, "login_result", result)
	# kick player if failed to login
	if not result:
		print("Kicking player: %d" % player)
		peer.disconnect_peer(player)
	return

remote func login_result(result: bool):
	print("login result is: " + str(result))
	if result:
		# only emit signal when authenticated
		emit_signal("connection_succeeded")
	# disconnect self if failed to authenticate
	else:
		print("Failed to authenticate with server")
		emit_signal("authentication_failed")
		close_connection()
	return
