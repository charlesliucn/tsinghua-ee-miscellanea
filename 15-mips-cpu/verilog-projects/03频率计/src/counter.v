module single_counter(clk,reset,enable,ct,carry_num);//??
  input clk,reset,enable;
  output reg [3:0]ct;
  output reg carry_num;
  always@(posedge clk or negedge reset) 
  begin
    if(~reset)//reset?????
      begin
       ct<=4'b0;
       carry_num<=0;
      end
    else if(enable&&ct==4'd9)
      begin
       ct<=4'b0;
       carry_num<=1;
      end
    else if(enable&&ct<4'd9)
      begin
       ct<=ct+1'b1;
       carry_num<=0;
      end
  end
endmodule

module counter(enable,reset,sig_in,deci_th,deci_hun,deci_ten,deci);  
  input sig_in,enable,reset;
  output [3:0]deci_th,deci_hun,deci_ten,deci;
  wire [3:0]cout;
  wire sigin;
  assign sigin=sig_in;
  single_counter sc1(sigin,reset,enable,deci,cout[0]);
  single_counter sc2(cout[0],reset,enable,deci_ten,cout[1]);
  single_counter sc3(cout[1],reset,enable,deci_hun,cout[2]);
  single_counter sc4(cout[2],reset,enable,deci_th,cout[3]);
endmodule

