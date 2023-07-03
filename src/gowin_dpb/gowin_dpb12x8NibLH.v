//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//GOWIN Version: V1.9.9 Beta-1
//Part Number: GW2AR-LV18QN88C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Wed Jun 28 22:42:39 2023

module Gowin_DPB12x8NibLH (douta, doutb, clka, ocea, cea, reseta, wrea, clkb, oceb, ceb, resetb, wreb, ada, dina, adb, dinb);

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
defparam dpb_inst_0.INIT_RAM_00 = 256'h2C3403900B0A36A0A157B4E3A180980D0C0AAE04E5E2008120BAAA162000308C;
defparam dpb_inst_0.INIT_RAM_01 = 256'hFB1C8AE48C48DF18E588B51EEE1FAA81F42E243FFA2250F3022FA8BE0009C082;
defparam dpb_inst_0.INIT_RAM_02 = 256'h00000000000000000000000000000000A0090A80E9A60282EE12403EE2FF1876;
defparam dpb_inst_0.INIT_RAM_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

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
defparam dpb_inst_1.INIT_RAM_00 = 256'h7E0B0EB008FE34208070B8F320CCBB000020BEC736300C505020E30E3BBB3DDF;
defparam dpb_inst_1.INIT_RAM_01 = 256'hF8BFE0F75F0EEF7EF75E279BFF0F0BE4FB0FDE8FED5CF8F30EEFFEFEB44EDCE0;
defparam dpb_inst_1.INIT_RAM_02 = 256'h0000000000000000000000000000000070060A4022367323666472466764CEE8;
defparam dpb_inst_1.INIT_RAM_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

endmodule //Gowin_DPB12x8NibLH
