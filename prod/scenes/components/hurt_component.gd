class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.AxeWood

signal hurt(hit_damage: int) # Pastikan sinyal membawa parameter damage

func _on_area_entered(area: Area2D) -> void:
	# Cek apakah yang masuk adalah HitComponent
	if area is HitComponent:
		var hit_component = area as HitComponent
		
		# Debugging: Cek apakah tool yang digunakan sudah benar
		print("Pohon butuh: ", tool, " | Player pakai: ", hit_component.current_tool)
		
		if tool == hit_component.current_tool:
			hurt.emit(hit_component.hit_damage)
			print("Damage dikirim: ", hit_component.hit_damage)
		else:
			print("Alat salah! Tidak bisa menebang.")
