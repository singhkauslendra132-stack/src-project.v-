
module tt_um_quantum_engine (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    reg [15:0] q_state_lfsr;
    reg [3:0]  c_reg;

    wire b0  = q_state_lfsr & 1'b1;
    wire b2  = (q_state_lfsr >> 2) & 1'b1;
    wire b3  = (q_state_lfsr >> 3) & 1'b1;
    wire b15 = (q_state_lfsr >> 15) & 1'b1;

    wire q0_measured = b0 ^ b15;
    wire q1_measured = q0_measured;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_state_lfsr <= 16'hACE1 ^ {8'h00, ui_in};
            c_reg <= 4'b0000;
        end else if (ena) begin
            q_state_lfsr <= (q_state_lfsr << 1) | {15'b0, (b0 ^ b2 ^ b3 ^ b15)};
            c_reg <= {2'b00, q1_measured, q0_measured};
        end
    end

    assign uo_out = {4'b0000, c_reg};

endmodule
