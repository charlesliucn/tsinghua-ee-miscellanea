module UART_Controller(RX_DATA,RX_STATUS,sysclk,TX_DATA,TX_EN,TX_STATUS);
  input RX_STATUS,TX_STATUS,sysclk;
  input [7:0] RX_DATA;
  output reg TX_EN;
  output [7:0] TX_DATA;
  reg rx_over;
  
 // assign TX_DATA[7]=RX_DATA[7];
  assign TX_DATA[7:0]=(RX_DATA[7]==1)?~RX_DATA[7:0]:RX_DATA[7:0];
  
  always@(posedge sysclk)
    if(RX_STATUS) 
       rx_over<=1;
    else if(TX_STATUS&rx_over)
      begin
        rx_over<=0;
        TX_EN<=1;
      end
    else
      TX_EN<=0;
endmodule
