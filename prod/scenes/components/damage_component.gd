class_name DamageComponent
extends Node2D

@export var max_damage = 3
@export var current_damage = 0

# Tambahkan referensi ke node suara yang ada di hirarki SmallTree
@onready var hit_sfx: AudioStreamPlayer2D = $"../HitSfx"

signal max_damaged_reached

@export var item_scene: PackedScene =preload("res://scenes/object/trees/small_tree.tscn")

func apply_damage(damage: int) -> void:
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	if hit_sfx:
		hit_sfx.pitch_scale = randf_range(0.8, 1.2)
		hit_sfx.play()
	
	if current_damage == max_damage:
		_spawn_item() # Panggil fungsi spawn saat pohon hancur
		max_damaged_reached.emit()

func _spawn_item() -> void:
	if item_scene:
		var item = item_scene.instantiate()
		# Letakkan item di posisi pohon saat ini
		get_tree().root.add_child(item)
		item.global_position = global_position
