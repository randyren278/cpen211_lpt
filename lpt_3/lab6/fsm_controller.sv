module fsm_controller(
    input logic clk,//✓
    input logic reset, //✓
    input logic s,//✓
    input logic Z,//✓
    input logic N,//✓
    input logic V,//✓

    input logic [2:0] opcode,//✓
    input logic [1:0] ALU_op,//✓
    input logic [1:0] shift_op,//✓
    output logic wait_state,//✓

    output logic [1:0] nsel,//✓
    output logic  asel, bsel,//✓
    output logic [1:0] vsel,//✓
    output logic  write,//✓
    output logic loada, loadb, loadc, loads//✓ 
);
    localparam [4:0] Wait = 5'b00000,
                     mov_imm = 5'b00001,// Write immediate value to register

                     mov_reg_loadB = 5'b00010,// Load Rm into B register
                     mov_reg_compute = 5'b00011,// Perform optional shift operation
                     mov_reg_writeback = 5'b00100,// Write result back to Rd

                     mvn_loadB = 5'b00101, // Load Rm into B register
                     mvn_compute = 5'b00110, // Compute NOT of B (with optional shift)
                     mvn_writeback = 5'b00111,// Write result back to Rd

                     add_loadA = 5'b01000,// Load Rn into A register
                     add_loadB = 5'b01001, // Load Rm into B register
                     add_compute = 5'b01010, // Perform addition A + B
                     add_writeback = 5'b01011,// Write result back to Rd

                     cmp_loadA = 5'b01100, // Load Rn into A register
                     cmp_loadB = 5'b01101, // Load Rn into A register
                     cmp_compute = 5'b01110,// Compute A - B and update status flags

                     and_loadA = 5'b01111, // Load Rn into A register
                     and_loadB = 5'b10000, // Load Rm into B register
                     and_compute = 5'b10001,// Perform bitwise AND A & B
                     and_writeback = 5'b10010; // Write result back to Rd

    reg [4:0] state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= Wait;
        else begin
            case (state)
                Wait: begin
                    if (s) begin
                        case (opcode)
                            3'b101: begin
                                case (ALU_op)
                                    2'b00: state <= add_loadA; //add 
                                    2'b01: state <= cmp_loadA; //cmp
                                    2'b10: state <= and_loadA;//and 
                                    2'b11: state <= mvn_loadB; //mvn 
                                    default: state <= Wait;
                                endcase
                            end
                            3'b110: begin
                                case (ALU_op)
                                    2'b10: state <= mov_imm;
                                    2'b00: state <= mov_reg_loadB;
                                    default: state <= Wait;
                                endcase
                            end
                            default: state <= Wait;
                        endcase
                    end else begin
                        state <= Wait;
                    end
                end

                mov_imm: state <= Wait;
                mov_reg_loadB: state <= mov_reg_compute;
                mov_reg_compute: state <= mov_reg_writeback;
                mov_reg_writeback: state <= Wait;

                add_loadA: state <= add_loadB;
                add_loadB: state <= add_compute;
                add_compute: state <= add_writeback;
                add_writeback: state <= Wait;

                cmp_loadA: state <= cmp_loadB;
                cmp_loadB: state <= cmp_compute;
                cmp_compute: state <= Wait;

                and_loadA: state <= and_loadB;
                and_loadB: state <= and_compute;
                and_compute: state <= and_writeback;
                and_writeback: state <= Wait;

                mvn_loadB: state <= mvn_compute;
                mvn_compute: state <= mvn_writeback;
                mvn_writeback: state <= Wait;

                default: state <= Wait;
            endcase
        end
    end

   always_comb begin
        wait_state = (state == Wait);
        loada = (state == add_loadA) || (state == cmp_loadA) || (state == and_loadA);
        loadb = (state == add_loadB) || (state == cmp_loadB) || (state == and_loadB) ||
                (state == mvn_loadB) || (state == mov_reg_loadB);
        loadc = (state == add_compute) || (state == and_compute) || (state == mvn_compute) ||
                (state == mov_reg_compute);
        loads = (state == cmp_compute);
        asel = (state == mvn_compute) || (state == mov_reg_compute);
        bsel = 1'b0;

        vsel = (state == mov_imm) ? 2'b10 : // Select sximm8
               2'b00; // Default case
        nsel = (state == add_loadA || state == cmp_loadA || state == and_loadA) ? 2'b10 :
               (state == mov_imm) ? 2'b10 : // Changed from 2'b01 to 2'b10
               (state == add_writeback || state == and_writeback || state == mvn_writeback ||
                state == mov_reg_writeback) ? 2'b01 :
               (state == add_loadB || state == cmp_loadB || state == and_loadB ||
                state == mvn_loadB || state == mov_reg_loadB) ? 2'b00 :
               2'b00;

        write = ((state == add_writeback) || (state == mvn_writeback) || (state == and_writeback) ||
                 (state == mov_imm) || (state == mov_reg_writeback)) ? 1'b1 : 1'b0;
    end
endmodule

