extends CollisionPolygon2D

var vertice_vector 
var polygon_visual
# Called when the node enters the scene tree for the first time.
func _ready():
	vertice_vector = polygon
	polygon_visual = get_child(0) as Polygon2D
	for vertex in vertice_vector:
		print("Vertex: ", vertex)
	print("child: ", polygon_visual)
	polygon_visual.polygon = vertice_vector
	
