extends CanvasModulate


@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("day_cycle")
