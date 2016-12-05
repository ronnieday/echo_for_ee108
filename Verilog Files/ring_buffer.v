module ring_buffer (
	input         clk,
	input         reset,
	input [15:0]  sample_in,
	input         new_sample_ready,
	output [15:0] sample_out);

// Goes high once the
// delay length counter
// is done:
reg activate_delay;


// Switch that turns on and stays on
// when first sample comes in.
dffre #(1) switch_for_echo_begin_counter (
		.clk(clk),
		.r(reset),
		.en(new_sample_ready),
		.d(1'b1),
		.q(first_sample_received)
		);
// Signals echo_begin_counter to start:
reg first_sample_received;
assign first_sample_received = 1'b0;


// Delay length counter.  Activate_delay
// goes high when we should start reading
// from the buffer RAM:
echo_begin_counter delay_length_counter(
	.clk(clk),
	.reset(reset),
	.en(first_sample_received), // should stay high.
	.done(activate_delay)
	);

// This is the MUX that selects between
// our dry output or delayed signal:
always @(*) begin
	case(activate_delay)
		// dry out during first 16th:
		1'b0: sample_out = sample_in;
		// wet out while echo is running:
		1'b1: sample_out = combined_sample;
	endcase
end

// This is where we sum the delayed signal with the dry:
reg [15:0] combined_sample = sample_in + delayed_sample;


	// Goes high while sample is being
	// written into the ring buffer:
	wire writing_sample_to_buffer;
	// Flopper to delay new_sample_ready
	// by the one clock cycle that it takes
	// to write to the RAM:
	dffr #(1) start_writing_to_buffer (
		.clk(clk),
		.r(reset),
		.d(new_sample_ready),
		.q(writing_sample_to_buffer)
		);
	// Goes high on the clock cycle after
	// a new sample has been written into
	// the ring buffer:
	wire done_writing_sample_to_buffer;
	// Flopper that delays the already 
	// delayed writing_sample_to_buffer
	// signal to signal that its been done.
	dffr #(1) stop_writing_to_buffer (
		.clk(clk),
		.r(reset),
		.d(writing_sample_to_buffer),
		.q(done_writing_sample_to_buffer)
		);


// ///////////// //
// Write counter //
// ///////////// //
ring_buffer_address_counter write_address_counter (
	.clk(clk),
    .reset(reset),
    .en(writing_sample_to_buffer && !done_writing_sample_to_buffer),
    .count(write_address));


// //////////// //
// Read counter //
// //////////// //
ring_buffer_address_counter read_address_counter (
	.clk(clk),
    .reset(reset),
    .en(activate_delay && writing_sample_to_buffer && !done_writing_sample_to_buffer),
    .count(read_address));


	// This is our RAM for the ring buffer.  2 read, 1 write,
	// (we only need 1 read, 1 write).  The size of the 
	// RAM is WIDTH bits wide by DEPTH^2 words deep.
	ram_1w2r #(.WIDTH(16), .DEPTH(13)) ring_buffer_RAM (  // 256 Depth
		.clka(clk),                     // Clock for port A
		.wea(writing_sample_to_buffer), // Write Enable
		.addra(write_address),          // Address, port A, 16'b
		.dina(sample_in),               // Data in, port A
		.douta(),                       // Data out, port A
		.clkb(clk),                     // Clock for port B
		.addrb(read_address),           // Address, port B
		.doutb(delayed_sample)          // Data out, port B
		);

endmodule // ring_buffer
