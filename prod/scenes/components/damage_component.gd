class_name DamageComponent
extends Node2D

@export_group("Settings")
@export var max_damage: int = 3
@export var current_damage: int = 0

# Pastikan jalur ini benar sesuai hirarki di pohon_kecil.tscn
@onready var hit_sfx: AudioStreamPlayer2D = $"../HitSfx"

signal max_damaged_reached

# GANTI INI: Gunakan scene kayu/log, bukan scene pohon itu sendiri
@export var item_scene: PackedScene = preload("res://scenes/object/trees/log.tscn")

func apply_damage(damage: int) -> void:
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	# Efek suara saat dipukul
	if hit_sfx:
		hit_sfx.pitch_scale = randf_range(0.8, 1.2)
		hit_sfx.play()
	
	# Jika darah habis (pohon hancur)
	if current_damage >= max_damage:
		_spawn_item() 
		max_damaged_reached.emit()
		# Menghapus pohon dari map setelah hancur
		get_parent().queue_free() 

func _spawn_item() -> void:
	if item_scene:
		var item = item_scene.instantiate()
		# Masukkan kayu ke scene utama agar tidak ikut terhapus bersama pohon
		get_tree().root.add_child(item)
		item.global_position = global_position
		print("Kayu berhasil muncul!")
