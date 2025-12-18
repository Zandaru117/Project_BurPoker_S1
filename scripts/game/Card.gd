extends Area2D
class_name Card

enum Suit { hearts, diamonds, clubs, spades }
enum Rank { six, seven, eight, nine, ten, jack, queen, king, ace }

var suit: Suit
var rank: Rank

var initial_position: Vector2

@onready var sprite: Sprite2D = $Sprite2D   # ← ВАЖНО

func setup(new_suit: Suit, new_rank: Rank):
	suit = new_suit
	rank = new_rank

func change_position(new_position):
	position = new_position

func load_card_texture():
	var texture_path = "res://assets/cards/card_%s_%s.png" % [Suit.keys()[suit], Rank.keys()[rank]]
	var texture: Texture2D = load(texture_path)
	sprite.texture = texture
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_card_texture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
