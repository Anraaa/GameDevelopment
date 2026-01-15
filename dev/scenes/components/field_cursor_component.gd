class_name FieldCursorComponent
extends Node

@export_category("TileMap Configuration")
@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

@export_category("Gameplay Settings")
# Jarak maksimal player bisa mencangkul (dalam pixel)
@export var max_interaction_distance: float = 200.0 

@onready var player: Player = get_tree().get_first_node_in_group("player")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var distance: float

func _input(event: InputEvent) -> void:
	if not player:
		return

	# Gunakan event.is_action_pressed(aksi, false) 
	# Parameter 'false' artinya "jangan looping kalau tombol ditahan"
	if event.is_action_pressed("remove_dirt", false):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
			
	elif event.is_action_pressed("hit", false):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	# 1. Dapatkan posisi mouse relatif terhadap TileMapLayer
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	
	# 2. Dapatkan koordinat grid (cell) dari posisi mouse
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	
	# 3. Cek apakah di grid tersebut ada tile rumput (Source ID valid)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	
	# 4. Dapatkan posisi tengah tile tersebut secara lokal
	var local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	
	# 5. [PENTING] Konversi posisi lokal tile ke Posisi Global Dunia
	var global_cell_position = grass_tilemap_layer.to_global(local_cell_position)
	
	# 6. Hitung jarak antara Player (Global) dan Tile (Global)
	distance = player.global_position.distance_to(global_cell_position)
	
	# Debug print (opsional, bisa dihapus nanti)
	# print("Jarak ke tile: ", distance)

func add_tilled_soil_cell() -> void:
	# Cek jarak dan pastikan kita mengklik di atas tile rumput yang valid (id != -1)
	if distance <= max_interaction_distance and cell_source_id != -1:
		# Lakukan Terraining
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
		print("Berhasil mencangkul! Jarak: ", distance)
	else:
		print("Gagal Mencangkul. Jarak: ", distance, " | SourceID: ", cell_source_id)

func remove_tilled_soil_cell() -> void:
	# Cek jarak saja (pastikan logic jaraknya sama atau mirip dengan add)
	if distance <= max_interaction_distance:
		# Menghapus tile (set terrain ke -1 atau empty)
		# Note: parameter kedua (0) disini harus sesuai dengan terrain_set 'kosong' atau gunakan set_cell biasa jika error
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
		print("Berhasil meratakan tanah! Jarak: ", distance)
	else:
		print("Kejauhan untuk meratakan tanah: ", distance)
