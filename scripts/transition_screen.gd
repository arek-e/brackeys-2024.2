extends CanvasLayer

signal on_animation_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
func _on_animation_finished(anim_name: String):
	if anim_name == "fade_to_black":
		on_animation_finished.emit()
		animation_player.play("fade_to_normal")
	if anim_name == "fade_to_normal":
		color_rect.visible = false
