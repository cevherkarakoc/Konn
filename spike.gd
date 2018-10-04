extends Area2D



func _on_Area2D_body_entered(body):
	if body.is_in_group("player") :
		$hurtSFX.play(0)
		$Timer.start()


func _on_Timer_timeout():
	get_tree().reload_current_scene()
