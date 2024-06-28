#ifndef AUDIO_STREAM_OSCILLATOR3D_H
#define AUDIO_STREAM_OSCILLATOR3D_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/audio_stream.hpp>
#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/audio_stream_playback.hpp>
#include <godot_cpp/classes/audio_stream_player3d.hpp>


using namespace godot;

class AudioStreamOscillator3D : public AudioStreamPlayer3D {

	GDCLASS(AudioStreamOscillator3D, AudioStreamPlayer3D);
	double frame = 0.0;
	double frequency = 440.0;
	double phase= 0.0;
	double mix_rate= 48000.0;
	int osc_type = 0;
	bool generating = false;
	//

	Ref<AudioStreamGeneratorPlayback> playback;
       
	

	private:
		int to_fill = 0;
		
		
	protected:
		static void _bind_methods();

	public:

		enum WAVE_TYPE{
        SIN = 0,
        SAW = 1,
        PULSE = 2,
        SQUARE = 3
		};

		PackedFloat32Array buffer = PackedFloat32Array();

		AudioStreamOscillator3D();
		~AudioStreamOscillator3D();

		void _ready() ;
		void _process(double delta) ;
		
		void set_frequency(double _value);
		double get_frequency();

		void set_mix_rate(double _value);
		double get_mix_rate();

		void set_generating(bool _value);
		bool get_generating();

		void _fill_buffer_sin();
        void _fill_buffer_saw();
        void _fill_buffer_pulse();
        void _fill_buffer_square();

		void set_playback(Ref<AudioStreamGeneratorPlayback> _playback);
        Ref<AudioStreamGeneratorPlayback> get_playback();

		void set_osc_type(int _value);
		int get_osc_type();

	};

VARIANT_ENUM_CAST(AudioStreamOscillator3D::WAVE_TYPE);


#endif