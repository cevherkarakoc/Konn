extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCELERATON = 50
const MAX_SPEED = 500
const GRAVITY = 20
const JUMP_HEIGHT = -400

var the_part = null
var the_part_type = ""

var motion = Vector2()
var near_parts = []
var focus_index = 0

func _ready():
	$main_shape.shape.extents = Vector2(50, 50)

func _physics_process(delta):
	var jump_height = JUMP_HEIGHT
	var gravity = GRAVITY
	
	if the_part_type == "JUMPER" :
		jump_height *= 1.5
	elif the_part_type == "ANTIG" :
		gravity = -1
	
	motion.y += gravity
	
	if Input.is_action_pressed("right"):
		motion.x = min(motion.x + ACCELERATON, MAX_SPEED)
	elif Input.is_action_pressed("left"):
		motion.x = max(motion.x - ACCELERATON, -MAX_SPEED)
	else:
		motion.x = lerp(motion.x, 0, 0.1)
	
	if is_on_floor():
		if Input.is_action_pressed("up"):
			motion.y = jump_height
			$jumpSFX.play(0)
	
	if Input.is_action_just_released("focus"):
		focus_index += 1

	update_focus()
	if Input.is_action_just_released("connect"):
		if the_part == null:
			if near_parts.size() > 0:
				konnect()
		elif !is_on_floor():
			diskonnect()
	
	motion = move_and_slide(motion, UP)
	
	update_line()

func konnect():
	$konnSFX.play(0)
	
	var body = near_parts[ focus_index ]
	the_part = load(body.part).instance()
	the_part_type = the_part.type
	
	$main_shape.shape.extents = Vector2(50, 70)
	$main_shape.move_local_y(20)
	
	the_part.move_local_y(70)

	body.queue_free()
		
	add_child (the_part)

func diskonnect():
	$dekonnSFX.play(0)
	
	var ex_part = load(the_part.part).instance()
	ex_part.move_local_x(get_position().x)
	ex_part.move_local_y(get_position().y + 100)
	get_parent().add_child( ex_part )
	ex_part.add_force(Vector2(40,0), Vector2(0, 300))
	
	the_part.queue_free()
	the_part = null
	the_part_type = ""
	
	$main_shape.shape.extents = Vector2(50, 50)
	$main_shape.move_local_y(-20)

func update_line():
	var target = Vector2(0, 0)
	if the_part == null && near_parts.size() > focus_index:
		target = near_parts[focus_index].get_position() - get_position()
	$line.set_point_position(1, target)

func update_focus():
	if focus_index >= near_parts.size():
		focus_index = 0

func _on_Area2D_body_entered(body):
	if(body.is_in_group("parts")):
		near_parts.append( body)

func _on_Area2D_body_exited(body):
	if(body.is_in_group("parts")):
		var index = near_parts.find( body )
		near_parts.remove(index)
