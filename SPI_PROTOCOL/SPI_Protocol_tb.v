`timescale 1ns / 1ps

module protocol_spi_tb;

    reg clk;
    reg rst;
    reg ss;
    reg start;
    reg [7:0] data_in;
    reg miso;

    wire mosi;
    wire sclk;
    wire [7:0] data_out;
    wire done;
    wire [7:0] shift_in;
    wire [7:0] shift_out;

    protocol_spi uut (
        .clk(clk),
        .rst(rst),
        .ss(ss),
        .start(start),
        .data_in(data_in),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .data_out(data_out),
        .done(done),
        .shift_in(shift_in), 
        .shift_out(shift_out) );

    initial clk = 0;
    always #10 clk = ~clk;

reg [7:0] slave_shift;

always @(posedge rst or negedge sclk) begin
    if (rst) begin
        slave_shift <= 8'b11001010; 
        miso <= 0;
    end else if (!ss) begin
        miso <= slave_shift[7]; 
        slave_shift <= {slave_shift[6:0], miso}; 
    end else begin
        slave_shift <= 8'b11001010;
        miso <= 0;
    end
end


    initial begin
        rst = 1; 
        ss = 1;          
        start = 0;
        data_in = 8'b10101101;

        #150 rst = 0;
        #200 ss = 0;
         start = 1;
        #100 start = 1;
        wait (done);
        #20;
        #40 ss = 1;
        
         #100000 $finish;
    end

endmodule
