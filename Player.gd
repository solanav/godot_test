extends KinematicBody2D

var SERVER_PORT = 4343

var MAX_SPEED = 500
var ACCELERATION = 6000
var motion = Vector2.ZERO
var socket = PacketPeerUDP.new()

func _init():
	randomize()
	socket.listen(randi() % 6000 + 5000)

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
	send_update(str(get_position()))
	get_update()
	
func get_input_axis():
	var axis = Vector2.ZERO
	
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func send_update(coords):
	socket.set_dest_address("127.0.0.1", SERVER_PORT)
	socket.put_packet(coords.to_ascii())
	
func get_update():
	var data = socket.get_packet().get_string_from_ascii()
	print(data)
	data = data.replace("(", "").replace(")", "")
	var data_list = data.split(", ")
	
	if len(data_list) == 2:
		var posx = float(data_list[0])
		var posy = float(data_list[1])
		var other = get_parent().get_node("Other")
		other.position = Vector2(posx, posy)
