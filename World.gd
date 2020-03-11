extends Node2D

const Other = preload("res://Other.tscn")

var SERVER_PORT = 4343
var socket = PacketPeerUDP.new()

var other_list = {}

func _init():
	randomize()
	var rand_port = randi() % 60000 + 5000
	socket.listen(rand_port)

func _process(delta):
	var pos = get_node("Player").get_position()
	send_update(str(pos))
	get_update()

func get_update():
	var data = socket.get_packet().get_string_from_ascii()
	print(data)
	var data_list = data.split(",")
	
	if len(data_list) == 3:
		var id = data_list[0]
		var posx = float(data_list[1])
		var posy = float(data_list[2])
		
		print(id, posx, posy)
		
		if other_list.has(id):
			other_list[id].position = Vector2(posx, posy)
		else:
			# Create a new other
			var new_other = Other.instance()
			new_other.name = id
			new_other.visible = true
			get_parent().add_child(new_other)
			new_other.position = Vector2(posx, posy)
			other_list[id] = new_other
	
func send_update(coords):
	socket.set_dest_address("127.0.0.1", SERVER_PORT)
	socket.put_packet(coords.to_ascii())
