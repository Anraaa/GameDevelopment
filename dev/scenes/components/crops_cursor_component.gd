class_name CropsCursorComponent
extends Node

@export var tilled_soild_tilemap_layer: TileMapLayer

# Jarak interaksi (sama dengan script sebelumnya biar konsisten)
@export var max_interaction_distance: float = 200.0

@onready var player: Player = get_tree().get_first_node_in_group("player")
# Sebaiknya gunakan export untuk CropFields agar lebih aman daripada find_child
@onready var crop_parent: Node = get_parent().find_child("CropFields")

var corn_plant_scene = preload("res://scenes/object/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/object/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position : Vector2
var global_cell_position : Vector2 # Tambahan variabel penting
var distance: float

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		# Kalau toolsnya bukan buat nanam, mungkin fungsinya buat remove crop (misal sabit)
		# Sesuaikan logic ini dengan game design kamu
		pass 
		
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soild_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soild_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soild_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soild_tilemap_layer.map_to_local(cell_position)
	
	# PERBAIKAN UTAMA: Konversi ke Global Position
	global_cell_position = tilled_soild_tilemap_layer.to_global(local_cell_position)
	
	# Hitung jarak menggunakan Global Position
	distance = player.global_position.distance_to(global_cell_position)
	# print("Dist: ", distance, " ID: ", cell_source_id)

func add_crop() -> void:
	if distance < max_interaction_distance and cell_source_id != -1:
		
		if is_crop_already_there(global_cell_position):
			print("Sudah ada tanaman!")
			return

		var plant_instance: Node2D = null

		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			plant_instance = corn_plant_scene.instantiate()
			print("Menanam Jagung...")
	
		elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			plant_instance = tomato_plant_scene.instantiate()
			print("Menanam Tomat...")
			
		if plant_instance:
			# 1. Masukkan ke tree dulu
			crop_parent.add_child(plant_instance)
			
			# 2. Paksa posisi Global (Timpa semua settingan scene)
			plant_instance.global_position = global_cell_position
			
			# 3. DEBUG: Paksa Z-Index biar nongol di atas segalanya
			plant_instance.z_index = 100 
			
			print("BERHASIL! Posisi Jagung di: ", plant_instance.global_position)
			print("Posisi Player di: ", player.global_position)
	else:
		print("Gagal. Jarak: ", distance, " ID Tanah: ", cell_source_id)
	
	
# Fungsi helper untuk mengecek apakah di posisi itu sudah ada tanaman
func is_crop_already_there(check_position: Vector2) -> bool:
	var crop_nodes = crop_parent.get_children()
	for node in crop_nodes:
		# Gunakan distance_to yang sangat kecil untuk komparasi posisi float
		if node is Node2D and node.global_position.distance_to(check_position) < 1.0:
			return true
	return false

# Jika kamu ingin menghapus crop (misal pakai sabit)
func remove_crop() -> void:
	if distance < max_interaction_distance:
		var crop_nodes = crop_parent.get_children()
		for node: Node2D in crop_nodes:
			# Bandingkan dengan GLOBAL position
			if node.global_position.distance_to(global_cell_position) < 1.0:
				node.queue_free()
				print("Tanaman dihapus")
