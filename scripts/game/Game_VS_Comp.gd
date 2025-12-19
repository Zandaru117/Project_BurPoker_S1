extends Node2D
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var hand_scene: PackedScene
@onready var player_dropzone: DropZone = $Player_DropZone
@onready var enemy_dropzone: DropZone = $Enemy_DropZone
@onready var screen_score: Label = $Score

var hands: Array[Hand] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_score.text = "Счёт"
	deck.initialize_deck()
	deck.shuffle()
	#print(deck.cards)
	#for i in range(deck.cards.size()):
	#	deck.cards[i].change_position(Vector2(35+i*100,35+i*100))
	#	#print(deck.cards[i].suit)
	
	var enemy_hand: Hand = hand_scene.instantiate()
	hands.append(enemy_hand)
	hands[0].hand_position = Vector2(500, 100 + 0*400)
	add_child(hands[0])
	#print("POOP %s" % [hands[i].hand_position])
	hands[0].deal_cards(false, enemy_dropzone)
	
	var player_hand: Hand = hand_scene.instantiate()
	player_hand.hand_position = Vector2(500, 550)
	player_hand.is_player_hand = true
	add_child(player_hand)
	player_hand.deal_cards(true, player_dropzone)
	#print("первому раздал")
	#for i in range(2):
	#	for j in range(4):
	#		print(hands[i].hand_cards[j].position[0], hands[i].hand_cards[j].position[1])
	#print(deck.cards.size())
	pass # Replace with function body.
var check_cards: Array[Card] = []
var round_count = 0
var score = 0
func check(card: Card):
	#card.z_index = round_count * 1000
	round_count += 1
	hands[0].hand_cards[hands[0].hand_cards.size()-1].position = hands[0].hand_cards[hands[0].hand_cards.size()-1].dropzone.position
	hands[0].hand_cards[hands[0].hand_cards.size()-1].sprite.texture = hands[0].hand_cards[hands[0].hand_cards.size()-1].main_texture
	check_cards.append(card)
	check_cards.append(hands[0].hand_cards[hands[0].hand_cards.size()-1])
	hands[0].hand_cards.pop_back()
	if check_cards[0].rank > check_cards[1].rank:
		
		print("You won")
		score += 1
	else:
		print("You losed")
	screen_score.text = "Счёт %s:%s" % [score, round_count - score]
	print("%s:%s" % [score, round_count - score])
	await get_tree().create_timer(1.0).timeout
	check_cards[0].queue_free()
	check_cards[1].queue_free()
	check_cards = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
