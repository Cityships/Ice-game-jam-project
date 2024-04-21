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

func _physics_process(delta):
	
	if shape_cast.is_colliding():
		var obj = shape_cast.get_collider(0)
		
		if Input.is_action_just_pressed("interact") && !holding_item:
			holding_item = true
			obj.get_parent().queue_free()
			held_item.visible = true
			held_item_glow.visible = true
			ItemAnim.play("HoldingStick")
			
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
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
