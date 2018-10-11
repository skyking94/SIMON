///////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module operator #(parameter WORD_SIZE=64, KEY_SIZE=128)
		(
		input		[WORD_SIZE-1:0]		data_lsb,
		input		[WORD_SIZE-1:0]		data_msb,
		input		[KEY_SIZE-1:0]			key_in,
		input		[15:0]					select_in,
		input									select,
		input		[1:0]						phase,
		//input		[7:0]						rounds,
		output	[WORD_SIZE-1:0]		data_out_1,
		output	[WORD_SIZE-1:0]		data_out_2
		);
		
//--------------------------------------------------------------------------------------------------
//					Registers and Wires
//--------------------------------------------------------------------------------------------------

wire		[WORD_SIZE-1:0]		input_1;
wire		[WORD_SIZE-1:0]		input_2;
wire		[WORD_SIZE-1:0]		XOR_out;
wire		[WORD_SIZE-1:0]		round_lsb;
wire		[WORD_SIZE-1:0]		round_msb;
wire		[WORD_SIZE-1:0]		first_step;
wire		[WORD_SIZE-1:0]		second_step;
wire		[WORD_SIZE-1:0]		third_step;
wire		[WORD_SIZE-1:0]		msb_Lshift_1;
wire		[WORD_SIZE-1:0]		msb_Lshift_2;
wire		[WORD_SIZE-1:0]		msb_Lshift_8;

wire		[1:0]						xor_in_1_mux;
wire									xor_in_2_mux;
wire									xor_out_mux;
wire									swap_sel;

reg		[WORD_SIZE-1:0]		xor_in_1;
reg		[WORD_SIZE-1:0]		xor_in_2;
reg		[WORD_SIZE-1:0]		xor_out_fb;
reg		[WORD_SIZE-1:0]		data_lsb_r;
reg		[WORD_SIZE-1:0]		data_msb_r;
reg		[WORD_SIZE-1:0]		main_XOR_out;


//--------------------------------------------------------------------------------------------------
//					Assignment Operations
//--------------------------------------------------------------------------------------------------

// Distribution of Select Wires from Select Word
assign	xor_in_1_mux	=		select_in[1:0];
assign	xor_in_2_mux	=		select_in[2];
assign	swap_sel			=		select_in[3];

// Main XOR Logic
assign 	XOR_out		=		input_1 ^ input_2;  // XOR Operation for SIMON Round Datapath

// Inputs to XOR
assign	input_1		=		xor_in_1;
assign	input_2		=		xor_in_2;

// Two words used for every round of SIMON
assign	round_lsb		=		swap_sel	?	round_msb		:	data_lsb;
assign	round_msb		=		swap_sel	?	main_XOR_out	:	data_msb;

// XOR Input for each round
assign	first_step		=		msb_Lshift_1 & msb_Lshift_8;
assign	second_step		=		msb_Lshift_2;
assign	third_step		=		key_in;

//  + + + CIPHERTEXT OUT + + + 
assign	data_out_1		=		round_lsb;
assign	data_out_2		=		round_msb;	

//--------------------------------------------------------------------------------------------------
//					Logical Operations
//--------------------------------------------------------------------------------------------------

// Logic for 4:1 Mux for One of the inputs to Main XOR
always @ (*) begin
	if (xor_in_1_mux == 2'b00) begin
		xor_in_1			=		first_step;
	end
	else if (xor_in_1_mux == 2'b01) begin
		xor_in_1			=		second_step;
	end
	else if (xor_in_1_mux == 2'b10) begin
		xor_in_1			=		third_step;
	end
	else begin
		xor_in_1			=		0;
	end
end

//Logic for 2:1 MUX for One of the inputs to Main XOR
always @ (*) begin
	if (xor_in_2_mux) begin
		xor_in_2			=		data_lsb;
	end
	else begin
		xor_in_2			=		xor_out_fb;
	end
end

//Logic for 1:2 DEMUX for output from Main XOR
always @ (*) begin
	if (xor_in_1_mux == 2'b10) begin
		main_XOR_out	=		XOR_out;
	end
	else begin
		xor_out_fb		=		XOR_out;
	end
end


//--------------------------------------------------------------------------------------------------
//					Instantiations
//--------------------------------------------------------------------------------------------------

left_shifter #(.BLOCK_SIZE(64),
					.SHIFT_NUMBER(1))	LS_1 (
													.data_in(round_msb),
													.data_out(msb_Lshift_1)
													);
left_shifter #(.BLOCK_SIZE(64),
					.SHIFT_NUMBER(2))	LS_2 (
													.data_in(round_msb),
													.data_out(msb_Lshift_2)
													);
left_shifter #(.BLOCK_SIZE(64),
					.SHIFT_NUMBER(8))	LS_8 (
													.data_in(round_msb),
													.data_out(msb_Lshift_8)
													);
													

endmodule
