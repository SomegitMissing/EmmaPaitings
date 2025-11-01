class_name Trajectory
extends Node2D

var delta_pos: Vector2;
var direction: float = 0;
const step_magnitude: float = 1080 - 200;
var line_color: Color = Color.WHITE;
var generation: int = 0;
var near: float = 1;

var parent: Node2D;

var ttl: float;
var timer: Timer;

var sound: AudioStreamPlayer;

const particle_amount := [30, 5];

func _ready() -> void:
	parent = get_parent();
	delta_pos = position;

	timer = Timer.new();
	timer.autostart = false;

	timer.one_shot = true;

	add_child(timer);

	timer.start(ttl);

func average_color(target: Trajectory, percentage: float) -> void:
	line_color = line_color.lerp(target.line_color, percentage);

func foward():
	delta_pos.x += cos(direction) * step_magnitude * Canvas.delta;
	delta_pos.y += sin(direction) * step_magnitude * Canvas.delta;

	parent.draw_line(
		position,
		delta_pos,
		line_color,
		(timer.time_left * 10 * (generation + 1)) * near,
		true
	);

	if sound != null:
		sound.pitch_scale = lerp(sound.pitch_scale, 0.00001, Canvas.delta * 0.5);

	if timer.time_left <= 0:

		if generation == 0:
			var onda := Onda.new();
			onda.position = position;
			onda.max_radius = 100.0 * near;
			parent.add_child(onda);

			var explo := ExplosionPlayer.new();
			explo.stream = Canvas.exp_audio;
			explo.pitch_scale = randf_range(0.75, 1);
			parent.add_child(explo);
			explo.play();

		elif randi() % 2 == 0:
			var explo := ExplosionPlayer.new();
			explo.stream = Canvas.exp_mini_audio;
			explo.volume_db = -15;
			explo.pitch_scale = randf_range(0.75, 1.5);
			parent.add_child(explo);
			explo.play();

		queue_free();

		if generation > 1:
			parent.draw_circle(
				position,
				3,
				Color.WHITE,
			);
			return;

		for _i in particle_amount[generation]:
			var traject := Trajectory.new();
			traject.generation = generation + 1;

			if generation == 0:
				traject.ttl = randf_range(0.2, 0.4) * (near+0.1);
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
		lerp(sin(direction), sin(angle), steering_magnitude * Canvas.delta),
		lerp(cos(direction), cos(angle), steering_magnitude * Canvas.delta)
	);
