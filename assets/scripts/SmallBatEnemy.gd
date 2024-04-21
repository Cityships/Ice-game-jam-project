extends CharacterBody2D

@export var speed = 300
@export var accel = 10
@export var decel = 10
var target_position: Vector2 = Vector2()
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
##the channel timer for casting summon
@onready var timer = $Timer
@onready var chase_buffer
@onready var shape_cast = $ShapeCast2D
@export var is_summoner = true
##range for scaring summoner bats
@export var scare_range = 100
var channeling = false
@onready var channel_anim_speed_ramp = 0.5
var summon_cooldown = 13
@export var max_summon_cooldown = 10
@onready var hit_box = $Hitbox
@onready var ice_cube = $icecube
@onready var offset = Vector2(0, -200)

func channel_summon():
	anim.speed_scale = 1
	timer.start()
	print("Summoning!")

func _on_timer_timeout():
	anim.speed_scale = 1
	anim.play("screech")
	channeling = false
	var rng = RandomNumberGenerator.new()
	summon_cooldown = max_summon_cooldown + rng.randf_range(-2,2)	#logic for summoning more bats

func _defeated():
	self.queue_free()

func _ready():
	if !is_summoner:
		ice_cube.visible = true
		target_position = get_parent().get_node("campfire").position + offset
	timer.timeout.connect(_on_timer_timeout)
	#connect the signal
	
func _physics_process(delta):
	
	if !anim.is_playing():
		anim.play("idlemove")
	var player = get_parent().get_node("player")
	if is_summoner:
		target_position = player.position
	var direction = (target_position - position).normalized()
	
	if channeling:
		anim.speed_scale += channel_anim_speed_ramp * delta
	if summon_cooldown >= 0:
		summon_cooldown -= delta
	#if player.holding_item && position.distance_to(target_position) < scare_range:
	#	anim.play("flyaway")
	if hit_box.is_colliding():
		var object = hit_box.get_collider(0) as RigidBody2D
		if object != null && !(object.linear_velocity.is_zero_approx()):
			anim.play("flyaway")
	
	if is_summoner && anim.current_animation != "screech" && !channeling && position.distance_to(target_position) > 500:	
		if shape_cast.is_colliding() && !channeling && summon_cooldown < 0:
			channeling = true
			channel_summon()
	elif is_summoner:
		direction = Vector2()

	
	
	
	if direction.x < 0 && sprite.flip_h:
		sprite.flip_h = false
	if direction.x > 0 && !sprite.flip_h:
		sprite.flip_h = true
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)	

	move_and_slide()
