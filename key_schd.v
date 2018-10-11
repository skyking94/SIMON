////////////////////////////////////////////////////////////////////////////////////////////////////
//
//			KEY SCHEDULAR
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module key_schd 
		(
		input			[KEY_SIZE-1:0]			key_in,
		//input			[7:0]					round_count,
		input									clk,
		input									select,
		output		    [WORD_SIZE-1:0]			key_out
		);
		
//--------------------------------------------------------------------------------------------------
//					Registers and Wires
//--------------------------------------------------------------------------------------------------

wire 		[WORD_SIZE-1:0] 		r_shifter_1_i, r_shifter_1_o;
wire 		[WORD_SIZE-1:0] 		r_shifter_3_i, r_shifter_3_o;

wire 		[61:0]					Z;
wire 		[WORD_SIZE-1:0]			C;

// Wires for XOR Operations
wire 		[WORD_SIZE-1:0]			XOR_3in_o, const_XOR_o, last_XOR_o, key_i_3_XOR_o;

// Wires for KEY Scheduling
wire  		[WORD_SIZE-1:0]			key_1_init, key_2_init, key_3_init, key_4_init;

reg 			[WORD_SIZE-1:0]		key_1_i;

`ifdef KEY_WORDS_2
	reg 		[WORD_SIZE-1:0]		key_2_i;
`elsif KEY_WORDS_3
	reg 		[WORD_SIZE-1:0]		key_2_i;
	reg 		[WORD_SIZE-1:0]		key_3_i;
`elsif KEY_WORDS_4
	reg 		[WORD_SIZE-1:0]		key_2_i;
	reg 		[WORD_SIZE-1:0]		key_3_i;
	reg 		[WORD_SIZE-1:0]		key_4_i;
`endif

//--------------------------------------------------------------------------------------------------
//					Assignment Operations
//--------------------------------------------------------------------------------------------------

`ifdef KEY_SIZE_64
		assign 		key_1_init		=	key_in[63:48];
		assign 		key_2_init		=	key_in[47:32];
		assign 		key_3_init		=	key_in[31:16];
		assign 		key_4_init		= 	key_in[15:00];
`elsif KEY_SIZE_72
	  	assign 		key_1_init		=	key_in[71:48];
	  	assign 		key_2_init		=	key_in[47:24];
	  	assign 		key_3_init 		=	key_in[23:00];
`elsif KEY_SIZE_96
	`ifdef KEY_WORDS_2
		assign 		key_1_init		=	key_in[95:48];
		assign 		key_2_init		=	key_in[47:00];
 	`elsif KEY_WORDS_3
  		assign 		key_1_init		=	key_in[95:64];
  		assign 		key_2_init		=	key_in[63:32];
  		assign 		key_3_init 		=	key_in[31:00];
  	`elsif KEY_WORDS_4
		assign 		key_1_init		=	key_in[95:72];
		assign 		key_2_init		=	key_in[71:48];
		assign 		key_3_init		=	key_in[47:24];
		assign 		key_4_init		= 	key_in[23:00];
	`endif
`elsif KEY_SIZE_128
	`ifdef KEY_WORDS_4
		assign 		key_1_init		=	key_in[127:96];
		assign 		key_2_init		=	key_in[95:64];
		assign 		key_3_init		=	key_in[63:32];
		assign 		key_4_init		= 	key_in[31:00];
	`elsif KEY_WORDS_2
		assign 		key_1_init		=  	key_in[127:064];
		assign 		key_2_init		=	key_in[063:000];
	`endif
`elsif KEY_SIZE_144
		assign 		key_1_init		=	key_in[143:096];
		assign 		key_2_init		=	key_in[095:048];
		assign 		key_3_init		=	key_in[047:000];
`elsif KEY_SIZE_192
		assign 		key_1_init		=	key_in[191:128];
		assign 		key_2_init		=	key_in[127:064];
		assign 		key_3_init		=	key_in[063:000];
`elsif KEY_SIZE_256
		assign 		key_1_init		=	key_in[255:192];
		assign 		key_2_init		=	key_in[191:128];
		assign 		key_3_init		=	key_in[127:064];
		assign 		key_4_init		= 	key_in[063:000];
`endif

// MAIN KEY OUT for GIVEN ROUND
`ifdef KEY_WORDS_2
	assign 		key_out			= 	key_2_i;
`elsif KEY_WORDS_3
	assign 		key_out 		= 	key_3_i;
`else 
	assign 		key_out			=	key_4_i;
`endif

// Input to Right Shift by 3 Shifter
assign 		r_shifter_3_i		= 	key_1_i;

// Input to Right Shift by 1 Shifter
`ifdef KEY_WORDS_2
	assign 	r_shifter_1_i		=	r_shifter_3_o;
