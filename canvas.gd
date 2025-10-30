class_name Canvas
extends Camera2D

static var frame_count: int;

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER,
	);

func _process(_delta: float) -> void:
	frame_count = Engine.get_process_frames();
	queue_redraw()

func fill(color: Color):
	var viewport_size := get_viewport_rect().size;

	draw_rect(Rect2(
		position - viewport_size/2,
		viewport_size,
	), color);

func _draw() -> void:
	pass
