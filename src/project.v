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

    wire q0_measured = q_state_lfsr[0] ^ q_state_lfsr[2];
    wire q1_measured = (q_state_lfsr[1] ^ q_state_lfsr[3]) ^ (q0_measured & q_state_lfsr[5]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_state_lfsr <= 16'hACE1 ^ {8'h00, ui_in};
            c_reg <= 4'b0000;
        end else if (ena) begin
            q_state_lfsr <= {q_state_lfsr[14:0], q_state_lfsr[15] ^ q_state_lfsr[13] ^ q_state_lfsr[12] ^ q_state_lfsr[10]};
            c_reg[0] <= q0_measured;
            c_reg[1] <= q1_measured;
            c_reg[2] <= 1'b0;
            c_reg[3] <= 1'b0;
        end
    end

    assign uo_out = {4'b0000, c_reg};

endmodule
