extends Node2D

@onready var GPUParticleFire = $GPUParticlesFireIntensity
##fire intesnity, default value 1, good visuals <4
@export var fire_intensity = 1
@onready var campfire_durability = 5
@onready var area = $Area2D 
var particle_mat: ParticleProcessMaterial

func _on_campfire_damaged():
	_update_fire_intensity(1)
		

func _update_fire_intensity(amount):
	print("campfire.gd: campfire damaged!")
	particle_mat.scale_min -= amount
	particle_mat.scale_max -= amount+1
	GPUParticleFire.lifetime -= amount
# Called when the node enters the scene tree for the first time.
func _ready():
	
	particle_mat = GPUParticleFire.process_material
	particle_mat.scale_min = fire_intensity
	particle_mat.scale_max = fire_intensity+1
	GPUParticleFire.lifetime = fire_intensity
	
func _physics_process(delta):
	
	if area.has_overlapping_bodies():
		_on_campfire_damaged()
		var obj = area.get_overlapping_bodies()[0]
		obj.queue_free()
	#add behaviour that adjusts the fire
	pass

