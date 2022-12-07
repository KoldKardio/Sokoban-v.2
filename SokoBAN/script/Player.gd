extends KinematicBody2D

onready var ray = $RayCast2D

export var walk_speed = 4.0
const TILE_SIZE = 16

var init_position = Vector2.ZERO
var input_direction = Vector2.ZERO
var is_moving = false
var move_to_tile = 0.0

# main #
func _ready():
	init_position = position
	pass

# called per frame.. #
func _physics_process(delta):
	
	if !is_moving:
		player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else: is_moving = false
	
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	

# player_inputs #
func player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	
	if input_direction != Vector2.ZERO:
		init_position = position
		is_moving = true
	
	pass

# move #
func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.cast_to = desired_step
	ray.force_raycast_update()
	
	# check collision
	if !ray.is_colliding():
		move_to_tile += walk_speed * delta
		if move_to_tile >= 1.0:
			position = init_position + (TILE_SIZE * input_direction)
			move_to_tile = 0
			is_moving = false
			#move counter
			get_parent().moves += 1
			
		else:
			position = init_position + (TILE_SIZE * input_direction * move_to_tile )
		
	else:
		is_moving = false
		var node = ray.get_collider()
#		print("Player is in collision!...:", ray.get_collider()) # obtain the data on collider
		if node is KinematicBody2D: # id node is is_in_group('box') - using group method
			get_parent().moves += 1
			node.push(input_direction, TILE_SIZE)
	pass
