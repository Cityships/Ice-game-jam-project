extends RigidBody2D

@onready var shape_cast = $ShapeCast2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shape_cast.is_colliding():
		queue_free()
		

