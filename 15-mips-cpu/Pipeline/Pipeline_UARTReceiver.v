module Pipeline_UARTReceiver(UART_RX,RX_STATUS,RX_DATA,sampleclk,clk,reset);
  input sampleclk,clk,reset;
  input UART_RX;
  output reg RX_STATUS; 
  output reg [7:0] RX_DATA;

  reg mark,ENTX;
  reg [9:0] count;
  wire START;
  
  assign START=(mark&&~UART_RX&&~count)? 1:0; 
  
  initial 
  begin
    RX_STATUS<=0;
    RX_DATA<=0;
    mark<=0;
    ENTX<=0;
    count<=0;
  end 
 
  always @(posedge clk or negedge reset)
  begin
    if(reset)
    begin
      mark<=0;
      ENTX<=0;
    end 
    else 
    begin
      mark<=UART_RX;
      if(START==1) 
        ENTX<=1;
      else if(count==608) 
        ENTX<=0;
    end
  end

  always @(posedge clk or negedge reset)
  begin
    if(reset) 
      RX_STATUS<=0;
    else if(count==608&&ENTX) 
      RX_STATUS<=1;  
    else RX_STATUS<=0;
  end
  
  always @(posedge sampleclk or negedge reset)
  begin
  if(reset)
  begin 
    RX_DATA<=8'b0;
    count<=0;
  end
  else if(ENTX)
  begin
    count<=count+1;
    case(count)
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
