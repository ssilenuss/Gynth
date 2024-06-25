extends Node

var mix_rate :float = 48000.0

var held_wire :WireEnd :
	set(value):
		held_wire = value
		#print('held wire:  ', held_wire)

#exponential interpolation
func logerp(_from:float, _to:float, _t: float)->float:
	return _from*pow(_to/_from, _t)
	#return a*pow(b/a, t);
	#return start + (end - start) * Mathf.Pow(t, weight);

func inverp(_from:float, _to:float, _t: float)->float:
	return _to*( log(_from/_to)/log(_t) )
	#return return end - (end - start) * Mathf.Log(t, weight);


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float)->Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r	
