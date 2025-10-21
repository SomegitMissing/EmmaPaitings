class_name Parent
extends Camera2D

@export var particles: int;
@export var diameter: float;

var p_arr: Array[Trajectory] = [];

func _ready() -> void:
	var pi_div_p := (PI / particles) * 2

	for i in particles:
		var p := Trajectory.new();
		p.global_position.x = cos(i * pi_div_p)*diameter;
		p.global_position.y = sin(i * pi_div_p)*diameter;
		p_arr.append(p);
		add_child(p);


func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var frame_count = Engine.get_process_frames();
	for i in particles:
		var i_pi_div := float(i) / particles * PI;
		var curvature := 0.7 + cos(i_pi_div + frame_count * 0.1)/5;
		var osc := cos(i_pi_div + frame_count * 0.01) + 0.2;

		var p := p_arr[i];
		if i > 0:
			var prev_p = p_arr[i-1];
			p.foward();
			p.steer_towards(prev_p.position, curvature);
			p.average_color(prev_p, 0.95);
		else:
			var prev_p = p_arr[particles - 1];
			p.foward()
			p.steer_towards(prev_p.position, curvature);


		if p.mutant:
			p.step_magnitude = osc;

	if randi_range(0, 50) != 1:
		return;

	var r_i = randi_range(0, particles-1);

	var swap = p_arr[0];
	p_arr[0] = p_arr[r_i];
	p_arr[r_i] = swap;

	var p0 := p_arr[0];

	p0.line_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1));
	p0.mutant = true;
