// Counts down instead of up
// to avoid costly logic comparisons
// on each bit of count value.
module echo_begin_counter(
   input        Clk,
   input        Reset,
   input        Enable,
   output       DONE,
   );

//--------------------------------------------------------------
// signal definitions
//--------------------------------------------------------------

//counter signals
// reg [11:0] count_top = 12'b101110111000;  // REAL count for synthesis...  3,000
reg [2:0] count_top = 3'b101; // decimal 5 for TESTBENCHING
reg [3:0] counter;

//--------------------------------------------------------------
// counter
//--------------------------------------------------------------

// For this counter, we add an extra bit to the MSB side of our
// count_top signal.  Then, when we reach 0 and decrement past
// it, we cause an overflow.  Only then does this extra MSB become
// 1.  At all other times it is 0.  This saves us from comparing
// each bit in our counter number (as would be required if we were
// counting up instead of down).  This way, we only run one comparison
// per enabled clock tick.
always @(posedge Clk)
begin
   if(Reset) begin

      //intitialize counter on reset
      counter <= {1'b0,count_top};

   end

   else if(Enable) begin

      //backward counter
      if(!counter[4]) begin
         counter <= counter - 1;
      end
      //count reached
      else if(counter[4]) begin
         assign DONE = 1'b1;
      end

   end

   else begin
      assign DONE = 1'b0;
   end

end

endmodule
