#include "audio_stream_oscillator.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void AudioStreamOscillator::_bind_methods() {
	
	ClassDB::bind_method(D_METHOD("get_frequency"), &AudioStreamOscillator::get_frequency);
	ClassDB::bind_method(D_METHOD("set_frequency", "_value"), &AudioStreamOscillator::set_frequency);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
	
	ClassDB::bind_method(D_METHOD("get_generating"), &AudioStreamOscillator::get_generating);
	ClassDB::bind_method(D_METHOD("set_generating", "_value"), &AudioStreamOscillator::set_generating);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::BOOL, "generating"), "set_generating", "get_generating");

	ClassDB::bind_method(D_METHOD("get_playback"), &AudioStreamOscillator::get_playback);
	ClassDB::bind_method(D_METHOD("set_playback", "_value"), &AudioStreamOscillator::set_playback);
	ClassDB::add_property("AudioStreamOscillator", PropertyInfo(Variant::OBJECT, "playback"), "set_playback", "get_playback");

	ClassDB::bind_method(D_METHOD("_fill_buffer"), &AudioStreamOscillator::_fill_buffer);
}

AudioStreamOscillator::AudioStreamOscillator() {
	// Initialize any variables here.
	float frequency = 440.0;
	double phase = 0.0;
	Ref<AudioStreamGeneratorPlayback> playback = instantiate_playback();
	generating = false;
}

AudioStreamOscillator::~AudioStreamOscillator() {
	// Add your cleanup here.
}

void AudioStreamOscillator::set_frequency(float _value) {
	frequency = _value;
}

float AudioStreamOscillator::get_frequency() {
	return frequency;
}

void AudioStreamOscillator::set_playback(Ref<AudioStreamGeneratorPlayback> _value) {
	playback = _value;
}

Ref<AudioStreamGeneratorPlayback> AudioStreamOscillator::get_playback(){
	return playback;
}

void AudioStreamOscillator::set_generating(bool _value){
	generating = _value;
}
bool AudioStreamOscillator::get_generating(){
	return generating;
}



void AudioStreamOscillator::_fill_buffer() {
	if (generating==true){
		float increment = frequency;
		int to_fill = playback->get_frames_available();
		UtilityFunctions::print(to_fill);
		while (to_fill > 0){
			playback->push_frame(Vector2(1.0,1.0)*sin(phase * Math_TAU));
			phase = fmod(phase + increment, 1.0);
			to_fill -= 1;
		}

	}
	
	
}