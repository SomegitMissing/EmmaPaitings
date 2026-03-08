class_name LGC
extends Object


const M = 4294967296;
const A = 1664525;
const C = 1664525;


var _seed: int = randi() % M;
var z: float = _seed;


func set_seed(val: int) -> void:
	_seed = val & 0xffffffff;
	z = _seed;


func rand() -> float:
	z = A * z + C;

	var int_part: int = floori(z);
	var decimal_part: float = z - int_part;

	return ((int_part % M) + decimal_part) / M
