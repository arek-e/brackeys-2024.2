extends CharacterBody2D

@export var TOOL_RESOURCE: ToolResource
@export var SPEED: float = 150.0
@export var SPRINT_SPEED: float = 300.0
@export var ACCELERATION: float = 2.0
@export var BREAK_FORCE: float = 5.0
@export var HAND_RADIUS: float = 10.0
@export var HAND_LERP_SPEED: float = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand: Node2D = $Hand
@onready var mouse_cursor: Marker2D = $MouseCursor

var input: Vector2
var last_input_direction: Vector2 = Vector2.RIGHT # Default to facing right
var snap_angles: Array[float]     = [45, 135, 225, 315] # These correspond to NE, SE, SW, and NW
var directions: Array[String]     = [ "se", "sw", "nw", "ne" ]

func get_input() -> Vector2:
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()


func _process(delta: float) -> void:
	var player_input: Vector2 = get_input()

	# Determine the speed based on whether the sprint button is pressed
	var current_speed      = SPEED
	var is_sprinting: bool = Input.is_action_pressed("sprint")
	if is_sprinting:
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
	update_sprite_flip(is_sprinting)

	# Play animations based on the current speed and velocity
	play_animations()

	# Move the character based on input
	move_and_slide()

	# Update the mouse cursor and hand positions
	update_mouse_cursor()
	if is_sprinting and animation_player.current_animation != "sprinting" and velocity.length() > 0.5:
		animation_player.queue("sprinting")
	elif animation_player.current_animation != "sprinting":
		var new_target_hand_position = calculate_hand_position()
		hand.position = lerp(hand.position, new_target_hand_position, HAND_LERP_SPEED * delta)



func update_sprite_flip(is_sprinting: bool) -> void:
	if is_sprinting:
		if last_input_direction.x < 0:
			animated_sprite.flip_h = true
			if animation_player.current_animation == "sprinting":
				hand.get_node("ToolSprite").z_index = 1  
				hand.get_node("ToolSprite").flip_h = true
		else:
			animated_sprite.flip_h = false
			if animation_player.current_animation == "sprinting":
				hand.get_node("ToolSprite").z_index = 1  
				hand.get_node("ToolSprite").flip_h = false
	else:
		# Determine flip based on hand position
		var direction_to_hand = (hand.global_position - global_position).normalized()
		var angle             = rad_to_deg(direction_to_hand.angle())
		if angle < 0:
			angle += 360

		var nearest_angle_index = get_nearest_angle_index(angle)
		var direction_string    = get_direction_from_index(nearest_angle_index)

		# Flip the sprite based on hand direction
		if direction_string == "sw" or direction_string == "nw":
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false


func adjust_tool_z_index(nearest_angle_index: float) -> void:
	# Set the z_index to a lower value (behind player) if angle is in the north range (315° to 45°)
	var direction_string = get_direction_from_index(nearest_angle_index)
	if  direction_string == "nw" or direction_string == "ne":
		hand.get_node("ToolSprite").z_index = -1  # Behind the player
	else:
		hand.get_node("ToolSprite").z_index = 1  # In front of the player		


func play_animations() -> void:
	if velocity.length() < 0.1 or input.length() == 0:
		animated_sprite.play("idle")
	elif Input.is_action_pressed("sprint") and velocity.length() > 0.1:
		animated_sprite.play("run")
	else:
		animated_sprite.play("walk")


func update_mouse_cursor() -> void:
	var mouse_position_relative_to_player = get_global_mouse_position() - global_position
	mouse_cursor.position = mouse_position_relative_to_player


func calculate_hand_position() -> Vector2:
	var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
	var angle              = rad_to_deg(direction_to_mouse.angle())

	# Normalize the angle to the range 0° to 360°
	if angle < 0:
		angle += 360

	# Get the nearest angle index
	var nearest_angle_index = get_nearest_angle_index(angle)

	rotate_tool(nearest_angle_index)

	# Snap the angle to the nearest of the snap_angles
	var closest_angle = snap_angles[nearest_angle_index]
	adjust_tool_z_index(nearest_angle_index)

	# Convert the closest snapped angle to radians for positioning
	var snapped_angle_radians = deg_to_rad(closest_angle)

	# Calculate the target position for the hand based on the snapped angle and HAND_RADIUS
	return Vector2(
		cos(snapped_angle_radians) * HAND_RADIUS,
		sin(snapped_angle_radians) * HAND_RADIUS
	)


func get_nearest_angle_index(angle: float) -> int:
	var closest_index      = 0
	var closest_difference = abs(snap_angles[0] - angle)

	for i in range(snap_angles.size()):
		var difference = abs(snap_angles[i] - angle)
		if difference < closest_difference:
			closest_difference = difference
			closest_index = i

	return closest_index


func get_direction_from_index(index: int) -> String:
	if index >= 0 and index < directions.size():
		return directions[index]
	return ""


func rotate_tool(nearest_angle_index: int) -> void:
	if TOOL_RESOURCE and TOOL_RESOURCE.tool_sprite_attributes.size() > 0:
		var tool_sprite_attributes: ToolSpriteAttributes = TOOL_RESOURCE.tool_sprite_attributes[nearest_angle_index]
		hand.get_node("ToolSprite").rotation = tool_sprite_attributes.rotation
		hand.get_node("ToolSprite").flip_h = tool_sprite_attributes.flip_h
		hand.get_node("ToolSprite").flip_v = tool_sprite_attributes.flip_v
