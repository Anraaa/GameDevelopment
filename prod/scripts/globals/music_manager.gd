extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer # Pastikan nama node sesuai

@export var fade_duration: float = 2.0
@export var farm_music: AudioStream
@export var cave_music: AudioStream

func _ready() -> void:
	# Mulai dari volume rendah untuk efek fade in
	music_player.volume_db = -80
	if farm_music:
		change_music(farm_music)

func change_music(new_stream: AudioStream):
	if music_player.stream == new_stream and music_player.playing:
		return

	var tween = create_tween()
	# 1. Fade Out suara lama
	tween.tween_property(music_player, "volume_db", -80, fade_duration)
	
	# 2. Ganti lagu di tengah transisi
	tween.tween_callback(func(): 
		music_player.stream = new_stream
		music_player.play()
	)
	
	# 3. Fade In suara baru
	tween.tween_property(music_player, "volume_db", 0, fade_duration)
