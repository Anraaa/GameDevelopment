extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

# Referensi ke node suara yang ada di bawah Player/FieldCursor
@onready var watering_sfx: AudioStreamPlayer2D = $"../../WateringSFX"

func _ready() -> void:
	# Pastikan collision mati saat awal game agar tidak menyiram otomatis
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0, 0)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	# Transisi kembali ke Idle hanya setelah animasi menyiram selesai
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	# Putar suara menyiram saat masuk state
	if watering_sfx:
		watering_sfx.pitch_scale = randf_range(0.9, 1.1) # Beri sedikit variasi suara
		watering_sfx.play()

	# Atur animasi dan posisi collision berdasarkan arah hadap player
	match player.player_direction:
		Vector2.UP:
			animated_sprite_2d.play("watering_back")
			hit_component_collision_shape.position = Vector2(0, -18)
		Vector2.RIGHT:
			animated_sprite_2d.play("watering_right")
			hit_component_collision_shape.position = Vector2(9, 0)
		Vector2.DOWN:
			animated_sprite_2d.play("watering_front")
			hit_component_collision_shape.position = Vector2(0, 3)
		Vector2.LEFT:
			animated_sprite_2d.play("watering_left")
			hit_component_collision_shape.position = Vector2(-9, 0)
		_:
			animated_sprite_2d.play("watering_front")
			hit_component_collision_shape.position = Vector2(0, 3)
	
	# Aktifkan collision agar mengenai Hitbox tanaman/tanah
	hit_component_collision_shape.disabled = false

func _on_exit() -> void:
	# Matikan collision dan hentikan animasi saat keluar dari state
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
	
	# Suara dibiarkan selesai sendiri agar tidak terpotong kasar (opsional)
	# Jika ingin langsung berhenti, gunakan watering_sfx.stop()
