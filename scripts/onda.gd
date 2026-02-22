class_name Onda
extends Node2D

var radius: float = 0;
var speed: float = 0;
var acceleration: float = 10000;
var max_radius: float;

var delta: float;

func _process(_delta: float) -> void:
	delta = _delta;
	queue_redraw();

func _draw() -> void:
	speed += acceleration * delta;
	radius += speed * delta;

	draw_circle(
		Vector2.ZERO,
		radius,
		Color.from_hsv(randf()*0.2, 0.3, 1, (1.0 - (radius/max_radius))*0.3),
	);

	if radius >= max_radius:
		queue_free();
