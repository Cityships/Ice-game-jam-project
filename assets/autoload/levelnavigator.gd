extends Node

var current_scene = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	#pass # Replace with function body.
func goto_scene(path):
	call_deferred("_deffered_goto_scene", path)

func _deffered_goto_scene(path):
	current_scene.free()
	var loadedscene = ResourceLoader.load(path)
	current_scene = loadedscene.instantiate()
	get_tree().root.add_child(current_scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
