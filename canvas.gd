class_name Canvas
extends Camera2D

static var intance: Canvas;
static var frame_count: int;

static var max_iterations: int = 8;
static var speed: float = 0.002;

func _ready() -> void:
	intance = self;
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
	fill(Color.from_rgba8(0, 0, 100, 2));
