extends Node

@onready var campfire = $campfire
@onready var bat_preload = preload("res://assets/prefabs/small_bat_enemy.tscn")
@onready var stick_preload = preload("res://assets/prefabs/stick.tscn")
var bat_obj

@export var bat_spawn_count = 3
@export var bat_offset_spawn = 300

@export var stick_spawn_count = 3
@export var stick_offset_spawn = 1500

@onready var game_over_text = $player/CanvasLayer/GameOverText
@onready var night_timer = $player/CanvasLayer/ProgressBar
var game_started = false
@onready var minus_plus = [1, -1]
# minus_plus used to switch polarity
# I want to avoid spawning bats close to the campfire
# So I'm going to stop randf from from giving me values near 0

@onready var LabelText = $TutorialText
@onready var WaveTimer = $WaveTimer

@onready var WaveNumber = -1

@onready var BatSpawnTimer = $BatSpawnTimer
@onready var StickSpawnTimer = $StickSpawnTimer

@export_range(0, 1) var summoner_spawn_chance = 0.0
#summoner_spawn_chance is used in bat_spawn func

func on_no_fire():
	game_over_text.visible = true
	night_timer.visible = false
	
func _on_summon_bats():
	#signal connection from summoner bats
	
	var bat_clone = bat_preload.instantiate()
	print("Bat summoned")
	bat_clone.position = $player.position + Vector2(minus_plus[randi_range(0, 1)] * randf_range(0.6,1), minus_plus[randi_range(0, 1)] * randf_range(0.6, 1))*700
	add_child(bat_clone)
	
	pass

func _bat_spawn():
	var bat_clone = bat_preload.instantiate()
	#print("Bat spawned")
	bat_clone.position = campfire.position + Vector2(minus_plus[randi_range(0, 1)] * randf_range(0.6,1), minus_plus[randi_range(0, 1)] * randf_range(0.6, 1))*bat_offset_spawn
	var spawn_seed = randf_range(0,1)
	if spawn_seed <= summoner_spawn_chance:
		bat_clone.is_summoner = true
	add_child(bat_clone)
	
	pass

func _stick_spawn():
	
	var stick_clone = stick_preload.instantiate()
	stick_clone.position = campfire.position + Vector2(minus_plus[randi_range(0, 1)] * randf_range(0.4,1), minus_plus[randi_range(0, 1)] * randf_range(0.4, 1))*stick_offset_spawn
	stick_clone.rotation = randf_range(-90, 50)
	#print("stick spawned at", stick_clone.position)
	add_child(stick_clone)
	$StickSpawnSound.play()
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	$BatSpawnTimer.timeout.connect(_on_BatSpawnTimer_timeout)
	$StickSpawnTimer.timeout.connect(_on_StickSpawnTimer_timeout)
	
	LabelText.text = "WASD or arrow keys to move.
Spacebar to pick up sticks."
	
	pass # Replace with function body.

func _on_BatSpawnTimer_timeout():
	#print("Bat spawn time!")
	
	_bat_spawn()
	
	pass

func _on_StickSpawnTimer_timeout():
	
	_stick_spawn()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if WaveNumber >=2 && !game_started:
		$player/CanvasLayer/ProgressBar/Timer.start()
		game_started = true
		
	if WaveNumber == -1 and $player.holding_item:
		LabelText.text = "Left click to throw sticks.
		Add sticks to your campfire"
		WaveNumber += 1
	
	if WaveNumber == 0 and !$player.holding_item:
		LabelText.text = "Bats will damage your campfire"
		stick_offset_spawn = 500
		WaveTimer.start(20)
		BatSpawnTimer.start(7)
		StickSpawnTimer.start(5)
		WaveNumber = 1
	
	#print(WaveTimer.get_time_left())
	
	pass


