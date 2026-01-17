extends Node2D
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var hand_scene: PackedScene
@onready var player_dropzone: DropZone = $Player_DropZone
@onready var enemy_dropzone: DropZone = $Enemy_DropZone
@onready var screen_score: Label = $Score

var hands: Array[Hand] = []
var is_my_turn: bool = true
var number_of_players: int = 2
var player_hand: Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_score.text = "Счёт"
	deck.initialize_deck()
	deck.shuffle()
	#print(deck.cards)
	#for i in range(deck.cards.size()):
	#	deck.cards[i].change_position(Vector2(35+i*100,35+i*100))
	#	#print(deck.cards[i].suit)
	
	for i in range(number_of_players-1):
		var enemy_hand: Hand = hand_scene.instantiate()
		hands.append(enemy_hand)
		hands[i].hand_position = Vector2(500, 100 + 0*400)
		add_child(hands[i])
		#print("POOP %s" % [hands[i].hand_position])
		hands[i].deal_cards(false, enemy_dropzone)
	
	
	player_hand = hand_scene.instantiate()
	player_hand.hand_position = Vector2(500, 550)
	player_hand.is_player_hand = true
	add_child(player_hand)
	player_hand.deal_cards(true, player_dropzone)
	#print("первому раздал")
	#for i in range(2):
	#	for j in range(4):
	#		print(hands[i].hand_cards[j].position[0], hands[i].hand_cards[j].position[1])
	#print(deck.cards.size())
	for i in range(4):
		if hands[0].hand_cards[i].suit == 0:
			print("h")
		if hands[0].hand_cards[i].suit == 1:
			print("d")
		if hands[0].hand_cards[i].suit == 2:
			print("c")
		if hands[0].hand_cards[i].suit == 3:
			print("s")
	
	
	start_game()
	pass # Replace with function body.
var check_cards: Array[Card] = []
var circle_count = 0
var score = 0

func start_game():
	# началась игра, ходит игрок
		
	
	pass

func enemys_turn(s: int):
	var fl = true
	print("you are going with")
	for i in range(4):
		if s == 0:
			print("h")
		if s == 1:
			print("d")
		if s == 2:
			print("c")
		if s == 3:
			print("s")
	print(hands[0].hand_cards)
	for i in range (hands.size()):
		for j in range(hands[i].hand_cards.size()-1):
			if hands[i].hand_cards[j].suit == s:
				hands[i].hand_cards[j].position = hands[i].hand_cards[j].dropzone.position
				hands[i].hand_cards[j].sprite.texture = hands[i].hand_cards[j].main_texture
				check_cards.append(hands[i].hand_cards[j])
				hands[i].hand_cards.remove_at(j)
				fl = false
				print("мэтч")
				break
		if fl:
			hands[i].hand_cards[0].position = hands[i].hand_cards[0].dropzone.position
			hands[i].hand_cards[0].sprite.texture = hands[i].hand_cards[0].main_texture
			check_cards.append(hands[i].hand_cards[0])
			hands[i].hand_cards.remove_at(0)
			fl = false
			print("не мэтч")
			break
var what_need: String
func enemy_goes():
	for i in range(hands.size()):
		hands[i].hand_cards[0].position = hands[i].hand_cards[0].dropzone.position
		hands[i].hand_cards[0].sprite.texture = hands[i].hand_cards[0].main_texture
		check_cards.append(hands[i].hand_cards[0])
		hands[i].hand_cards.remove_at(0)
	var k = 0
	for i in range(player_hand.hand_cards.size()):
		print(player_hand.hand_cards)
		print(check_cards)
		if player_hand.hand_cards[i].suit == check_cards[check_cards.size()-1].suit:
			k+=1
	if k > 0: what_need = "same"
	else: what_need = "any"
	pass

func check(card: Card):
	circle_count += 1
	
	
	if is_my_turn:
		print("новая масть")
		enemys_turn(card.suit)
		check_cards.append(card)
	else:
		check_cards.append(card)
	player_hand.hand_cards.erase(card)
	for i in range(2):
		check_cards[i].z_index = circle_count
	print("ща будет проверка")
	if check_cards[check_cards.size()-2].suit == check_cards[check_cards.size()-1].suit:
		if check_cards[check_cards.size()-2].rank < check_cards[check_cards.size()-1].rank:
			print("You won")
			score += 1
			is_my_turn = true
		else:
			print("You losed")
			is_my_turn = false
	else:
		if is_my_turn:
			score += 1
			print("You won")
			is_my_turn = true
		else:
			print("you losed")
			is_my_turn = false
	print("была проверка")
	#for i in range(check_cards.size()):
	#	print(check_cards[i].rank, ' ', check_cards[i].suit)
	
	
	var c1 = check_cards[0]
	var c2 = check_cards[1]
	check_cards = []
	screen_score.text = "Счёт %s:%s" % [score, circle_count - score]
	print("%s:%s" % [score, circle_count - score])
	await get_tree().create_timer(1.0).timeout
	
	
	
	
	
	
	#check_cards[0].queue_free()
	#check_cards[1].queue_free()
	c1.queue_free()
	c2.queue_free()
	if is_my_turn == false and player_hand.hand_cards.size() > 0:
		enemy_goes()
	#check_cards.remove_at(0)
	#check_cards.remove_at(1)
	#check_cards = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
