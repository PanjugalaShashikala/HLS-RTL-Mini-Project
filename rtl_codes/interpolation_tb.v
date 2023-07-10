`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2023 13:35:17
// Design Name: 
// Module Name: inter_tb
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


module ComplexConvolution_tb;

  reg clk;
  reg [15:0] input_r;
  reg [15:0] input_i;
  //reg [2:0] coefficients_r;
  //reg [2:0] coefficients_i;
  wire [31:0] result_r;
  wire [31:0] result_i;
  integer i;
  integer file;
  reg [255:0] line;
  
  // Instantiate the module under test
  ComplexConvolution uut (
    .clk(clk),
    .input_r(input_r),
    .input_i(input_i),
    .result_r(result_r),
    .result_i(result_i)
  );
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end
    
    
initial begin
    // Read input values from file and store in the input_real and input_imag arrays
    file = $fopen("input_fir.txt", "r");
    if (file == 0) begin
      $display("Error opening values file!");
      $finish;
    end
    
    for (i = 0; i < 100; i = i + 1) begin
    //begin
	@(posedge clk);
      $fgets(line, file);
      $sscanf(line, "%d %d", input_r, input_i);
      //$display("%d %d", input_r, input_i);
    end
    $fclose(file);
end

endmodule



