extends Control

@onready var restart_button = $RestartButton

func _ready():
	visible = false  

func show_game_over():
	visible = true
	get_tree().paused = true  

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().reload_current_scene()# Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
