module ring_buffer_tb ();
	reg         clk, 
	reg         reset, 
	reg         new_sample_ready;
	reg [15:0]  sample_in;
	wire [15:0] sample_to_codec;
	
	ring_buffer DUT (.clk(clk),
				 .reset(reset),
				 .sample_in(sample_in),
				 .new_sample_ready(new_sample_ready),
				 .sample_out(sample_to_codec));
	
	initial begin
		reset = 1; 	new_sample_ready = 0;
		#10 reset = 0; sample_in = 16'd1;
		#10 sample_in = 16'd2; new_sample_ready = 1;
		#10 sample_in = 16'd3;
		#10 sample_in = 16'd4; new_sample_ready = 0;
		#10 sample_in = 16'd5;
		#10 sample_in = 16'd6;
		#10 sample_in = 16'd7;
		#10 sample_in = 16'd8; new_sample_ready = 1;
		#10 sample_in = 16'd9;
		#10 sample_in = 16'd10;
		#10 sample_in = 16'd11; new_sample_ready = 0;
		#10
		#10 sample_in = 16'd12; new_sample_ready = 1;
		#10 sample_in = 16'd15; new_sample_ready = 0;
		#10
		#10 sample_in = 16'd16; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd17; new_sample_ready = 0;
		#10 sample_in = 16'd18;
		#10 sample_in = 16'd19; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd20; new_sample_ready = 0;
		#10 sample_in = 16'd21;
		#10 sample_in = 16'd22; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd21; new_sample_ready = 0;
		#10 sample_in = 16'd20;
		#10 sample_in = 16'd19;
		#10 sample_in = 16'd18; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd0; new_sample_ready = 0;
		#10 sample_in = 16'd0;
		#10 sample_in = 16'd17; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd16; new_sample_ready = 0;
		#10 sample_in = 16'd15;
		#10 sample_in = 16'd14;
		#10 sample_in = 16'd13;
		#10 sample_in = 16'd12; new_sample_ready = 1;
		#10
		#10 sample_in = 16'd11; new_sample_ready = 0;
		#10 sample_in = 16'd10;
		#10 sample_in = 16'd9;
		#10 sample_in = 16'd8;
		#10 sample_in = 16'd7; new_sample_ready = 1;
		#20 sample_in = 16'd6; 
		#10 sample_in = 16'd5;
		#10
		$stop;
		 
	end
endmodule