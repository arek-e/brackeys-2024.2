extends CharacterBody2D

@export var SPEED: float = 150.0
@export var SPRINT_SPEED: float = 300.0
@export var ACCELERATION: float = 2.0
@export var BREAK_FORCE: float = 5.0
@export var STAMINA_REGEN_RATE: float = 10.0  # Stamina per second to regen
@export var STAMINA_DRAIN_RATE: float = 20.0  # Stamina drain per second when sprinting

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar: ProgressBar = $"../Healthbar"
@onready var staminabar: ProgressBar = $"../Staminabar"

var input: Vector2
var last_input_direction: Vector2 = Vector2.RIGHT # Default to facing right
var hp: int = 100
var stamina: float = 100.0
var idle_timer: float = 0.0
var is_idle: bool = false

func stamina_ready():
	staminabar.max_value = 100
	staminabar.min_value = 0
	staminabar.value = stamina

func hp_ready():
	healthbar.max_value = 100
	healthbar.value = hp
	
func on_stamina_usage(amount: float) -> void:
	stamina -= amount
	if stamina < 0:
		stamina = 0
	staminabar.value = stamina

func on_stamina_regen(amount: float) -> void:
	stamina += amount
	if stamina > 100:
		stamina = 100
	staminabar.value = stamina

func on_hp_subtract(damage: int) -> void:
	hp -= damage
	healthbar.value = hp
	if(hp <= 0):
		game_over()

func game_over() -> void:
	print("Restarting game...")
	get_tree().reload_current_scene()

func get_input() -> Vector2:
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

func _process(delta: float) -> void:
	var player_input: Vector2 = get_input()
	var current_speed = SPEED
	
	# Handle sprinting and stamina
	if Input.is_action_pressed("sprint") and stamina > 0:
		current_speed = SPRINT_SPEED
		on_stamina_usage(STAMINA_DRAIN_RATE * delta)
	else:
		if !Input.is_action_pressed("sprint"):
				on_stamina_regen(STAMINA_REGEN_RATE * delta)
		else:
			idle_timer = 0.0
	
	# Check if the player is idle
	is_idle = player_input.length() == 0
	
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
