extends Control

func _on_animation_animation_finished(anim_name):
	if anim_name == "fade_out":
		$Animation.play("fade_in")
		
		
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://UI/title_screen.tscn")
