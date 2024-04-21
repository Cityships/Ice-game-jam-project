extends Node

@onready var timer = $Timer
@onready var campfire = $campfire
@onready var bat_preload = preload("res://assets/prefabs/small_bat_enemy.tscn")
var bat_obj
@export var spawn_count = 3
@export var offset_spawn = 300
@onready var game_over_text = $player/CanvasLayer/GameOverText
@onready var night_timer = $player/CanvasLayer/ProgressBar

func on_no_fire():
	game_over_text.visible = true
	night_timer.visible = false
	
func _on_summon_bats():
	var bat_clone = bat_preload.instantiate()
	bat_clone.position = campfire.position + Vector2(randf_range(-1,1), randf_range(-1, 1))*offset_spawn
	var spawn_seed = randf_range(0,4)
	if spawn_seed >= 2.3:
		bat_clone.make_summoner()
	add_child(bat_clone)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	pass # Replace with function body.

func _on_timer_timeout():
	for i in spawn_count:
		_on_summon_bats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
