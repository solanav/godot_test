extends KinematicBody2D

var MAX_SPEED = 100
var ACCELERATION = 6000
var motion = Vector2.ZERO
onready var ANI = get_node("Sprite/AnimationPlayer")

func _physics_process(delta):
	var axis = get_input_axis()
	
	if axis == Vector2.LEFT:
		ANI.play("left")
	elif axis == Vector2.RIGHT:
		ANI.play("right")
	elif axis == Vector2.DOWN:
		ANI.play("down")
	elif axis == Vector2.UP:
		ANI.play("up")
		
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
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
