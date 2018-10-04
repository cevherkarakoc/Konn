extends Area2D

export(PackedScene) var next_level

func _on_exit_zone_body_entered(body):
	if body.is_in_group("player") and body.the_part_type == "KEY":
		$exitSFX.play(0)
		$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene_to(next_level)
