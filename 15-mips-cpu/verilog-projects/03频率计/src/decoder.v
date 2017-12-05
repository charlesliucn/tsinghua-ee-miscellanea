module BCD7(din,dout);
  input [3:0] din;
  output [7:0] dout;
  assign dout=(din==0)?8'b0111_1110:
              (din==1)?8'b0011_0000:
              (din==2)?8'b0110_1101:
              (din==3)?8'b0111_1001:
              (din==4)?8'b0011_0011:
              (din==5)?8'b0101_1011:
              (din==6)?8'b0101_1111:
              (din==7)?8'b0111_0000:
              (din==8)?8'b0111_1111:
              (din==9)?8'b0111_1011:8'b0;
endmodule

module decoder(th,hun,ten,one,clk_scan,Cathodes,AN);
  input clk_scan;
  input [3:0] th,hun,ten,one;
  output [7:0] Cathodes;
  output [3:0] AN;
  reg [3:0] an;
  reg [3:0] display;
  wire [7:0] digi;
  
  initial
  begin
   an<=4'b0111;
 end
  
  always @(posedge clk_scan) 
  begin
  if(an[0]==1&&an[1]==1&&an[2]==1&&an[3]==0)
  begin
    an[0]<=1;
    an[1]<=1;
    an[2]<=0;
    an[3]<=1;
    display=hun;
  end
  if(an[0]==1&&an[1]==1&&an[2]==0&&an[3]==1)
  begin
    an[0]<=1;
    an[1]<=0;
    an[2]<=1;
    an[3]<=1;
    display=ten;
  end
  if(an[0]==1&&an[1]==0&&an[2]==1&&an[3]==1)
  begin
    an[0]<=0;
    an[1]<=1;
    an[2]<=1;
    an[3]<=1;
    display=one;
  end
  if(an[0]==0&&an[1]==1&&an[2]==1&&an[3]==1)
  begin
    an[0]<=1;
    an[1]<=1;
    an[2]<=1;
    an[3]<=0;
    display=th;
  end
end

  BCD7 bcd(display,digi);
  assign AN[0] = an[0];
  assign AN[1] = an[1]; 
  assign AN[2] = an[2];
  assign AN[3] = an[3];
  assign Cathodes=~digi;

endmodule

