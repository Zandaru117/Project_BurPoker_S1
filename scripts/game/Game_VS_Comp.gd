extends Node2D
@onready var deck: Deck = $Deck
@onready var hand: Hand = $Hand
@export var hand_scene: PackedScene

var hands: Array[Hand] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.initialize_deck()
	deck.shuffle()
	#print(deck.cards)
	#for i in range(deck.cards.size()):
	#	deck.cards[i].change_position(Vector2(35+i*100,35+i*100))
	#	#print(deck.cards[i].suit)
	
	for i in range(2):
		var hand1: Hand = hand_scene.instantiate()
		hands.append(hand1)
		hands[i].hand_position = Vector2(500, 100 + i*400)
		add_child(hands[i])
		#print("POOP %s" % [hands[i].hand_position])
		hands[i].deal_cards()
		#print("первому раздал")
	#for i in range(2):
	#	for j in range(4):
	#		print(hands[i].hand_cards[j].position[0], hands[i].hand_cards[j].position[1])
	#print(deck.cards.size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
