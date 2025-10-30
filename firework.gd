class_name Firework
extends Node2D

var f: float = 1;
var stroke_color: Color = Color.from_rgba8(255, 150, 0);

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for i in 300:
		var circle_pos := Vector2(
			0.2 * cos(f * 0.999 * i + Canvas.frame_count * 0.01) * i,
			0.2 * sin(f * i + Canvas.frame_count * 0.01) * i
		);

		var radius := cos(Canvas.frame_count * 0.001 * i) + 5;

		draw_circle(
			circle_pos,
			radius + 1,
			stroke_color
		);
		draw_circle(
			circle_pos,
			radius,
			Color.WHITE
		);
		draw_rect(
			Rect2(
				Vector2(
					0.5 * sin(f * 0.999 * i + Canvas.frame_count * 0.01) * i,
					0.5 * cos(f * i + Canvas.frame_count * 0.01) * i
				),
				Vector2.ONE
			),
			stroke_color,
		);
