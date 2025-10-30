class_name Canvas
extends Camera2D

@export var billboard: Billboard;

static var frame_count: int;

var amplitude: float = 1;

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER,
	);
	Engine.max_fps = 60;

func _process(_delta: float) -> void:
	frame_count = Engine.get_process_frames();
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
	if cos(frame_count*0.1) < -0.999:
		billboard.f = randf() * 5;
		var viewport_size := (get_viewport_rect().size / 2) - Vector2.ONE * 100;

		billboard.position = Vector2(
			randf_range(-viewport_size.x, viewport_size.x),
			randf_range(-viewport_size.y, viewport_size.y),
		);

	fill(Color.from_rgba8(0, 0, 0, 10));

	billboard.rotation = frame_count * 0.001 * cos(frame_count*0.01);
	billboard.scale = amplitude * Vector2.ONE;

	amplitude = 0.5 * cos(frame_count * 0.1) + 1;
