module Pipeline_DataMem(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData);
  input clk,reset,MemRd,MemWr;
  input [31:0] Addr,WriteData;
  output [31:0] ReadData;

  parameter RAM_SIZE = 256;
  //(* ram_style = "distributed" *)
  reg [31:0] RAMDATA [RAM_SIZE-1:0];
   
  assign ReadData=(MemRd&&(Addr<RAM_SIZE)) ? RAMDATA[Addr[31:2]] : 32'b0;
  
  always@(posedge clk) 
  begin
		  if((Addr[31:2]<RAM_SIZE)&&MemWr) 
		    RAMDATA[Addr[31:2]]<=WriteData;
  end
endmodule
