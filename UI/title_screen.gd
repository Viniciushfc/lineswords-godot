extends Control
class_name TitleScreen

@onready var color_rect: ColorRect = $ColorRect
@export var game_scene : String
@onready var musica_home: AudioStreamPlayer = $MarginContainer3/VBoxContainer/CanvasLayer/MusicaHome
@onready var h_slider_music: HSlider = $MarginContainer3/VBoxContainer/CanvasLayer/Control/HSliderMusic
@onready var name_input: LineEdit = $MarginContainer2/VBoxContainer2/Control/LineEdit
@onready var confirm_button: Button = $MarginContainer2/VBoxContainer2/Control/Button
var player_name: String 

func _on_start_btn_pressed() -> void:
	#get_tree().change_scene_to_file(game_scene)
	SceneLoader.load_scene(game_scene)

func _on_saves_game_pressed() -> void:
	pass # Replace with function body.

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
func _on_animation_animation_finished(_anim_name: StringName) -> void:
	color_rect.visible = false

func _on_h_slider_music_value_changed(value: float) -> void:
	musica_home.volume_db = value




func _on_button_pressed() -> void:
	GameState.player_name = name_input.text  
	print("Nome do jogador:", GameState.player_name)
	get_tree().change_scene_to_file("res://Scenes/GameLevel.tscn")
	
	
