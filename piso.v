//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : piso.v	                                                	//
//  Description : It takes Parallel Input and gives the Serial Output.         		//
//  Inputs      : clock, enable, load, in                                    		//
//  Outputs     : q                                                   			//
//////////////////////////////////////////////////////////////////////////////////////////

//Design Module
module piso #(
    parameter WIDTH = 8
) (
    input i_clock,
    i_enable,
    i_load,
    input [WIDTH-1:0] i_in,
    output reg o_q
);
  reg [WIDTH - 1:0] data;
  always @(posedge i_clock) begin
    if (i_load) data <= i_in;
    else if (i_enable) {data, o_q} <= {1'b0, data};
    else o_q <= 0;
  end
endmodule

//Testbench Module
module piso_tb;
  parameter WIDTH = 16;
  reg clk, enable, load;
  reg [WIDTH -1:0] in;
  wire q;
  //Instantiation
  piso #(WIDTH) p1 (
      clk,
      enable,
      load,
      in,
      q
  );
  initial begin
    clk = 1'b0;
    in = 16'b0110101101101011;
    load = 1'b0;
    enable = 1'b0;
    @(posedge clk) load = 1'b1;
    repeat (2) @(posedge clk);
    load   = 1'b0;
    enable = 1'b1;
  end
  always #5 clk = ~clk;
endmodule
