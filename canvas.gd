class_name Canvas
extends Camera2D

static var frame_count: int;

@export var particles: int;
@export var radius: float;

var p_arr: Array[Trajectory] = [];

func _ready() -> void:
	RenderingServer.viewport_set_clear_mode(
		get_viewport().get_viewport_rid(),
		RenderingServer.VIEWPORT_CLEAR_NEVER
	);
	var pi_div_p := TAU / particles;

	for i in particles:
		var p := Trajectory.new();
		p.position.x = cos(i * pi_div_p)*radius;
		p.position.y = sin(i * pi_div_p)*radius;
		p_arr.append(p);
		add_child(p);


func _process(_delta: float) -> void:
	frame_count = Engine.get_process_frames();
	queue_redraw()

func fill(color: Color):
	var viewport_size := get_viewport_rect().size;

	draw_rect(Rect2(
		position - viewport_size/2,
		viewport_size,
	), color);

func _draw() -> void:
	fill(Color.from_rgba8(0, 0, 0, 5));

	for i in particles:
		var i_pi_div := float(i) / particles * PI;
		var curvature := 0.7 + cos(i_pi_div + frame_count * 0.1)/5;
		var osc := cos(i_pi_div + frame_count * 0.01) + 0.2;

		var p := p_arr[i];
		if i > 0:
			var prev_p := p_arr[i-1];
			p.foward();
			p.steer_towards(prev_p.position, curvature);
			p.average_color(prev_p, 0.95);
		else:
			var prev_p := p_arr[particles - 1];
			p.foward()
			p.steer_towards(prev_p.position, curvature);


		if p.mutant:
			p.step_magnitude = osc;

	if randi_range(0, 50) != 1:
		return;

	var r_i := randi_range(0, particles-1);

	var swap = p_arr[0];
	p_arr[0] = p_arr[r_i];
	p_arr[r_i] = swap;

	var p0 := p_arr[0];

	p0.line_color = Color(randf(), randf(), randf());
	p0.mutant = true;
