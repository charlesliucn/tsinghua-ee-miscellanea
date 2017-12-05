module UART_Receiver(RX_DATA,RX_STATUS,sampleclk,UART_RX);
  input sampleclk,UART_RX;
  output reg [7:0] RX_DATA;
  output reg RX_STATUS;
  reg [7:0] data;
  reg enable;
  reg [3:0] count1,count2;
  initial
  begin
    count1<=0;
    count2<=0;
    enable<=0;
    data<=0;
  end
  
  always@(posedge sampleclk)
  begin
    if(UART_RX==1&&enable==0)
    begin
      RX_STATUS<=0;
      RX_DATA<=data;
    end
    else if(count1==0)
      begin
        if(count2==7)
          begin
          enable<=1;
          count2<=0;
          count1<=count1+1;
          end
        else
          count2<=count2+1;
      end
    else if(count1<4'b1010&count1>0&enable==1)
      begin
        if(count2==15)
          begin
          data[count1-1]<=UART_RX;
          count2<=0;
          count1=count1+1;
          end
        else
          count2<=count2+1;
     end
   else if(count1==4'b1010)
     begin
       count1<=0;
       RX_STATUS<=1;
       enable<=0;
     end
  end
endmodule
