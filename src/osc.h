#ifndef OSCILLATOR_H
#define OSCILLATOR_H

#include <godot_cpp/classes/node.hpp>




namespace godot {

	class Osc : public Node {
		GDCLASS(Osc, Node);
		double frequency = 440.0;
		double phase= 0.0;
		double mix_rate= 48000.0;
       
		
	

	private:
		int to_fill = 0;
		
	protected:
		static void _bind_methods();

	public:



		Osc();
		~Osc();
		
		void set_frequency(double _value);
		double get_frequency();

        void set_mix_rate(double _value);
		double get_mix_rate();

		PackedVector2Array get_sin_buffer(int _size);
		PackedVector2Array get_saw_buffer(int _size);
		PackedVector2Array get_pulse_buffer(int _size);
		PackedVector2Array get_square_buffer(int _size);

	};

}

#endif