////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module controller #(parameter WORD_SIZE=64, KEY_SIZE=128) 
		(
		input			[1:0]			phase,
		input							clk,
		input							reset,
		input							start,
		input							select_in,
		//input			[7:0]			rounds,
		output		[15:0]		select_out
		);
		
//--------------------------------------------------------------------------------------------------
//					Registers and Wires
//--------------------------------------------------------------------------------------------------
reg	[15:0]select_out_reg;
reg			init;					// select for intializing round count
reg			round_sel; 			// select for mux to control count of rounds of operations
reg	[7:0]	round_count; 		// temp variable to store current round count

wire			max_count;
wire	[7:0]	round_count_w;

//--------------------------------------------------------------------------------------------------
//					Assignment Operations
//--------------------------------------------------------------------------------------------------

assign 		round_count_w		=	ROUND_COUNT;


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Select Logic breakdown
//--------------------------------------------------------------------------------------------------
//
// select[1:0] --> XOR Input MUX_1 : 0 - step one; 1 - step two; 2 - step three
// select[2]   --> XOR Input MUX_2 : 0 - feedback from XOR output ; 1 - Input word LSB
// select[3]   --> Word Swap after each round : 1 - swap value ; 0 - initial value
//
//
//
//
//
//--------------------------------------------------------------------------------------------------
assign		select_out		=		select_out_reg;
assign		max_count		=		rounds;

//			round count wire --- initialized by vv ----- updated to this vv when '0' and vv when '1'
assign		round_count_w	=		init ? round_count : round_sel ? round_count : round_count + 1;

//--------------------------------------------------------------------------------------------------
//					Register Operations
//--------------------------------------------------------------------------------------------------



//--------------------------------------------------------------------------------------------------
//
// Main Logic Bock controlling all MUXs in operator.v
//
always @ (posedge clk or negedge reset) begin
	if (!reset) begin
		select_out_reg			<=		16'd00;
		init						<=		1'b0;
		round_sel				<=		1'b0;
		round_count				<=		8'd0;
	end
	else if (start) begin
		case (select_in)
		
		//-------- Encryption ------------------------------------------------------------------------
			1'b0 :	begin
							if (round_count != max_count) begin
										init					<=		1'b1;
								if (init == 1'b1) begin
										round_sel			<=		1'b0;
										select_out_reg		<=		16'b0000000000000100; //first step in the round
								end
								else if (select_out_reg == 	16'd0) begin
										select_out_reg		<=		16'b0000000000000001; //second step
								end
								else if (select_out_reg == 	16'd0) begin
										select_out_reg		<=		16'b0000000000001010; //third step
										round_sel			<=		1'b1;
								end
							end
							else begin
								select_out_reg				<=		16'd0;
								round_sel					<=		1'b0;
								init							<=		1'b0;
							end
						end
		//-------- Decryption ------------------------------------------------------------------------
			1'b1 :	begin
						
						end
		endcase
	end
end



endmodule
