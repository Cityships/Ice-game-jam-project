extends Node2D

@onready var sprite = $Sprite2D
@onready var glow = $ItemGlow
@onready var shape_cast = $ShapeCast2D
@export var modulate_speed = 1
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shape_cast.is_colliding() && glow.modulate.a <= 1:
		glow.modulate += Color(0,0,0,modulate_speed * delta)
	if !shape_cast.is_colliding() && glow.modulate.a > 0:
		glow.modulate -= Color(0,0,0, modulate_speed * delta)
