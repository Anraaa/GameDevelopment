extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

# Menggunakan preload agar scene kayu selalu siap
var log_scene = preload("res://scenes/object/trees/log.tscn")

func _ready() -> void:
	# Menghubungkan sinyal dari komponen
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	# Efek goyang saat dipukul
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(0.2).timeout # Timer diperpendek agar lebih responsif
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	print("Pohon tumbang!")
	spawn_log()
	queue_free() # Menghapus pohon setelah item muncul

func spawn_log() -> void:
	if log_scene:
		var log_instance = log_scene.instantiate() as Node2D
		
		# Ambil parent dari pohon (misal: YSort atau Level node)
		var parent_node = get_parent()
		if parent_node:
			parent_node.add_child(log_instance)
			# Set posisi kayu sesuai posisi pohon saat ini
			log_instance.global_position = global_position	
