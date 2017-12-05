module Pipeline_ID_WB_IDEX(clk,reset,IFID,IDEX,MEMWB,IRQ,Rs,Rt,PCSrc,JT,DataBusA,DataBusC,Stallin,Stallout);
  input[63:0] IFID;
  input[70:0] MEMWB;
  input clk,reset,IRQ,Stallin;
  output[157:0] IDEX;
  output[31:0] DataBusA,DataBusC;
  output[25:0] JT;
  output[4:0] Rt, Rs;
  output[2:0] PCSrc;
  output Stallout;
  wire[15:0] Imm16;
  wire[5:0] ALUFun;
  wire[4:0] Shamt,Rd,AddrC;
  wire[1:0] RegDst, MemToReg;
  wire RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
  wire[31:0] Instruct,PC,DataBusB,Imm32,ALUA,LUout,ConBA;
  assign Instruct=IFID[63:32];
  assign PC=IFID[31:0];
  assign ConBA={PC[31],{PC[30:0]+31'd4+{Imm32[28:0],2'b00}}};
  assign Stallout=PCSrc[2]^PCSrc[1];

Pipeline_Control pipecon(Instruct,PC[31],JT,Imm16,Shamt,Rd,Rt,Rs,
                    PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,
                    Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp,IRQ);
Pipeline_MuxFour m1(.c0(Rd),.c1(Rt),.c2(5'b11111),.c3(5'b11010),.s(RegDst),.y(AddrC));
Pipeline_RegisterFile pipereg(.clk(clk),.reset(reset),.AddrA(Rs),.AddrB(Rt),.AddrC(MEMWB[68:64]),
                       .WrC(MEMWB[70]),.WriteDataC(DataBusC),.PC(PC),.IRQ(IRQ),
                       .ReadDataA(DataBusA),.ReadDataB(DataBusB),.MemToReg(MemToReg[1]));
Pipeline_Extender pipeext(Imm16,EXTOp,Imm32);
Pipeline_MuxTwo m2(.a(DataBusA),.b({27'b0,Shamt}),.s(ALUSrc1),.y(ALUA));
Pipeline_MuxTwo m3(.a(Imm32),.b({Imm16,16'b0}),.s(LUOp),.y(LUout));
Pipeline_MuxTwo m4(.a(MEMWB[31:0]),.b(MEMWB[63:32]),.s(MEMWB[69]),.y(DataBusC));
Pipeline_IDEX pipeidex(clk,reset,Rs,Rt,IDEX,Stallin,LUout,ALUSrc2,ConBA,PCSrc,ALUFun,Sign,
                   MemWr,MemRd,RegWr,MemToReg[0],AddrC,ALUA,DataBusB);
endmodule