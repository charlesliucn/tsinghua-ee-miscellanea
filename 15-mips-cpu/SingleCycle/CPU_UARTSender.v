/*单周期处理器 UART发送器模块*/
module CPU_UARTSender(TX_EN,TX_DATA,TX_STATUS,UART_TX,sampleclk,clk,reset);
  input sampleclk,TX_EN,reset,clk;
  input [7:0] TX_DATA; //发射的8bit数据
  output reg TX_STATUS,UART_TX; 
  
  reg ENTX,mark;
  reg [9:0] count; 
  wire START;
	
  assign START=mark&~TX_EN;  //TX_EN脉冲之后开始发送
  
  initial
  begin
    TX_STATUS=1; 
	UART_TX=1;
    ENTX=0;
	count=0;
  end
  
  always @(posedge clk or negedge reset)
  begin
    if(reset)
      begin 
	      ENTX=0;
	      TX_STATUS=1;
		  mark<=0;
	    end
    else
	begin
		mark<=TX_EN;	
		if(TX_EN) ENTX<=1;				//发送使能信号
		else if(START) TX_STATUS<=0;	//开始发送数据时，处于忙碌状态
		else if(count==640)
		begin
			ENTX<=0;		//数据发送完毕，发送模块恢复空闲状态
			TX_STATUS<=1;
		end
	end
 end

  always @(posedge sampleclk or negedge reset)
  begin
    if(reset) 
	  begin
		  UART_TX<=1;
		  count<=0;
	  end
    else if(ENTX)//发送数据使能，发送10位 包括起始位和停止位
    begin
	     count<=count+1;
	     case(count)//每个64个采样周期发送1位数据，以保证9600的波特率
		      0:   UART_TX<=0;
		      64:  UART_TX<=TX_DATA[0];
		      128: UART_TX<=TX_DATA[1];
		      192: UART_TX<=TX_DATA[2];
		      256: UART_TX<=TX_DATA[3];
		      320: UART_TX<=TX_DATA[4];
		      384: UART_TX<=TX_DATA[5];
		      448: UART_TX<=TX_DATA[6];
		      512: UART_TX<=TX_DATA[7];
		      576: UART_TX<=1;	
	     endcase
    end
    else 
	  begin
		  UART_TX<=1;
		  count<=0;
	  end
 end
 
endmodule