func _on_wave_timer_timeout():
	
	# Total time of all timed waves is 219 seconds right now.
	# Need to adjust timer/progress for the Progress Bar to match
	# or start with the wave.
	# But you could reasonable leave 20-30 seconds extra and autoplay
	# I think it will be perfectly okay!
	
	# Numbers displayed ot runtime are representing
	# BatSpawnTimer and StickSpawnTimer respectively.
	# That's how I've balanced the waves.
	WaveNumber += 1
	print("Wave ", WaveNumber," start!")
	
	if WaveNumber == 2:
		LabelText.text = "Throw sticks at the bats."
		WaveTimer.start(15)
		stick_offset_spawn = 1000
		pass
	
	if WaveNumber == 3:
		LabelText.text = "Some bats summon more bats.
		Don't let them screech."
		summoner_spawn_chance = 1
		stick_offset_spawn = 1500
		WaveTimer.start(20)
		pass
	
	if WaveNumber == 4:
		LabelText.text = "Good luck!"
		BatSpawnTimer.start(6)
		StickSpawnTimer.start(5)
		summoner_spawn_chance = 0.3
		stick_offset_spawn = 2000
		WaveTimer.start(10)
		pass
	
	if WaveNumber == 5:
		LabelText.text = ""
		BatSpawnTimer.start(4)
		StickSpawnTimer.start(6)
		stick_offset_spawn = 1000
		WaveTimer.start(20)
		pass
	
	if WaveNumber == 6:
		#LabelText.text = "2, 2.2"
		BatSpawnTimer.start(2)
		StickSpawnTimer.start(2.2)
		stick_offset_spawn = 1500
		summoner_spawn_chance = 0.8
		WaveTimer.start(8)
		pass
	
	if WaveNumber == 7:
		#LabelText.text = "3, 2"
		BatSpawnTimer.start(3)
		StickSpawnTimer.start(2)
		stick_offset_spawn = 700
		summoner_spawn_chance = 0
		WaveTimer.start(15)
		pass
	
	if WaveNumber == 8:
		#LabelText.text = "4, 2"
		BatSpawnTimer.start(4)
		StickSpawnTimer.start(2)
		stick_offset_spawn = 1000
		summoner_spawn_chance = 0.0
		WaveTimer.start(20)
		pass
	
	if WaveNumber == 9:
		#LabelText.text = "4.6, 4"
		BatSpawnTimer.start(4.6)
		StickSpawnTimer.start(4)
		stick_offset_spawn = 2000
		summoner_spawn_chance = 0.3
		WaveTimer.start(15)
		pass
	
	if WaveNumber == 10:
		#LabelText.text = "4, 6"
		BatSpawnTimer.start(4)
		StickSpawnTimer.start(6)
		summoner_spawn_chance = 0.5
		WaveTimer.start(15)
		pass
	
	if WaveNumber == 11:
		#LabelText.text = "3, 2"
		BatSpawnTimer.start(3)
		StickSpawnTimer.start(2)
		stick_offset_spawn = 1000
		summoner_spawn_chance = 0.8
		WaveTimer.start(15)
		pass
	
	if WaveNumber == 11:
		#LabelText.text = "1.3, 2"
		BatSpawnTimer.start(1.3)
		StickSpawnTimer.start(2)
		stick_offset_spawn = 1000
		WaveTimer.start(13)
		pass
	
	if WaveNumber == 12:
		#LabelText.text = "5, 2.5"
		BatSpawnTimer.start(5)
		StickSpawnTimer.start(2.5)
		stick_offset_spawn = 1000
		WaveTimer.start(10)
		summoner_spawn_chance = 0
		pass
	
	if WaveNumber == 13:
		LabelText.text = "Almost there."
		BatSpawnTimer.start(1.6)
		StickSpawnTimer.start(1.5)
		stick_offset_spawn = 1200
		WaveTimer.start(20)
		summoner_spawn_chance = 0.5
		pass
	
	if WaveNumber == 14:
		LabelText.text = ""
		BatSpawnTimer.stop()
		StickSpawnTimer.stop()
		WaveTimer.stop()
		pass
	
	print("Wave duration: ", WaveTimer.get_time_left())
	
	pass # Replace with function body.
