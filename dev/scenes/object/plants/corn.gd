extends Node2D

# --- SETUP DI INSPECTOR ---
# Masukkan scene item hasil panen di sini (misal: scenes/items/corn_item_drop.tscn)
@export var harvest_drop_scene: PackedScene 

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles

# Component Logic
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)

func _process(delta: float) -> void:
	# Update visual sprite frame sesuai state tumbuh
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state
	
	# Logic visual tambahan saat matang
	if growth_state == DataTypes.GrowthStates.Maturity:
		if !flowering_particles.emitting:
			flowering_particles.emitting = true

func on_hurt(hit_damage: int) -> void:
	# LOGIKA PENTING:
	# 1. Cek apakah MATANG? -> Kalau ya, PANEN.
	if growth_state == DataTypes.GrowthStates.Maturity:
		harvest_crop()
	
	# 2. Kalau BELUM MATANG -> SIRAM.
	elif !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true
		print("Tanaman disiram!")

func on_crop_maturity() -> void:
	flowering_particles.emitting = true
	print("Tanaman Matang! Siap Panen.")

func harvest_crop() -> void:
	if harvest_drop_scene:
		# Buat item drop
		var harvest_instance = harvest_drop_scene.instantiate()
		harvest_instance.global_position = global_position
		
		# Masukkan ke world (CropFields)
		get_parent().add_child(harvest_instance)
		
		# Hapus tanaman ini
		queue_free()
		print("Panen Berhasil!")
	else:
		print("ERROR: harvest_drop_scene belum diisi di Inspector node Corn!")
