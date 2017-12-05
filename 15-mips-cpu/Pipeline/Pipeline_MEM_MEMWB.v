module Pipeline_MEM_MEMWB(clk,reset,led,AN,digital,switch,IRQ,EXMEM,MEMWB,UART_TXD,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
  input clk,reset,TX_STATUS,RX_STATUS;
  input [31:0] switch;
  input [72:0] EXMEM;
  input [7:0] RX_DATA;
  output[7:0] digital,led,UART_TXD;
  output[3:0] AN;
  output IRQ,TX_EN;
  output[70:0] MEMWB;
  wire [31:0] ReadData;
  wire [31:0] ReadData1,ReadData2,ReadData3;
  
  Pipeline_UARTController CUC(clk,reset,EXMEM[31:0],EXMEM[63:32],EXMEM[71],EXMEM[72],ReadData3,UART_TXD,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
  Pipeline_DataMem CDM(clk,reset,EXMEM[31:0],EXMEM[63:32],EXMEM[71],EXMEM[72],ReadData1);
  Pipeline_Peripheral CPP(clk,reset,EXMEM[31:0],EXMEM[63:32],EXMEM[71],EXMEM[72],ReadData2,led,AN,digital,switch,IRQ);

  assign ReadData =
        (EXMEM[31:0]<32'h0000_03ff) ? ReadData1 : //data
        (EXMEM[31:0]<32'h4000_0018) ? ReadData2 : //LED, switch, digi, timer
        ReadData3;                           //UART
  Pipeline_MEMWB pipememwb(.clk(clk),.reset(reset),.ReadData(ReadData),
                     .EXMEM({EXMEM[70:64],EXMEM[31:0]}),.MEMWB(MEMWB));
                     
endmodule