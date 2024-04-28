#ifndef AUDIO_STREAM_OSCILLATOR_H
#define AUDIO_STREAM_OSCILLATOR_H

#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>
#include <godot_cpp/classes/audio_stream_playback.hpp>

namespace godot {

	class AudioStreamOscillator : public AudioStreamGenerator {
		GDCLASS(AudioStreamOscillator, AudioStreamGenerator);

		float frequency;
		double phase;
		bool generating;
		Ref<AudioStreamGeneratorPlayback> playback;

	private:
		
	protected:
		static void _bind_methods();

	public:



		AudioStreamOscillator();
		~AudioStreamOscillator();


		void set_frequency(float _value);
		float get_frequency();
		void _fill_buffer();
		void set_generating(bool _value);
		bool get_generating();
		void set_playback(Ref<AudioStreamGeneratorPlayback> _value);
		Ref<AudioStreamGeneratorPlayback> get_playback();
	};

}

#endif