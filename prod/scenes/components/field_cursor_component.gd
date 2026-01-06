extends Node

# Node TileMap yang akan dimodifikasi (Tarik dari Inspector)
@export var tilled_soil_layer: TileMapLayer

# Referensi suara cangkul
@onready var hoe_sfx = $"../HoeSFX"

var player: Player
var terrain_set_id: int = 0 
var terrain_id: int = 3 

func _ready() -> void:
	_reconnect_references()

func _reconnect_references() -> bool:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	if tilled_soil_layer == null:
		# Mencari layer tanah secara otomatis jika belum di-assign
		var layer = get_tree().root.find_child("TilledSoil", true, false)
		if layer is TileMapLayer:
			tilled_soil_layer = layer
	
	return player != null and tilled_soil_layer != null

func _unhandled_input(event: InputEvent) -> void:
	# Cek input hit (klik kiri/tombol aksi)
	if event.is_action_pressed("hit"): 
		# Hanya jalan jika alat yang dipilih adalah Cangkul (TillGround)
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			if _reconnect_references():
				handle_tilling()

func handle_tilling() -> void:
	# Dapatkan posisi mouse di TileMap
	var mouse_position = tilled_soil_layer.get_local_mouse_position()
	var cell_position = tilled_soil_layer.local_to_map(mouse_position)
	
	# Konversi posisi ubin ke koordinat global untuk cek jarak
	var tile_global_pos = tilled_soil_layer.to_global(tilled_soil_layer.map_to_local(cell_position))
	
	# Cek jarak player (maksimal 50 unit)
	if player.global_position.distance_to(tile_global_pos) < 50.0:
		
		# JALANKAN SUARA CANGKUL
		if hoe_sfx and hoe_sfx.has_method("play"):
			hoe_sfx.pitch_scale = randf_range(0.8, 1.2) # Variasi nada
			hoe_sfx.play()
		
		# LOGIKA MERUBAH TANAH
		tilled_soil_layer.set_cells_terrain_connect([cell_position], terrain_set_id, terrain_id)
		print("Berhasil mencangkul di: ", cell_position)
