module ALU_Shift(A,B,ALUFun,S);
  input [31:0]  A;
  input [31:0]  B;
  input [5:0]   ALUFun;
  output  reg [31:0]  S;
  wire  [31:0]  S0;
  wire  [31:0]  S1;
  wire  [31:0]  S2;
  assign S0=B<<A[4:0];
  assign S1=B>>A[4:0];
  assign S2=B>>>A[4:0];
  always @(*)
  begin
    case(ALUFun[1:0])
      2'b00:  S=S0;
      2'b01:  S=S1;
      2'b11:  S=S2;
      default:S=B;
    endcase
  end
  
endmodule
