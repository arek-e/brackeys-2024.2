extends Node

@export var PlayerScene: PackedScene
@export var enemies: Array[PackedScene]

@onready var day_and_night_cycle: Node2D = %DayAndNightCycle
@onready var world_clock: DayAndNightCycle = %DayAndNightCycle.get_node("CanvasModulate")

var rng = RandomNumberGenerator.new()

const PLAYER_SPAWN_POSITION = Vector2(0,0)

const MAX_NUMBER_OF_ENEMIES = 5
const SPAWN_MIN = -100
const SPAWM_MAX = 100

var current_day: int
var current_hour: int
var current_minute: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_clock.time_tick.connect(update_daytime)

	var new_player: Player = PlayerScene.instantiate()
	get_tree().get_root().call_deferred("add_child", new_player)

	new_player.position = PLAYER_SPAWN_POSITION
	
	for i in MAX_NUMBER_OF_ENEMIES:
		var new_enemy = (enemies.pick_random() as PackedScene).instantiate()
		get_owner().get_node("Enemies").add_child(new_enemy)
		var xPos = rng.randi_range(SPAWN_MIN, SPAWM_MAX)
		var yPos = rng.randi_range(SPAWN_MIN, SPAWM_MAX)
		new_enemy.position = Vector2(xPos, yPos)

func update_daytime(day:int, hour: int, minute:int):
	current_day = day
	current_hour = hour
	current_minute = minute
	#print_debug("Day:", day," Hour:", hour, " Minute:", minute)
	
