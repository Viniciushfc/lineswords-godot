extends Control
class_name GameOver

@export var game_scene : String = "res://game_level.tscn"

func _on_resume_btn_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
