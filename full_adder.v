//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : full_adder.v			                                  	//
//  Description : It takes three Inputs bits and produce Sum and Carry.	            	//
//  Inputs      : a, b, cin		                                              	//
//  Outputs     : sum, cout                                            			//
//////////////////////////////////////////////////////////////////////////////////////////

//Design Module
module full_adder (
    input  i_a,
    i_b,
    i_cin,
    output o_sum,
    o_cout
);
  assign {o_cout, o_sum} = i_a + i_b + i_cin;
endmodule
//Testbench Module
module full_adder_tb;
  reg a, b, cin;
  wire sum, cout;
  //Instantaition
  full_adder fa1 (
      a,
      b,
      cin,
      sum,
      cout
  );
  initial begin
    {a, b, cin} = 3'b000;
    #10{a, b, cin} = 3'b001;
    #10{a, b, cin} = 3'b010;
    #10{a, b, cin} = 3'b011;
    #10{a, b, cin} = 3'b100;
    #10{a, b, cin} = 3'b101;
    #10{a, b, cin} = 3'b110;
    #10{a, b, cin} = 3'b111;
  end
endmodule




