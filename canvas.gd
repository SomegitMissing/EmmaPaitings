class_name Canvas
extends Camera2D

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER,
	);

func _process(_delta: float) -> void:
	queue_redraw()

func fill(color: Color):
	var viewport_size := get_viewport_rect().size;

	draw_rect(Rect2(
		position.x - viewport_size.x/2,
		position.y - viewport_size.y/2,
		viewport_size.x,
		viewport_size.y,
	), color);

func _draw() -> void:
	pass
