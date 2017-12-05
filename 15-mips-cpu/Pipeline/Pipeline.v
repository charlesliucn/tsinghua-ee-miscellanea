module CPU_Pipeline(sysclk,reset,led,AN,digital,switch,UART_TX,UART_RX);  
  input sysclk,reset,UART_RX;
  input [7:0] switch;
  output UART_TX;
  output[3:0] AN;
  output[7:0] digital,led;
  wire clk,sampleclk;
  
	wire [63:0] IFID;
	wire [157:0] IDEX;
	wire [72:0] EXMEM;
	wire [70:0] MEMWB;
	
	wire [31:0] ConBA,DataBusA,DataBusC;
	wire [25:0] JT;
	wire [7:0] TX_DATA,RX_DATA;
	wire [4:0] Rs,Rt;
	wire [2:0] IFIDPCSrc,IDEXPCSrc,PCSrc;
	wire [1:0] forwardA,forwardB;
  wire	PCWrite,IFIDWrite,Zero,IRQ;
  wire IFIDStall,IFIDStallA,StallB,IDEXStall,IDEXStallA,TX_EN,TX_STATUS,RX_STATUS;
  
	assign PCSrc=(IFIDPCSrc==3'b001||IDEXPCSrc == 3'b001)? IDEXPCSrc: IFIDPCSrc;
	assign IFIDStall=IFIDStallA|StallB;
	assign IDEXStall=IDEXStallA|StallB;
	assign PCWrite=~IDEXStallA;
	assign IFIDWrite=PCWrite;
	assign clk=sysclk;
	//Pipeline_Clk PClk(sysclk,reset,clk);
	Pipeline_UARTBaudrate PUBr(sysclk,sampleclk,reset);
  Pipeline_IF_IFID IF(clk,PCSrc,Zero,JT,ConBA,DataBusA,reset,PCWrite,IFIDWrite,IFIDStall,IFID);
  Pipeline_ID_WB_IDEX ID_WB(clk,reset,IFID,IDEX,MEMWB,IRQ,Rs,Rt,IFIDPCSrc,JT,DataBusA,DataBusC,IDEXStall,IFIDStallA);
  Pipeline_EX_EXMEM EX(clk,reset,IDEX,forwardA,forwardB,EXMEM[31:0],DataBusC,EXMEM,Zero,IDEXPCSrc,ConBA,StallB);
  Pipeline_UARTReceiver PUR(UART_RX,RX_STATUS,RX_DATA,sampleclk,clk,reset);
  Pipeline_UARTSender PUS(TX_EN,TX_DATA,TX_STATUS,UART_TX,sampleclk,clk,reset);
  Pipeline_MEM_MEMWB MEM(clk,reset,led,AN,digital,switch,IRQ,EXMEM,MEMWB,TX_DATA,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
  Pipeline_Forward forward(EXMEM[70],MEMWB[70],EXMEM[68:64],MEMWB[68:64],IDEX[157:153],IDEX[152:148],forwardA,forwardB);
  Pipeline_Hazard hazard(IDEX[71],IDEX[152:148],Rs,Rt,IDEXStallA);

endmodule
