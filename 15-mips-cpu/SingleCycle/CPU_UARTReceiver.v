/*单周期处理器 UART接收模块*/
module CPU_UARTReceiver(UART_RX,RX_STATUS,RX_DATA,sampleclk,clk,reset);
  input sampleclk,clk,reset;
  input UART_RX;	//串行接收数据
  output reg RX_STATUS; 	//用于表示8bit数据是否接收完毕
  output reg [7:0] RX_DATA;	//接收到的8bit数据

  reg mark,ENRX;	
  reg [9:0] count;	
  wire START;		
  
  initial 
  begin
    RX_STATUS<=0;
    RX_DATA<=0;
    mark<=0;
    ENRX<=0;
    count<=0;
  end 
  assign START=(mark&&~UART_RX&&~count)? 1:0;  //开始数据的接收
  always @(posedge clk or negedge reset)
  begin
    if(reset)
    begin
      mark<=0;
      ENRX<=0;
    end 
    else 
    begin
      mark<=UART_RX; 
      if(START==1) 		//接收开始
        ENRX<=1;		//接收使能信号
      else if(count==608) 
        ENRX<=0;		//8bit数据全部接收完毕，接收使能置0
    end
  end

  always @(posedge clk or negedge reset)
  begin
    if(reset) 
      RX_STATUS<=0;		
    else if(count==608&&ENRX) 	
      RX_STATUS<=1;  	//数据接收完毕
    else RX_STATUS<=0;
  end
  
  always @(posedge sampleclk or negedge reset)
  begin
  if(reset)
  begin 
    RX_DATA<=8'b0;
    count<=0;
  end
  else if(ENRX)
  begin
    count<=count+1;
    case(count)		//采样信号驱动下，每隔64个采样周期，得到1bit数据
      96:  RX_DATA[0]<=UART_RX; 
      160: RX_DATA[1]<=UART_RX;
      224: RX_DATA[2]<=UART_RX;
      288: RX_DATA[3]<=UART_RX;
      352: RX_DATA[4]<=UART_RX;
      416: RX_DATA[5]<=UART_RX;
      480: RX_DATA[6]<=UART_RX;
      544: RX_DATA[7]<=UART_RX;
    endcase
  end
  else count<=0;
end
  
endmodule