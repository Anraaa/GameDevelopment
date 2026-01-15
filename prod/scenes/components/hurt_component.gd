class_name HurtComponent
extends Area2D

@export_group("Settings")
@export var tool: DataTypes.Tools = DataTypes.Tools.AxeWood
@export var is_permanen: bool = false 

@export_group("Notifications")
@export var custom_notif_message: String = "Pohon ini terlalu besar untuk ditebang!"

signal hurt(hit_damage: int)

func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:
		var hit_component = area as HitComponent
		
		# Ambil referensi GameUI
		var ui = get_tree().root.find_child("GameUI", true, false)
		
		# Jika ini pohon besar (is_permanen tercentang)
		if is_permanen:
			if ui and ui.has_method("show_notif"):
				ui.show_notif(custom_notif_message)
			return # Berhenti, jangan biarkan pohon menerima damage
		
		# Logika untuk pohon biasa yang bisa ditebang
		if tool == hit_component.current_tool:
			hurt.emit(hit_component.hit_damage)
		else:
			if ui and ui.has_method("show_notif"):
				ui.show_notif("Gunakan kapak untuk menebang ini!")
