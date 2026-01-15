extends Area2D

@export_group("Settings")
@export var tool: DataTypes.Tools = DataTypes.Tools.AxeWood
@export var is_permanen: bool = false # Pastikan dicentang di Inspector pohon besar

func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:
		var hit_component = area as HitComponent
		
		# Cara paling aman mencari GameUI di scene utama
		var ui = get_tree().root.find_child("GameUI", true, false)
		
		# Debug: Cek apakah area terdeteksi (Lihat tab Output)
		print("Pohon dipukul! is_permanen: ", is_permanen)
		
		# LOGIKA POHON BESAR
		if is_permanen:
			if ui and ui.has_method("show_notif"):
				ui.show_notif("Pohon yang tidak bisa digunakan")
				print("Notif pohon besar dikirim ke UI")
			return # Berhenti di sini agar tidak lanjut ke pengecekan alat
		
		# LOGIKA POHON KECIL
		if tool == hit_component.current_tool:
			var damage_comp = get_parent().get_node_or_null("DamageComponent")
			if damage_comp:
				damage_comp.apply_damage(hit_component.hit_damage)
		else:
			if ui and ui.has_method("show_notif"):
				ui.show_notif("Gunakan kapak untuk menebang ini!")	
