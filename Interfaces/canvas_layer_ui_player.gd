extends CanvasLayer
@onready var label: Label = $PlayerNameLabel

func _ready():
	label.text = "Nome: " + GameState.player_name
