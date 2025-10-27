class_name Branch
extends Node2D

var angle: float;
var length: float;
var spliting: int;
var iteration: float;

var position2: Vector2;
var parent: Canvas;

func _ready() -> void:
	position2.x = position.x + cos(angle) * length;
	position2.y = position.y + sin(angle) * length;

	parent = get_parent();

func grow() -> void:
	if iteration >= Canvas.max_iterations:
		return;

	for i in spliting:
		var branch := Branch.new();
		branch.position = position2;
		branch.angle = angle * i - Canvas.frame_count * Canvas.speed * iteration;
		branch.length = length * 0.8;
		branch.spliting = spliting;
		branch.iteration = iteration + 1;

		parent.add_child(branch);

func b_show() -> void:
	parent.draw_line(
		position,
		position2,
		Color.WHITE,
	);

	if iteration != Canvas.max_iterations:
		return;

	show_leaf();

	var child_count := parent.get_child_count();
	for _i in child_count:
		parent.get_child(0).queue_free();

func show_leaf() -> void:
	var n := P5Noise.noise(Canvas.frame_count * Canvas.speed * 10);

	var radius := 50 * n;
	parent.draw_circle(
		position2,
		radius,
		Color(n, n, n),
	);

	var border_color := Color.from_rgba8(int(252 + n*100), int(98 + n*100), int(3 + n*100));
	parent.draw_circle(
		position2,
		radius + 1,
		border_color,
	);

static func draw_arch(start: Vector2, end: Vector2, color: Color, depth: int) -> void:
	if depth <= 0:
		return;

	var mid := start.lerp(end, 0.5);
	var r := start.distance_to(end) / 2;

	var a1 := atan2(start.y - mid.y, start.x - mid.x);
	var a2 := atan2(end.y - mid.y, end.x - mid.x);

	if a2 < a1:
		a2 += TAU;

	Canvas.intance.draw_arc(
		mid,
		r * 2,
		a1,
		a2,
		50,
		color
	);
