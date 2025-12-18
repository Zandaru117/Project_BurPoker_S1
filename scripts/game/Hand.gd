extends Node
class_name Hand

var max_cards: int = 4

@onready var deck = get_parent().get_node("Deck")
var hand_position: Vector2
var hand_cards: Array[Card] = []
var is_player_hand: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func deal_cards(is_p_card: bool, zone: Area2D):
	for i in range(max_cards):
		var card = deck.cards.pop_back()
		add_card(card, i, is_p_card, zone)

func add_card(card: Card, index: int, is_p_card: bool, zone: Area2D):
	hand_cards.append(card)
	card.position = Vector2(hand_position[0] + 50* index, hand_position[1])
	card.is_player_card = is_p_card
	card.dropzone = zone
	add_child(hand_cards[index])
	#print("поставил на [%s, %s]" % [hand_position[0] + hand_position[0] * index, hand_position[1]])
	card.initial_position = card.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
