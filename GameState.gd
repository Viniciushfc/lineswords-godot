extends Node

var volume: float
var player_name: String = ""

var scoreWood: int = 0
var scoreGold: int = 0
var scoreMeat: int = 0




func add_score_wood(value: int) -> void:
	scoreWood += value
	
	print("Score atual de madeira:", scoreWood)
	
func add_score_gold(value: int) -> void:
	scoreGold += value
	
	print("Score atual de ouro:", scoreGold)
		
func add_score_meat(value: int) -> void:
	scoreMeat += value
	
	print("Score atual de Carne:", scoreMeat)
