//////////////////////////////////////////////////////////////////////////////////////////
//  File Name   : control_fsm.v		                                          	//
//  Description : It has three states RESET, LOAD, ENABLE.                     		//
//  Inputs      : i_clock, i_resetn, i_start	                                 	//
//  Outputs     : o_reset, o_load, o_enable                                  		//
//////////////////////////////////////////////////////////////////////////////////////////
//
//Design Module
module fsm_control (
    input i_clock,
    i_resetn,
    i_start,
    output reg o_reset,
    o_load,
    o_enable
);
  reg [1:0] state, next_state;
  parameter RESET = 0, LOAD = 1, ENABLE = 2;
  always @(*) begin
    case (state)
      RESET: begin
        next_state = i_resetn ? LOAD : RESET;
        o_reset    = ~i_resetn;
        o_load     = 1'b0;
        o_enable   = 1'b0;
      end
      LOAD: begin
        next_state = i_resetn ? ENABLE : RESET;
        o_reset    = ~i_resetn;
        o_load     = 1'b1;
        o_enable   = 1'b0;
      end
      ENABLE: begin
        next_state = i_resetn ? ((i_start == 1'b0) ? LOAD : ENABLE) : RESET;
        o_reset    = ~i_resetn;
        o_load     = 1'b0;
        o_enable   = i_start;
      end
      default: next_state = RESET;
    endcase
  end
  always @(posedge i_clock) begin
    if (~i_resetn) state <= RESET;
    else state <= next_state;
  end
endmodule

//Testbech Module
module fsm_tb;
  reg clk, resetn, start;
  wire reset, load, enable;
  //Instantiation
  fsm_control f1 (
      clk,
      resetn,
      start,
      reset,
      load,
      enable
  );

  initial begin
    clk = 1'b0;
    resetn = 1'b0;
    start = 1'b0;
    @(posedge clk) start = 1'b1;
    repeat (2) @(posedge clk);
    resetn = 1'b1;
  end
  always #5 clk = ~clk;
endmodule

