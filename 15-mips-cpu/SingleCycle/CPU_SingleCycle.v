/*单周期处理器最高模块*/
module CPU_SingleCycle(sysclk,reset,led,AN,digital,switch,UART_TX,UART_RX);
    input sysclk,reset,UART_RX;
    input [7:0] switch;
    output UART_TX;
    output [3:0] AN;
    output [7:0] digital,led;

    wire IRQ,RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp,TX_EN,TX_STATUS,RX_STATUS;
    wire [1:0] RegDst,MemToReg;
    wire [2:0] PCSrc;
    wire [5:0] ALUFun;
    wire [15:0] Imm_16;
	wire [25:0] JT;
	wire [31:0] PC_plus,ConBA,DataBusA,DataBusB,DataBusC,Imm_32,Imm_out;
	wire [31:0] ALU_A,ALU_B,ALUOut,ReadData,Instruct,PC;
    wire [4:0] Shamt,Rd,Rt,Rs,AddrC;
    wire [7:0] TX_DATA,RX_DATA;
    wire clk,sampleclk;
    wire [31:0] ReadData1,ReadData2,ReadData3;
    
    assign PC_plus={PC[31],{PC[30:0]+31'd4}};
    assign ConBA={PC[31],PC_plus[30:0]+{Imm_32[28:0],2'b00}};
    
	/*系统时钟产生单周期处理器主时钟*/
    CPU_Clk CClk(sysclk,clk,reset);
    
    CPU_PCSrc CPS(PCSrc,ALUOut[0],ConBA,JT,DataBusA,PC,clk,reset);
    CPU_ROM CROM (PC[8:2],Instruct);
    CPU_Control CC(Instruct,PC[31],JT,Imm_16,Shamt,Rd,Rt,Rs,PCSrc,RegDst,   
    RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp,IRQ);
    CPU_MuxFour CMF(.c0(Rd),.c1(Rt),.c2(5'b11111),.c3(5'b11010),.s(RegDst),.y(AddrC));
    CPU_RegisterFile CRF(clk,reset,Rs,Rt,AddrC,RegWr,DataBusC,PC,IRQ,DataBusA,DataBusB);
    CPU_Extender CE(EXTOp,Imm_16,Imm_32);
    CPU_MuxTwo CMT1(.a(Imm_32),.b({Imm_16,16'b0}),.s(LUOp),.y(Imm_out));
    CPU_MuxTwo CMT2(.a(DataBusA),.b({27'b0,Shamt}),.s(ALUSrc1),.y(ALU_A));
    CPU_MuxTwo CMT3(.a(DataBusB),.b(Imm_out),.s(ALUSrc2),.y(ALU_B));
    ALU ALU(.A(ALU_A),.B(ALU_B),.sign(Sign),.ALUFun(ALUFun),.S(ALUOut));

    CPU_UARTBaudrate CUB(sysclk,sampleclk,reset);
    CPU_UARTReceiver CUR(UART_RX,RX_STATUS,RX_DATA,sampleclk,clk,reset);
    CPU_UARTSender CUS(TX_EN,TX_DATA,TX_STATUS,UART_TX,sampleclk,clk,reset);
    
    CPU_UARTController CUC(clk,reset,ALUOut,DataBusB,MemRd,MemWr,ReadData3,TX_DATA,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
    CPU_DataMem CDM(clk,reset,ALUOut,DataBusB,MemRd,MemWr,ReadData1);
    CPU_Peripheral CPP(clk,reset,ALUOut,DataBusB,MemRd,MemWr,ReadData2,led,AN,digital,switch,IRQ);
    /*根据地址从数据内存、外设和UART的输入读取数据*/
    assign ReadData =
        (ALUOut<32'h0000_03ff) ? ReadData1 ://数据内存
        (ALUOut<32'h4000_0018) ? ReadData2 : //外设
        ReadData3;                           //UART输入
    CPU_MuxThree CMTh(.a(ALUOut),.b(ReadData),.c(PC_plus),.s(MemToReg),.y(DataBusC));
    
endmodule
