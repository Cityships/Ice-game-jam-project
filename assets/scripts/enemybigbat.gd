extends CharacterBody2D

@export var speed = 100
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(delta):
	anim.play("idlemove")
	move_and_slide()
