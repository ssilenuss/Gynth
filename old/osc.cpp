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



    ClassDB::bind_method(D_METHOD("get_playback"), &Osc::get_playback);
	ClassDB::bind_method(D_METHOD("set_playback", "_value"), &Osc::set_playback);

    ClassDB::bind_method(D_METHOD("get_generator"), &Osc::get_generator);
	ClassDB::bind_method(D_METHOD("set_generator", "_value"), &Osc::set_generator);

	ClassDB::bind_method(D_METHOD("fill_buffer"), &Osc::fill_buffer);
}

Osc::Osc() {
	// Initialize any variables here.
	double frequency = 440.0;
	double phase = 0.0;
	double mix_rate = 48000.0;
	bool generating = false;
	int to_fill = 0;
	
}

Osc::~Osc() {
	// Add your cleanup here.
}

void Osc::_process(double delta){
    if (playback==nullptr){
    return;
    }
    else{
        fill_buffer();
    }

}

void Osc::set_frequency(double _value) {
	frequency = _value;
}

double Osc::get_frequency() {
	return frequency;
}

void Osc::set_playback(Ref<AudioStreamGeneratorPlayback> _playback){
    playback = _playback;
}

Ref<AudioStreamGeneratorPlayback> Osc::get_playback(){
    return this->playback;
}

void Osc::set_generator(Ref<AudioStreamGenerator> _generator){
    generator = _generator;
}

Ref<AudioStreamGenerator> Osc::get_generator(){
    return this->generator;
}



void Osc::set_mix_rate(double _value) {
	mix_rate = _value;
	generator->set_mix_rate(_value);
}

double Osc::get_mix_rate() {
	return mix_rate;
}

void Osc::fill_buffer() {
    
	double increment = frequency/this->get_mix_rate();
	to_fill = playback->get_frames_available();
	
	while (to_fill > 0){
		playback->push_frame(Vector2(1.0,1.0)*sin(phase * Math_TAU));
		phase = fmod(phase + increment, 1.0);
		to_fill -= 1;
	}
	
	
	
}