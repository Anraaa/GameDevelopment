class_name GrowtCyleComponent
extends Node

# Pastikan DataTypes.GrowthStates memiliki urutan yang sesuai (misal: Germination, Sprout, Growing, Maturity, Harvesting)
@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(1, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool = false
var starting_day: int = -1 # Diubah ke -1 agar Day 0 bisa terdeteksi sebagai hari awal yang valid
var current_day: int = 0

func _ready() -> void:
	# Pastikan autoload DayAndNightCycleManager sudah ada di Project Settings
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	current_day = day
	
	if is_watered:
		# Set hari mulai jika ini adalah pertama kalinya disiram
		if starting_day == -1:
			starting_day = day
		
		var days_passed = current_day - starting_day
		update_growth_logic(days_passed)

func update_growth_logic(days_passed: int) -> void:
	# 1. Cek Fase Harvesting (Selesai)
	if days_passed >= days_until_harvest:
		if current_growth_state != DataTypes.GrowthStates.Harvesting:
			current_growth_state = DataTypes.GrowthStates.Harvesting
			crop_harvesting.emit()
		return

	# 2. Cek Fase Maturity
	# Jika hari sudah mencapai target tapi belum masuk fase harvesting
	if days_passed >= days_until_harvest - 1:
		if current_growth_state != DataTypes.GrowthStates.Maturity:
			current_growth_state = DataTypes.GrowthStates.Maturity
			crop_maturity.emit()
		return

	# 3. Hitung Fase Pertumbuhan Menengah (0 sampai Maturity)
	# Kita bagi total hari dengan jumlah fase yang ada sebelum Maturity
	# Misal ada 5 total state, maka state 0, 1, 2, 3 adalah pertumbuhan, 4 adalah Maturity
	var total_states = DataTypes.GrowthStates.size()
	var growth_progress = float(days_passed) / float(days_until_harvest)
	var state_index = int(growth_progress * (total_states - 1))
	
	# Update state hanya jika state baru lebih tinggi (mencegah penurunan fase)
	if state_index > current_growth_state:
		current_growth_state = state_index as DataTypes.GrowthStates

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
