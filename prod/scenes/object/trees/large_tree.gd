extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var audio_play_component: AudioPlayComponent = $AudioPlayComponent

# Tambahkan variabel untuk menyimpan status pohon
@export var is_cut: bool = false

# Menggunakan preload agar scene kayu selalu siap
var log_scene = preload("res://scenes/object/trees/log.tscn")

func _ready() -> void:
	# Hubungkan sinyal
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
	# Cek status saat load game
	if is_cut:
		_show_stump_only()

func on_hurt(hit_damage: int) -> void:
	# Jika sudah ditebang, jangan bisa dipukul lagi
	if is_cut: return
	
	damage_component.apply_damage(hit_damage)
	
	# Putar suara tebasan dari AudioStreamPlayer2D lokal
	if audio_play_component:
		audio_play_component.play_tool_audio()
	
	# Efek goyang
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(0.2).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	if is_cut: return # Mencegah double trigger
	
	print("Pohon tumbang!")
	is_cut = true # Tandai status sebagai sudah ditebang
	
	spawn_log()
	_show_stump_only() # Ubah tampilan, jangan di queue_free()

func _show_stump_only() -> void:
	# 1. Matikan visual pohon utama (Sprite2D ini)
	self.visible = false 
	
	# 2. Aktifkan visual tunggul (Pastikan kamu punya node Stump di dalam Scene ini)
	if has_node("Stump"):
		get_node("Stump").visible = true
	
	# 3. Matikan Collision agar player bisa lewat di atas bekas tebangan
	# Pastikan path ke CollisionShape2D kamu benar
	var collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	if collision:
		collision.set_deferred("disabled", true)
	
	# 4. Matikan komponen hurt agar tidak bisa dipukul lagi
	hurt_component.set_deferred("monitoring", false)
	hurt_component.set_deferred("monitorable", false)

func spawn_log() -> void:
	if log_scene:
		var log_instance = log_scene.instantiate() as Node2D
		var parent_node = get_parent()
		if parent_node:
			parent_node.add_child(log_instance)
			log_instance.global_position = global_position
