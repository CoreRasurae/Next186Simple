//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-1
//Part Number: GW2AR-LV18QN88C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Wed Jun 28 22:43:12 2023

module Gowin_DPB12x8NibLL (douta, doutb, clka, ocea, cea, reseta, wrea, clkb, oceb, ceb, resetb, wreb, ada, dina, adb, dinb);

output [7:0] douta;
output [7:0] doutb;
input clka;
input ocea;
input cea;
input reseta;
input wrea;
input clkb;
input oceb;
input ceb;
input resetb;
input wreb;
input [11:0] ada;
input [7:0] dina;
input [11:0] adb;
input [7:0] dinb;

wire [11:0] dpb_inst_0_douta_w;
wire [11:0] dpb_inst_0_doutb_w;
wire [11:0] dpb_inst_1_douta_w;
wire [11:0] dpb_inst_1_doutb_w;
wire gw_gnd;

assign gw_gnd = 1'b0;

DPB dpb_inst_0 (
    .DOA({dpb_inst_0_douta_w[11:0],douta[3:0]}),
    .DOB({dpb_inst_0_doutb_w[11:0],doutb[3:0]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,gw_gnd}),
    .BLKSELB({gw_gnd,gw_gnd,gw_gnd}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[3:0]})
);

defparam dpb_inst_0.READ_MODE0 = 1'b0;
defparam dpb_inst_0.READ_MODE1 = 1'b0;
defparam dpb_inst_0.WRITE_MODE0 = 2'b00;
defparam dpb_inst_0.WRITE_MODE1 = 2'b00;
defparam dpb_inst_0.BIT_WIDTH_0 = 4;
defparam dpb_inst_0.BIT_WIDTH_1 = 4;
defparam dpb_inst_0.BLK_SEL_0 = 3'b000;
defparam dpb_inst_0.BLK_SEL_1 = 3'b000;
defparam dpb_inst_0.RESET_MODE = "SYNC";
defparam dpb_inst_0.INIT_RAM_00 = 256'h2AAFAF6F7C04748F000AACFE01A3F0000000E0A81E1023AD0A0014303FB0CEEA;
defparam dpb_inst_0.INIT_RAM_01 = 256'h11109FB8FB1E41EF7A8C4C85FF4B93FFF85C8AF51A1A457F687B2C3134410C00;
defparam dpb_inst_0.INIT_RAM_02 = 256'h00000000000000000000000000000000F00F0150E0002503F97B344F50E9BFB6;
defparam dpb_inst_0.INIT_RAM_03 = 256'h000A000000000000000000000000000000000000000000000000000000000000;

DPB dpb_inst_1 (
    .DOA({dpb_inst_1_douta_w[11:0],douta[7:4]}),
    .DOB({dpb_inst_1_doutb_w[11:0],doutb[7:4]}),
    .CLKA(clka),
    .OCEA(ocea),
    .CEA(cea),
    .RESETA(reseta),
    .WREA(wrea),
    .CLKB(clkb),
    .OCEB(oceb),
    .CEB(ceb),
    .RESETB(resetb),
    .WREB(wreb),
    .BLKSELA({gw_gnd,gw_gnd,gw_gnd}),
    .BLKSELB({gw_gnd,gw_gnd,gw_gnd}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DIA({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dina[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd}),
    .DIB({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,dinb[7:4]})
);

defparam dpb_inst_1.READ_MODE0 = 1'b0;
defparam dpb_inst_1.READ_MODE1 = 1'b0;
defparam dpb_inst_1.WRITE_MODE0 = 2'b00;
defparam dpb_inst_1.WRITE_MODE1 = 2'b00;
defparam dpb_inst_1.BIT_WIDTH_0 = 4;
defparam dpb_inst_1.BIT_WIDTH_1 = 4;
defparam dpb_inst_1.BLK_SEL_0 = 3'b000;
defparam dpb_inst_1.BLK_SEL_1 = 3'b000;
defparam dpb_inst_1.RESET_MODE = "SYNC";
defparam dpb_inst_1.INIT_RAM_00 = 256'h0FDFEFFB0F0DF2E20048FA0EB0B3F0BBBBBBE1B78480D8505D0EC7644888F88F;
defparam dpb_inst_1.INIT_RAM_01 = 256'h3E181F65F8BF77BF7A5F0CE6F5B8BCEF9EBFE0F00B5870DF0E4EEA70CEE8DE44;
defparam dpb_inst_1.INIT_RAM_02 = 256'h00000000000000000000000000000000F00F0090233263256674764667648E8F;
defparam dpb_inst_1.INIT_RAM_03 = 256'h00FE000000000000000000000000000000000000000000000000000000000000;

endmodule //Gowin_DPB12x8NibLL
