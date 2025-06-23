extends CharacterBody2D
class_name Dead

var _is_dead: bool = false

const _HIT_PARTICLES: PackedScene = preload("res://Effects/hit_particles.tscn")

var _health: int
var _wait_time: float
var _run_wait_time: float
var _direction: Vector2

var _regular_move_speed: float

@export_category("Variables")
@export var _move_speed: float = 128.0
@export var _min_health: int = 5
@export var _max_health: int = 15

@export_category("Objects")
@export var _sprite: Sprite2D
@export var _animation: AnimationPlayer
@export var _walk_timer: Timer
@export var _run_timer: Timer
@export var _dust: CPUParticles2D

@onready var attack_area: Area2D = $AttackArea
@export var attack_damage: int = 50
@export var attack_cooldown: float = 2.0
var can_attack: bool = true


func _ready() -> void:
	_regular_move_speed = _move_speed
	_health = randi_range(_min_health, _max_health)
	_wait_time = randf_range(5.0, 15.0)
	_run_wait_time = randf_range(1.0, 3.0)
	_direction = _get_direction()
	_walk_timer.start(_wait_time)

func _physics_process(delta: float) -> void:
	_dust.emitting = false

	if _direction:
		_dust.emitting = true

	velocity = _direction * _move_speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		_direction = _direction.bounce(collision.get_normal()).normalized()

	_animate()

func _animate() -> void:
	if _animation.is_playing() and _animation.current_animation == "Hit":
		return
	if velocity.x > 0:
		_sprite.flip_h = false
	elif velocity.x < 0:
		_sprite.flip_h = true

	if velocity.length() > 0:
		_animation.play("Idle")
	else:
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
		_animation.play("dead")
		_is_dead = true
		queue_free()
		return
		
	_direction = _get_direction()
	_run_timer.start(_run_wait_time)
	_move_speed *= 2

func _get_direction() -> Vector2:
	return [
		Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(0, -1),
		Vector2(1, -1), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1),
		Vector2.ZERO
	].pick_random().normalized()

func _on_walk_timer_timeout() -> void:
	_walk_timer.start(_wait_time)
	if _direction == Vector2.ZERO:
		_direction = _get_direction()
	else:
		_direction = Vector2.ZERO

func _spawn_particles() -> void:
	var _hit = _HIT_PARTICLES.instantiate()
	_hit.global_position = global_position
	_hit.modulate = Color.RED
	_hit.emitting = true
	get_tree().root.call_deferred("add_child", _hit)

func _on_run_timer_timeout() -> void:
	_move_speed = _regular_move_speed


func _on_attack_area_body_entered(body: Node2D) -> void:
	if can_attack and body.is_in_group("player"):  
		can_attack = false
		body.take_damage(attack_damage) 
		print("Acertou o player!")
		_animation.play("Hit")
		await get_tree().create_timer(2.0).timeout
		can_attack = true
