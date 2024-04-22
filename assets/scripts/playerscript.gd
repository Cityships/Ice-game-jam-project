extends CharacterBody2D


@export var speed: float = 100;
@export var accel: float = 10;
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var held_item = $item/HeldItem
@onready var held_item_glow = $item/HeldItemGlow
@onready var shape_cast = $ItemDetection
@onready var ItemAnim = $ItemAnimationPlayer
var holding_item = false

@export var throw_speed = 1000
@onready var stick_preload = preload("res://assets/prefabs/stick.tscn") 

func _is_holding_item() -> bool:
	return holding_item

func _process(delta):
	
	if holding_item && Input.is_action_just_pressed("throw item"):
		var stick_clone = stick_preload.instantiate() as RigidBody2D
		stick_clone.position = position
		stick_clone.linear_velocity = (get_global_mouse_position() - position).normalized() * throw_speed
		get_parent().add_child(stick_clone)
		holding_item = false
		ItemAnim.play("RESET")
		held_item.visible = false
		held_item_glow.visible = false
		$Throw.play()

func _physics_process(delta):
	
	if shape_cast.is_colliding():
		var obj = shape_cast.get_collider(0)
		
		if Input.is_action_just_pressed("interact") && !holding_item:
			holding_item = true
			obj.queue_free()
			held_item.visible = true
			held_item_glow.visible = true
			ItemAnim.play("HoldingStick")
			$SoundAnimationPlayer.play("PickStickUp")
		
	var direction: Vector2 = Input.get_vector("left","right","up","down")
	
	if direction.x < 0 && !sprite.flip_h:
		sprite.flip_h = true
		sprite.position.x += -40
	elif direction.x > 0 && sprite.flip_h:
		sprite.flip_h = false;
		sprite.position.x = 0

	if (!direction.is_zero_approx()):
		anim.play("walking")
	else:
		anim.play("idle")
	direction = direction.normalized()
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)

	move_and_slide()
