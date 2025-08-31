module protocol_spi#(
    parameter cpol = 1'b0,   
    parameter cpha = 1'b0    
)(
    input clk,
    input rst,
    input ss,
    input start,
    input [7:0]data_in,
    input miso,
    output reg mosi,
    output reg sclk,
    output reg [7:0]data_out,
    output reg done,
  output   reg [7:0] shift_in, 
  output  reg [7:0] shift_out );
    
    localparam Idle =2'b00,
               Transfer=2'b01,
               Done=2'b10; 
               
    reg [1:0] state, next_state;
    reg[2:0] bit_count;
   // reg [7:0] shift_in;  
    //reg [7:0] shift_out; 
    
    
    
  always @(*) begin
        case(state)
            Idle: next_state = (!ss) ? Transfer : Idle;
            Transfer: next_state = (bit_count == 3'd7 && sclk == cpol) ? Done : Transfer;
            Done: next_state = (ss) ? Idle : Done;
            default: next_state = Idle;
        endcase
    end
    
    
  always @(posedge clk or posedge rst) begin
        if (rst)
            state <= Idle;
        else
            state <= next_state;
    end 
    
   always @(posedge clk or posedge rst) begin
    if (rst) begin
        sclk <=cpol;
        done<=0;
        mosi <=0;
        shift_in<=0;
        shift_out<=0;
        data_out<=0;
        bit_count <=3'd7;
        
      end
      else begin
      case (state)
      Idle : begin
          bit_count<=0;
          shift_out<=data_in;
          done<=0;
          shift_in=0;
          sclk<=cpol;
          state<=next_state;
      end
      
     Transfer: begin
         sclk <= ~sclk;    
    if ((cpha == 0 && sclk == ~cpol) || (cpha == 1 && sclk == cpol)) begin
//       if ((cpha == 1 && sclk == ~cpol) || (cpha == 0 && sclk == cpol)) begin
         mosi <= shift_out[7];
        shift_out <= {shift_out[6:0], mosi};
        
        shift_in <= {shift_in[6:0], miso};
      
        
          if (bit_count != 0)
            bit_count <= bit_count - 1;
            state<=next_state;
end
    end
    
      Done: begin
                 done <= 1;
                    data_out <= shift_in;
                    sclk <= cpol;
                    mosi <= 0;
                end
            endcase
        end
    end
   

endmodule
