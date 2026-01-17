extends Node2D

@onready var fs_button: CheckButton = $FullscreenButton
# Убедись, что имя узла в сцене совпадает с тем, что после знака $
@onready var res_button: OptionButton = $ResolutionOptionButton 

# Словарь с разрешениями
const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func _ready() -> void:
	# Отключаем встраивание окон
	get_viewport().gui_embed_subwindows = false
	
	# 1. Настраиваем список разрешений (OptionButton)
	res_button.clear()
	for res_name in RESOLUTION_DICTIONARY.keys():
		res_button.add_item(res_name)
	
	# 2. Устанавливаем положение кнопок в зависимости от текущего окна
	var mode = DisplayServer.window_get_mode()
	var is_fs = (mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
	fs_button.button_pressed = is_fs
	res_button.disabled = is_fs # Блокируем выбор разрешения в полном экране

# Выбор разрешения в выпадающем списке
func _on_resolution_option_button_item_selected(index: int) -> void:
	var res_name = res_button.get_item_text(index)
	var target_size = RESOLUTION_DICTIONARY[res_name]
	
	# Меняем размер окна
	DisplayServer.window_set_size(target_size)
	
	# Ждем один кадр и центрируем
	await get_tree().process_frame
	center_window_simple()

# Переключатель полного экрана
func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		res_button.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		res_button.disabled = false
		# После выхода из фуллскрина ставим размер, выбранный в списке
		_on_resolution_option_button_item_selected(res_button.selected)

# Улучшенная функция центровки (без ошибок сложения Vector2 и Vector2i)
func center_window_simple() -> void:
	var screen_id = DisplayServer.window_get_current_screen()
	var screen_size = Vector2i(DisplayServer.screen_get_size(screen_id))
	var window_size = DisplayServer.window_get_size()
	var screen_pos = Vector2i(DisplayServer.screen_get_position(screen_id))
	
	# Математика для точного центра
	var target_pos = screen_pos + (screen_size / 2 - window_size / 2)
	DisplayServer.window_set_position(target_pos)

func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
