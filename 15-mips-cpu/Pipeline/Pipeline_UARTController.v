module Pipeline_UARTController(clk,reset,Addr,WriteData,MemRd,MemWr,ReadData,UART_TXD,RX_DATA,TX_EN,TX_STATUS,RX_STATUS);
  input clk,reset,MemRd,MemWr;
  input RX_STATUS,TX_STATUS;
  input [7:0] RX_DATA;
  input [31:0] Addr,WriteData;
  output reg [31:0] ReadData;
  output reg [7:0] UART_TXD;
  output reg TX_EN;
  
 	reg [4:0] UART_CON;
	reg [15:0] Data;//?????????
	reg [7:0] UART_RXD,RXData;
	reg [1:0] Mark;
	reg DataOver,read,count;//DataOver??????????
	
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

  always @(*)
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
	if(reset)
	begin
      UART_CON<=5'b0;
      TX_EN<=0;
      Data<=16'b0;
      UART_RXD<=8'b0;
      count<=0;
	end
	else
	begin
		if(RX_STATUS)
		begin 
		    if(DataOver) 
			begin 
				Data<=16'b0; 
				RXData<=RX_DATA; 
				DataOver<=0; 
			end
			else 
			begin
				Data<={RX_DATA,RXData};
				DataOver<=1;
				Mark<=2'b01;
			end
		end
		if((Addr==32'h40000018)&&MemWr) 
		begin 
			UART_TXD<=WriteData[7:0];
			if(TX_STATUS&&(Mark==2'b11)) 
			begin 
				if(count)
				begin 
					TX_EN<=1; 
					Mark<=2'b00; 
				end
				count<=~count;
			end
		end
		if((Addr==32'h40000018)&&MemWr)
			UART_CON<=WriteData[4:0];
		if((Addr==32'h4000001c)&&MemRd)
		begin 
			if(read) 
			begin
				UART_RXD<=Data[7:0];
				read<=0;
				if(Mark==2'b01)
				Mark<=2'b10; 
			end
			else 
			begin 
				UART_RXD<=Data[15:8];
				read<=1; 
				if(Mark==2'b10)
					Mark<=2'b11;  
			end
		end
		if(~(TX_STATUS&&(Mark==2'b11)))
			TX_EN<=1'b0;
	end
  end
  
  
endmodule
