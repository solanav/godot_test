extends Area2D

func _init():
	print("Sending message")
	var socket = PacketPeerUDP.new()
	
	socket.set_dest_address("127.0.0.1", 4343)
	socket.put_packet("quit".to_ascii())
