class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	# Cek apakah Node yang masuk memang bertipe HitComponent
	if area is HitComponent:
		var hit_component = area as HitComponent # Casting aman karena sudah dicek
		
		if tool == hit_component.current_tool:
			hurt.emit(hit_component.hit_damage)
