class_name CollectableComponent
extends Area2D

@export var collectable_name: String = "Corn"

func _ready() -> void:
	# --- DIAGNOSA OTOMATIS ---
	print("Item muncul di dunia! Menunggu Player...")
	
	# Cek apakah Monitoring nyala? Kalau mati, kita nyalakan paksa.
	if monitoring == false:
		print("PERINGATAN: Monitoring mati! Menyalakan otomatis...")
		monitoring = true
	
	# --- PAKSA SAMBUNG SINYAL (SOLUSI UTAMA) ---
	# Ini menghubungkan kejadian 'terinjak' langsung ke fungsi '_on_body_entered'
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		print("SUKSES: Sinyal body_entered berhasil disambung paksa!")
	else:
		print("INFO: Sinyal sudah tersambung dari editor.")

func _on_body_entered(body: Node2D) -> void:
	# Print siapa saja yang lewat (termasuk tanah/tembok)
	print("ADA YANG LEWAT! Objek bernama: ", body.name)

	# Cek apakah itu Player
	if body.is_in_group("player"):
		print(">>> PLAYER TERDETEKSI! <<<")
		
		# Panggil Inventory Manager
		if InventoryManager.has_method("add_collectable"):
			InventoryManager.add_collectable(collectable_name)
			print("Item masuk inventory: ", collectable_name)
		else:
			print("Item diambil, tapi InventoryManager tidak punya fungsi add_collectable")
		
		# Hapus Item (Penting: Hapus Parent/Node2D-nya, bukan cuma component ini)
		if get_parent() is Node2D:
			get_parent().queue_free()
		else:
			queue_free() # Fallback kalau tidak punya parent
