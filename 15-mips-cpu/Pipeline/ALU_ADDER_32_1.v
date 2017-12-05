module ALU_ADDER_32(sign, a, b, aors, s, Z, V, N);
input [31:0]a;
input [31:0]b;
input sign;
input aors; //0 add   1 sub
output [31:0]s;
output Z;                //zero result
output V;                //over result
output N;                //negative result
wire [31:0]b1;
wire [32:0]a1;
wire [32:0]b2;
wire [32:0]s1;

assign b1 = (aors == 0)? b: ~b;
 assign a1[31:0]=a[31:0];
 assign b2[31:0]=b1[31:0];
 assign
 a1[32]=0;
 assign
 b2[32]=0;
assign s1=a1+b2+aors;
assign s=s1[31:0];
 assign Z = aors && (s == 0);
 assign V = sign && ((aors&&(a[31]^b[31])&(b[31]^~s[31]))||(~aors&&(a[31]^~b[31])&(b[31]^s[31])));
 assign N= aors && ((sign && s[31]  && ~V )||(sign && V && ~s[31])||(~sign && aors && ~s1[32]));
endmodule
