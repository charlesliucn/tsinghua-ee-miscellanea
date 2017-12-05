/*??2-1???????4-1?????*/
module Pipeline_muxtwo(a,b,s,y);
  input [4:0] a,b;
  input s;
  output [4:0] y;
  assign y=(s==0)? a:b;
endmodule

module Pipeline_MuxFour(c0,c1,c2,c3,s,y);
  input [4:0] c0,c1,c2,c3;
  input [1:0] s;
  output  [4:0] y;
  wire [4:0] out1,out2;
  Pipeline_muxtwo Pmt1(c0,c1,s[0],out1); 
  Pipeline_muxtwo Pmt2(c2,c3,s[0],out2);
  Pipeline_muxtwo Pmt3(out1,out2,s[1],y);
endmodule
