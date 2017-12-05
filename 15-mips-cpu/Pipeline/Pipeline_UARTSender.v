module Pipeline_UARTSender(TX_EN,TX_DATA,TX_STATUS,UART_TX,sampleclk,clk,reset);
  input sampleclk,TX_EN,reset,clk;
  input[7:0] TX_DATA; 
  output reg TX_STATUS,UART_TX;
  
  reg ENTX,mark;
  reg [9:0] count; 
  wire START;
	
  assign START=mark&~TX_EN; //find the START
  
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
		if(TX_EN) ENTX<=1;
		else if(START) TX_STATUS<=0;
		else if(count==640)
		begin
			ENTX<=0;
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
    else if(ENTX)
    begin
	     count<=count+1;
	     case(count)
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


