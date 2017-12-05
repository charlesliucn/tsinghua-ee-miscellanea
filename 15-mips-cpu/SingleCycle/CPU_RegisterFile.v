/*单周期处理器 寄存器堆模块*/
module CPU_RegisterFile(clk,reset,AddrA,AddrB,AddrC,WrC,WriteDataC,PC,IRQ,ReadDataA,ReadDataB);
  input clk,reset;
  input WrC,IRQ;
  input [4:0] AddrA,AddrB,AddrC;
  input [31:0] WriteDataC,PC;
  output [31:0] ReadDataA,ReadDataB;
  
  wire[31:0] PC_plus;
  reg [31:0] RF_DATA [31:1];
  integer i;
  
  assign PC_plus={PC[31],{PC[30:0]+31'd4}};
  assign ReadDataA=(AddrA==5'b0)? 32'b0:RF_DATA[AddrA];
  assign ReadDataB=(AddrB==5'b0)? 32'b0:RF_DATA[AddrB]; 
  
  always @(posedge clk or negedge reset)
  begin
    if(reset) 
      for(i=1;i<32;i=i+1)
        RF_DATA[i]<=32'b0;
    else
      begin 
        if(WrC&&AddrC) RF_DATA[AddrC]<=WriteDataC;
        if(~PC[31]&IRQ&(~WrC|AddrC!=5'b11111)) 
          RF_DATA[31]<=PC_plus;
     end
  end
  
endmodule
