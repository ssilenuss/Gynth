extends Node

var held_wire :WireEnd :
	set(value):
		held_wire = value
		#print('held wire:  ', held_wire)

func logerp(_from:float, _to:float, _t: float)->float:
	return _from*pow(_to/_from, _t)
	#return a*pow(b/a, t);
