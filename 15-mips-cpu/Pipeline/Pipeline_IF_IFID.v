module Pipeline_IF_IFID(clk,PCSrc,ALUOut,JT,ConBA,DatabusA,reset,PCWrite,IFIDWrite,Stall,IFID);
input clk,reset,PCWrite,ALUOut,IFIDWrite,Stall;
input[2:0] PCSrc;
input[25:0] JT;
input[31:0] DatabusA,ConBA;
output[63:0] IFID;
wire[31:0] PC,Instruct;
Pipeline_PCSrc pipepc(clk,PCSrc,ALUOut,JT,ConBA,DatabusA,reset,PCWrite,PC);
Pipeline_ROM pipeins(.reset(reset),.PC(PC[8:2]),.enable(IFIDWrite),.Instruct_o(Instruct));
Pipeline_IFID pipeifid(clk,reset,PC,Instruct,Stall,IFIDWrite,IFID);
endmodule