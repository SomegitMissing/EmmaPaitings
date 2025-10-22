@tool
extends CollisionShape2D

var parent: Canvas;
var circle_shape: CircleShape2D;

func _ready() -> void:
	parent = get_parent();
	circle_shape = shape;

	if Engine.is_editor_hint():
		return;

	queue_free();

func _process(_delta: float) -> void:
	if parent == null or circle_shape == null:
		return;

	circle_shape.radius = parent.radius;
