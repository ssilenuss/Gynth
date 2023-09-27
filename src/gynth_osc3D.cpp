#include "gynth_osc3D.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void GynthOsc3D::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_frequency"), &GynthOsc3D::get_frequency);
    ClassDB::bind_method(D_METHOD("set_frequency", "p_freq_hz"), &GynthOsc3D::set_frequency);
    ClassDB::add_property("GynthOsc3D", PropertyInfo(Variant::FLOAT, "frequency"), "set_frequency", "get_frequency");
    ClassDB::bind_method(D_METHOD("get_mix_rate"), &GynthOsc3D::get_mix_rate);
    ClassDB::bind_method(D_METHOD("set_mix_rate", "p_mix_hz"), &GynthOsc3D::set_mix_rate);
    ClassDB::add_property("GynthOsc3D", PropertyInfo(Variant::FLOAT, "mix_rate"), "set_mix_rate", "get_mix_rate");
}

GynthOsc3D::GynthOsc3D() {
    // Initialize any variables here.
    time_passed = 0.0;
    frequency = 440.0;
    phase = 0.0;
    mix_rate = 48000.0;
    
}
GynthOsc3D::~GynthOsc3D() {
    // Add your cleanup here.
}

void GynthOsc3D::_ready(){
    Ref<AudioStreamGenerator> gen_ref = memnew(AudioStreamGenerator);
    gen_ref->call("set_mix_rate", mix_rate);
    gen_ref->call("set_buffer_length", 0.01);
    AudioStreamPlayer3D::set_stream(gen_ref);
    play();
    playback = get_stream_playback();
    _fill_buffer();
    set_stream_paused(true);
}

void GynthOsc3D::_process(double delta) {
  
    _fill_buffer();

}

void GynthOsc3D::set_frequency(const double p_freq_hz){
    frequency = p_freq_hz;
    Ref<AudioStreamGenerator> gen_ref = get_stream();
    gen_ref->call("clear_buffer");
}

double GynthOsc3D::get_frequency() const {
    return frequency;
}

void GynthOsc3D::set_mix_rate(const double p_mix_hz){
     mix_rate = p_mix_hz;
    Ref<AudioStreamGenerator> gen_ref = get_stream();
    gen_ref->call("set_mix_rate", mix_rate);
   
}

double GynthOsc3D::get_mix_rate() const {
    return mix_rate;
}

void GynthOsc3D::_fill_buffer(){
    double increment = frequency / mix_rate;
    int to_fill = playback->call("get_frames_available");
    Vector2 one = Vector2(0,1);
    while (to_fill>0){
        playback->call("push_frame", Vector2(1.0,1.0) * sin(phase * Math_TAU));
        phase = fmod(phase+increment, 1.0);
        to_fill -= 1;
    }
        
}

