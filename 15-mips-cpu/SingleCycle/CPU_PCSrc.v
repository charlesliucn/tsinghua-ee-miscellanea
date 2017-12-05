/*单周期处理器 PC的来源选择模块*/
module CPU_PCSrc(PCSrc,ALUOut,ConBA,JT,DatabusA,PC,clk,reset);
  input [2:0] PCSrc;  //PC来源共六种情况
  input ALUOut;       //ALUout[0]=0, PC=PC+4; ALUOut[0]=1,PC=ConBA
  input [31:0] ConBA; //条件分支指令
  input [31:0] DatabusA;   //寄存器跳转指令
  input [25:0] JT;         //直接跳转指令
  input clk,reset;         //处理器时钟信号
  output reg [31:0] PC; //输出PC地址
  
 	parameter START=32'h8000_0000; //PC的起始地址
	parameter ILLOP=32'h8000_0004; //中断的PC地址
	parameter XADR =32'h8000_0008; //异常的PC地址

	initial
	begin
	  PC<=START;  //PC起始地址
	end
	
	wire [31:0] PC_plus,Branch,JTs;
	assign PC_plus={PC[31],PC[30:0]+31'd4};       //PC+4且不改变P[31]的值
	assign Branch = (ALUOut==1) ? ConBA:PC_plus;  //条件分支地址
	assign JTs={PC[31:28],JT,2'b0};               //直接跳转地址
	 
	always @(posedge clk or negedge reset)
	begin
	  if (reset)
	    PC<=START; //复位则地址恢复起始地址
	  else
	    begin
	    case(PCSrc)  //PC的六种来源
	      3'd0: PC<=PC_plus;
	      3'd1: PC<=Branch;
	      3'd2: PC<=JTs;
	      3'd3: PC<=DatabusA;
	      3'd4: PC<=ILLOP;
	      3'd5: PC<=XADR;
	    endcase
	    end
  end
endmodule

  
