class_name Canvas
extends Camera2D

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER,
	);

func camera_size() -> Vector2:
	return get_viewport_rect().size / zoom;

func _process(_delta: float) -> void:
	queue_redraw()

func fill(color: Color):
	var cam_size := camera_size();

	draw_rect(Rect2(
		position.x - cam_size.x/2,
		position.y - cam_size.y/2,
		cam_size.x,
		cam_size.y,
	), color);

func _draw() -> void:
	pass
