module KeyChords
	(
		input CLOCK_50,						//	On Board 50 MHz
      input [3:0] KEY,
      input [17:0] SW,
		output VGA_CLK,   						//	VGA Clock
		output VGA_HS,							//	VGA H_SYNC
		output VGA_VS,							//	VGA V_SYNC
		output VGA_BLANK_N,						//	VGA BLANK
		output VGA_SYNC_N,						//	VGA SYNC
		output [9:0] VGA_R,   						//	VGA Red[9:0]
		output [9:0] VGA_G,	 						//	VGA Green[9:0]
		output [9:0] VGA_B,   						//	VGA Blue[9:0]
		output [17:0] LEDR,
		output [7:0] HEX0,
		output [7:0] HEX1,
		output [7:0] HEX2,
		output [7:0] HEX3,
		output [7:0] HEX4,
		//output [7:0] HEX5,
		output [7:0] HEX6
	);
	
	wire resetn;
	assign resetn = SW[17];
	wire writeEN;
	
	wire [7:0] x;
	wire [7:0] y;
	wire [2:0] colour;
	wire [818:0] song_note1;
	wire [818:0] song_note2;
	wire [818:0] song_note3;
	wire [818:0] song_note4;
	
	wire [159:0] note1_bar;
	wire [159:0] note2_bar;
	wire [159:0] note3_bar;
	wire [159:0] note4_bar;
	
	wire ld_notes;
	wire initialize;
	wire erase_notes;
	wire draw_board;
	wire draw_notes_1;
	wire draw_notes_2;
	wire draw_notes_3;
	wire draw_notes_4;
	wire check_notes;
	wire updating;
	wire playerEN;
	wire done;
	
	wire [15:0] score;
	
	wire refresh;
	wire go;
	
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEN),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	datapath d0(
		.resetn(resetn),
		.clk(CLOCK_50),
		.keypress(KEY[3:0]),
		.initialize(initialize),
		.ld_notes(ld_notes),
		.erase_notes(erase_notes),
		.draw_board(draw_board),
		.draw_notes1(draw_notes_1),
		.draw_notes2(draw_notes_2),
		.draw_notes3(draw_notes_3),
		.draw_notes4(draw_notes_4),
		.playerEN(playerEN),
		.song(SW[3:0]),
		.song_note1(song_note1),
		.song_note2(song_note2),
		.song_note3(song_note3),
		.song_note4(song_note4),
		.x_out(x),
		.y_out(y),
		.colour_out(colour),
		.score(score),
		.done(done),
		.updating(updating));
		
	control c0(
		.resetn(resetn),
		.clk(CLOCK_50),
		.go(go),
		.start(!KEY[0]),
		.updating(updating),
		.ld_notes(ld_notes),
		.initialize(initialize),
		.erase_notes(erase_notes),
		.draw_board(draw_board),
		.draw_notes1(draw_notes_1),
		.draw_notes2(draw_notes_2),
		.draw_notes3(draw_notes_3),
		.draw_notes4(draw_notes_4),
		.check_notes(check_notes),
		.playerEN(playerEN),
		.plot(writeEN));
	

	refresh_rate_counter r0(
		.clk(CLOCK_50),
		.resetn(resetn),
		.refresh(refresh));
	
	frames_counter f0(
		.clk(CLOCK_50),
		.refresh(refresh),
		.speed(SW[16:13]),
		.go(go));
		
	hex_display h0(
		.IN(score[3:0]),
		.OUT(HEX0));
		
	hex_display h1(
		.IN(score[7:4]),
		.OUT(HEX1));
	
	hex_display h2(
		.IN(score[11:8]),
		.OUT(HEX2));
		
	hex_display h3(
		.IN(score[15:12]),
		.OUT(HEX3));
	
	hex_display h4(
		.IN(SW[3:0]),
		.OUT(HEX4));
	
	hex_display h6(
		.IN(done),
		.OUT(HEX6));

endmodule
