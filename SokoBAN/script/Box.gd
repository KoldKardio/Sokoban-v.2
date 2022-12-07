extends KinematicBody2D

onready var tween = get_node("../../Tween")

var pushin = false

func push(direction, TILE_SIZE):
	if pushin: 
		return
	if test_move(transform, direction): # collision detection to walls
		return
	
	pushin = true
	tween.interpolate_property(
		self, "position", 
		position, position + direction * TILE_SIZE, 
		0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	tween.start()


func _on_Tween_tween_all_completed():
	pushin = false
