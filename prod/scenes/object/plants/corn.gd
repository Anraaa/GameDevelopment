extends Node2D

# Gunakan preload agar sama dengan tomat
var harvest_drop_scene = preload("res://scenes/object/plants/corn_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
# Sesuaikan offset jika sprite sheet jagung kamu berbeda urutannya dengan tomat
var start_corn_frame_offset: int = 0 

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	# Pastikan sinyal ini ada di GrowthCycleComponent kamu
	if growth_cycle_component.has_signal("crop_harvesting"):
		growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(_delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	sprite_2d.frame = growth_state + start_corn_frame_offset
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true

func on_hurt(hit_damage: int) -> void:
	# Jika sudah matang, panen saat dipukul (sama seperti tomat)
	if growth_state == DataTypes.GrowthStates.Maturity:
		on_crop_harvesting()
		return

	# Jika belum matang, disiram (logika tomat)
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		growth_cycle_component.is_watered = true
		await get_tree().create_timer(5.0).timeout
		if is_instance_valid(self):
			watering_particles.emitting = false

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	# Logika spawn item sama persis dengan tomat
	if harvest_drop_scene:
		var corn_harvest_instance = harvest_drop_scene.instantiate() as Node2D
		var current_parent = get_parent()
		
		if current_parent:
			current_parent.add_child(corn_harvest_instance)
			corn_harvest_instance.global_position = global_position
			print("Jagung berhasil dipanen!")
	
	queue_free()
