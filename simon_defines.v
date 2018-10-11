// SIMON Defines File


//===============================================================================
// Available BLOCK and KEY SIZES
//===============================================================================

// NOTE: Please select only one BLOCK Size and one KEY size

// Uncomment the unwanted ones

//`define BLOCK_SIZE_32
//`define BLOCK_SIZE_48
//`define BLOCK_SIZE_64
//`define BLOCK_SIZE_96
`define BLOCK_SIZE_128

//`define KEY_SIZE_64
//`define KEY_SIZE_72
//`define KEY_SIZE_96
`define KEY_SIZE_128
//`define KEY_SIZE_144
//`define KEY_SIZE_192
//`define KEY_SIZE_256


//===============================================================================
//		Define BLOCK SIZE
//===============================================================================

`ifdef BLOCK_SIZE_32
	`define BLOCK_SIZE 32
`endif

`ifdef BLOCK_SIZE_48
	`define BLOCK_SIZE 48
`endif

`ifdef BLOCK_SIZE_64
	`define BLOCK_SIZE 64
`endif

`ifdef BLOCK_SIZE_96
	`define BLOCK_SIZE 96
`endif

`ifdef BLOCK_SIZE_128
	`define BLOCK_SIZE 128
`endif



//===============================================================================
//		Define KEY SIZE
//===============================================================================

`ifdef KEY_SIZE_64
	`define  KEY_SIZE 64
`endif

`ifdef KEY_SIZE_72
	`define  KEY_SIZE 72
`endif

`ifdef KEY_SIZE_96
	`define  KEY_SIZE 96
`endif

`ifdef KEY_SIZE_128
	`define  KEY_SIZE 128
`endif

`ifdef KEY_SIZE_144
	`define  KEY_SIZE 144
`endif

`ifdef KEY_SIZE_192
	`define  KEY_SIZE 192
`endif

`ifdef KEY_SIZE_256
	`define  KEY_SIZE 256
`endif




//===============================================================================
//		Other CALCULATIONS
//===============================================================================


//---------------------------------------------
// Calculate WORD SIZE
//---------------------------------------------
`define WORD_SIZE  		(BLOCK_SIZE / 2)
//`define KEY_WORDS  		(KEY_SIZE / WORD_SIZE)

//---------------------------------------------
// Determining number of KEY WORDS
//---------------------------------------------
`ifdef BLOCK_SIZE_32
	`ifdef KEY_SIZE_64
		`define KEY_WORDS_4
	`endif
`elsif BLOCK_SIZE_48
	`ifdef KEY_SIZE_72
		`define KEY_WORDS_3
	`elsif KEY_SIZE_96
		`define KEY_WORDS_4
	`endif
`elsif BLOCK_SIZE_64
	`ifdef KEY_SIZE_96 
		`define KEY_WORDS_3
	`elsif KEY_SIZE_128
		`define KEY_WORDS_4
	`endif
`elsif BLOCK_SIZE_96
	`ifdef KEY_SIZE_96
		`define KEY_WORDS_2
	`elsif KEY_SIZE_144
		`define KEY_WORDS_3
	`endif
`elsif BLOCK_SIZE_128
	`ifdef KEY_SIZE_128
		`define KEY_WORDS_2
	`elsif KEY_SIZE_192
		`define KEY_WORDS_3
	`elsif KEY_SIZE_256
		`define KEY_WORDS_4
	`endif
`endif


//---------------------------------------------
// Calculate - ROUND COUNT
//---------------------------------------------
`ifdef BLOCK_SIZE_32
	`ifdef KEY_SIZE_64
		`define ROUND_COUNT 32
	`endif
`elsif BLOCK_SIZE_48
	`ifdef KEY_SIZE_72
		`define ROUND_COUNT 36
	`elsif KEY_SIZE_96
		`define ROUND_COUNT 36
	`endif
`elsif BLOCK_SIZE_64
	`ifdef KEY_SIZE_96 
		`define ROUND_COUNT 42
	`elsif KEY_SIZE_128
		`define ROUND_COUNT 44
	`endif
`elsif BLOCK_SIZE_96
	`ifdef KEY_SIZE_96
		`define ROUND_COUNT 52
	`elsif KEY_SIZE_144
		`define ROUND_COUNT 54
	`endif
`elsif BLOCK_SIZE_128
	`ifdef KEY_SIZE_128
		`define ROUND_COUNT 68
	`elsif KEY_SIZE_192
		`define ROUND_COUNT 69
	`elsif KEY_SIZE_256
		`define ROUND_COUNT 72
	`endif
`endif

//---------------------------------------------
// Determining CONSTANT SEQUENCE "Z"
//---------------------------------------------
`ifdef BLOCK_SIZE_32
	`ifdef KEY_SIZE_64
		`define CONST_SEQ_0
	`endif
`elsif BLOCK_SIZE_48
	`ifdef KEY_SIZE_72
		`define CONST_SEQ_0
	`elsif KEY_SIZE_96
		`define CONST_SEQ_1
	`endif
`elsif BLOCK_SIZE_64
	`ifdef KEY_SIZE_96 
		`define CONST_SEQ_2
	`elsif KEY_SIZE_128
		`define CONST_SEQ_3
	`endif
`elsif BLOCK_SIZE_96
	`ifdef KEY_SIZE_96
		`define CONST_SEQ_2
	`elsif KEY_SIZE_144
		`define CONST_SEQ_3
	`endif
`elsif BLOCK_SIZE_128
	`ifdef KEY_SIZE_128
		`define CONST_SEQ_2
	`elsif KEY_SIZE_192
		`define CONST_SEQ_3
	`elsif KEY_SIZE_256
		`define CONST_SEQ_4
	`endif
`endif





//===============================================================================
//			CONFIGURATION CHECKS
//===============================================================================


//---------------------------------------------
// Input BLOCK and KEY SIZE configuration errors
//---------------------------------------------
`ifdef BLOCK_SIZE_32
	`ifdef KEY_SIZE_72
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_96
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_128
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_144
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_192
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_256
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`endif
`elsif BLOCK_SIZE_48
	`ifdef KEY_SIZE_64
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_128
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_144
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_192
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_256
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`endif
`elsif BLOCK_SIZE_64
	`ifdef KEY_SIZE_64
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_72
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_144
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_192
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_256
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`endif
`elsif BLOCK_SIZE_96
	`ifdef KEY_SIZE_64
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_72
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_128
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_192
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_256
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`endif
`elsif BLOCK_SIZE_128
	`ifdef KEY_SIZE_64
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_72
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_96
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`elsif KEY_SIZE_144
CONFIGURATION ERROR: UNSUPPORTED KEY SIZE FOR GIVEN BLOCK SIZE 
	`endif
`endif









