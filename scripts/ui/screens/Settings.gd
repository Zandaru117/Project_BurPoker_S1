extends Node2D

@onready var fs_button: CheckButton = $FullscreenButton
@onready var res_button: OptionButton = $ResolutionOptionButton 
# Добавьте эту строку для кнопки игроков
@onready var players_button: OptionButton = $NumberOfPlayers 

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func _ready() -> void:
	get_viewport().gui_embed_subwindows = false
	
	# 1. Настраиваем список разрешений
	res_button.clear()
	for res_name in RESOLUTION_DICTIONARY.keys():
		res_button.add_item(res_name)
	
	# --- НОВОЕ: Настраиваем список игроков ---
	players_button.clear()
	players_button.add_item("2 Players") # index 0
	players_button.add_item("3 Players") # index 1
	players_button.add_item("4 Players") # index 2
	
	# Выставляем в меню то значение, которое уже сохранено в Globals
	# (например, если там 3, то выберется index 1)
	players_button.selected = Globals.player_count - 2
	# -----------------------------------------
	
	var mode = DisplayServer.window_get_mode()
	var is_fs = (mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	fs_button.button_pressed = is_fs
	res_button.disabled = is_fs

# Функция выбора количества игроков (уже была у вас)
func _on_number_of_players_item_selected(index: int) -> void:
	var count = index + 2
	Globals.player_count = count
	print("Глобальная настройка обновлена. Игроков: ", Globals.player_count)

# --- Остальной ваш код без изменений ---

func _on_resolution_option_button_item_selected(index: int) -> void:
	var res_name = res_button.get_item_text(index)
	var target_size = RESOLUTION_DICTIONARY[res_name]
	DisplayServer.window_set_size(target_size)
	await get_tree().process_frame
	center_window_simple()

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		res_button.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		res_button.disabled = false
		_on_resolution_option_button_item_selected(res_button.selected)

func center_window_simple() -> void:
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = Vector2i(DisplayServer.screen_get_size(screen_id))
	var window_size = DisplayServer.window_get_size()
	var screen_pos = Vector2i(DisplayServer.screen_get_position(screen_id))
	var target_pos = screen_pos + (screen_size / 2 - window_size / 2)
	DisplayServer.window_set_position(target_pos)

func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
