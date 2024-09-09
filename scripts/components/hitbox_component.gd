class_name HitboxComponent
extends Area2D

@export var health_component : HealthComponent
@onready var animated_sprite = $"../AnimatedSprite2D"

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		animated_sprite.play("hit")
