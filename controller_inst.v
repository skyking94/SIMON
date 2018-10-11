// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Generated by Quartus Prime Version 16.0 (Build Build 211 04/27/2016)
// Created on Fri Mar 16 14:51:32 2018

controller controller_inst
(
	.phase(phase_sig) ,	// input [1:0] phase_sig
	.clk(clk_sig) ,	// input  clk_sig
	.reset(reset_sig) ,	// input  reset_sig
	.start(start_sig) ,	// input  start_sig
	.select_in(select_in_sig) ,	// input  select_in_sig
	.rounds(rounds_sig) ,	// input [7:0] rounds_sig
	.select_out(select_out_sig) 	// output [15:0] select_out_sig
);

defparam controller_inst.WORD_SIZE = 64;
defparam controller_inst.KEY_SIZE = 128;