module bitwise(clk, reset, s, op, in, out, done); 
  input clk, reset, s; 
  input [7:0] in; 
  input [3:0] op; 
  output [7:0] out; 
  output done; 
  wire [1:0] sr, Rn, aluop; 
  wire w, lt; 
  wire [2:0] bsel, tsel; 
  
  datapath DP(clk, in, sr, Rn, w, aluop, lt, tsel, bsel, out); 

  // Controller states
  typedef enum logic [3:0] {
      WAIT        = 4'b0000,
      MOV_RI      = 4'b0001,
      XOR_LOAD1   = 4'b0010,
      XOR_LOAD2   = 4'b0011,
      XOR_WRITE   = 4'b0100,
      ASL_LOAD1   = 4'b0101,
      ASL_LOAD2   = 4'b0110,
      ASL_SHIFT   = 4'b0111,
      ASL_WRITE   = 4'b1000,
      SWP_LOAD    = 4'b1001,
      SWP_SWAP    = 4'b1010,
      SWP_WRITE   = 4'b1011
  } state_t;

  state_t state, next_state;

  // State transitions
  always_ff @(posedge clk or posedge reset) begin
      if (reset)
          state <= WAIT;
      else
          state <= next_state;
  end

  // Next state logic
  always_comb begin
      next_state = state; // Default to stay in current state
      case (state)
          WAIT: begin
              if (s) begin
                  case (op[3:2])
                      2'b00: next_state = MOV_RI;
                      2'b01: next_state = XOR_LOAD1;
                      2'b10: next_state = ASL_LOAD1;
                      2'b11: next_state = SWP_LOAD;
                  endcase
              end
          end
          MOV_RI: next_state = WAIT;
          XOR_LOAD1: next_state = XOR_LOAD2;
          XOR_LOAD2: next_state = XOR_WRITE;
          XOR_WRITE: next_state = WAIT;
          ASL_LOAD1: next_state = ASL_LOAD2;
          ASL_LOAD2: next_state = ASL_SHIFT;
          ASL_SHIFT: next_state = ASL_WRITE;
          ASL_WRITE: next_state = WAIT;
          SWP_LOAD: next_state = SWP_SWAP;
          SWP_SWAP: next_state = SWP_WRITE;
          SWP_WRITE: next_state = WAIT;
          default: next_state = WAIT;
      endcase
  end

  // Output logic
  always_comb begin
      // Default values
      done = (state == WAIT);
      sr = 2'b00;
      Rn = 2'b00;
      aluop = 2'b00;
      w = 1'b0;
      lt = 1'b0;
      bsel = 3'b000;
      tsel = 3'b000;

      case (state)
          MOV_RI: begin
              sr = 2'b00; // Select `in`
              Rn = op[1:0]; // Target register
              w = 1'b1; // Enable write
          end
          XOR_LOAD1: begin
              sr = 2'b01; // Select `R1`
              bsel = 3'b001; // Select `R1` for Bin
              lt = 1'b1; // Load tmp
          end
          XOR_LOAD2: begin
              sr = 2'b01; // Select `tmp`
              bsel = 3'b010; // Select `R2`
              aluop = 2'b00; // XOR operation
              lt = 1'b1; // Load tmp
          end
          XOR_WRITE: begin
              sr = 2'b01; // Select `tmp`
              Rn = 2'b00; // Target R0
              w = 1'b1; // Enable write
          end
          ASL_LOAD1: begin
              sr = 2'b01; // Select `R1`
              bsel = 3'b001; // Select `R1` for Bin
              lt = 1'b1; // Load tmp
          end
          ASL_LOAD2: begin
              sr = 2'b01; // Select `tmp`
              bsel = 3'b010; // Select `R2`
              aluop = 2'b01; // AND operation
              lt = 1'b1; // Load tmp
          end
          ASL_SHIFT: begin
              sr = 2'b01; // Select `tmp`
              aluop = 2'b10; // Shift operation
              lt = 1'b1; // Load tmp
          end
          ASL_WRITE: begin
              sr = 2'b01; // Select `tmp`
              Rn = 2'b00; // Target R0
              w = 1'b1; // Enable write
          end
          SWP_LOAD: begin
              sr = 2'b01; // Select `R0`
              tsel = 3'b001; // Select R0
              lt = 1'b1; // Load tmp
          end
          SWP_SWAP: begin
              sr = 2'b01; // Select `tmp`
              Rn = op[1:0]; // Target Ri
              w = 1'b1; // Enable write
          end
          SWP_WRITE: begin
              sr = 2'b01; // Select `tmp`
              Rn = 2'b00; // Target R0
              w = 1'b1; // Enable write
          end
      endcase
  end
endmodule
