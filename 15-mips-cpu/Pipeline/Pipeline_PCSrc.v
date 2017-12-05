module Pipeline_PCSrc(clk,PCSrc,ALUOut,JT,ConBA,DatabusA,reset,PCWrite,PC);
	input ALUOut,clk,reset,PCWrite;  //ALUOut[0]:0->PC+4; 1->ConBA;
	input[2:0] PCSrc;
	input[25:0] JT;
	input[31:0] DatabusA,ConBA;
	output reg[31:0] PC;
	wire[31:0] plus,branch;
	
	parameter ILLOP=32'h8000_0004;
	parameter XADR=32'h8000_0008;
	
	assign plus={PC[31],PC[30:0]+31'b000_0000_0000_0000_0000_0000_0000_0100}; //PC+4
	assign branch=ALUOut? ConBA:plus; //branch:1->ConBA; 0->PC+4;
	
	initial begin PC<=32'h80000000; end
	  
  always @(posedge clk, posedge reset)
	 begin
		if(reset) PC<=32'h80000000;
		else if(PCWrite)
		 begin
			case(PCSrc)
			 3'b000: PC<=plus;
			 3'b001: PC<=branch; 
			 3'b010: PC<={PC[31:28],JT,2'b0};
			 3'b011: PC<=DatabusA;
			 3'b100: PC<=ILLOP;
			 3'b101: PC<=XADR;
			endcase
		 end
	 end
endmodule