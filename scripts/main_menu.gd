extends Node

@onready var anim_player: AnimationPlayer = %AnimationPlayer

func _ready():
	$MarginContainer/VBoxContainer/StartButton.grab_focus()
	
func _on_start_button_pressed():
	anim_player.play("pan_into_planet")
	

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pan_into_planet":
		get_tree().change_scene_to_file("res://scenes/main.tscn")
