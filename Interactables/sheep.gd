extends CharacterBody2D
class_name Sheep

const _HIT_PARTICLES: PackedScene = preload("res://Effects/hit_particles.tscn")
const _MEAT_COLLECTABLE: PackedScene = preload("res://Collectables/meat.tscn")

var _is_dead: bool = false


var _health: int
var _wait_time: float
var _run_wait_time: float
var _direction: Vector2

var _regular_move_speed: float

@export_category("Variables")
@export var _move_speed: float = 128.0
@export var _min_health: int = 5
@export var _max_health: int = 15
@export var _min_meet: int = 1
@export var _max_meet: int = 5

@export_category("Objects")
@export var _sprite: Sprite2D
@export var _animation: AnimationPlayer
@export var _walk_timer: Timer
@export var _run_timer: Timer
@export var _dust: CPUParticles2D

func _ready() -> void:
	_regular_move_speed = _move_speed
	_health = randi_range(_min_health, _max_health)
	_wait_time = randf_range(5.0, 15.0)
	_run_wait_time = randf_range(1.0, 3.0)
	_direction = _get_direction()
	_walk_timer.start(_wait_time)

func _physics_process(_delta: float) -> void:
	_dust.emitting = false
	if _direction:
		_dust.emitting = true
	velocity = _direction * _move_speed
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		_direction = velocity.bounce(
			get_slide_collision(0).get_normal()
		).normalized()
		 
	_animate()
	
	
func _animate() -> void:
	if velocity.x > 0:
		_sprite.flip_h = false
	
	if velocity.x < 0:
		_sprite.flip_h = true
		
	if velocity:
		_animation.play("Walk")
		return
		
	_animation.play("Idle")

func update_health(_damage_range: Array) -> void:
	if _is_dead:
		return
		
	_health -= randi_range(
		_damage_range[0],
		_damage_range[1]
	)
	
	_spawn_particles()
	
	if _health <= 0:
		_spawn_meat()
		_is_dead = true
		queue_free()
		return
		
	_direction = _get_direction()
	_run_timer.start(_run_wait_time)
	_move_speed *= 2
	
	
	
func _spawn_meat() -> void:
	var _meat_amount: int = randi_range(_min_meet, _max_meet)
	for _i in _meat_amount:
		var _meat: CollectableComponent = _MEAT_COLLECTABLE.instantiate()
		_meat.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", _meat)

func _get_direction() -> Vector2:
		return [
			Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(0, -1),
			Vector2(1, -1), Vector2(-1, 1), Vector2(0,1), Vector2(1, 1),
			Vector2.ZERO
		].pick_random().normalized()


func _on_walk_timer_timeout() -> void:
	_walk_timer.start(_wait_time)
	if _direction == Vector2.ZERO:
		_direction = _get_direction()
		return
		
	_direction = Vector2.ZERO
	
func _spawn_particles() -> void:
	var _hit = _HIT_PARTICLES.instantiate()
	_hit.global_position = global_position
	_hit.modulate = Color.RED
	_hit.emitting = true
	
	get_tree().root.call_deferred("add_child", _hit)

func _on_run_timer_timeout() -> void:
	_move_speed = _regular_move_speed
