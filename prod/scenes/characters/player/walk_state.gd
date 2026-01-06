extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

# Tambahkan referensi ke node suara yang ada di Player
# Pastikan di scene Player sudah ada AudioStreamPlayer2D bernama "FootstepSFX"
@onready var footstep_sfx: AudioStreamPlayer2D = $"../../FootstepSfx"

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
		
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("idle")

func _on_enter() -> void:
	# Jalankan suara saat masuk ke state Walk
	if footstep_sfx:
		footstep_sfx.play()

func _on_exit() -> void:
	# Hentikan suara saat keluar dari state Walk
	if footstep_sfx:
		footstep_sfx.stop()
