class_name P5Noise
extends Object

const PERLIN_YWRAPB = 4;
const PERLIN_YWRAP = 1 << PERLIN_YWRAPB;
const PERLIN_ZWRAPB = 8;
const PERLIN_ZWRAP = 1 << PERLIN_ZWRAPB;
const PERLIN_SIZE = 4095;

static var perlin: Array[float];
static var perlin_octaves := 4;
static var perlin_amp_falloff := 0.5;

static func scaled_cosine(i: float) -> float:
	return 0.5 * (1.0 - cos(i * PI));

static func noise(x: float, y: float = 0, z: float = 0) -> float:
	if perlin.size() == 0:
		perlin = [];
		perlin.resize(PERLIN_SIZE);
		for i in PERLIN_SIZE:
			perlin[i] = randf();

	x = abs(x);
	y = abs(y);
	z = abs(z);

	var xi: int = floor(x);
	var yi: int = floor(y);
	var zi: int = floor(z);

	var xf := x - xi;
	var yf := y - yi;
	var zf := z - zi;

	var r: float = 0;
	var ampl: float = 0.5;

	for o in perlin_octaves:
		var of := xi + (yi << PERLIN_YWRAPB) + (zi << PERLIN_ZWRAPB);

		var rxf := scaled_cosine(xf);
		var ryf := scaled_cosine(yf);

		var n1 := perlin[of & PERLIN_SIZE];
		n1 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n1);
		var n2 := perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
		n2 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n2);
		n1 += ryf * (n2 - n1);

		of += PERLIN_ZWRAP;
		n2 = perlin[of & PERLIN_SIZE];
		n2 += rxf * (perlin[(of + 1) & PERLIN_SIZE] - n2);
		var n3 := perlin[(of + PERLIN_YWRAP) & PERLIN_SIZE];
		n3 += rxf * (perlin[(of + PERLIN_YWRAP + 1) & PERLIN_SIZE] - n3);
		n2 += ryf * (n3 - n2);

		n1 += scaled_cosine(zf) * (n2 - n1);

		r += n1 * ampl;
		ampl *= perlin_amp_falloff;
		xi <<= 1;
		xf *= 2;
		yi <<= 1;
		yf *= 2;
		zi <<= 1;
		zf *= 2;

		if xf >= 1.0:
			xi += 1;
			xf -= 1;

		if yf >= 1.0:
			yi += 1;
			yf -= 1;

		if zf >= 1.0:
			zi += 1;
			zf -= 1;


	return r;
