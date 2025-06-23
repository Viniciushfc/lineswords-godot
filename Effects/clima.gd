extends Node2D


@onready var animation: AnimationPlayer = $DayNightCycle/Animation


func _ready():
	animation.play("clima")
