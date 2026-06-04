//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : dff.v					                        	//
//  Description : It stores previous carry and give it to the full adder as          	//
//  		  input carry.                                                		//
//  Inputs      : clock, reset, d                                          		//
//  Outputs     : q		                                                    	//
//////////////////////////////////////////////////////////////////////////////////////////
//Design Module
module dff (
    input i_clock,
    i_reset,
    i_d,
    output reg o_q
);
  always @(posedge i_clock) begin
    if (i_reset) o_q <= 0;
    else o_q <= i_d;
  end
endmodule
//Testbench Module
module dff_tb;
  reg clk, d, reset;
  wire q;
  //Instantiation
  dff d1 (
      clk,
      reset,
      d,
      q
  );
  initial begin
    clk = 1'b0;
    reset = 1'b0;
    d = 1'b0;
    @(posedge clk) reset = 1'b1;
    d = 1'b1;
    repeat (1) @(negedge clk);
    d = 1'b0;
    repeat (2) @(negedge clk);
    #10 d = 1'b1;
    repeat (3) @(posedge clk);
    reset = 1'b0;
    repeat (4) @(negedge clk);
    reset = 1'b1;
    d = 1'b1;
  end
  always #5 clk = ~clk;
endmodule
