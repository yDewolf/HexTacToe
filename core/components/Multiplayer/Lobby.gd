extends Node
class_name MultiLobby

const PORT = 7777
const MAX_CLIENTS = 2
const IP_ADDRESS = "127.0.0.1"

var peer: ENetMultiplayerPeer
signal created_peer()

func _exit_tree() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

func create_server():
	if peer != null:
		print("Can't start two peers on one instance")
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	self.peer.peer_connected.connect(_on_peer_connected)
	self.peer.peer_disconnected.connect(_on_peer_disconnected)
	self.created_peer.emit()

func create_client():
	if peer != null:
		print("Can't start two peers on one instance")
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
	self.peer.peer_connected.connect(_on_peer_connected)
	self.peer.peer_disconnected.connect(_on_peer_disconnected)
	self.created_peer.emit()


func _on_peer_connected(id: int):
	print(id, " joined")

func _on_peer_disconnected(id: int):
	print(id, " left")
