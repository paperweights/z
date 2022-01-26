extends Node

# signals to update gui
signal connection_succeeded()
signal connection_failed()

# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const MIN_PORT = 1
const MAX_PORT = 49151
const DEFAULT_PORT = 42069

var peer: NetworkedMultiplayerPeer


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	return


func host_game(port: int, max_clients: int):
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, max_clients)
	get_tree().set_network_peer(peer)
	print("Hosting server")
	return


func join_game(address: String, port: int):
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(address, port)
	get_tree().set_network_peer(peer)
	print("Connecting to server")
	return


func _player_connected(id: int):
	print("Player: " + str(id) + " connected")
	return


func _player_disconnected(id: int):
	print("Player: " + str(id) + " disconnected")
	return


func _connected_ok():
	print("Connected to the server successfully")
	emit_signal("connection_succeeded")
	return


func _connected_fail():
	print("Failed to connect to the server!")
	get_tree().set_network_peer(null)
	emit_signal("connection_failed")
	return