`elsif KEY_WORDS_3
	assign 	r_shifter_1_i		=	r_shifter_3_o;
`elsif KEY_WORDS_4	
	assign 	r_shifter_1_i		=	key_i_3_XOR_o;
`endif

// 2-input XOR Operation when KEY WORDS = 4
`ifdef KEY_WORDS_4
	assign 	key_i_3_XOR_o 		=	r_shifter_3_o ^ key_3_i;
`endif

// 3-input XOR Operations
`ifdef KEY_WORDS_4
	assign 	XOR_3in_o			=	key_i_3_XOR_o ^ r_shifter_1_o ^ key_4_i;
`elsif KEY_WORDS_3 
	assign 	XOR_3in_o			=	r_shifter_3_o ^ r_shifter_1_o ^ key_3_i;
`elsif KEY_WORDS_2
	assign 	XOR_3in_o			=	r_shifter_3_o ^ r_shifter_1_o ^ key_2_i;
`endif

// Calculation of Value of C
assign 		C 					=  	{{WORD_SIZE-2{1'b1}},2'b0};

// 2-input XOR Operation (With Constant Sequence)
assign 		const_XOR_o			=	C ^ Z_sel_bit;

// 2-input XOR Operation (With Output of Constant Sequence)
assign 		last_XOR_o 			= 	XOR_3in_o ^ const_XOR_o;


//--------------------------------------------------------------------------------------------------
//					Register Operations
//--------------------------------------------------------------------------------------------------

always @(posedge clk) begin : proc_key_1_i
	if(round_count_curr == 1) 	key_1_i 		<=		key_1_init
	else						key_1_i  		<=  	last_XOR_o;
end // proc_key_1_i

`ifdef KEY_WORDS_2
always @(posedge clk) begin : proc_key_2_i
	if(round_count_curr == 1) 	key_2_i 		<=		key_2_init
	else						key_2_i  		<=  	last_XOR_o;
end // proc_key_2_i
`endif

`ifdef KEY_WORDS_3
always @(posedge clk) begin : proc_key_2_i
	if(round_count_curr == 1) 	key_2_i 		<=		key_2_init
	else						key_2_i  		<=  	last_XOR_o;
end // proc_key_2_i

always @(posedge clk) begin : proc_key_3_i
	if(round_count_curr == 1) 	key_3_i 		<=		key_3_init
	else						key_3_i  		<=  	last_XOR_o;
end // proc_key_3_i
`endif

`ifdef KEY_WORDS_4
always @(posedge clk) begin : proc_key_2_i
	if(round_count_curr == 1) 	key_2_i 		<=		key_2_init
	else						key_2_i  		<=  	last_XOR_o;
end // proc_key_2_i

always @(posedge clk) begin : proc_key_3_i
	if(round_count_curr == 1) 	key_3_i 		<=		key_3_init
	else						key_3_i  		<=  	last_XOR_o;
end // proc_key_3_i

always @(posedge clk) begin : proc_key_4_i
	if(round_count_curr == 1) 	key_4_i 		<=		key_4_init
	else						key_4_i  		<=  	last_XOR_o;
end // proc_key_4_i
`endif


//--------------------------------------------------------------------------------------------------
//					Constant Sequence
//--------------------------------------------------------------------------------------------------
`ifdef CONST_SEQ_0
	assign 	Z	=	62'b11111010001001010110000111001101111101000100101011000011100110;
`elsif CONST_SEQ_1
	assign 	Z	=	62'b10001110111110010011000010110101000111011111001001100001011010;
`elsif CONST_SEQ_2
	assign 	Z	=	62'b10101111011100000011010010011000101000010001111110010110110011;
`elsif CONST_SEQ_3
	assign 	Z 	=	62'b11011011101011000110010111100000010010001010011100110100001111;
`elsif CONST_SEQ_4
	assign 	Z	=	62'b11010001111001101011011000100000010111000011001010010011101111;
`else 
	assign 	Z 	= 	{62{1'b1}};
`endif




//--------------------------------------------------------------------------------------------------
//					Instantiations
//--------------------------------------------------------------------------------------------------

// Right Shift by 3
right_shifter #(
				.WORD_SIZE(WORD_SIZE),
				.SHIFT_COUNT(3)
				) 						right_shift_3 (
														.data_in(r_shifter_3_i)
														.data_out(r_shifter_3_o)
														);


// Right Shift by 1
right_shifter #(
				.WORD_SIZE(WORD_SIZE),
				.SHIFT_COUNT(1)
				) 						right_shift_1 (
														.data_in(r_shifter_1_i)
														.data_out(r_shifter_1_o)
														);



endmodule
