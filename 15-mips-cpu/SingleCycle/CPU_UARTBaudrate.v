/*UART生成9600波特率对应的采样信号*/
module CPU_UARTBaudrate(sysclk,sampleclk,reset);
  input sysclk,reset;
  output reg sampleclk;
  
  reg [8:0] count;
  initial 
  begin
    count<=0;
    sampleclk<=1;
  end
  
  always @(posedge sysclk or negedge reset) 
  begin
    if(reset)
      begin
      count<=0;   
      sampleclk<=1;
      end
    else
    begin
      if(count==80)//采用64倍的采样准确度更高
        begin 
	        sampleclk<=~sampleclk;
	        count<=0;
	      end
      else
        count<=count+1; 
    end
  end

endmodule

