class_name Canvas
extends Camera2D

var camera_size: Vector2;
var frame_count: int;
var viewport_size: Vector2;

var amplitude: float = 1;

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER,
	);
	viewport_size = get_viewport_rect().size;

func _process(_delta: float) -> void:
	camera_size = get_viewport_rect().size / zoom;
	frame_count = Engine.get_process_frames();
	queue_redraw()

func fill(color: Color):
	draw_rect(Rect2(
		position.x - viewport_size.x/2,
		position.y - viewport_size.y/2,
		viewport_size.x,
		viewport_size.y,
	), color);


func _draw() -> void:
	fill(Color(0, 0, 0, 10.0/255));
	rotate(deg_to_rad(frame_count * 0.0003));
	zoom = Vector2.ONE * (amplitude + 2);

	amplitude = (cos(frame_count * 0.012) + 1)/2;

	var n1 := P5Noise.noise(frame_count * 0.01) * 255;
	var n2 := P5Noise.noise(frame_count * 0.02) * 255;
	var n3 := P5Noise.noise(frame_count * 0.03) * 255;

	var small_color := Color.from_rgba8(floor(n1), floor(n2), floor(n3));
	var big_color := Color.from_rgba8(floor(n2), floor(n3), floor(n1));

	var small_radius := 5 * n2 / 255;
	var big_radius := small_radius + 0.5;

	var n1_x2: int = floor(n1 * 2);

	for i in n1_x2:
		var pos := Vector2(
			0.5 * cos(i + frame_count * 0.015) * i,
			0.5 * sin(i + frame_count * 0.01) * i,
		);

		draw_circle(
			pos,
			big_radius,
			big_color,
		);
		draw_circle(
			pos,
			small_radius,
			small_color,
		);
