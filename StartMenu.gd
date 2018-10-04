extends Control

export(PackedScene) var first_level

func _on_Button_pressed():
	get_tree().change_scene_to(first_level)
