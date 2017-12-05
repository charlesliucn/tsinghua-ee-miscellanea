/*****分频模块*****/
/*将系统时钟分频后作为单周期处理器的主时钟*/
module CPU_Clk(sysclk,clk,reset);
  input sysclk,reset;
  output reg clk;
  reg [4:0] count;
  
  initial 
  begin
    count<=0; //计数信号用于系统时钟分频
    clk<=1;
  end
    
  always@(posedge sysclk or posedge reset) 
  begin
    if(reset)//复位信号清零
      begin
        count<=0;
		clk<=1;
      end
    else
      begin
        if(count==2)//count==2实际为四分频率
          begin 
	         clk<=~clk;
			 count<=0;
	        end
        else  count<=count+1; 
      end
  end
endmodule