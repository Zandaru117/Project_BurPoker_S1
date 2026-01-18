extends Node2D
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var hand_scene: PackedScene
@export var enemy_drop_zone_scene: PackedScene = preload("res://scenes/DropZone.tscn")
@onready var player_dropzone: DropZone = $Player_DropZone
@onready var enemy_dropzone: DropZone = $Enemy_DropZone
@onready var screen_score: Label = $Score

var hands: Array[Hand] = []
var enemy_dropzones: Array[DropZone]
var is_my_turn: bool = true
var number_of_players: int = 2
var player_hand: Hand
var trump: int
var trump_string: String
var score: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Globals.player_count):
		score.append(0)
	check_cards.resize(Globals.player_count)
	for i in range(Globals.player_count-1):
		who_goes.append(false)
	who_goes.append(true)
	print("Игра запущена! Количество игроков из настроек: ", Globals.player_count)
	# Здесь вы можете использовать Globals.player_count для спавна персонажей
	trump = randi_range(0, 3)
	if trump == 0: trump_string = "Hearts"
	if trump == 1: trump_string = "Diamonds"
	if trump == 2: trump_string = "Clubs"
	if trump == 3: trump_string = "Spades"
	screen_score.text = "Козырь: %s\nСчёт" % trump_string
	deck.initialize_deck()
	deck.shuffle()
	#print(deck.cards)
	#for i in range(deck.cards.size()):
	#	deck.cards[i].change_position(Vector2(35+i*100,35+i*100))
	#	#print(deck.cards[i].suit)
	for i in range(Globals.player_count-1):
		var enemy_drop_zone: DropZone = enemy_drop_zone_scene.instantiate()
		
		enemy_drop_zone.position = Vector2(600-(140*Globals.player_count+10*(i+1))/2 + 140*(i+1)+10*(i+1), 310) 
		#print("Инициировано ", enemy_drop_zone, " Позиция: ", enemy_drop_zone.position)
		enemy_dropzones.append(enemy_drop_zone)
		add_child(enemy_dropzones[i])
	for i in range(Globals.player_count-1):
		var enemy_hand: Hand = hand_scene.instantiate()
		hands.append(enemy_hand)
		hands[i].hand_position = Vector2(500-300*sin(2*PI/(Globals.player_count)*(i+1)), 300+200*cos(2*PI/(Globals.player_count)*(i+1)))
		#print(sin(2*PI/(Globals.player_count)))
		#print(2*PI/(Globals.player_count))
		#print(hands[i].hand_position)
		add_child(hands[i])
		#print("POOP %s" % [hands[i].hand_position])
		hands[i].deal_cards(false, enemy_dropzones[i])
	
	#print(hands)
	player_hand = hand_scene.instantiate()
	player_hand.hand_position = Vector2(500, 550) #500, 550
	player_dropzone.position = Vector2(600-(140*Globals.player_count+10)/2, 310)
	player_hand.is_player_hand = true
	add_child(player_hand)
	player_hand.deal_cards(true, player_dropzone)
	hands.append(player_hand)
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


func start_game():
	# началась игра, ходит игрок
		
	
	pass

func enemys_turn(i: int,s: int):
	var fl = true
	print("Должен ходить соперник")
	if s == 0:
		print("h")
	if s == 1:
		print("d")
	if s == 2:
		print("c")
	if s == 3:
		print("s")
	#print(hands[0].hand_cards)
	for j in range(hands[i].hand_cards.size()-1):
		if hands[i].hand_cards[j].suit == s:
			hands[i].hand_cards[j].position = hands[i].hand_cards[j].dropzone.position
			hands[i].hand_cards[j].sprite.texture = hands[i].hand_cards[j].main_texture
			check_cards[i] = hands[i].hand_cards[j]
			hands[i].hand_cards.remove_at(j)
			fl = false
			print("мэтч")
			break
	if fl:
		for j in range(hands[i].hand_cards.size()-1):
			if hands[i].hand_cards[j].suit == trump:
				hands[i].hand_cards[j].position = hands[i].hand_cards[j].dropzone.position
				hands[i].hand_cards[j].sprite.texture = hands[i].hand_cards[j].main_texture
				check_cards[i] = hands[i].hand_cards[j]
				hands[i].hand_cards.remove_at(j)
				fl = false
				print("мэтч")
				break
	if fl:
		hands[i].hand_cards[0].position = hands[i].hand_cards[0].dropzone.position
		hands[i].hand_cards[0].sprite.texture = hands[i].hand_cards[0].main_texture
		check_cards[i] = hands[i].hand_cards[0]
		hands[i].hand_cards.remove_at(0)
		fl = false
		print("не мэтч")
