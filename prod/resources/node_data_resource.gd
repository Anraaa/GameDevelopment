extends Resource
class_name NodeDataResource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath

func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	var parent_node = node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()

func _load_data(root_scene: Node) -> void:
	# Gunakan get_node_or_null agar tidak crash jika node tidak ketemu
	var target_node = root_scene.get_node_or_null(node_path)
	
	if target_node != null and target_node is Node2D:
		target_node.global_position = global_position
		print("Berhasil me-load posisi: ", target_node.name)
	else:
		print("Gagal menemukan node di path: ", node_path)
