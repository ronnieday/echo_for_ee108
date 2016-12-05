// This counter addresses our ring
// buffer.  The buffer needs to be 
// set up to match this counter.
// The buffer is inside ring_buffer.v
// The value for TOP should match the
// depth of the buffer.  (13' TOP means
// we should have a buffer DEPTH=13).
// Enable should only go high when we've
// received a new_sample_ready signal
// in the ring_buffer.v module.
module ring_buffer_address_counter (
    input clk,
    input reset,
    input en,
    output reg [3:0] count
);

    // reg TOP = 13'b1011101110000; // decimal 6,000, 8th note
    reg TOP = 4'b1101;  // decimal 13 (For TESTBENCHING)
    reg [3:0] current_count;

    dffre #(4) counter (
        .clk(clk),
        .en(en),
        .r(reset | (current_count == TOP)),
        .d(current_count + 1'b1),
        .q(current_count)
    );

    // Outputs a 13 bit address:
    assign count = current_count;

endmodule
