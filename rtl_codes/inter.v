`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2023 13:35:05
// Design Name: 
// Module Name: convolution
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ComplexConvolution (
  input wire clk,
  input [15:0] input_r,
  input [15:0] input_i,
  output wire [31:0] result_r,
  output wire [31:0] result_i
);

  reg [31:0] input_real [0:99];              // Array for input real values
  reg [31:0] input_imag [0:99];              // Array for input imaginary values
  //reg [2:0] coefficients_real [10:0];        // Array for filter real coefficients
  //reg [2:0] coefficients_imag [10:0];        // Array for filter imaginary coefficients
  reg [31:0] result_real [0:110];             // Array for storing convolution real result
  reg [31:0] result_imag [0:110];             // Array for storing convolution imaginary result
 // reg [15:0] input_real_f [0:100];              // Array for input real values
  //reg [15:0] input_imag_f [0:100];   
  integer i=0, j;
  
  integer file;
 // reg [255:0] line;
  
reg [31:0] coefficients_real [0:10]; 
initial begin
    coefficients_real[0] = 8'd1;
    coefficients_real[1] = 8'd0;
    coefficients_real[2] = 8'd2;
    coefficients_real[3] = 8'd0;
    coefficients_real[4] = 8'd3;
    coefficients_real[5] = 8'd4;
    coefficients_real[6] = 8'd3;
    coefficients_real[7] = 8'd0; 
    coefficients_real[8] = 8'd2;
    coefficients_real[9] = 8'd0;
    coefficients_real[10] = 8'd1;
end     
reg [31:0] coefficients_imag [0:10];      
   initial begin
    coefficients_imag[0] = 8'd0;
    coefficients_imag[1] = 8'd0;
    coefficients_imag[2] = 8'd0;
    coefficients_imag[3] = 8'd0;
    coefficients_imag[4] = 8'd0;
    coefficients_imag[5] = 8'd0;
    coefficients_imag[6] = 8'd0;
    coefficients_imag[7] = 8'd0; 
    coefficients_imag[8] = 8'd0;
    coefficients_imag[9] = 8'd0;
    coefficients_imag[10] = 8'd0;
end        

//reg [15:0] input_real [0:100]; 


initial begin
  for (i = 0; i < 100; i = i + 1)
  begin
  @(posedge clk);
  input_real[i] = input_r;
  input_imag[i] = input_i;
  //$display("Input: %0d + %0di",input_r, input_i);
  //$display("Input: %0d + %0di",input_real[i], input_imag[i]);
    //$display("Coefficients: %0d + %0di",coefficients_real[i], coefficients_imag[i]);
  //i=i+1;
   end
   //$display("Input: %0d + %0di",input_real[0], input_imag[0]);

    // Perform complex convolution
    for (i = 0; i < 110; i = i + 1) begin
      result_real[i] = 0;
      result_imag[i] = 0;
      for (j = 0; j < 11; j = j + 1) begin
        if ((i-j)>=0 && (i-j)<100) begin
          result_real[i] = result_real[i] + (input_real[i - j] * coefficients_real[j]) - (input_imag[i - j] * coefficients_imag[j]);
          result_imag[i] = result_imag[i] + (input_real[i - j] * coefficients_imag[j]) + (input_imag[i - j] * coefficients_real[j]);
        end
      end
    end
     for (i = 5; i < 105; i = i + 1) begin
      $display("Result[%0d]: %0d + %0di", i-5, $signed(result_real[i]), $signed(result_imag[i]));
    end
    
     // Write the convolution result to a text file
    file = $fopen("output.txt", "w");
    if (file == 0) begin
      $display("Error opening output file!");
      $finish;
    end
    for (i = 5; i <= 104; i = i + 1) begin
      $fdisplay(file, "%0d  %0d", $signed(result_real[i]), $signed(result_imag[i]));
    end
    $fclose(file);
end
endmodule



