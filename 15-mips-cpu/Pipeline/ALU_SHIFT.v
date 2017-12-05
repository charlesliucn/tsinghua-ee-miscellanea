module Shift16(A, B, ALUFun, S);
  input [31:0] B;
  input A;
  input [1:0] ALUFun;
  output [31:0] S;
  wire [31:0]left, right, sright;
  assign left =  {B[15:0], 16'h0000};
  assign right = {16'h0000, B[31:16]};
  assign sright = (B[31])?{16'hFFFF, B[31:16]}:{16'h0000,  B[31:16]};
  assign S =  (~A)?B:(~ALUFun[0]) ? left:(ALUFun[1]) ? sright : right;
endmodule
module Shift8(A, B, ALUFun, S);
  input [31:0] B;
  input A;
  input [1:0] ALUFun;
  output [31:0] S;
  wire [31:0]left, right, sright;
  assign left =  {B[23:0], 8'h00};
  assign right = {8'h00 , B[31:8]};
  assign sright = (B[31])?{8'hFF, B[31:8]}:{8'h00,  B[31:8]};
  assign S =  (~A)?B:(~ALUFun[0]) ? left:(ALUFun[1]) ? sright : right;
endmodule
module Shift4(A, B, ALUFun, S);
  input [31:0] B;
  input A;
  input [1:0] ALUFun;
  output [31:0] S;
  wire [31:0]left, right, sright;
  assign left =  {B[27:0], 4'B0000};
  assign right = {4'B0000, B[31:4]};
  assign sright = (B[31])?{4'B1111, B[31:4]}:{4'B0000,  B[31:4]};
  assign S =  (~A)?B:(~ALUFun[0]) ? left:(ALUFun[1]) ? sright : right;
  endmodule
module Shift2(A, B, ALUFun, S);
  input [31:0] B;
  input A;
  input [1:0] ALUFun;
  output [31:0] S;
  wire [31:0]left, right, sright;
  assign left =  {B[29:0], 2'B00};
  assign right = {2'B00, B[31:2]};
  assign sright = (B[31])?{2'B11, B[31:2]}:{2'B00,  B[31:2]};
  assign S = (~A)?B:(~ALUFun[0]) ? left:(ALUFun[1]) ? sright : right;
endmodule
module Shift1(A, B, ALUFun, S);
  input [31:0] B;
  input A;
  input [1:0] ALUFun;
  output [31:0] S;
  wire [31:0]left, right, sright;
  assign left =  {B[30:0], 1'B0};
  assign right = {1'B0, B[31:1]};
  assign sright = (B[31])?{1'B1, B[31:1]}:{1'B0,  B[31:1]};
  assign S = (~A)?B:(~ALUFun[0]) ? left:(ALUFun[1]) ? sright : right;
endmodule
module  ALU_Shift(A, B, ALUFun, S);
input [31:0] A, B;
input [1:0] ALUFun;
output[31:0]S;
wire [31:0]S1,S2,S3,S4;
Shift16 Shift16_1(A[4], B, ALUFun, S1);
Shift8 Shift8_1(A[3], S1, ALUFun, S2);
Shift4 Shift4_1(A[2], S2, ALUFun, S3);
Shift2 Shift2_1(A[1], S3, ALUFun, S4);
Shift1 Shift1_1(A[0], S4, ALUFun, S);
endmodule
