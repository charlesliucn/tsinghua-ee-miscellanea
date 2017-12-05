module ALU(A, B, sign, ALUFun, S);
input [31:0] A, B;  
input [5:0] ALUFun;
input sign;
output [31:0] S;
wire Z, V, N;
wire [31:0]adder32o,logo,shifto,cmpo;
ALU_ADDER_32 aluadder32(.sign(sign), .a(A), .b(B), .aors(ALUFun[0]), .s(adder32o), .Z(Z), .V(V), .N(N));
ALU_LOG alulog(.a(A),.b(B),.alufun(ALUFun[3:0]),.s(logo));
ALU_Shift alushift(.A(A),.B(B),.ALUFun(ALUFun),.S(shifto));
ALU_CMP ALU_CMP_1(.Z(Z), .V(V), .N(N), .ALUFun(ALUFun[3:1]), .S(cmpo));
assign S = ( ALUFun[5:4] == 2'b00)?adder32o:
( ALUFun[5:4] == 2'b11)?cmpo:
( ALUFun[5:4] == 2'b01)?logo:
shifto;
        endmodule