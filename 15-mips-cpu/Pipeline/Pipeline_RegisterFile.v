module Pipeline_RegisterFile(clk,reset,AddrA,AddrB,AddrC,WrC,WriteDataC,PC,IRQ,ReadDataA,ReadDataB,MemToReg);
  input clk,reset,WrC,IRQ,MemToReg; //MemToReg[1]
  input[4:0] AddrA,AddrB,AddrC;
  input[31:0] WriteDataC,PC;
  output[31:0] ReadDataA,ReadDataB;
  wire enable;
  wire[4:0] address;
  wire[31:0] PC_plus;
  reg [31:0] RF_DATA[31:1];
  integer i;

  assign enable=~PC[31]&(IRQ|MemToReg);
  assign address= MemToReg ? 5'b11010:5'b11111;
  
  assign PC_plus={PC[31],{PC[30:0]+31'b000_0000_0000_0000_0000_0000_0000_0100}};//PC_plus=PC+4
  
  assign ReadDataA=(AddrA==5'b0)? 32'b0:RF_DATA[AddrA];  //$0==0
  assign ReadDataB=(AddrB==5'b0)? 32'b0:RF_DATA[AddrB];  
  
  always @(negedge clk,posedge reset)
   begin
    if(reset) 
     begin
        for(i=1;i<32;i=i+1)
        RF_DATA[i]<=32'b0;
     end
    else
     begin 
      if(WrC&&AddrC) RF_DATA[AddrC]<=WriteDataC;
      if(enable&&(AddrC!=address)) RF_DATA[address]<=PC_plus;
     end
   end
endmodule