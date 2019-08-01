module control
	(
		input resetn,
		input clk,
		input go,
		input start,
		input updating,
		output reg ld_notes,
		output reg erase_notes,
		output reg draw_board,
		output reg draw_notes1,
		output reg draw_notes2,
		output reg draw_notes3,
		output reg draw_notes4,
		output reg check_notes,
		output reg playerEN,
		output reg initialize,
		//output reg game_end,
		output reg plot
	);
	
	reg [3:0] current_state;
	reg [3:0] next_state;
	
	localparam			GAME_START = 4'd0,
							INITIALIZE_SONG = 4'd1,
							LOAD_NOTES = 4'd2,
							ERASE_NOTES = 4'd3,
							DRAW_BOARD = 4'd4,
							DRAW_NOTES1 = 4'd5,
							DRAW_NOTES2 = 4'd6,
							DRAW_NOTES3 = 4'd7,
							DRAW_NOTES4 = 4'd8,
							CHECK_NOTES = 4'd9,
							PLAYER_GO = 4'd10,
							PLAYER_GO_WAIT = 4'd11;
						
							
	always @(*)
	begin: state_table
		case(current_state)
			GAME_START: next_state = start ? INITIALIZE_SONG : GAME_START;
			INITIALIZE_SONG: next_state = LOAD_NOTES;
			LOAD_NOTES: next_state = DRAW_BOARD;
			
			ERASE_NOTES: next_state = updating ? ERASE_NOTES : DRAW_BOARD;
			DRAW_BOARD: next_state = updating ? DRAW_BOARD : DRAW_NOTES1;
			
			DRAW_NOTES1: next_state = updating ? DRAW_NOTES1 : DRAW_NOTES2;
			DRAW_NOTES2: next_state = updating ? DRAW_NOTES2 : DRAW_NOTES3;
			DRAW_NOTES3: next_state = updating ? DRAW_NOTES3 : DRAW_NOTES4;
			DRAW_NOTES4: next_state = updating ? DRAW_NOTES4 : CHECK_NOTES;
			
			CHECK_NOTES: next_state = PLAYER_GO;
			
			PLAYER_GO: next_state = go ? LOAD_NOTES : PLAYER_GO;
			PLAYER_GO_WAIT: next_state = go ? PLAYER_GO_WAIT : LOAD_NOTES;
		endcase
	end
	
	
	always @(*)
	begin
		ld_notes = 1'b0;
		erase_notes = 1'b0;
		draw_board = 1'b0;
		draw_notes1 = 1'b0;
		draw_notes2 = 1'b0;
		draw_notes3 = 1'b0;
		draw_notes4 = 1'b0;
		check_notes = 1'b0;
		initialize = 1'b0;
		playerEN = 1'b0;
		plot = 1'b0;
		
		case(current_state)
			INITIALIZE_SONG: begin
				initialize = 1'b1;
				draw_board = 1'b0;
			end
			LOAD_NOTES: begin
				ld_notes = 1'b1;
				draw_board = 1'b0;
			end
			ERASE_NOTES: begin
				draw_board = 1'b0;
				erase_notes = 1'b1;
				plot = 1'b1;
			end
			DRAW_BOARD: begin
				draw_board = 1'b1;
				plot = 1'b1;
			end
			DRAW_NOTES1: begin
				draw_notes1 = 1'b1;
				plot = 1'b1;
			end
			DRAW_NOTES2: begin
				draw_notes2 = 1'b1;
				plot = 1'b1;
			end
			DRAW_NOTES3: begin
				draw_notes3 = 1'b1;
				plot = 1'b1;
			end
			DRAW_NOTES4: begin
				draw_notes4 = 1'b1;
				plot = 1'b1;
			end
			CHECK_NOTES: begin
				check_notes = 1'b1;
			end
			PLAYER_GO: begin
				draw_board = 1'b0;
				playerEN = 1'b1;
			end
			PLAYER_GO_WAIT: begin
				playerEN = 1'b1;
			end
		endcase
	end
	
	always @(posedge clk)
	begin: state_FFs
		if(!resetn)
			current_state <= GAME_START;
		else
			current_state <= next_state;
	end
	
	
endmodule
