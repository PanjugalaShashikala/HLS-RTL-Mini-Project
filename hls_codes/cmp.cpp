#include <iostream>
#include <fstream>
#include <vector>
#include <hls_stream.h>
#include <ap_int.h>

typedef ap_int<16> my_int;
typedef ap_int<32> my_int2;
typedef hls::stream<my_int> stream_t;
typedef hls::stream<my_int2> stream_t2;

void convolution(stream_t& input_real, stream_t& input_imag,  stream_t2& output_real, stream_t2& output_imag)
{
#pragma HLS PIPELINE II=1

    int filter_coeffs_real[11] = {1, 0, 2, 0, 3, 4, 3, 0, 2, 0, 1};
    int filter_coeffs_imag[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    int input_real_array[100];
    int input_imag_array[100];
    int sum_real[110] = {0};
    int sum_imag[110] = {0};

    // Read input real and imaginary values into arrays
    for (int i = 0; i < 100; i++) {
#pragma HLS UNROLL
        if (!input_real.empty()) {
            input_real_array[i] = input_real.read();
        }
        if (!input_imag.empty()) {
            input_imag_array[i] = input_imag.read();
        }
    }

    // Perform convolution
    for (int i = 0; i < 110; i++) {
#pragma HLS UNROLL
        for (int j = 0; j < 11; j++) {
#pragma HLS UNROLL
            if ((i - j >= 0) && (i - j < 100)) {
                sum_real[i] += input_real_array[i - j] * filter_coeffs_real[j] - input_imag_array[i - j] * filter_coeffs_imag[j];
                sum_imag[i] += input_real_array[i - j] * filter_coeffs_imag[j] + input_imag_array[i - j] * filter_coeffs_real[j];
            }
        }
    }

    // Write the convolution result to the output streams
    for (int i = 5; i < 105; i++) {
#pragma HLS UNROLL
        output_real.write(sum_real[i]);
        output_imag.write(sum_imag[i]);
    }
}
