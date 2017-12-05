/*单周期处理器  UART控制模块*/
module CPU_UARTController(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData,UART_TXD,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
  input clk,reset,MemRd,MemWr;
  input RX_STATUS,TX_STATUS; 	//UART输入输出的状态
  input [7:0] RX_DATA;			//输出的数据	
  input [31:0] Addr,WriteData;	//地址和写入的数据
  output reg [31:0] ReadData;	//读取的数据
  output reg [7:0] UART_TXD;	//发送的数据
  output reg TX_EN;				//发送使能信号，由控制模块确定数据接收完毕时置1
  
 	reg [4:0] UART_CON;			//UART_CON控制
	reg [15:0] Data;			//UART接收的两位8bit操作数数据
	reg [7:0] UART_RXD,RXData;	//UART先后接收的数据
	reg [1:0] Mark;				//
	reg DataOver,read,count;	//DataOver表示两位8bit数据已经接收完毕
	
	initial 
	 begin
	  ReadData<=32'b0;
	  Data<=16'b0;
	  UART_RXD<=8'b0;
	  DataOver<=1;
	  read<=1;
	  Mark<=0;
	  count<=0;
	  UART_CON<=5'b0;
	 end

  always @(*)		//根据地址读取数据
  begin
	if(MemRd)
    begin
      case(Addr)
       32'h40000018: ReadData<={24'b0,UART_TXD};
       32'h4000001c: ReadData<={24'b0,UART_RXD};
       32'h40000020: ReadData<={27'b0,UART_CON}; 
       default: ReadData<=32'b0;
      endcase
	end
    else ReadData<=32'b0;
  end
  
  
  always @(posedge clk, posedge reset) 
  begin
	if(reset)	//复位清零
	begin
      UART_CON<=5'b0;
      TX_EN<=0;
      Data<=16'b0;
      UART_RXD<=8'b0;
      count<=0;
	end
	else
	begin
		if(RX_STATUS)	//RX_STATUS=1表示接收数据
		begin 
		    if(DataOver) 	//两位8bit数据接收完毕时，Data清零，准备下一次输入数据（实现刷新）
			begin 
				Data<=16'b0; 
				RXData<=RX_DATA; //RXData存储新接收到的第一个8bit数据
				DataOver<=0; 	 //数据尚未接收完毕
			end
			else 
			begin
				Data<={RX_DATA,RXData};	//DataOver=0时，将第二位数据接在之后，此时两位数据均接收到，并存于Data中
				DataOver<=1;	//此时将DataOver置1
				Mark<=2'b01;	//Mark=2b'01表示新准备接收两位8bit数据
			end
		end
		if((Addr==32'h40000018)&&MemWr) //地址为UART_TXD时，将数据存入UART_TXD
		begin 
			UART_TXD<=WriteData[7:0];
			//TX_STATUS上出现高电平时，意味着此时串口发送器处于空闲状态可以接收一个新的发送数据
			if(TX_STATUS&&(Mark==2'b11)) //若TX_STATUS=1发送部分空闲且Mark=2'b11即两个操作数都接收完毕
			begin 
				if(count)	
				begin 
					TX_EN<=1; 		//TX_EN为高电平
					Mark<=2'b00; 	//Mark恢复为2b'00
				end
				count<=~count;		//用于产生TX_EN脉冲
			end
		end
		if((Addr==32'h40000018)&&MemWr)	//UART_CON对应的地址
			UART_CON<=WriteData[4:0];
			
		if((Addr==32'h4000001c)&&MemRd)	//UART_RXD对应的地址
		begin 
			if(read) //允许读取
			begin
				UART_RXD<=Data[7:0];	//接收第一个操作数
				read<=0;				//此时不允许读取数据
				if(Mark==2'b01)			//Mark=2'b10，表示第一个操作数接收完毕 
					Mark<=2'b10; 
			end
			else 
			begin 
				UART_RXD<=Data[15:8];	//接收第二个操作数
				read<=1; 				//此时允许读取数据
				if(Mark==2'b10)
					Mark<=2'b11;  		//Mark=2'b11，表示两个操作数都接收完毕 
			end
		end
		if(~(TX_STATUS&&(Mark==2'b11)))	//TX_STATUS繁忙或者数据未接收完毕时，TX_EN始终保持为0
			TX_EN<=1'b0;
	end
  end
  
  
endmodule