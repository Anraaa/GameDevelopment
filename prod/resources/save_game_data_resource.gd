extends Resource
class_name SaveGameDataResource

## Array ini akan menampung semua data resource dari objek yang memiliki SaveDataComponent.
## Menggunakan tipe [Resource] agar lebih fleksibel jika ada data selain NodeDataResource di masa depan.
@export var save_data_nodes: Array[Resource] = []

## Fungsi tambahan untuk membersihkan data lama sebelum melakukan penyimpanan baru.
func clear_data() -> void:
	save_data_nodes.clear()
