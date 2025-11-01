class_name Canvas
extends Node2D

static var frame_count: int;
static var delta: float;

static var exp_audio: AudioStreamMP3;
static var exp_mini_audio: AudioStreamMP3;

@export var margin: float = 100;
@export var audio: AudioStreamMP3;
@export var _exp_audio: AudioStreamMP3;
@export var _exp_mini_audio: AudioStreamMP3;

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_ONLY_NEXT_FRAME
	);
	exp_audio = _exp_audio;
	exp_mini_audio = _exp_mini_audio;

func _process(_delta: float) -> void:
	frame_count = Engine.get_process_frames();
	delta = _delta;
	queue_redraw()

func fill(color: Color):
	var viewport_size := get_viewport_rect().size;

	draw_rect(Rect2(
		Vector2.ZERO - position,
		viewport_size,
	), color);

func _draw() -> void:
	fill(Color(0, 0, 0, P5Noise.noise(frame_count * 0.1) * 0.1));
	var viewport_size := get_viewport_rect().size / 2;

	var rand_pos := Vector2(
		randf_range(-viewport_size.x + margin, viewport_size.x - margin),
		viewport_size.y,
	);

	if randi_range(0, 70) == 0:
		var traject := Trajectory.new();
		traject.position = rand_pos;
		traject.direction = deg_to_rad(270);
		traject.ttl = randf_range(0.5, 1);
		traject.near = 1 + randf_range(-2, 1) * 0.5;

		add_child(traject);

		var sound = AudioStreamPlayer.new();
		sound.stream = audio;
		sound.volume_db = randf_range(-10, -5);
		sound.pitch_scale = randf_range(1, 1.5);

		traject.add_child(sound);
		traject.sound = sound;

		sound.play(traject.ttl);

	var child_count := get_child_count();
	for child_i in child_count:
		var node := get_child(child_i);
		if not node is Trajectory:
			continue;

		var particle: Trajectory = node;

		particle.foward();
		match particle.generation:
			0:
				particle.direction = deg_to_rad(270 + cos(Canvas.frame_count * 0.1) * 10);
			1:
				particle.steer(deg_to_rad(90), 0.01);
			2:
				particle.steer(deg_to_rad(90), 0.03);


	# fill(Color.from_rgba8(0, 0, 0, 5));

	# for i in particles:
	# 	var i_pi_div := float(i) / particles * PI;
	# 	var curvature := 0.7 + cos(i_pi_div + frame_count * 0.1)/5;
	# 	var osc := cos(i_pi_div + frame_count * 0.01) + 0.2;

	# 	var p := particle_arr[i];
	# 	if i > 0:
	# 		var prev_p := particle_arr[i-1];
	# 		p.foward();
	# 		p.steer_towards(prev_p.position, curvature);
	# 		p.average_color(prev_p, 0.95);
	# 	else:
	# 		var prev_p := particle_arr[particles - 1];
	# 		p.foward()
	# 		p.steer_towards(prev_p.position, curvature);


	# 	if p.mutant:
	# 		p.step_magnitude = osc;

	# if randi_range(0, 50) != 1:
	# 	return;

	# var r_i := randi_range(0, particles-1);

	# var swap = particle_arr[0];
	# particle_arr[0] = particle_arr[r_i];
	# particle_arr[r_i] = swap;

	# var p0 := particle_arr[0];

	# p0.line_color = Color(randf(), randf(), randf());
	# p0.mutant = true;
