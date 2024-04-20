extends CharacterBody2D

@export var speed = 100
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var shape_cast = $ShapeCast2D
var is_summoner = false

func _physics_process(delta):
	anim.play("idlemove")
	if shape_cast.is_colliding():
		timer.start()
		anim.speed_scale = 1.5
	move_and_slide()
