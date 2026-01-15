extends Resource
#class_name NodeDataResource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath

func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	var parent_node = node.get_parent()
	
	if parent_node != null:
		parent_node_path = parent_node.get_path()

# PERBAIKAN DI SINI: Ganti _window: Window menjadi _root: Node
func _load_data(_root: Node) -> void:
	# 1. Cari objek berdasarkan path yang disimpan
	var target_node = _root.get_node_or_null(node_path)
	
	if target_node != null and target_node is Node2D:
		# 2. Kembalikan posisinya
		target_node.global_position = global_position
		print("Berhasil Load: ", target_node.name, " ke posisi ", global_position)
	else:
		print("Gagal Load: Node tidak ditemukan di path ", node_path)
