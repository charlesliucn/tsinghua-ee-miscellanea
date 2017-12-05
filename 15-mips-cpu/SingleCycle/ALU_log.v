module ALU_LOG(a,b,alufun,s);
  input[31:0] a, b;
  input[3:0] alufun;
  output[31:0] s;
  assign s = (alufun == 4'b1000)? a & b :(alufun == 4'b1110)? 
  a | b :(alufun == 4'b0110)? a ^ b :
  (alufun == 4'b0001)? ~(a | b) :(alufun == 4'b1010)? a : 0;
endmodule
