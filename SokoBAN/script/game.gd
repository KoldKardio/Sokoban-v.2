extends Node

var gameEnd = false
var timer = 1 # 1 sec delay
var moves = 0

func _process(delta):
	$moves.text = "Moves:" + str(moves)
	if gameEnd == false:
		var spots = $spots.get_child_count()
		for i in $spots.get_children():
			if i.occupied:
				spots -= 1
				if spots == 0:
					timer -= delta
		if spots == 0 && timer <= 0:
			$AcceptDialog.popup()
			gameEnd = true
	

func _on_AcceptDialog_confirmed():
	get_tree().reload_current_scene()
