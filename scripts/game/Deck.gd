extends Node
class_name Deck

@export var cards: Array = []
@export var card_scene: PackedScene

func initialize_deck():
	for suit in Card.Suit.size():
		for rank in Card.Rank.size():
			var card: Card = card_scene.instantiate()
			var position = Vector2(35+suit*100,35+rank*100)
			card.setup(suit, rank)
			cards.append(card)
			#add_child(card)
			card.position = position

func shuffle():
	cards.shuffle()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
