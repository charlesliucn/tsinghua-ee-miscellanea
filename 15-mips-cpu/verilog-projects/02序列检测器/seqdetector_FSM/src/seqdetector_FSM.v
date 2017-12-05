module seqdetector_FSM(clk_in,system_clk,reset,x,z,Q);
  input clk_in,system_clk,reset,x;//clk_in?BTND????????system_clk??????x???????
  output reg z;//????????????????
  output reg [3:1]Q;//??LED??
  wire clk_o;//????????????
  
  debounce d(system_clk,clk_in,clk_o);//???????
  
  parameter A=3'b000,B=3'b001,C=3'b010,D=3'b011,E=3'b100,F=3'b101;//??????6???
  
  always @(posedge clk_o or posedge reset)//??????????
  begin
    if(reset)//???????????
    begin Q<=A; z<=0; end
    else
      case(Q)//?????????????
        A:begin
          if(x) 
          begin Q<=B;z<=0; end
          else 
          begin Q<=A;z<=0; end
          end
        B:begin
          if(x) 
          begin Q<=B;z<=0; end
          else 
          begin Q<=C;z<=0; end
          end
        C:begin
          if(x) 
          begin Q<=D;z<=0; end
          else 
          begin Q<=A;z<=0; end
          end
        D:begin
          if(x) 
          begin Q<=B;z<=0; end
          else 
          begin Q<=E;z<=0; end
          end  
        E:begin
          if(x) 
          begin Q<=F;z<=0; end
          else 
          begin Q<=A;z<=0; end
          end
        F:begin
          if(x) 
          begin Q<=B;z<=1; end
          else 
          begin Q<=E;z<=0; end
          end
        default://???????????????
          begin Q<=A;z<=0; end
      endcase
    end
  endmodule
