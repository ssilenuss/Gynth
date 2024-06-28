#include "audio_stream_oscillator3D.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void AudioStreamOscillator3D::_bind_methods() {

	ClassDB::bind_method(D_METHOD("get_generating"), &AudioStreamOscillator3D::get_generating);
	ClassDB::bind_method(D_METHOD("set_generating", "_value"), &AudioStreamOscillator3D::set_generating);
	ClassDB::add_property("AudioStreamOscillator3D", PropertyInfo(Variant::BOOL, "generating"), "set_generating", "get_generating");
	
	ClassDB::bind_method(D_METHOD("get_frequency"), &AudioStreamOscillator3D::get_frequency);
	ClassDB::bind_method(D_METHOD("set_frequency", "_value"), &AudioStreamOscillator3D::set_frequency);
	ClassDB::add_property("AudioStreamOscillator3D", PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
	
	ClassDB::bind_method(D_METHOD("get_mix_rate"), &AudioStreamOscillator3D::get_mix_rate);
	ClassDB::bind_method(D_METHOD("set_mix_rate", "_value"), &AudioStreamOscillator3D::set_mix_rate);
	ClassDB::add_property("AudioStreamOscillator3D", PropertyInfo(Variant::FLOAT, "mix_rate"), "set_mix_rate", "get_mix_rate");

	ClassDB::bind_method(D_METHOD("get_osc_type"), &AudioStreamOscillator3D::get_osc_type);
	ClassDB::bind_method(D_METHOD("set_osc_type", "_value"), &AudioStreamOscillator3D::set_osc_type);
	ClassDB::add_property("AudioStreamOscillator3D", PropertyInfo(Variant::INT, "osc_type"), "set_osc_type", "get_osc_type");
    

	ClassDB::bind_method(D_METHOD("get_playback"), &AudioStreamOscillator3D::get_playback);
	ClassDB::bind_method(D_METHOD("set_playback", "_value"), &AudioStreamOscillator3D::set_playback);

	

	ClassDB::bind_method(D_METHOD("ready"), &AudioStreamOscillator3D::_ready);
	ClassDB::bind_method(D_METHOD("process", "delta"), &AudioStreamOscillator3D::_process);


	ClassDB::bind_method(D_METHOD("_fill_buffer_sin"), &AudioStreamOscillator3D::_fill_buffer_sin);
    ClassDB::bind_method(D_METHOD("_fill_buffer_saw"), &AudioStreamOscillator3D::_fill_buffer_saw);
    ClassDB::bind_method(D_METHOD("_fill_buffer_pulse"), &AudioStreamOscillator3D::_fill_buffer_pulse);
    ClassDB::bind_method(D_METHOD("_fill_buffer_square"), &AudioStreamOscillator3D::_fill_buffer_square);

    BIND_ENUM_CONSTANT(SIN);
    BIND_ENUM_CONSTANT(SAW);
    BIND_ENUM_CONSTANT(PULSE);
    BIND_ENUM_CONSTANT(SQUARE);
	
}

AudioStreamOscillator3D::AudioStreamOscillator3D() {
	// Initialize any variables here.
	double frequency = 440.0;
	double phase = 0.0;
	double mix_rate = 48000.0;
	bool generating = false;
	int osc_type = 0;
	float frame = 0.0;
	int to_fill = 0;
	
	
}

void AudioStreamOscillator3D::set_playback(Ref<AudioStreamGeneratorPlayback> _playback){
    playback = _playback;
}

Ref<AudioStreamGeneratorPlayback> AudioStreamOscillator3D::get_playback(){
    return this->playback;
}


AudioStreamOscillator3D::~AudioStreamOscillator3D() {
	// Add your cleanup here.
}

void AudioStreamOscillator3D::set_frequency(double _value) {
	frequency = _value;
}

double AudioStreamOscillator3D::get_frequency() {
	return frequency;
}

void AudioStreamOscillator3D::set_mix_rate(double _value) {
	mix_rate = _value;
	Ref<AudioStreamGenerator> gen = this->get_stream();
	gen->set_mix_rate(mix_rate);
}

double AudioStreamOscillator3D::get_mix_rate() {
	return mix_rate;
}

int AudioStreamOscillator3D::get_osc_type() {
	return osc_type;
}

void AudioStreamOscillator3D::set_osc_type(int _value) {
	osc_type = _value;
}

void AudioStreamOscillator3D::_ready(){
	
	this->set_stream(& AudioStreamGenerator());
	Ref<AudioStreamGenerator> gen = this->get_stream();
	gen->set_mix_rate(mix_rate);
	
	
	
}


void AudioStreamOscillator3D::set_generating(bool _value){

	generating = _value;
	if (generating){
		play();
		playback = this->get_stream_playback();

	} else {
		stop();
	}
}
bool AudioStreamOscillator3D::get_generating(){
	return generating;
}



void AudioStreamOscillator3D::_process(double delta){
	//UtilityFunctions::print(this->is_playing());

	if (generating){
        switch(osc_type){
            case 0:
                _fill_buffer_sin();
                break;
            case 1: 
                _fill_buffer_saw();
                break;
            case 2: 
                _fill_buffer_pulse();
                break;
            case 3: 
                _fill_buffer_square();
                break;

        }
	}
	
}


void AudioStreamOscillator3D::_fill_buffer_sin() {

	double increment = frequency/mix_rate;
	to_fill = playback->get_frames_available();
	
	while (to_fill > 0){
        frame = sin(phase * Math_TAU);
		playback->push_frame(Vector2(1.0,1.0)*frame);
        if (buffer.size()<mix_rate){
             buffer.append(frame);
        }
		phase = fmod(phase + increment, 1.0);
		to_fill -= 1;
	}
}

void AudioStreamOscillator3D::_fill_buffer_saw() {

	double increment = frequency/mix_rate;
	to_fill = playback->get_frames_available();
	
	while (to_fill > 0){
        phase = fmod(phase + increment, 1.0);
        frame = (phase*2)-1.0;
		playback->push_frame(Vector2(1.0,1.0)*frame);
        if (buffer.size()<mix_rate){
             buffer.append(frame);
        }
		to_fill -= 1;
	}
}

void AudioStreamOscillator3D::_fill_buffer_pulse() {

	double increment = frequency/mix_rate;
	to_fill = playback->get_frames_available();
	
	while (to_fill > 0){
        phase = fmod(phase + increment, 1.0);
        frame = -(phase*2)-1.0;
		playback->push_frame(Vector2(1.0,1.0)*frame);
        if (buffer.size()<mix_rate){
             buffer.append(frame);
        }
		to_fill -= 1;
	}
}

void AudioStreamOscillator3D::_fill_buffer_square() {

	double increment = frequency/mix_rate;
	to_fill = playback->get_frames_available();
	
    while (to_fill > 0){
        phase = fmod(phase + increment, 1.0);
        if (phase<0.5){
            frame = -1.0;
        } else {
            frame = 1.0;
        }
		playback->push_frame(Vector2(1.0,1.0)*frame);
        if (buffer.size()<mix_rate){
             buffer.append(frame);
        }
		to_fill -= 1;
	}
}