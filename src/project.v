/*
 * Copyright (c) 2024 IndexAsm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none






module tt_um_IndexAsm (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    localparam STATE_FETCH      =   4'd0;
    localparam STATE_DECODE     =   4'd1;


    localparam OPCODE_HALT      =   8'd0;
    localparam OPCODE_MOVAI     =   8'd1;
    localparam OPCODE_MOVBI     =   8'd2;
    localparam OPCODE_ADDAB     =   8'd3;
    localparam OPCODE_SUBAB     =   8'd4;
    localparam OPCODE_MOVAMEM   =   8'd5;
    localparam OPCODE_MOVBMEM   =   8'd6;
    localparam OPCODE_MOVAB     =   8'd7;
    localparam OPCODE_MOVBA     =   8'd8;
    localparam OPCODE_CMPAB     =   8'd9;
    localparam OPCODE_JE        =   8'd10;
    localparam OPCODE_JNE       =   8'd11;
    localparam OPCODE_JA        =   8'd12;
    localparam OPCODE_JB        =   8'd13;
    localparam OPCODE_JMP       =   8'd14;
    localparam OPCODE_ANDAB     =   8'd15;
    localparam OPCODE_ORAB      =   8'd16;
    localparam OPCODE_NOTA      =   8'd17;
    localparam OPCODE_NOTB      =   8'd18;
    localparam OPCODE_INCA      =   8'd19;
    localparam OPCODE_DECA      =   8'd20;
    localparam OPCODE_INCB      =   8'd20;
    localparam OPCODE_DECB      =   8'd20;
    localparam OPCODE_MOVCSI    =   8'd20;
    localparam OPCODE_MOVDSI    =   8'd20;
    localparam OPCODE_MOVSSI    =   8'd20;










    assign uio_oe[4] = 1'b0;
    assign uio_out[4] = 1'b0;




    // All output pins must be assigned. If not used, assign to 0.


    reg     [9:0]   address_bus;
    reg     [3:0]   dataout_bus;
    reg     [3:0]   datadir_bus;
    wire    [3:0]   datain_bus;

    reg     rw;

    assign  uio_out[7] = rw;


    assign uo_out = address_bus[7:0];
    assign uio_out[5] = address_bus[8];
    assign uio_out[6] = address_bus[9];

    assign uio_out[3:0] = dataout_bus;
    assign datain_bus = uio_in[3:0];
    assign uio_oe[3:0] = datadir_bus;

    assign uio_oe[7:5] = 3'b111;

    reg [7:0]   register_INST;

    reg [3:0]   register_IP;

    reg [3:0]   register_A;
    reg [3:0]   register_B;


    reg [3:0]   register_STATE;

    reg [1:0]   register_STATE_PART;


    reg [3:0]   register_CS;
    reg [3:0]   register_DS;
    reg [3:0]   register_SS;


    always @ (posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            register_STATE <= STATE_FETCH;
            register_IP <= 4'h2;
            register_A <= 4'b0;
            register_B <= 4'b0;
            dataout_bus <= 4'b0;
            address_bus <= 10'b0;
            datadir_bus <= 4'b0;

            register_CS <= 4'b0;
            register_DS <= 4'b0;
            register_SS <= 4'b0;
            register_STATE_PART <= 2'b0;
            rw <= 1'b0;
            register_INST <= 8'b0;
            
        end else begin
            case (register_STATE)
                STATE_FETCH: begin
                    if (register_STATE_PART == 2'b00) begin
                        address_bus[3:0] <= register_IP;
                        address_bus[7:4] <= register_CS;
                        register_STATE_PART <= 2'b01;
                    end else if (register_STATE_PART == 2'b01) begin
                        register_INST[3:0] <= datain_bus;
                        address_bus[3:0] <= register_IP + 4'b0001;
                        register_STATE_PART <= 2'b10;
                    end else begin 
                        register_INST[7:4] <= datain_bus;
                        register_IP <= register_IP + 4'b0010;
                        register_STATE <= STATE_DECODE;
                        register_STATE_PART <= 2'b00;
                    end
                end

                STATE_DECODE: begin
                    case (register_INST)
                        OPCODE_HALT: begin

                        end
                        OPCODE_MOVAI: begin 
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_A <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_MOVBI: begin 
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_B <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_ADDAB: begin
                            register_A <= register_A + register_B;
                            register_STATE <= STATE_FETCH;
                        end

                        OPCODE_SUBAB: begin
                            register_A <= register_A - register_B;
                            register_STATE <= STATE_FETCH;
                        end

                        OPCODE_MOVAMEM: begin
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else if (register_STATE_PART == 2'b01) begin
                                address_bus[3:0] <= datain_bus;
                                address_bus[7:4] <= register_DS;
                                register_STATE_PART <= 2'b10;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_A <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_MOVBMEM: begin
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else if (register_STATE_PART == 2'b01) begin
                                address_bus[3:0] <= datain_bus;
                                address_bus[7:4] <= register_DS;
                                register_STATE_PART <= 2'b10;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_B <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_MOVAB: begin
                            register_A <= register_B;
                            register_STATE <= STATE_FETCH;
                        end
                        OPCODE_MOVBA: begin
                            register_B <= register_A;
                            register_STATE <= STATE_FETCH;
                        end

                        OPCODE_INCA: begin
                            register_A <= register_A + 4'b1;
                            register_STATE <= STATE_FETCH;
                        end
                        OPCODE_INCB: begin
                            register_B <= register_B + 4'b1;
                            register_STATE <= STATE_FETCH;
                        end


                        OPCODE_DECA: begin
                            register_A <= register_A - 4'b1;
                            register_STATE <= STATE_FETCH;
                        end
                        OPCODE_DECB: begin
                            register_B <= register_B - 4'b1;
                            register_STATE <= STATE_FETCH;
                        end

                        OPCODE_MOVCSI: begin 
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_CS <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_MOVDSI: begin 
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_DS <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        OPCODE_MOVSSI: begin 
                            if (register_STATE_PART == 2'b00) begin
                                address_bus[3:0] <= register_IP;
                                address_bus[7:4] <= register_CS;
                                register_STATE_PART <= 2'b1;
                            end else begin
                                register_IP <= register_IP + 4'b1;
                                register_SS <= datain_bus;
                                register_STATE_PART <= 2'b0;
                                register_STATE <= STATE_FETCH;
                            end
                        end

                        default: begin
                            register_IP <= register_IP + 4'd1;
                            register_STATE <= STATE_FETCH;
                        end
                    endcase
                    

                end

                default: begin
                    register_STATE <= STATE_FETCH;
                end

            endcase

        end

    end




    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in, 1'b0};

endmodule
