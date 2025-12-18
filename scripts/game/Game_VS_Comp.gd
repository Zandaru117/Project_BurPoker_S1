extends Node2D
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var hand_scene: PackedScene
@onready var player_dropzone: DropZone = $Player_DropZone
@onready var enemy_dropzone: DropZone = $Enemy_DropZone

var hands: Array[Hand] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
