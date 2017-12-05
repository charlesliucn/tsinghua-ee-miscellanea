module Pipeline_EXMEM(clk,reset,EXMEM,IDEX,ALURt,S);
  input clk,reset;
  input[8:0] IDEX;//IDEX[72:64]
  input[31:0] ALURt,S;
  output reg[72:0] EXMEM;
  always @(posedge clk,posedge reset)
   begin
    if(reset) EXMEM<=73'b0;
    else EXMEM<={IDEX,ALURt,S};
   end
 endmodule
 
 module Pipeline_EX_EXMEM(clk,reset,IDEX,forwardA,forwardB,dataEXMEM,dataMEMWB,EXMEM,Zero,PCSrc,ConBA,Stall);
  input clk,reset;
  input[147:0] IDEX;
  input[31:0] dataEXMEM,dataMEMWB;
  input[1:0] forwardA,forwardB;
  output[72:0] EXMEM;
  output[31:0] ConBA;
  output[2:0] PCSrc;
  output Zero,Stall;
  reg[31:0] A,B,ALURt;
  wire[31:0] S;
  wire con; //condition:conBA is true
  assign Zero=S[0];
  assign ConBA=IDEX[114:83];
  assign PCSrc=IDEX[82:80];
  assign con=(PCSrc==3'b001)? 1:0;
  assign Stall=Zero&con;
  always @(*)
  begin
    case(forwardA)
      2'b00:A<=IDEX[63:32];
      2'b01:A<=dataMEMWB;
      2'b10:A<=dataEXMEM;
      2'b11:A<=32'b0;
      default:A<=32'b0;
    endcase
  end
  always @(*)
  begin
    case(forwardB)
      2'b00:ALURt<=IDEX[31:0];
      2'b01:ALURt<=dataMEMWB;
      2'b10:ALURt<=dataEXMEM;
      2'b11:ALURt<=32'b0;
      default:ALURt<=32'b0;
    endcase
  end
  always @(*)
  begin
    case(IDEX[115])
      1'b0:B<=ALURt;
      1'b1:B<=IDEX[147:116];
    endcase
  end
  ALU pipeALU(A,B,IDEX[79:74],IDEX[73],S);
  Pipeline_EXMEM pipeexmem(clk,reset,EXMEM,IDEX[72:64],ALURt,S);
endmodule
