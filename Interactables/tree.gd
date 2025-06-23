extends StaticBody2D
class_name PhysicsTree

const _HIT_PARTICLES: PackedScene = preload("res://Effects/hit_particles.tscn")
const _WOOD_COLLECTABLE: PackedScene = preload("res://Collectables/wood.tscn")
var _is_dead: bool = false

@export_category("Variables")
@export var _health: int
@export var _min_health: int = 15
@export var _max_health: int = 30
@export var _min_wood: int = 1
@export var _max_wood: int = 5

@export_category("Objects")
@export var _animation: AnimationPlayer

func _ready() -> void:
	_health = randi_range(_min_health, _max_health)
	
func update_health(_damage_range: Array) -> void:
	if _is_dead:
		return
		
	_health -= randi_range(
		_damage_range[0],
		_damage_range[1]
	)
	
	_spawn_particles()
	
	if _health <= 0:
		_spawn_wood()
		_is_dead = true
		_animation.play("Kill")
		return
		
	_animation.play("Hit")
	

func _spawn_wood() -> void:
	var _wood_amount: int = randi_range(_min_wood, _max_wood)
	for _i in _wood_amount:
		var _wood: CollectableComponent = _WOOD_COLLECTABLE.instantiate()
		_wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", _wood)
	
func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "Hit":
			_animation.play("Idle")
			
			
func _spawn_particles() -> void:
	var _hit = _HIT_PARTICLES.instantiate()
	_hit.global_position = global_position + Vector2(32, 32)
	_hit.modulate = Color.SADDLE_BROWN
	_hit.emitting = true
	
	get_tree().root.call_deferred("add_child", _hit)
