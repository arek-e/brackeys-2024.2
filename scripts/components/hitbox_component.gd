class_name HitboxComponent
extends Area2D

@export var health_component : HealthComponent
@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var collision_shape: CollisionShape2D = $"../CollisionShape2D"

var pushback_force: Vector2 = Vector2.ZERO

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		if animation_tree:
			animation_tree["parameters/conditions/is_hit"] = true


func knockback(source_position: Vector2, attack: Attack):
	#hit_particles.rotation = get_angle_to(source_position) + PI
	pushback_force = -global_position.direction_to(source_position) * attack.knockback


func _physics_process(delta: float) -> void:
	var target = get_owner() as CharacterBody2D
	pushback_force = lerp(pushback_force, Vector2.ZERO, delta * 10)
	target.velocity = pushback_force
	target.move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		if animation_tree:
			animation_tree["parameters/conditions/is_hit"] = false
	
