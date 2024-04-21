extends Node2D

@onready var GPUParticleFire = $GPUParticlesFireIntensity
##fire intesnity, default value 1, good visuals <4
@export var fire_intensity = 2
@export_range(0, 10, 1) var campfire_durability
@onready var area = $IceCheckArea
var particle_mat: ParticleProcessMaterial

#func _on_campfire_damaged():
	
	#_update_fire_intensity(1)
		

func _update_fire_intensity(amount):
	
	
	if fire_intensity < campfire_durability:
		fire_intensity += amount
	
	#I'm using campfire_durability as a kind of max health.
	#fire_intensity is the current health and it determines the state of particles.
	
	fire_intensity = clampi(fire_intensity, 0, campfire_durability)
	
	if fire_intensity == 0:
		particle_mat.scale_min = 0
		particle_mat.scale_max = 0
		GPUParticleFire.lifetime = 0
		print("campfire is out")
		pass
	
	#print("campfire.gd: campfire damaged!")
	
	if fire_intensity > 0:
		particle_mat.scale_min += amount
		particle_mat.scale_max += amount
		GPUParticleFire.lifetime += amount
	
	#print("lifetime=", GPUParticleFire.lifetime," scale_min=", particle_mat.scale_min, " scale_max=", particle_mat.scale_max, " health=", fire_intensity)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	particle_mat = GPUParticleFire.process_material
	particle_mat.scale_min = fire_intensity
	particle_mat.scale_max = fire_intensity+1
	GPUParticleFire.lifetime = fire_intensity
	
	
func _physics_process(delta):
	
	if $IceCheckArea.has_overlapping_bodies():
		_update_fire_intensity(-1)
		var obj = $IceCheckArea.get_overlapping_bodies()[0]
		$FireFizz.play(0)
		obj.queue_free()
	
	if $StickCheckArea.has_overlapping_bodies():
		_update_fire_intensity(1)
		var obj = $StickCheckArea.get_overlapping_bodies()[0]
		$AnimationPlayer.play("FireStickAdd")
		obj.queue_free()
	
	fireloop_volume()
	
	#add behaviour that adjusts the fire
	pass

func fireloop_volume():
	# this function changes sound of campfire based on health
	# Balanced volumes are 0dB Fireloop1, 0dB Fireloop2, 3dB Fireloop3
	
	var FireLoop1 = $FireLoop1
	var FireLoop2 = $FireLoop2
	var FireLoop3 = $FireLoop3
	var volume = inverse_lerp(0, campfire_durability, fire_intensity)
	
	if volume == 0:
		FireLoop1.volume_db = -80
		FireLoop2.volume_db = -80
		FireLoop3.volume_db = -80
	
	if volume > 0 and volume <= 0.8:
		FireLoop1.volume_db = -3 + (volume * 3/0.8)
		FireLoop2.volume_db = -30 + (volume * 35)
		FireLoop3.volume_db = -30 + (volume * 30)
	
	if volume == 1:
		FireLoop1.volume_db = 0
		FireLoop2.volume_db = 3
		FireLoop3.volume_db = 3
	
	pass
