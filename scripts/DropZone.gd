extends Area2D
class_name DropZone


var mouse_inside := false

func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
