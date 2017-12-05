module UART_Sender(TX_DATA,TX_EN,TX_STATUS,UART_TX,baudclk);
  input [7:0] TX_DATA;
  input TX_EN,baudclk;
  output reg UART_TX,TX_STATUS;
  reg [3:0] count;
  initial
    count<=9;
    
  always@(posedge baudclk or posedge TX_EN)
  begin
    if(TX_EN)
      begin
      count<=0;
      TX_STATUS<=0;
      end
    else if(count==0)
        begin
          UART_TX<=0;
          count<=count+1;
          TX_STATUS<=0;
        end
      else if(count==9)
        begin
          UART_TX<=1;
          TX_STATUS<=1;
        end
      else
        begin
          UART_TX<=TX_DATA[count-1];
          count=count+1;
        end
      end
  endmodule
