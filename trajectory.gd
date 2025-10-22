class_name Trajectory
extends Node2D

var delta_pos: Vector2;
var direction: float = 0;
var step_magnitude: float = 3;
var mutant: bool = false;
var line_color: Color = Color.WHITE;
var drw_line: Callable;
var drw_circle: Callable;

func _ready() -> void:
	delta_pos = position;

	var parent = get_parent();
	drw_line = parent.draw_line;
	drw_circle = parent.draw_circle;

func average_color(target: Trajectory, percentage: float) -> void:
	line_color = line_color.lerp(target.line_color, percentage);

func foward():
	delta_pos.x += cos(direction) * step_magnitude;
	delta_pos.y += sin(direction) * step_magnitude;

	drw_line.call(
		position,
		delta_pos,
		line_color,
		1,
		true
	);

	if mutant:
		drw_circle.call(position, 3, line_color)


	position = delta_pos;

func steer_towards(target: Vector2, steering_magnitude: float):
	var target_dir := atan2(
		target.y - position.y,
		target.x - position.x,
	);

	direction = atan2(
		lerp(sin(direction), sin(target_dir), steering_magnitude),
		lerp(cos(direction), cos(target_dir), steering_magnitude),
	);
