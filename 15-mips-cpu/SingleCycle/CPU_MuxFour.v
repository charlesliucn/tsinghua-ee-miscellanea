/*三个 5位数据的2选1多路选择器 构成4选1多路选择器*/
module CPU_muxtwo(a,b,s,y);
  input [4:0] a,b;
  input s;
  output [4:0] y;
  assign y=(s==0)? a:b;
endmodule

module CPU_MuxFour(c0,c1,c2,c3,s,y);
  input [4:0] c0,c1,c2,c3;
  input [1:0] s;
  output  [4:0] y;
  wire [4:0] out1,out2;
  CPU_muxtwo Cmt1(c0,c1,s[0],out1); 
  CPU_muxtwo Cmt2(c2,c3,s[0],out2);
  CPU_muxtwo Cmt3(out1,out2,s[1],y);
endmodule