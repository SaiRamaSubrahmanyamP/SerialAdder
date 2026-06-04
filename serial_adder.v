//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : serial_adder.v					                	                            //
//							                    	                                                 	//
//  Description : It takes two N bit numbers as inputs and compute                    	//
//   		          sum and gives N+1 bit number as a output.                            	//
//						                              	                                        	//
//  Inputs      : clock, resetn, start, A, B	                                   				//
//						             			                                                      	//
//  Outputs     : sum				                                                     				//
//////////////////////////////////////////////////////////////////////////////////////////
`include "full_adder.v"
`include "dff.v"
`include "piso.v"
`include "sipo.v"
`include "control_fsm.v"
//Top Module
module top_module #(parameter WIDTH = 8)(input i_clock, i_resetn, i_start, [WIDTH-1:0]i_a, i_b, output [WIDTH:0]o_sum);
  wire reset, load, enable, shift_a, shift_b, sum_out, carry_out, carry_in;
  wire [WIDTH:0] temp;
  reg[$clog2(WIDTH):0] count;

  //Parallel In Serial Out Shift Register for Inputs A and B 
  piso #(WIDTH) p1 ( i_clock,enable,load,i_a,shift_a);
  piso #(WIDTH) p2 ( i_clock,enable,load,i_b,shift_b);

  //Full Adeer Instantiation
  full_adder fa1 ( shift_a,shift_b,carry_in,sum_out,carry_out);

  //D Flip Flop Instantiation
  dff d1 ( i_clock, reset, carry_out, carry_in);

  //Serial In Parallel Out Shift Register(SIPO) Instantaition for output
  sipo #(WIDTH) p3 ( i_clock, reset, enable, sum_out, temp);

  //FSM Instantiation for Control Circuit
  fsm_control f1 ( i_clock, i_resetn, i_start, reset, load, enable);

  //Counter for output 
  always @ (posedge i_clock)
  begin
	  if(~i_resetn | ~i_start)
		  count <= 0;
	  else if (enable && count <= WIDTH+2)
		  count <= count + 1;
  end

  //Assigning output
  assign o_sum = count == WIDTH+2 ? temp:o_sum;

endmodule

//Testbench Module
module ser_adder_tb;
  parameter WIDTH = 8;
  reg clk,resetn,start;
  reg [WIDTH-1:0]A,B;
  wire [WIDTH:0]sum;
  //Instantiating the top module
  top_module #(WIDTH) sa1 (clk, resetn, start, A, B, sum);
  //Applying the test vectors
  initial
  begin
	  clk = 1'b1;
	  //case 1
	  resetn = 1'b0;start = 1'b0;
	  A = 8'd252; B = 8'd213;
	  repeat(2) @(posedge clk); 
	  resetn = 1'b1;start = 1'b1;
	  repeat(50) @(posedge clk); 
	  resetn = 1'b1;start = 1'b0;


	  //case 2
	  repeat(50) @(posedge clk); 
	  resetn = 1'b1;start = 1'b0;
	  A = $random ;B = $random;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 3
	  repeat(50) @(posedge clk); 
	  resetn = 1'b0;start = 1'b0;
	  A = $random;B = $random;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 4
	  repeat(50) @(posedge clk); 
	  resetn = 1'b0;start = 1'b0;
	  A = $random;B = $random;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 5
	  repeat(50) @(posedge clk); 
	  resetn = 1'b0;start = 1'b0;
	  A = $random;B = $random;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 6
	  repeat(50) @(posedge clk); 
	  resetn = 1'b0;start = 1'b0;
	  A = 8'hff;B = 8'hff;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 7
	  repeat(50) @(posedge clk); 
	  resetn = 1'b0;start = 1'b0;
	  A = 8'd0;B = 8'd0;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;

	  //case 8
	  repeat(50) @(posedge clk);
	  resetn = 1'b0;start = 1'b0;
	  A = 8'd41;B = 8'd5;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b0;
	  @(posedge clk);
	  resetn = 1'b0;start = 1'b0;
	  repeat(2) @(posedge clk);
	  resetn = 1'b1;start = 1'b1;
	  repeat(15) @(posedge clk);
	  resetn = 1'b0;
	  @(posedge clk)
	  start = 1'b1;

  end
  initial $monitor("time = %0t, resetn = %0b, start = %0b, a = %0d, b = %0d, sum = %0d", $time, resetn, start, A, B, sum);
  //clock signal generation
  always #5 clk = ~clk;
endmodule
