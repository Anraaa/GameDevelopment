extends Node

var allow_save_game: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()


func save_game() -> void:
	print("Mencoba melakukan Save...")
	# Ambil semua node di group tersebut
	var nodes = get_tree().get_nodes_in_group("save_level_data_component")
	
	if nodes.size() > 0:
		for node in nodes:
			print("Ditemukan node: ", node.name)
			# Menggunakan call() lebih aman daripada memanggil fungsi langsung
			if node.has_method("save_game"):
				node.call("save_game")
				print("Berhasil memanggil fungsi save_game!")
			else:
				print("ERROR: Node ", node.name, " tidak punya fungsi save_game")
	else:
		print("ERROR: Tidak ada node dalam group save_level_data_component!")

func load_game() -> void:
	await get_tree().process_frame
	
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.load_game()
