extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn_card()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")



#func spawn_card():
#	var data = load("res://data/cards/card_spades_king.tres")
#	var card = load("res://scenes/cards/Card.tscn").instantiate()
#	card.data = data

#	add_child(card)
