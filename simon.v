//======================================================================================
//
//			SIMON CIPHER ENCRYPTION & DECRYPTION - VARIABLE BLOCK SIZE 
//
//======================================================================================

//`include "simon_defines.v"


module simon #(parameter BLOCK_SIZE=128, KEY_SIZE=128)
		(
		input		[BLOCK_SIZE-1:0]		data_in,
		input		[KEY_SIZE-1:0]			key_in,
		input								clk,
		input								reset, //omit ?
		input								load,
		input								loadcv,
		input								start,
		input								select,
		output								ready,
		output		[BLOCK_SIZE-1:0]		data_out		
		);
		

//--------------------------------------------------------------------------------------
//								Registers and Wires
//--------------------------------------------------------------------------------------
wire		[2:0]						phase;
wire		[7:0]						word_size;
wire		[(BLOCK_SIZE/2)-1:0]		data_lsb;
wire		[(BLOCK_SIZE/2)-1:0]		data_msb;
wire		[(BLOCK_SIZE/2)-1:0]		key_in_word;
wire		[(BLOCK_SIZE/2)-1:0]		cipher_lsb;
wire		[(BLOCK_SIZE/2)-1:0]		cipher_msb;
wire		[15:0]						select_word;

//reg 		[7:0]						round_count_reg;


//----------------------------------------------------------------------------------------
//								Assignment Operations
//----------------------------------------------------------------------------------------
//assign	word_size	    =	BLOCK_SIZE / 2; //Divide by 2 to get the word size from block size
//assign	phase			=	KEY_SIZE / word_size; //Division to get "m" value -- try other implementation for less resources

assign	data_out		=	{cipher_msb , cipher_lsb};

//----------------------------------------------------------------------------------------
//								Logical Operations
//----------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
//								Instantiations
//--------------------------------------------------------------------------------------------------

// Instantiation for Controller Module where state machine for SIMON is written
controller #(
				.WORD_SIZE(WORD_SIZE), 
				.KEY_SIZE(KEY_SIZE)
				) 								simon_controller (
																		.phase(KEY_WORDS),
																		.clk(clk),
																		.reset(reset),
																		.start(start),
																		.select_in(select),
																		//.rounds(round_count_reg),
																		.select_out(select_word)
																		);
																		
// Instantiation for Operator Module where all datapath operations are written
operator #(
				.WORD_SIZE(WORD_SIZE),
				.KEY_SIZE(KEY_SIZE)
			  )								simon_operator		(
																		.data_lsb(data_lsb),
																		.data_msb(data_msb),
																		.key_in(key_in_word),
																		.select_in(select_word),
																		.select(select),
																		.phase(KEY_WORDS),
																		//.rounds(round_count_reg),
																		.data_out_1(cipher_lsb),
																		.data_out_2(cipher_msb)
																		);


endmodule
