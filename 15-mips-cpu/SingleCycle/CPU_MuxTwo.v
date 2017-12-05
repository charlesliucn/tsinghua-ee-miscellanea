/*32位数据的二选一多路选择器*/
module CPU_MuxTwo(a,b,s,y);
  input [31:0] a,b;
  input s;
  output [31:0] y;
  assign y=(s==0)? a:b;
endmodule

