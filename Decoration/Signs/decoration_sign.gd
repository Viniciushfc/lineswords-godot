extends DecorationComponent
class_name DecorationSign

func _ready() -> void:
	for _children in get_children():
		if _children is Sprite2D:
			_children.texture = load(_textures_list.pick_random())
