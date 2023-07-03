module cacheRAM (
       input        clka,
       input        ena,
       input[3:0]   wea,
       input[11:0]  addra,
       input[31:0]  dina,
       output[31:0] douta,
       //------------------
       input        clkb,
       input        enb,
       input[3:0]   web,
       input[11:0]  addrb,
       input[31:0]  dinb,
       output[31:0] doutb
    );

    //-------------------------------
    wire reseta_i1 = 1'b0;
    wire resetb_i1 = 1'b0;
    wire reseta_i2 = 1'b0;
    wire resetb_i2 = 1'b0;
    wire reseta_i3 = 1'b0;
    wire resetb_i3 = 1'b0;
    wire reseta_i4 = 1'b0;
    wire resetb_i4 = 1'b0;

    wire [7:0] dina_i1; 
    wire [7:0] dina_i2;
    wire [7:0] dina_i3;
    wire [7:0] dina_i4;

    wire [7:0] dinb_i1; 
    wire [7:0] dinb_i2;
    wire [7:0] dinb_i3;
    wire [7:0] dinb_i4;

    assign dina_i1 = dina[7:0];
    assign dina_i2 = dina[15:8];
    assign dina_i3 = dina[23:16];
    assign dina_i4 = dina[31:24];
    assign dinb_i1 = dinb[7:0];
    assign dinb_i2 = dinb[15:8];
    assign dinb_i3 = dinb[23:16];
    assign dinb_i4 = dinb[31:24];

    wire [7:0] douta_o1; 
    wire [7:0] douta_o2;
    wire [7:0] douta_o3;
    wire [7:0] douta_o4;

    wire [7:0] doutb_o1; 
    wire [7:0] doutb_o2;
    wire [7:0] doutb_o3;
    wire [7:0] doutb_o4;

    assign douta = {douta_o4, douta_o3, douta_o2, douta_o1};
    assign doutb = {doutb_o4, doutb_o3, doutb_o2, doutb_o1};

    //-------------------------------
    wire cea_i1; 
    wire ocea_i1;
    wire wrea_i1;
    assign cea_i1  =  ena;
    assign ocea_i1 =  ena;
    assign wrea_i1 =  wea[0];

    wire ceb_i1;
    wire oceb_i1;
    wire wreb_i1;
    assign ceb_i1  =  enb;
    assign oceb_i1 =  enb;
    assign wreb_i1 =  web[0];

    //-------------------------------
    wire cea_i2; 
    wire ocea_i2;
    wire wrea_i2;
    assign cea_i2  =  ena;
    assign ocea_i2 =  ena;
    assign wrea_i2 =  wea[1];

    wire ceb_i2;
    wire oceb_i2;
    wire wreb_i2;
    assign ceb_i2  =  enb;
    assign oceb_i2 =  enb;
    assign wreb_i2 =  web[1];

    //-------------------------------
    wire cea_i3; 
    wire ocea_i3;
    wire wrea_i3;
    assign cea_i3  =  ena;
    assign ocea_i3 =  ena;
    assign wrea_i3 =  wea[2];

    wire ceb_i3;
    wire oceb_i3;
    wire wreb_i3;
    assign ceb_i3  =  enb;
    assign oceb_i3 =  enb;
    assign wreb_i3 =  web[2];

    //-------------------------------
    wire cea_i4; 
    wire ocea_i4;
    wire wrea_i4;
    assign cea_i4  =  ena;
    assign ocea_i4 =  ena;
    assign wrea_i4 =  wea[3];

    wire ceb_i4;
    wire oceb_i4;
    wire wreb_i4;
    assign ceb_i4  =  enb;
    assign oceb_i4 =  enb;
    assign wreb_i4 =  web[3];

    Gowin_DPB12x8NibHH cache1 (
        .douta(douta_o1), //output [7:0] douta
        .doutb(doutb_o1), //output [7:0] doutb
        .clka(clka), //input clka
        .ocea(ocea_i1), //input ocea
        .cea(cea_i1), //input cea
        .reseta(reseta_i1), //input reseta
        .wrea(wrea_i1), //input wrea
        .clkb(clkb), //input clkb
        .oceb(oceb_i1), //input oceb
        .ceb(ceb_i1), //input ceb
        .resetb(resetb_i1), //input resetb
        .wreb(wreb_i1), //input wreb
        .ada(addra), //input [11:0] ada
        .dina(dina_i1), //input [7:0] dina
        .adb(addrb), //input [11:0] adb
        .dinb(dinb_i1) //input [7:0] dinb
    );

    Gowin_DPB12x8NibHL cache2 (
        .douta(douta_o2), //output [7:0] douta
        .doutb(doutb_o2), //output [7:0] doutb
        .clka(clka), //input clka
        .ocea(ocea_i2), //input ocea
        .cea(cea_i2), //input cea
        .reseta(reseta_i2), //input reseta
        .wrea(wrea_i2), //input wrea
        .clkb(clkb), //input clkb
        .oceb(oceb_i2), //input oceb
        .ceb(ceb_i2), //input ceb
        .resetb(resetb_i2), //input resetb
        .wreb(wreb_i2), //input wreb
        .ada(addra), //input [11:0] ada
        .dina(dina_i2), //input [7:0] dina
        .adb(addrb), //input [11:0] adb
        .dinb(dinb_i2) //input [7:0] dinb
    );

    Gowin_DPB12x8NibLH cache3 (
        .douta(douta_o3), //output [7:0] douta
        .doutb(doutb_o3), //output [7:0] doutb
        .clka(clka), //input clka
        .ocea(ocea_i3), //input ocea
        .cea(cea_i3), //input cea
        .reseta(reseta_i3), //input reseta
        .wrea(wrea_i3), //input wrea
        .clkb(clkb), //input clkb
        .oceb(oceb_i3), //input oceb
        .ceb(ceb_i3), //input ceb
        .resetb(resetb_i3), //input resetb
        .wreb(wreb_i3), //input wreb
        .ada(addra), //input [11:0] ada
        .dina(dina_i3), //input [7:0] dina
        .adb(addrb), //input [11:0] adb
        .dinb(dinb_i3) //input [7:0] dinb
    );

    Gowin_DPB12x8NibLL cache4 (
        .douta(douta_o4), //output [7:0] douta
        .doutb(doutb_o4), //output [7:0] doutb
        .clka(clka), //input clka
        .ocea(ocea_i4), //input ocea
        .cea(cea_i4), //input cea
        .reseta(reseta_i4), //input reseta
        .wrea(wrea_i4), //input wrea
        .clkb(clkb), //input clkb
        .oceb(oceb_i4), //input oceb
        .ceb(ceb_i4), //input ceb
        .resetb(resetb_i4), //input resetb
        .wreb(wreb_i4), //input wreb
        .ada(addra), //input [11:0] ada
        .dina(dina_i4), //input [7:0] dina
        .adb(addrb), //input [11:0] adb
        .dinb(dinb_i4) //input [7:0] dinb
    );

endmodule
