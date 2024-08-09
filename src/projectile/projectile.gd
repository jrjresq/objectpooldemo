extends Area2D
class_name Projectile

const SPEED := 1500.0

####### WARNING This does not get set manually!
## However, it must be included with every poolable scene!
var pool_handle : PackedScene

var direction := Vector2.ZERO
var random_speed := 0.0

func _ready() -> void:
	########NOTE this obejct is never readied.
	## If it did, it would only be called once
	pass

############################### OBJECT POOL FUNCTIONS

func prepare() -> void:
	if not visible:
		show()
	set_process(true)
	set_physics_process(true)

func scrub() -> void:
	hide()
	set_process(false)
	set_physics_process(false)

func exit_scene() -> void:
	if Settings.object_pooling:
		ObjectPool.free_instance(self)
	else:
		queue_free()

############################### Regular functions

func _physics_process(delta: float) -> void:
	position = position.lerp(position + direction * random_speed, delta)

func launch(from : Vector2, rot : float, rando : float = 0.0) -> void:
	global_position = from
	rotation = rot
	random_speed = SPEED * (1-rando)
	direction = Vector2.RIGHT.rotated(rot)

func _on_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		exit_scene()


func _on_area_entered(area: Area2D) -> void:
	exit_scene()
