extends CharacterBody2D
class_name Player

const DEADZONE_SQUARED := 0.1
const MAX_SPEED := 500.0
const ACCELERATION := 2500.0
const FRICTION := 2500.0
const BPS := 8.0

@export var payload := preload("res://src/projectile/projectile.tscn")
@export var spread := PI/4
@export var speed_randomness := 0.25

@onready var marker : Marker2D = $Marker2D

var look_target : Vector2 = Vector2.RIGHT
var projectile_parent : Node2D
var trigger_timer : Timer

func _ready() -> void:
	projectile_parent = get_tree().get_current_scene().get_node('Projectiles')
	
	if not projectile_parent:
		projectile_parent = self
	
	trigger_timer = Timer.new()
	trigger_timer.set_one_shot(true)
	add_child(trigger_timer)
	

func _process(delta: float) -> void:
	if Input.is_action_pressed('player_fire') and trigger_timer.is_stopped():
		for _i in range(Settings.bullets):
			var bullet : Projectile
			
			if Settings.object_pooling:
				bullet = ObjectPool.instance(payload)
				if not bullet.get_parent():
					projectile_parent.add_child(bullet)
			else:
				bullet = payload.instantiate()
				projectile_parent.add_child(bullet)
			
			bullet.launch(
				marker.global_position, 
				global_rotation + randf_range(-spread, spread), 
				randf_range(0.0, speed_randomness)
			)
		
		trigger_timer.start(1.0/BPS)


func _physics_process(delta: float) -> void:
	
	
	################## MOVEMENT STUFF
	var input_dir := Input.get_vector("move_left","move_right","move_up","move_down").normalized()

	if input_dir.length_squared() >= DEADZONE_SQUARED:
		velocity = velocity.move_toward(input_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	
	
	################## ROTATION STUFF
	
	look_at(look_target)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_target = get_global_mouse_position()

func reset_position() -> void:
	global_position = Vector2.ZERO
