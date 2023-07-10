#include <iostream>
#include <fstream>
#include <vector>
#include <hls_stream.h>
#include <ap_int.h>

typedef ap_int<16> my_int;
typedef ap_int<32> my_int2;
typedef hls::stream<my_int> stream_t;
typedef hls::stream<my_int2> stream_t2;

void convolution(stream_t& input_real, stream_t& input_imag, stream_t2& output_real, stream_t2& output_imag);

int main() {

		// Open the input file
		std::ifstream inputFile1("input.txt");

	    // Open the output file for writing
	    std::ofstream outputFile1("fir_input.txt");

	    std::string line;

	    // Iterate through each line in the input file
	    while (std::getline(inputFile1, line)) {
	        // Write the line with values to the output file
	        outputFile1 << line << std::endl;

	        // Insert a zero after the line
	        outputFile1 << "0 0" << std::endl;
	    }

	    // Close the input and output files
	    inputFile1.close();
	    outputFile1.close();


	// Open the input file
	    std::ifstream inputFile2("fir_input.txt");
	    if (!inputFile2) {
	        std::cout << "Failed to open the input file." << std::endl;
	        return 1;
	    }

	    // Read the sequence length from the input file
	    int seq_length=100;
	    int filter_length=11;

	    // Create HLS streams for input, filter, and output data
	    stream_t input_real;
	    stream_t input_imag;
	    //stream_t filter_real;
	    //stream_t filter_imag;
	    stream_t2 output_real;
	    stream_t2 output_imag;

	    // Read the complex sequence from the input file and write to input streams
	    for (int i = 0; i < seq_length; ++i) {
	        my_int real_val, imag_val;
	        inputFile2 >> real_val >> imag_val;
	        input_real.write(real_val);
	        input_imag.write(imag_val);
	    }

	    // Close the input file
	    inputFile2.close();

	   /* for (int i = 0; i < seq_length; ++i) {
	    	           if (!input_real.empty() && !input_imag.empty()) {
	    	               int real_val = input_real.read();
	    	               int imag_val = input_imag.read();

	    	               //std::cout << real_val << " + " << imag_val << "i" << std::endl;
	    	           }
	    	       }*/


	    // Length of the resulting convolution sequence
	    int conv_length = seq_length + filter_length - 1;

	    // Perform the convolution
	    convolution(input_real, input_imag, output_real, output_imag);

	       // Display the result
	       /*for (int i = 0; i < conv_length; ++i) {
	           if (!output_real.empty() && !output_imag.empty()) {
	               my_int2 real_val = output_real.read();
	               my_int2 imag_val = output_imag.read();

	               std::cout << real_val << "  " << imag_val << "i" << std::endl;
	           }
	       }*/
	       std::ofstream outputFile2("fir_output.txt");
	       while (!output_real.empty() && !output_imag.empty()) {
	    	   my_int2 real_val = output_real.read();
	    	   my_int2 imag_val = output_imag.read();
	               outputFile2 << real_val << " "<<  imag_val<< "\n";
	           }

	           // Close the file
	           outputFile2.close();

	           // Compare the results file with the ref file
	           int retval = system("diff --brief -w fir_output.txt matlab_output.txt");
	           if (retval != 0) {
	           printf("Output does not matching with matlab output \n");
	           retval=1;
	           } else {
	           printf("Output matches with matlab output. \n");
	           }
	           }

