extends CharacterBody2D

@export var movement_speed: float = 300.0
@export_range(0.0, 1.0) var acceleration = 0.4
@export_range(0.0, 1.0) var friction = 0.2

var movement_direction: Vector2 = Vector2.ZERO
var patrol_direction: Vector2 = Vector2(1.0, 0.0)
var target: Node

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_wall():
		patrol_direction = -patrol_direction

	if target:
		movement_direction = (target.position - position).normalized()
	else:
		movement_direction.x = patrol_direction.x

	if movement_direction:
		velocity.x = lerp(velocity.x, movement_direction.x * movement_speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	move_and_slide()

func _on_view_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body

func _on_view_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
