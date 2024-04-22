extends Control

@onready var game_manager =  get_parent().get_parent().get_parent()
@onready var timer = $Timer
@onready var texture_progress = $TextureProgressBar
@onready var win_text = $WinLabel
var vignette
var screen_hue
var modulate_alpha_speed = .2
var timer_start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	vignette = parent.get_node("vignette")
	screen_hue = parent.get_node("screen hue")
	win_text.visible = false
	timer.timeout.connect(_on_timer_timeout)
	#timer.start()
	# Replace with function body.

func _on_timer_timeout():
	print("Victory Time")
	win_text.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_manager.WaveNumber > 2:
		timer_start = true
	if timer_start:
		texture_progress.value = texture_progress.max_value - timer.time_left

func _physics_process(delta):
	if timer.time_left < 5 && timer.time_left > -10 && game_manager.WaveNumber > 2:
		var softness = vignette.material.get_shader_parameter("softness")
		vignette.material.set_shader_parameter("softness", softness + modulate_alpha_speed * delta)
		screen_hue.modulate.a -= modulate_alpha_speed * delta
		
