#ifndef GYNTH3D_H
#define GYNTH3D_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/audio_stream.hpp>
#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/audio_stream_playback.hpp>
#include <godot_cpp/classes/audio_stream_player3d.hpp>

namespace godot {

	class Gynth3D : public AudioStreamPlayer3D {

		GDCLASS(Gynth3D, AudioStreamPlayer3D);

		double frequency = 440.0;
		double phase= 0.0;
		double mix_rate= 48000.0;
        double time = 0.0;
        double voltage = 0.0;
        double prev_voltage = 0.0;
        double attenuation = 1.0;
        double env_limiter = 0.0;
        PackedFloat32Array buffer = PackedFloat32Array();
        PackedFloat32Array draw_buffer = PackedFloat32Array();

        int buffer_limit = 0;
        int bus_idx;
        StringName bus_name;

		bool generating = false;
        bool bang = false;
		

		Ref<AudioStreamGeneratorPlayback> playback;
       
	

	private:
		int to_fill = 0;
		
		
	protected:
		static void _bind_methods();

	public:



		Gynth3D();
		~Gynth3D();

		void _ready() ;
		void _process(double delta) ;
		
		void set_frequency(double _value);
		double get_frequency();

		void set_mix_rate(double _value);
		double get_mix_rate();

		void set_generating(bool _value);
		bool get_generating();

		void _fill_buffer();

		void set_playback(Ref<AudioStreamGeneratorPlayback> _playback);
        Ref<AudioStreamGeneratorPlayback> get_playback();

        void receive_bang(bool _value);

        void set_attenuation(double _value);
        void get_attenuation();

	};

}

#endif