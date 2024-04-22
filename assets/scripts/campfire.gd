extends Node2D

@onready var GPUParticleFire = $GPUParticlesFireIntensity
##fire intesnity, default value 1, good visuals <4
@export var fire_intensity = 2
@export_range(0, 10, 1) var campfire_durability
@onready var area = $IceCheckArea
var particle_mat: ParticleProcessMaterial
signal no_fire
@onready var game_manager = get_parent()

@onready var FireLoop1 = $FireLoop1
@onready var FireLoop2 = $FireLoop2
@onready var FireLoop3 = $FireLoop3

#func _on_campfire_damaged():
	
	#_update_fire_intensity(1)
		#This function is now redundant, can I delete?

func _update_fire_intensity(amount):
	
	fire_intensity += amount
	#I'm using campfire_durability as a kind of max health.
	#fire_intensity is the current health and it determines the state of particles.
	#amount = +1 to add intensity and -1 to subtract
	
	fire_intensity = clampi(fire_intensity, 0, campfire_durability)
	#print("Fire intensity = ", fire_intensity)
	
	if fire_intensity <= 0:
		particle_mat.scale_min = 0
		particle_mat.scale_max = 0
		GPUParticleFire.lifetime = 0
		#print("campfire is out")
		
		emit_signal("no_fire")
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
	
	no_fire.connect(game_manager.on_no_fire)
	
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
	
	pass

func fireloop_volume():
	# this function changes sound of campfire based on health
	# Balanced volumes are 0dB Fireloop1, 0dB Fireloop2, 3dB Fireloop3
	
	var volume = inverse_lerp(0, campfire_durability, fire_intensity)
	# inverse_lerp so I can change the campfire health and
	# volume logic will still work.
	
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
