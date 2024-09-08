extends CharacterBody2D


@export var SPEED: float = 150.0
@export var SPRINT_SPEED: float = 300.0
@export var ACCELERATION: float = 2.0
@export var BREAK_FORCE: float = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var input: Vector2
var last_input_direction: Vector2 = Vector2.RIGHT # Default to facing right

func get_input() -> Vector2:
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

func _process(delta: float) -> void:
	var player_input: Vector2 = get_input()

	# Determine the speed based on whether the sprint button is pressed
	var current_speed = SPEED
	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED

	# If player gives input, update the last input direction
	if player_input.length() > 0:
		last_input_direction = player_input

	# Adjust velocity based on the current speed
	velocity = lerp(velocity, player_input * current_speed, ACCELERATION * delta)

	# If there is no input, break the velocity fast
	if player_input.length() == 0:
		velocity = lerp(velocity, Vector2.ZERO, BREAK_FORCE * delta)

	# Flip the sprite based on the last non-zero input direction
	if last_input_direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

	# Play animations based on the current speed and velocity
	if velocity.length() < 0.1 or player_input.length() == 0:
		animated_sprite.play("idle")
	elif Input.is_action_pressed("sprint") and velocity.length() > 0.1:
		animated_sprite.play("run")
	else:
		animated_sprite.play("walk")

	move_and_slide()
