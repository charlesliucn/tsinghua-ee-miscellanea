module UART(sysclk,UART_RX,UART_TX);
  input UART_RX,sysclk;
  output UART_TX;
  wire sampleclk,baudclk,RX_STATUS,TX_STATUS,TX_EN;
  wire [7:0] RX_DATA;
  wire [7:0] TX_DATA;
  gen_Baudrate gB(.sysclk(sysclk),.sampleclk(sampleclk),.baudclk(baudclk));
  UART_Receiver UR(RX_DATA,RX_STATUS,sampleclk,UART_RX);
  UART_Controller UC(RX_DATA,RX_STATUS,sysclk,TX_DATA,TX_EN,TX_STATUS);
  UART_Sender US(TX_DATA,TX_EN,TX_STATUS,UART_TX,baudclk);
endmodule
  