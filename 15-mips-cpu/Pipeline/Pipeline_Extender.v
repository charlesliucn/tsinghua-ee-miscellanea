module Pipeline_Extender(Imm16,EXTOp,Imm32);
  input[15:0] Imm16;
  input EXTOp;
  output[31:0] Imm32;
  assign Imm32={{16{Imm16[15]&EXTOp}},Imm16};
endmodule