`timescale 1ns/1ps

module tb;

  reg        pclk;
  reg        prst;
  reg [7:0]  paddr;
  reg        psel;
  reg        penable;
  reg        pwrite;
  reg [31:0] pwdata;

  wire       pready;
  wire       pslver;
  wire [31:0] prdata;

  apb dut (.pclk(pclk),.prst(prst),.paddr(paddr),.psel(psel),.penable(penable), .pwrite(pwrite),
    .pwdata(pwdata),
    .pready(pready),
    .pslver(pslver),
    .prdata(prdata)
  );

  initial pclk = 0;
  always #5 pclk = ~pclk;


  initial begin
    
    
    prst    = 0;
    psel    = 0;
    penable = 0;
    pwrite  = 0;
    paddr   = 0;
    pwdata  = 0;

    #20;
     prst=1;
    #10 prst=0;
    
    @(posedge pclk);//write
      psel=1;
      pwrite=1;
      pwdata=32'h50;
      paddr=8'd10;
    
    @(posedge pclk);
    penable=1;

    $display("ADDRS = %0d | WRITE DATA = %0d",paddr,pwdata);
    
    
    @(posedge pclk);//write
    psel=1;
    pwrite=1;
    paddr=8'd20;
    pwdata=32'd100;
    
    @(posedge pclk);
    penable=1;
    
    @(posedge pclk);
    psel=0;
    penable=0;
    $display("ADDRS = %0d | WRITE DATA = %0d",paddr,pwdata);    
    @(posedge pclk);//read
    psel=1;
    penable=0;
    pwrite=0;
    paddr=8'd10;
    
        @(posedge pclk);
    penable=1;
    
    @(posedge pclk);
    psel=0;
    penable=0;
    $display("ADDRS = %0d | READ DATA = %0d",paddr,prdata);    
    
    @(posedge pclk);//read
    psel=1;
    pwrite=0;
    penable=0;
    paddr=8'd20;
    
        @(posedge pclk);
    penable=1;
    
    @(posedge pclk);
    psel=0;
    penable=0;
    $display("ADDRS = %0d | READ DATA = %0d",paddr,prdata);
    #30
    $finish;
  end
  
      
      
    
 



  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

endmodule
