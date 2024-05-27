#include "audio_stream_oscillator.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void AudioStreamOscillator::_bind_methods() {

	ClassDB::bind_method(D_METHOD("get_generating"), &AudioStreamOscillator::get_generating);
	ClassDB::bind_method(D_METHOD("set_generating", "_value"), &AudioStreamOscillator::set_generating);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::BOOL, "generating"), "set_generating", "get_generating");
	
	ClassDB::bind_method(D_METHOD("get_frequency"), &AudioStreamOscillator::get_frequency);
	ClassDB::bind_method(D_METHOD("set_frequency", "_value"), &AudioStreamOscillator::set_frequency);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
	
	ClassDB::bind_method(D_METHOD("get_mix_rate"), &AudioStreamOscillator::get_mix_rate);
	ClassDB::bind_method(D_METHOD("set_mix_rate", "_value"), &AudioStreamOscillator::set_mix_rate);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::FLOAT, "mix_rate"), "set_mix_rate", "get_mix_rate");

	ClassDB::bind_method(D_METHOD("get_to_fill"), &AudioStreamOscillator::get_to_fill);
	ClassDB::bind_method(D_METHOD("set_to_fill", "_value"), &AudioStreamOscillator::set_to_fill);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::INT, "to_fill"), "set_to_fill", "get_to_fill");

	ClassDB::bind_method(D_METHOD("_fill_buffer"), &AudioStreamOscillator::_fill_buffer);
}

AudioStreamOscillator::AudioStreamOscillator() {
	// Initialize any variables here.
	double frequency = 440.0;
	double phase = 0.0;
	double mix_rate = 48000.0;
	bool generating = false;
	int to_fill = 0;
	
	
}

AudioStreamOscillator::~AudioStreamOscillator() {
	// Add your cleanup here.
}

void AudioStreamOscillator::set_frequency(double _value) {
	frequency = _value;
}

double AudioStreamOscillator::get_frequency() {
	return frequency;
}

void AudioStreamOscillator::set_mix_rate(double _value) {
	mix_rate = _value;
	Ref<AudioStreamGenerator> gen = this->get_stream();
	gen->set_mix_rate(mix_rate);
}

double AudioStreamOscillator::get_mix_rate() {
	return mix_rate;
}


void AudioStreamOscillator::_ready(){
	
	this->set_stream(& AudioStreamGenerator());
	Ref<AudioStreamGenerator> gen = this->get_stream();
	gen->set_mix_rate(mix_rate);
	
	
	
}


void AudioStreamOscillator::set_generating(bool _value){

	generating = _value;
}
bool AudioStreamOscillator::get_generating(){
	return generating;
}

void AudioStreamOscillator::set_to_fill(int _value){
	to_fill = _value;
}
int AudioStreamOscillator::get_to_fill(){
	return generating;
}


void AudioStreamOscillator::_process(double delta){
	//UtilityFunctions::print(this->is_playing());

	if (generating){
		_fill_buffer();
	}
	
}


void AudioStreamOscillator::_fill_buffer() {

	double increment = frequency/mix_rate;
	Ref<AudioStreamGeneratorPlayback> playback = this->get_stream_playback();
	//to_fill = playback->get_frames_available();
	UtilityFunctions::print(increment);
	
	while (to_fill > 0){
		playback->push_frame(Vector2(1.0,1.0)*sin(phase * Math_TAU));
		phase = fmod(phase + increment, 1.0);
		to_fill -= 1;


	}
	
	
	
}