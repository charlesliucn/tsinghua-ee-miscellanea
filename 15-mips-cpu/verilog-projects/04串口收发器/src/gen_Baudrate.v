module gen_Baudrate(sysclk,sampleclk,baudclk);
input sysclk;
output reg sampleclk,baudclk;
reg [8:0] count1;
reg [4:0] count2;
initial
  begin
    sampleclk<=0;
    baudclk<=0;
    count1<=0;
    count2<=0;
  end
always@(posedge sysclk) //9600*12=153600Hz
  if(count1==325)
    begin
      count1<=0;
      sampleclk<=~sampleclk;
    end
  else
    count1<=count1+1;
    
always@(posedge sampleclk) //9600Hz
  if(count2==7)
    begin
      count2<=0;
      baudclk<=~baudclk;
    end
  else
    count2<=count2+1;
endmodule 
