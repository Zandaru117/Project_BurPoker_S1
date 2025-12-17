extends Node2D
@onready var deck: Deck = $Deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.initialize_deck()
	for i in range(deck.cards.size()):
		#add_child(deck.cards[i])
		deck.cards[i].card_position = Vector2(35,35)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
