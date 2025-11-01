class_name Trajectory
extends Node2D

var delta_pos: Vector2;
var direction: float = 0;
var step_magnitude: float = 3;
var line_color: Color = Color.WHITE;
var generation: int = 0;

var parent: Node2D;

var ttl: float;
var timer: Timer;

const particle_amount := [30, 5];

func _ready() -> void:
	parent = get_parent();
	delta_pos = position;

	timer = Timer.new();
	timer.autostart = false;
	timer.wait_time = ttl;

	timer.one_shot = true;

	add_child(timer);

	timer.start(ttl);


func average_color(target: Trajectory, percentage: float) -> void:
	line_color = line_color.lerp(target.line_color, percentage);

func foward():
	delta_pos.x += cos(direction) * step_magnitude;
	delta_pos.y += sin(direction) * step_magnitude;

	parent.draw_line(
		position,
		delta_pos,
		line_color,
		1,
		true
	);

	if timer.time_left <= 0:
		if generation == 0:
			var onda := Onda.new();
			onda.position = position;
			onda.max_radius = 100.0;
			parent.add_child(onda);

		queue_free();

		if generation > 1:
			return;

		for _i in particle_amount[generation]:
			var traject := Trajectory.new();
			traject.generation = generation + 1;

			if generation == 0:
				traject.ttl = randf_range(0.2, 0.4);
				traject.line_color = Color.from_hsv(randf()*0.2, 1, 1);
			elif generation == 1:
				traject.ttl = randf_range(0.05, 0.1);
				traject.line_color = Color.from_hsv(randf()*0.2 + 0.5, 1, 1);

			traject.direction = deg_to_rad(randf_range(0, 360));
			traject.position = position;

			parent.add_child(traject);

		return;

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

func steer(angle: float, steering_magnitude: float):
	direction = atan2(
		lerp(sin(direction), sin(angle),steering_magnitude),
		lerp(cos(direction), cos(angle),steering_magnitude)
	);
