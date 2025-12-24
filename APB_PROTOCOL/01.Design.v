
module apb(pclk,prst,paddr,psel,penable,pwrite,pwdata,pready,pslver,prdata);
  
  input pclk;
  input prst;
  input [7:0]paddr;
  
  input psel;
  input penable;
  input pwrite;
  input [31:0]pwdata;
  
  
  output reg pready;
  output reg  pslver;
  output reg [31:0]prdata;
  
  reg [31:0]mem[31:0];
  
  localparam   idle=2'b00;
  localparam setup=2'b01;
  localparam access=2'b10;
  
   
  reg [1:0]state,next_state;
  
  always @(posedge pclk) begin
    if(prst)
      state <= idle;
    else
      state <= next_state;
  end
  always @(*) begin
  
  case (state)
    idle:begin
      if (psel   & !penable) 	
				next_state = setup;
      pready=0;
    end

    setup:begin if (!penable | !psel) 
						next_state = idle; 
              else begin
						next_state=access;
                       
                if(pwrite ==1) begin
                  mem[paddr]= pwdata;
                  pready=1;
                  pslver=0;
                   end
                else begin
                  prdata=mem[paddr];
                   pready=1;
                   pslver=0;
                 end
               end
    end
    access :begin
      if (!penable | !psel) begin
					    next_state = idle;
                        pready =0;
             end
    end
	endcase 
end
endmodule

