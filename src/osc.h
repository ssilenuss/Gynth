#ifndef OSCILLATOR_H
#define OSCILLATOR_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/audio_stream_generator.hpp>
#include <godot_cpp/classes/audio_stream_generator_playback.hpp>



namespace godot {

	class Osc : public Node {
		GDCLASS(Osc, Node);
		double frequency = 440.0;
		double phase= 0.0;
		double mix_rate= 48000.0;
        Ref<AudioStreamGeneratorPlayback> playback;
        Ref<AudioStreamGenerator> generator;
		
	

	private:
		int to_fill = 0;
		
	protected:
		static void _bind_methods();

	public:



		Osc();
		~Osc();
		
        void _process(double delta) override;
        
		void set_frequency(double _value);
		double get_frequency();

        void set_playback(Ref<AudioStreamGeneratorPlayback> _playback);
        Ref<AudioStreamGeneratorPlayback> get_playback();

        void set_generator(Ref<AudioStreamGenerator> _generator);
        Ref<AudioStreamGenerator> get_generator();

        void set_mix_rate(double _value);
		double get_mix_rate();

		void fill_buffer();
		
		int get_to_fill();
		void set_to_fill(int _value);
	};

}

#endif