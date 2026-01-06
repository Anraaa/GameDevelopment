class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

var player: Player
var corn_plant_scene = preload("res://scenes/object/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/object/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var local_cell_position : Vector2 
var distance: float 

# Tambahkan variabel untuk menyimpan ID ubin tanah yang sudah dicangkul
# Sesuaikan ID ini (biasanya 0 atau 1) dengan yang ada di TileSet kamu
@export var tilled_tile_source_id: int = 3 

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	_reconnect_references()

func _reconnect_references() -> bool:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	if tilled_soil_tilemap_layer == null:
		var layer = get_tree().root.find_child("TilledSoil", true, false)
		if layer is TileMapLayer:
			tilled_soil_tilemap_layer = layer
	
	return tilled_soil_tilemap_layer != null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt") or event.is_action_pressed("hit"):
		if not _reconnect_references():
			return
			
		get_cell_under_mouse()
		
		if event.is_action_pressed("remove_dirt"):
			if ToolManager.selected_tool == DataTypes.Tools.TillGround:
				remove_crop()
		elif event.is_action_pressed("hit"):
			if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
				add_crop()

func get_cell_under_mouse() -> void:
	if tilled_soil_tilemap_layer == null: return
	
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	
	var tile_local_pos = tilled_soil_tilemap_layer.map_to_local(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.to_global(tile_local_pos)
	
	if player:
		distance = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	if distance < 100.0:
		# --- LOGIKA BARU: CEK APAKAH TANAH SUDAH DICANGKUL ---
		# Ambil Source ID dari ubin di posisi mouse
		var current_tile_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
		
		# Jika ID ubin bukan ID tanah yang sudah dicangkul (-1 berarti kosong/belum dicangkul)
		if current_tile_id == -1:
			print("Tidak bisa menanam: Tanah belum dicangkul!")
			return
		# ----------------------------------------------------

		var crop_field = get_tree().root.find_child("CropFields", true, false)
		if not crop_field: return

		var plant_instance: Node2D
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			plant_instance = corn_plant_scene.instantiate()
		elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			plant_instance = tomato_plant_scene.instantiate()
			
		if plant_instance:
			crop_field.add_child(plant_instance)
			plant_instance.global_position = local_cell_position
			plant_instance.z_index = 5 
			print("Berhasil menanam di tanah yang sudah dicangkul.")

func remove_crop() -> void:
	if distance < 100.0:
		var crop_field = get_tree().root.find_child("CropFields", true, false)
		if crop_field:
			for node in crop_field.get_children():
				if node is Node2D and node.global_position.distance_to(local_cell_position) < 5.0:
					node.queue_free()
