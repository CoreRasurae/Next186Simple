//Copyright (C)2014-2023 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.9 Beta-1
//Part Number: GW2AR-LV18QN88C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Wed Jun 28 22:41:24 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_DPB12x8NibHH your_instance_name(
        .douta(douta_o), //output [7:0] douta
        .doutb(doutb_o), //output [7:0] doutb
        .clka(clka_i), //input clka
        .ocea(ocea_i), //input ocea
        .cea(cea_i), //input cea
        .reseta(reseta_i), //input reseta
        .wrea(wrea_i), //input wrea
        .clkb(clkb_i), //input clkb
        .oceb(oceb_i), //input oceb
        .ceb(ceb_i), //input ceb
        .resetb(resetb_i), //input resetb
        .wreb(wreb_i), //input wreb
        .ada(ada_i), //input [11:0] ada
        .dina(dina_i), //input [7:0] dina
        .adb(adb_i), //input [11:0] adb
        .dinb(dinb_i) //input [7:0] dinb
    );

//--------Copy end-------------------
