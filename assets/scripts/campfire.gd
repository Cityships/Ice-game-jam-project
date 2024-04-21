extends Node2D

@onready var GPUParticleFire = $GPUParticlesFireIntensity
##fire intesnity, default value 1, good visuals <4
@export var fire_intensity = 1
@onready var shape_cast = $ShapeCast2D
var particle_mat: ParticleProcessMaterial

func _update_fire_intensity(amount):
	particle_mat.scale_min = amount
	particle_mat.scale_max = amount+1
	GPUParticleFire.lifetime = amount
# Called when the node enters the scene tree for the first time.
func _ready():
	particle_mat = GPUParticleFire.process_material
	particle_mat.scale_min = fire_intensity
	particle_mat.scale_max = fire_intensity+1
	GPUParticleFire.lifetime = fire_intensity
	
func _physics_process(delta):
	if shape_cast.is_colliding():
		var obj = shape_cast.get_collider(0)
		obj.queue_free()
	#add behaviour that adjusts the fire
	pass

