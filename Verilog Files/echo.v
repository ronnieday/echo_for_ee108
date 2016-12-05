// This is the top-most module
// for the echo effect.  Everything
// else is decomposed into lower
// level modules within the ring_buffer.
module echo (
	input         clk,
	input         reset,
	input [15:0]  sample_in,
	input         new_sample_ready,
	input         enable,
	output [15:0] sample_out_to_codec);

// MUX to select between our echo effect
// or no effect depending on enable input.
always @(*) begin
	case(enable)
		// echo not enabled
		1'b0: sample_out_to_codec = sample_in;
		// echo YES enabled
		1'b1: sample_out_to_codec = buffered_sample;
	endcase

// This is where our delay
// actually happens:
ring_buffer ring_buffer (
	.clk(clk),
	.reset(reset),
	.sample_in(sample_in),
	.new_sample_ready(new_sample_ready),
	.sample_out(buffered_sample);

	// Output from buffer:
	reg [15:0] buffered_sample;

endmodule 