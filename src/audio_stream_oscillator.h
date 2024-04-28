#ifndef AUDIO_STREAM_OSCILLATOR_H
#define AUDIO_STREAM_OSCILLATOR_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/audio_stream.hpp>
#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/audio_stream_playback.hpp>
#include <godot_cpp/classes/audio_stream_player.hpp>


namespace godot {

	class AudioStreamOscillator : public AudioStreamPlayer {
		GDCLASS(AudioStreamOscillator, AudioStreamPlayer);
		double frequency = 440.0;
		double phase= 0.0;
		double mix_rate= 48000.0;
		bool generating = false;
		int to_fill = 0;
	

	private:
		
		
	protected:
		static void _bind_methods();

	public:



		AudioStreamOscillator();
		~AudioStreamOscillator();

		void _ready() ;
		void _process(double delta) ;
		
		void set_frequency(double _value);
		double get_frequency();

		void set_mix_rate(double _value);
		double get_mix_rate();

		void set_generating(bool _value);
		bool get_generating();

		void _fill_buffer();
		
		int get_to_fill();
		void set_to_fill(int _value);
	};

}

#endif