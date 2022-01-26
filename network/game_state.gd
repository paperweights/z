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

var peer: NetworkedMultiplayerENet
var _login_data: LoginData


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	return


func host_game(port: int, max_clients: int) -> int:
	print("Hosting server at port: %d" % port)
	peer = NetworkedMultiplayerENet.new()
	var status = peer.create_server(port, max_clients)
	print("Hosting server status: %d" % status)
	if status != OK:
		return status
	get_tree().set_network_peer(peer)
	return status


func join_game(address: String, port: int, login_data: LoginData) -> int:
	print("Connecting to server at IP: %s:%d" % [address, port])
	peer = NetworkedMultiplayerENet.new()
	var status = peer.create_client(address, port)
	print("Connecting to server status %d" % status)
	if status != OK:
		return status
	get_tree().set_network_peer(peer)
	_login_data = login_data
	return status


func close_connection():
	print("Closing connection")
	peer.close_connection()
	get_tree().set_network_peer(null)
	emit_signal("connection_closed")
	return


func _player_connected(id: int):
	print("Player: %s connected with IP:%s%s" % [id, peer.get_peer_address(id), peer.get_peer_port(id)])
	return


func _player_disconnected(id: int):
	print("Player: %s disconnected!" % id)
	return


func _server_disconnected():
	print("Server disconnected")
	return


func _connected_ok():
	print("Connected to the server successfully")
	# try to authenticate with server
	rpc_id(1, "login_request", _login_data)
	_login_data.clear()
	return


func _connected_fail():
	print("Failed to connect to server")
	close_connection()
	emit_signal("connection_failed")
	return


remote func login_request(login_data: LoginData):
	var player = get_tree().get_rpc_sender_id()
	print("Authenticating player: %s" % player)
	var result = false
	print("Authentication result: %s" % result)
	rpc_id(player, "login_result", result)
	# kick player if failed to login
	if not result:
		print("Kicking player: %s" % player)
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
