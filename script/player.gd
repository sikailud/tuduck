extends CharacterBody2D

@export_category("horizontal")
@export var speed: float = 420.0
@export_range(0.0, 1.0) var acceleration: float = 0.32
@export_range(0.0, 1.0) var friction: float = 0.2

@export_category("vertical")
@export var jump_velocity: float = -600.0
@export var drop_velocity_max: float = 500.0
@export var drop_acceleration: float = 210.0

var drop_velocity: float = 0.0
var direction: float = 0.0

func _process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += jump_velocity

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		drop_velocity += drop_acceleration * delta
		velocity.y += clamp(drop_velocity, 0.0, drop_velocity_max)
	else:
		drop_velocity = 0

	if direction:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	move_and_slide()

	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().collision_layer & 2:
			print("被抓到啦！")
