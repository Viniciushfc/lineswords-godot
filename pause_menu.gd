extends CanvasLayer

@onready var bg_overlay: ColorRect = $BgOverlay
@onready var h_slider_music: HSlider = $BoxContainer/VBoxContainer/Control/HSliderMusic
@onready var waves: AudioStreamPlayer = $BoxContainer/VBoxContainer/Control/HSliderMusic/Waves



func _ready() -> void:
	visible = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		bg_overlay.grab_focus()

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_save_btn_pressed() -> void:
	pass


func _on_h_slider_music_value_changed(value: float) -> void:
		waves.volume_db = value
