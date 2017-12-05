/*单周期处理器 符号扩展单元*/
module CPU_Extender(EXTOp,Imm_16,Imm_32);
  input [15:0] Imm_16;
  input EXTOp;	//控制信号
  output [31:0] Imm_32;
  //当EXTOp=1时 有符号扩展，高16位全为原16位的最高位
  //当EXTOp=0时 无符号扩展，高16位全为0
  assign Imm_32={{16{Imm_16[15]&EXTOp}},Imm_16};
endmodule
