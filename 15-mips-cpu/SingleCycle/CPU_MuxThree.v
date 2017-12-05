/*31位数据的三选一多路选择器*/
module CPU_MuxThree(a,b,c,s,y);
  input [31:0] a,b,c;
  input [1:0] s;
  output [31:0]y;

  assign y=(s==2'b00)? a:(s== 2'b01)? b : c; //s=2b'10和s=2b'11均赋为c
endmodule
