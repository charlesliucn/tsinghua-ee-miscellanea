/*控制信号产生模块*/
module control(clk_ctrl,enable,reset,lock); 
  input clk_ctrl; 
  output enable,reset,lock;
  reg enable,reset,lock;
  reg [1:0]count;
  initial
    begin
      enable<=1;
      reset<=0;
      count<=0;
    end
    always @(posedge clk_ctrl)
    begin
      if(count==0)
        begin
          enable<=1;
          count<=1;
          reset<=1;
          lock<=0;
        end
      else if(count==2'd1)
        begin
          enable<=0;
          count<=2'd2;
          reset<=1;
          lock<=1;
        end
      else if(count==2'd2)
        begin
          enable<=0;
          count<=2'd0;
          reset<=0;
          lock<=0;
        end
    end
  endmodule