#ifndef GYNTHOSC3D_H
#define GYNTHOSC3D_H

#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_playback.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/audio_stream_player3D.hpp>
#include <godot_cpp/classes/audio_stream.hpp>
namespace godot {

class GynthOsc3D : public AudioStreamPlayer3D {
    GDCLASS(GynthOsc3D, AudioStreamPlayer3D)

private:
    double time_passed;
    double frequency;
    double phase;
    double mix_rate;
    AudioStreamGenerator gen;
    Ref<AudioStreamPlayback> playback;
    void _fill_buffer();

protected:
    static void _bind_methods();

public:
    GynthOsc3D();
    ~GynthOsc3D();

    void _ready();
    void _process(double delta);
    
    void set_frequency(const double p_freq_hz);
    double get_frequency() const;

    void set_mix_rate(const double p_mix_hz);
    double get_mix_rate() const;
};

}

#endif