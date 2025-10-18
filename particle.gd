class_name Trajectory
extends Node2D

var delta_pos: Vector2;
var direction: float = 0;
var step_magnitude: float = 3;
var mutant: bool = false;
var line_color: Color = Color.WHITE;

func _ready() -> void:
	delta_pos = position;

func average_color(target: Trajectory) -> Color:
	var result := Color(
		(line_color.r + target.line_color.r)/2,
		(line_color.g + target.line_color.g)/2,
		(line_color.b + target.line_color.b)/2,
	);

	line_color = result;

	return result;

func foward():
	delta_pos.x += cos(direction) * step_magnitude;
	delta_pos.y += sin(direction) * step_magnitude;

	if visible:
		get_parent().draw_line(
			position,
			delta_pos,
			line_color,
			1,
			true
		);

	if mutant:
		get_parent().draw_circle(position, 3, line_color)


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
