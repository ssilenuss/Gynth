#include "Osc.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void Osc::_bind_methods() {

	ClassDB::bind_method(D_METHOD("get_frequency"), &Osc::get_frequency);
	ClassDB::bind_method(D_METHOD("set_frequency", "_value"), &Osc::set_frequency);
	ClassDB::add_property("Osc", PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");

    ClassDB::bind_method(D_METHOD("get_mix_rate"), &Osc::get_mix_rate);
	ClassDB::bind_method(D_METHOD("set_mix_rate", "_value"), &Osc::set_mix_rate);
	ClassDB::add_property("Osc", PropertyInfo(Variant::FLOAT, "mix_rate"), "set_mix_rate", "get_mix_rate");


	ClassDB::bind_method(D_METHOD("get_sin_buffer", "_size"), &Osc::get_sin_buffer);
	ClassDB::bind_method(D_METHOD("get_saw_buffer", "_size"), &Osc::get_saw_buffer);
	ClassDB::bind_method(D_METHOD("get_pulse_buffer", "_size"), &Osc::get_pulse_buffer);
	ClassDB::bind_method(D_METHOD("get_square_buffer", "_size"), &Osc::get_square_buffer);
	ClassDB::bind_method(D_METHOD("get_noise_buffer", "_size"), &Osc::get_noise_buffer);
}

Osc::Osc() {
	// Initialize any variables here.
	double frequency = 440.0;
	double phase = 0.0;
	double mix_rate = 48000.0;
	int to_fill = 0;
	
}

Osc::~Osc() {
	// Add your cleanup here.
}



void Osc::set_frequency(double _value) {
	frequency = _value;
}

double Osc::get_frequency() {
	return frequency;
}

void Osc::set_mix_rate(double _value) {
	mix_rate = _value;
}

double Osc::get_mix_rate() {
	return mix_rate;
}

PackedVector2Array Osc::get_sin_buffer(int _size) {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = _size;
	PackedVector2Array buffer = PackedVector2Array();
	
	while (to_fill > 0){
		buffer.append(Vector2(1.0,1.0)*sin(phase * Math_TAU));
		phase = fmod(phase + increment, 1.0);
		to_fill -= 1;
	}
	return buffer;
}

PackedVector2Array Osc::get_saw_buffer(int _size) {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = _size;
	PackedVector2Array buffer = PackedVector2Array();
	
	while (to_fill > 0){
		phase = fmod(phase + increment, 1.0);
		double frame = (phase*2)-1.0;
		buffer.append(Vector2(1.0,1.0)*frame);
		to_fill -= 1;
	}
	return buffer;
}

PackedVector2Array Osc::get_pulse_buffer(int _size) {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = _size;
	PackedVector2Array buffer = PackedVector2Array();
	
	while (to_fill > 0){
		phase = fmod(phase + increment, 1.0);
		double frame = (phase*2)-1.0;
		buffer.append(Vector2(1.0,1.0)*-frame);
		to_fill -= 1;
	}
	return buffer;
}

PackedVector2Array Osc::get_noise_buffer(int _size) {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = _size;
	PackedVector2Array buffer = PackedVector2Array();
	
	while (to_fill > 0){
		double frame = rand()/double(RAND_MAX);
		frame = (frame*2.0)-1.0;
		buffer.append(Vector2(1.0,1.0)*frame);
		to_fill -= 1;
	}
	return buffer;
}

PackedVector2Array Osc::get_square_buffer(int _size) {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = _size;
	PackedVector2Array buffer = PackedVector2Array();
	
	while (to_fill > 0){
		phase = fmod(phase + increment, 1.0);
		double frame = 0.0;
		if (phase<0.5){
			frame = -1.0;
		} else {
			frame = 1.0;
		}
		buffer.append(Vector2(1.0,1.0)*frame);
		to_fill -= 1;
	}
	return buffer;
	
}

