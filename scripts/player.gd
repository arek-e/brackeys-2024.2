extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const ACCELERATION = 2.0
const BREAK_FORCE = 5.0

var input: Vector2
var last_input_direction: Vector2 = Vector2.RIGHT # Default to facing right

func get_input() -> Vector2:
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

func _process(delta: float) -> void:
	var player_input: Vector2 = get_input()

	# If player gives input, update the last input direction
	if player_input.length() > 0:
		last_input_direction = player_input
	
	velocity = lerp(velocity, player_input * SPEED, ACCELERATION * delta)
	
	# If there is no input, break the velocity fast
	if player_input.length() == 0:
		# Deaccelerate
		velocity = lerp(velocity, Vector2.ZERO, BREAK_FORCE * delta)

	# Flip the sprite based on the last non-zero input direction
	if last_input_direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	# If the player velocity is zero, play the idle animation
	if velocity.length() < 0.1 or player_input.length() == 0:
		animated_sprite.play("idle")
	elif velocity.length() > 0:
		animated_sprite.play("walk")
	elif velocity.length() > 0.5:
		animated_sprite.play("run")



	move_and_slide()
