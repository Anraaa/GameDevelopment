extends CanvasLayer

# Pastikan nama node Label kamu adalah "NotificationLabel" di bawah CanvasLayer
@onready var notification_label: Label = $NotificationLabel 

func _ready() -> void:
	notification_label.hide() # Sembunyikan saat mulai

# Fungsi ini yang dipanggil oleh HurtComponent
func show_notif(text: String) -> void:
	notification_label.text = text
	notification_label.show()
	
	# Tunggu 2 detik lalu sembunyikan kembali
	await get_tree().create_timer(2.0).timeout
	notification_label.hide()