var what_need: String
func enemy_goes():
	#print(hands)
	#print(who_goes)
	hands[who_goes.find(true)].hand_cards[0].position = hands[who_goes.find(true)].hand_cards[0].dropzone.position
	hands[who_goes.find(true)].hand_cards[0].sprite.texture = hands[who_goes.find(true)].hand_cards[0].main_texture
	check_cards[who_goes.find(true)] = hands[who_goes.find(true)].hand_cards[0]
	hands[who_goes.find(true)].hand_cards.remove_at(0)
	var kfsuit = 0
	var ktrump = 0
	for i in range(player_hand.hand_cards.size()):
		#print(player_hand.hand_cards)
		#print(check_cards)
		print(check_cards)
		if player_hand.hand_cards[i].suit == check_cards[who_goes.find(true)].suit:
			kfsuit += 1
		if player_hand.hand_cards[i].suit == trump:
			ktrump += 1
	if kfsuit > 0: what_need = "same"
	elif ktrump > 0: what_need = "trump"
	else: what_need = "any"
	pass

var who_goes: Array[bool]


func check(card: Card):
	circle_count += 1
	check_cards[Globals.player_count-1] = card
	print("Ты ходишь ")
	if card.suit == 0:
		print("h")
	if card.suit == 1:
		print("d")
	if card.suit == 2:
		print("c")
	if card.suit == 3:
		print("s")
	player_hand.hand_cards.erase(card)
	
	var i = 0
	#print(check_cards)
	while null in check_cards:
		if check_cards[i] != null:
			
			i += 1
			if i >= Globals.player_count:
				i = 0
			print("check_cards")
			continue
		else:
			if i == Globals.player_count-1:
				#is_my_turn = true
				print("новая масть")
				#await
#			elif i == who_is_going:
				
			else:
				#print(check_cards)
				#print(who_goes)
				#print(who_goes.find(true))
				print("дохрена текста, да?")
				print(i)
				print(who_goes.find(true))
				enemys_turn(i, check_cards[who_goes.find(true)].suit)
				
				#await
	
	
	
	for j in range(Globals.player_count):
		#print(j)
		check_cards[j].z_index = circle_count
	#print("ща будет проверка")
	var ktrumps = 0
	var trumps: Array[int]
	var fsuits: Array[int]
	print(trumps, fsuits)
	for p in range(Globals.player_count):
		trumps.append(0)
		fsuits.append(0)
	
	for j in range(check_cards.size()):
		if check_cards[j].suit == trump:
			ktrumps += 1
			trumps[j] = check_cards[j].rank
			fsuits[j] = 0
		elif check_cards[j].suit == check_cards[who_goes.find(true)].suit:
			fsuits[j] = check_cards[j].rank
			trumps[j] = 0
		else:
			fsuits[j] = 0
			trumps[j] = 0
	if ktrumps > 0:
		score[trumps.find(trumps.max())] += 1
		who_goes[who_goes.find(true)] = false
		who_goes[trumps.find(trumps.max())] = true
		if who_goes.find(true) == Globals.player_count-1: is_my_turn = true
		else: is_my_turn = false
		#print("Победил игрок ", trumps.find(trumps.max()))
		#print(trumps)
	else:
		score[fsuits.find(fsuits.max())] += 1
		who_goes[who_goes.find(true)] = false
		who_goes[fsuits.find(trumps.max())] = true
		if who_goes.find(true) == Globals.player_count-1: is_my_turn = true
		else: is_my_turn = false
		#print("Победил игрок ", fsuits.find(trumps.max()))
		#print(fsuits)
	#if check_cards[check_cards.size()-2].suit == check_cards[check_cards.size()-1].suit:
	#	if check_cards[check_cards.size()-2].rank < check_cards[check_cards.size()-1].rank:
	#		print("You won")
	#		#score += 1
	#		is_my_turn = true
	#	else:
	#		print("You losed")
	#		is_my_turn = false
	#elif check_cards[check_cards.size()-2].suit == trump: is_my_turn = false
	#elif check_cards[check_cards.size()-1].suit == trump:
	#	#score += 1
	#	is_my_turn = true
	#else:
	#	if is_my_turn:
	#		#score += 1
	#		print("You won")
	#		is_my_turn = true
	#	else:
	#		print("you losed")
	#		is_my_turn = false
	
	
	#print("была проверка")
	#for i in range(check_cards.size()):
	#	print(check_cards[i].rank, ' ', check_cards[i].suit)
	
	
	var c1 = check_cards[0]
	var c2 = check_cards[1]
	#print("ПЕРЕД РЕСАЙЗОМ", check_cards)
	check_cards = []
	check_cards.resize(Globals.player_count)
	#print("ПОСЛЕ РЕСАЙЗА", check_cards)
	screen_score.text = "Козырь: %s\nСчёт %s:%s" % [trump_string, score[1], circle_count - score[1]]
	#print("%s:%s" % [score, circle_count - score])
	await get_tree().create_timer(1.0).timeout
	
	
	
	
	
	
	#check_cards[0].queue_free()
	#check_cards[1].queue_free()
	c1.queue_free()
	c2.queue_free()
	if is_my_turn == false and player_hand.hand_cards.size() > 0 and who_goes.find(true) != Globals.player_count -1:
		enemy_goes()
		
	#check_cards.remove_at(0)
	#check_cards.remove_at(1)
	#check_cards = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if who_goes.find(true) == Globals.player_count: is_my_turn = true
	pass
	
func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
