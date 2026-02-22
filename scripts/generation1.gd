extends Trajectory


@export var next_gen_amount: int = 30;
@export var next_gen: PackedScene;


func foward() -> void:
	super.foward();

	if timer.time_left > 0:
		return;

	var onda := Onda.new();
	onda.position = position;
	onda.max_radius = 100.0 * near;
	parent.add_child(onda);

	var explo := ExplosionPlayer.new();
	explo.stream = Canvas.exp_audio;
	explo.pitch_scale = randf_range(0.75, 1);
	parent.add_child(explo);
	explo.play();

	queue_free();

	for _i: int in next_gen_amount:
		pass
