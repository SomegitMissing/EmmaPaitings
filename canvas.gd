class_name Canvas
extends Camera2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	queue_redraw()

func fill(color: Color):
	var camera_size := get_viewport_rect().size / zoom;

	draw_rect(Rect2(
		position.x - camera_size.x/2,
		position.y - camera_size.y/2,
		camera_size.x,
		camera_size.y,
	), color);


func _draw() -> void:
	pass
