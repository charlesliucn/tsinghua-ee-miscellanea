module Pipeline_IFID(clk,reset,PC,Instruct,Stall,IFIDWrite,IFID);
  input clk,reset,Stall,IFIDWrite;
  input[31:0] PC,Instruct;
  output reg[63:0] IFID;
  wire[31:0] IFIDW;
  assign IFIDW=IFIDWrite? Instruct:IFID[63:32];
  always @(posedge clk,posedge reset)
   begin
    if(reset) IFID<=64'b0;
    else 
     begin 
      IFID[31:0]<=PC;
      IFID[63:32]<=Stall? 32'b0:IFIDW;
     end
   end    
endmodule