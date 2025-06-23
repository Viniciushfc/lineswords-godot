extends Node2D
class_name GameLevel

@onready var day_night_modulate := $DayNightModulate
@onready var clock_label := $ClockLabel  
@onready var day := $Modulate

var game_hour: int = 6  # Começa às 6 da manhã
var is_daytime := true
var hour_duration := 2.0  # segundos reais por hora no jogo

func _ready():
	# Cria o timer do relógio
	var clock_timer = Timer.new()
	clock_timer.wait_time = hour_duration
	clock_timer.autostart = true
	clock_timer.timeout.connect(_on_clock_tick)
	add_child(clock_timer)

func _on_clock_tick():
	game_hour = (game_hour + 1) % 24
	update_day_night()
	update_clock_label()
	
func update_day_night():
	if game_hour >= 6 and game_hour < 18:
		# Dia
		is_daytime = true
		day.modulate = Color(1, 1, 1, 1)
	else:
		# Noite
		is_daytime = false
		day.modulate = Color(0.2, 0.2, 0.4, 1)
		
func update_clock_label():
	if clock_label:
		var hour_str = str(game_hour).pad_zeros(2)
		clock_label.text = hour_str + ":00"
