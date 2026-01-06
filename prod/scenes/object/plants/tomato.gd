extends Node2D

var tomato_harvest_scene = preload("res://scenes/object/plants/tomato_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
var start_tomato_frame_offset: int = 6

func _ready() -> void:
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(_delta: float) -> void:
	# Update tampilan hanya jika ada perubahan state (opsional untuk optimasi)
	var current_state = growth_cycle_component.get_current_growth_state()
	if growth_state != current_state:
		growth_state = current_state
		sprite_2d.frame = growth_state + start_tomato_frame_offset
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true

func on_hurt(_hit_damage: int) -> void:
	# Logika menyiram tanaman
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		growth_cycle_component.is_watered = true
		
		await get_tree().create_timer(5.0).timeout
		if is_inside_tree(): # Pastikan tanaman masih ada setelah 5 detik
			watering_particles.emitting = false

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	print("Memanen tomat...")
	spawn_tomato_item()
	queue_free()

func spawn_tomato_item() -> void:
	if tomato_harvest_scene:
		var tomato_instance = tomato_harvest_scene.instantiate() as Node2D
		var parent_node = get_parent()
		if parent_node:
			parent_node.add_child(tomato_instance)
			tomato_instance.global_position = global_position
