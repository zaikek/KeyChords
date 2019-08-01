// rate divider 50 Mhz to ~60 Hz
module refresh_rate_counter
	(
		input clk,
		input resetn,
		output reg refresh
		
	);
	
	reg [19:0] q; // reg for curr val
		
	always @ (posedge clk, negedge resetn)
	begin
		if (!resetn)
			q <= 20'd833333;
		else if (q == 20'd0) begin // reset
			q <= 20'd833333;
			refresh <= 1'b1;
		end
		else begin
			q <= q - 20'd1;
			refresh <= 1'b0;
		end

	end

endmodule


module frames_counter
	(
		input clk,
		input refresh,
		input [3:0] speed,
		output reg go
		
	);
	
	reg [3:0] q;
	
	always @ (posedge clk)
	begin
		if (q == 4'd0) begin 
			if(speed == 4'b0001)
				q <= 4'd3;
			else if(speed == 4'b0010)
				q <= 4'd5;
			else if(speed == 4'b0011)
				q <= 4'd10;
			else
				q <= 4'd1;
				
			go <= 1'b1;
		end
		else if (refresh) begin
			q <= q - 4'd1;
			go <= 1'b0;
			end
		else
			go <= 1'b0;

	end

endmodule
