module Pipeline_IDEX(clk,reset,Rs,Rt,IDEX,Stall,LUout,ALUSrc2,ConBA,PCSrc,ALUFun,Sign,
                 MemWr,MemRd,RegWr,MemToReg,AddrC,ALUA,DataBusB);
 input clk,reset,Stall,ALUSrc2,Sign,MemWr,MemRd,RegWr,MemToReg; //MemToReg[0]
 input[2:0] PCSrc;
 input[4:0] Rs,Rt,AddrC;
 input[5:0] ALUFun;
 input[31:0] LUout,ConBA,ALUA,DataBusB;
 output reg[157:0] IDEX;
 always @(posedge clk, posedge reset) 
	begin
	 if(reset||Stall) IDEX<=158'b0;
	 else IDEX<={Rs,Rt,LUout,ALUSrc2,ConBA,PCSrc,ALUFun,Sign,
	             MemWr,MemRd,RegWr,MemToReg,AddrC,ALUA,DataBusB};
	end
endmodule