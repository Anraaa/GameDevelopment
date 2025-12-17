class_name InteractableComponent
extends Area2D

# --- PERBAIKAN DI SINI (Ubah 'actived' jadi 'activated') ---
signal interactable_activated 
signal interactable_deactivated

func _on_body_entered(body: Node2D) -> void:
	# Jangan lupa ubah nama yang di-emit juga
	interactable_activated.emit() 

func _on_body_exited(body: Node2D) -> void:
	# Jangan lupa ubah nama yang di-emit juga
	interactable_deactivated.emit()
