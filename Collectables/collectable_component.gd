extends Area2D
class_name CollectableComponent

@export var item_type: String = ""

func _on_body_entered(_body: Node2D) -> void:
	if _body is BaseCharacter:
		match item_type:
			"madeira":
				GameState.add_score_wood(10)
			"ouro":
				GameState.add_score_gold(50)
			"carne":
				GameState.add_score_meat(25)


		queue_free()
