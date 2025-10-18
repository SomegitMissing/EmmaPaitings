class_name Parent
extends Camera2D

@export var curvature: float;
@export var particles: int;
var osc: float;

var p_arr: Array[Trajectory] = [];

func mod2(x: int, m: int):
	var mod = x % m;
	if mod < 0:
		mod += m;
	return mod;

func _ready() -> void:
	var pi_div_p := (PI / particles) * 2

	for i in particles:
		var p := Trajectory.new();
		p.global_position.x = cos(i * pi_div_p)*200.0;
		p.global_position.y = sin(i * pi_div_p)*200.0;
		p_arr.append(p);
		add_child(p);


func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	osc = cos(Engine.get_process_frames()*0.01) + 0.2;
	for i in particles:
		var p := p_arr[i];
		var prev_p := p_arr[mod2(i-1, particles)];

		p.foward();
		p.steer_towards(prev_p.position, curvature);
		p.average_color(prev_p);

	if randi_range(0, 100) != 1:
		return;

	var r_i = randi_range(0, particles-1);

	var co := Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1));
	for i in 1000:
		p_arr[mod2(r_i+i, particles)].average_color2(co);
		await draw
