module Pipeline_MEMWB(clk,reset,ReadData,EXMEM,MEMWB);
  input clk,reset;
  input[31:0] ReadData;
  input[38:0] EXMEM; //{EXMEM[70:64],EXMEM[31:0]}
  output reg[70:0] MEMWB;
  always @(posedge clk, posedge reset)
   begin
    if(reset) MEMWB<=71'b0;
    else MEMWB<={EXMEM[38:32],ReadData,EXMEM[31:0]};
   end
 endmodule