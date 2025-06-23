extends CanvasLayer

func _process(_delta):
	$ScoreLabelWood.text = str(GameState.scoreWood)
	$ScoreLabelGold.text = str(GameState.scoreGold)
	$ScoreLabelMeat.text = str(GameState.scoreMeat)
