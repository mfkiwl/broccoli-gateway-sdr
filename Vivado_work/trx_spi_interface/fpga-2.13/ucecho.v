/*%
   ucecho -- Uppercase conversion example using the low speed interface of default firmware
   Copyright (C) 2009-2017 ZTEX GmbH.
   http://www.ztex.de

   Copyright and related rights are licensed under the Solderpad Hardware
   License, Version 0.51 (the "License"); you may not use this file except
   in compliance with the License. You may obtain a copy of the License at
   
       http://solderpad.org/licenses/SHL-0.51.
       
   Unless required by applicable law or agreed to in writing, software, hardware
   and materials distributed under this License is distributed on an "AS IS"
   BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
   implied. See the License for the specific language governing permissions
   and limitations under the License.
%*/

`define UC(x) ( (((x) >= 8'd97) && ((x)<=8'd122)) ? (x)-8'd32 : (x) )

module ucecho (
        // control signals
	input fxclk_in,
	input reset_in,
        // hardware pins
	input lsi_clk,
    input lsi_mosi,
    input  lsi_stop,
    output lsi_miso
    // spi peripheral Signals
    
//    output dev_mosi,
//    input  dev_miso,
//    output dev_ss,
//    output dev_sclk 
		
	);
    
    wire rstb,tx_end;  // active low reset
    wire [7:0] in_addr, out_addr;
    wire [7:0] in_data0, in_data1, in_data2, in_data3;
    wire in_strobe, out_strobe, fxclk;

    reg [23:0] TxData, RxData = 24'habc;
    reg [31:0] out_data;
    reg tx_start;
    reg [31:0] mem[255:0];
    
    BUFG fxclk_buf (
	.I(fxclk_in),
	.O(fxclk) 
    );
    
    ezusb_lsi lsi_inst (
        .clk(fxclk),
        .reset_in(reset_in),
        .reset(),
        .data_clk(lsi_clk),
        .miso(lsi_miso),
        .mosi(lsi_mosi),
        .stop(lsi_stop),
        .in_addr(in_addr),
        .in_data({in_data3, in_data2, in_data1, in_data0}),
        .in_strobe(in_strobe),
        .in_valid(),
        .out_addr(out_addr),
        .out_data(out_data),
        .out_strobe(out_strobe)
    );
    
    assign rstb = !reset_in;
    
    spi_controller spi_master( 
        .i_clk(fxclk),          
        .i_rstb(rstb),         
        .i_tx_start(tx_start),     
        .o_tx_end(tx_end),       
        .i_data_parallel(TxData),
        .o_data_parallel(),
        .o_sclk(),         
        .o_ss(),           
        .o_mosi(),         
        .i_miso()              
     
    );
    
    
    always @ (posedge fxclk)
    begin
	if ( in_strobe ) mem[in_addr]     <=  { (in_data3), (in_data2), (in_data1), (in_data0) };
	if ( tx_end    ) mem[7'b01100100] <=  RxData;
	if (in_strobe== 1 && in_addr == 7'b01100100) 
        begin
           TxData   <= { (in_data2), (in_data1), (in_data0) };
           tx_start <= 1'b1;
        end
    else
           tx_start <= 1'b0;
           
    if ( out_strobe ) out_data <= mem[out_addr];
    
    end

endmodule

