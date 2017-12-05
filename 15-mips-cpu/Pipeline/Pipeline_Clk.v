/*100MHz?????????CPU???*/
module Pipeline_Clk(sysclk,reset,clk);
  input sysclk,reset;
  output reg clk;
  reg [4:0] count;
  
  initial //???
  begin
    count<=0;//??????
    clk<=1;
  end
    
  always@(posedge sysclk or posedge reset) 
  begin
    if(reset)
      begin
        count<=0; clk<=1; //??
      end
    else
      begin
        if(count==8) //??
          begin 
	         clk<=~clk;
	         count<=0;
	        end
        else  count<=count+1; 
      end
  end
endmodule