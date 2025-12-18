extends Area2D
class_name Card

enum Suit { hearts, diamonds, clubs, spades }
enum Rank { six, seven, eight, nine, ten, jack, queen, king, ace }

var suit: Suit
var rank: Rank
var is_player_card: bool
var back_texture: Texture2D = load( "res://assets/cards/card_back.png")
var dropzone: DropZone = null

var initial_position: Vector2

@onready var sprite: Sprite2D = $Sprite2D

func setup(new_suit: Suit, new_rank: Rank):
	suit = new_suit
	rank = new_rank

func change_position(new_position):
	position = new_position

func load_card_texture():
	var texture_path = "res://assets/cards/card_%s_%s.png" % [Suit.keys()[suit], Rank.keys()[rank]]
	var main_texture: Texture2D = load(texture_path)
	var texture: Texture2D
	if is_player_card:
		texture = main_texture
	else:
		texture = back_texture
	sprite.texture = texture
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_card_texture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
	
	
var is_dragging := false
var drag_offset := Vector2.ZERO

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and is_player_card:
		if event.pressed:
			is_dragging = true
			drag_offset = global_position - get_global_mouse_position()
			z_index = 1000 # поверх других
		else:
			is_dragging = false
			z_index = 0
			stop_drag()


func stop_drag():
	is_dragging = false
	if dropzone.mouse_inside:
		global_position = dropzone.global_position
	else:
		global_position = initial_position
