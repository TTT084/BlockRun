//***************************************************************************
// 
// Filename: blockRun.sv
//
// Author: Tristan Timothy
// Description: Codebreaker. Takes in bytes and uses an FSM to run every key
// through the decrpyt_rc4 to decrpyt the message. The message has to be a
// correct ASCII character. Puts out an error if it goes through every key
// and it doesn't find a message
//
//****************************************************************************/

module blockRun #(parameter CLK_FREQUENCY = 100000000;
    output logic block,
    input logic clk, reset
);
    localparam TIMER_CLOCK_COUNT = CLK_FREQUENCY
    // Determine the number of bits needed to represent the maximum count value
    localparam DIGIT_COUNTER_WIDTH = $clog2(TIMER_CLOCK_COUNT);
    // Declare a signal used for this counter signal
    logic [DIGIT_COUNTER_WIDTH-1:0] brCounter;
    logic [4:0] lfsr;
    logic feedback;

    // Feedback polynomial taps for 5-bit LFSR: x^5 + x^3 + 1 (taps at 5 and 3)
    assign feedback = lfsr[4] ^ lfsr[2];

    always_ff @(posedge clk) begin
        if (rst)
            lfsr <= 5'b00001;  // Non-zero seed
        else
            lfsr <= {lfsr[3:0], feedback};
    end

    // Map to 1–20 range using modulo and add 1
    assign rand_num = (lfsr % 20) + 1;
endmodule