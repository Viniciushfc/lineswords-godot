extends CharacterBody2D
class_name BaseCharacter


const _HIT_PARTICLES: PackedScene = preload("res://Effects/hit_particles.tscn")

var _can_attack: bool = true
var _attack_animation_name: String = ""

@export_category("Variables")
@export var max_health: int = 100
@export var _move_speed: float = 130.0
@export var _left_attack_name: String = ""
@export var _right_attack_name: String = ""
@export var _attack_area_collision: CollisionShape2D
@export var _min_attack: int = 5
@export var _max_attack: int = 10

@export_category("Objects")
@export var _animation: AnimationPlayer
@export var _sprite2D: Sprite2D
@export var _dust: CPUParticles2D
@export var current_health: int = max_health

@onready var health_bar: ProgressBar = $ProgressBar

func _physics_process(_delta: float) -> void:
	_move()
	_attack()
	_animate()
	

func _move() -> void:
	var _direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	_dust.emitting = false

	var speed_multiplier: float = 1.0
	if Input.is_action_pressed("run"):
		speed_multiplier = 2  

	if _direction:
		_dust.emitting = true

	velocity = _direction * _move_speed * speed_multiplier
	move_and_slide()


func take_damage(damage: int) -> void:
	current_health -= damage
	current_health = max(current_health, 0)
	_update_health_bar()

	if current_health <= 0:
		die()

		
func die() -> void:
	set_physics_process(false)
	set_process(false)
	
	_sprite2D.visible = false
	health_bar.visible = false

	_spawn_particles()
	await get_tree().create_timer(2.0).timeout

	_game_over()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _attack() -> void:
	if Input.is_action_just_pressed("left_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _left_attack_name
		set_physics_process(false)
		

	if Input.is_action_just_pressed("right_attack") and _can_attack:
		_can_attack = false
		_attack_animation_name = _right_attack_name
		set_physics_process(false)
	

func _animate() -> void:
	if velocity.x > 0:
		_sprite2D.flip_h = false
		_attack_area_collision.position.x = 64
		
	if velocity.x < 0:
		_sprite2D.flip_h = true
		_attack_area_collision.position.x = -64
		
	if _can_attack == false:
		_animation.play(_attack_animation_name)
		return
		
	if velocity:
		_animation.play("Run")
		return
		
	_animation.play("Idle")
	

func has_resource(_item_name: String, _amount: int) -> bool:
	return true

func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "attack_axe" or _anim_name == "attack_hammer":
		_can_attack = true
		set_physics_process(true)
	
func update_collision_layer_mask(_type: String) -> void:
	if _type == "in":
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)

		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		
	if _type == "out":
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)

		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)

func _on_attack_area_body_entered(_body: Node2D) -> void:
	if (
		_body is PhysicsTree or 
		_body is Sheep or
		_body is Dead 
		):
		_body.update_health([_min_attack, _max_attack])
		
func _spawn_particles() -> void:
	var _hit = _HIT_PARTICLES.instantiate()
	_hit.global_position = global_position
	_hit.modulate = Color.RED
	_hit.emitting = true
	get_tree().current_scene.add_child(_hit)
	
	
func _game_over() -> void:
	get_tree().change_scene_to_file("res://UI/GameOver.tscn")
