extends Node2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

func _ready() -> void:
	# PERHATIKAN EJAANNYA: "activated", bukan "actived"
	interactable_component.interactable_activated.connect(on_interactable_activated)
	
	# Ini yang tadi bikin error (sekarang harusnya sudah aman jika langkah 1 dilakukan)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	
	interactable_label_component.hide()

func on_interactable_activated() -> void:
	interactable_label_component.show()

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
