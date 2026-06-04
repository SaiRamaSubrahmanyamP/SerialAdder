//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : sipo.v	                                                	//
//  Description : It takes Serial Input and gives the Parallel Output.        		//
//  Inputs      : clock, reset, enable, in                             			//
//  Outputs     : q                                                 			//
//////////////////////////////////////////////////////////////////////////////////////////

//Design Module
module sipo #(
    parameter WIDTH = 8
) (
    input i_clock,
    i_reset,
    i_enable,
    i_in,
    output reg [WIDTH:0] o_q
);
  always @(posedge i_clock) begin
    if (i_reset) begin
      o_q <= 0;
    end else if (i_enable) o_q <= {i_in, o_q[WIDTH:1]};
    else o_q <= o_q;
  end
endmodule

//Testbench Module
module sipo_tb;
  parameter WIDTH = 8;
  reg clk, reset, enable, in;
  wire [WIDTH:0] q;
  //Design Instantiation
  sipo #(WIDTH) p1 (
      clk,
      reset,
      enable,
      in,
      q
  );
  initial begin
    clk    = 1'b0;
    reset  = 1'b1;
    enable = 1'b0;
    @(posedge clk) reset = 1'b0;
    enable = 1'b1;
  end
  always #5 clk = ~clk;
  initial begin
    in = 1'b1;
    @(posedge clk) in = 1'b0;
    repeat (2) @(posedge clk);
    in = 1'b1;
    repeat (3) @(posedge clk);
    in = 1'b1;
    repeat (4) @(posedge clk);
    in = 1'b1;
    repeat (5) @(posedge clk);
    in = 1'b0;
    repeat (6) @(posedge clk);
    in = 1'b0;
    repeat (7) @(posedge clk);
    in = 1'b0;
    repeat (8) @(posedge clk);
    in = 1'b1;
    repeat (9) @(posedge clk);
    in = 1'b0;
    repeat (10) @(posedge clk);
    in = 1'b0;
    repeat (11) @(posedge clk);
    in = 1'b0;
  end
endmodule

