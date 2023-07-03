`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:31 11/20/2014 
// Design Name: 
// Module Name:    PapilioProMain 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Nano20k_top
	(
		input CLK_27M,        

        // HDMI
	    output       tmds_clk_n,
	    output       tmds_clk_p,
	    output [2:0] tmds_d_n,
	    output [2:0] tmds_d_p,

        //SDRAM
        output O_sdram_clk,
        output O_sdram_cke,
        output O_sdram_cas_n,           // columns address select
        output O_sdram_ras_n,           // row address select
		output O_sdram_cs_n,            // chip select
		output O_sdram_wen_n,           // write enable
		output  [1:0] O_sdram_ba,        // four banks
		output [10:0] O_sdram_addr,     // 11 bit multiplexed address bus
		inout  [31:0] IO_sdram_dq,       // 32 bit bidirectional data bus
		output  [3:0] O_sdram_dqm,       // 32/4

        //RS232
		input UART_RXD,
		output UART_TXD,
		//input RX_EXT,
		//output TX_EXT,

        //AUDIOtwo
		//output AUDIO_L,
		//output AUDIO_R,

        //PS/2
		inout PS2CLKA,
		inout PS2DATA,
		inout PS2CLKB,
		inout PS2DATB,

        //uSD
		output SD_nCS,
		output SD_DI,
		output SD_CK,
		input  SD_DO,

        //I/O
		//inout [3:0]GPIO

        //Buttons
		input BTN_RES,
		//input BTN_WEST,

        //LEDs
		 //output [5:0] EXOUT,
		//output [7:0] SEG,
		//output [3:0] DIG,
		//output [7:0]LED
        output [4:0]LED
	);

	assign O_sdram_cke = 1'b1;

    wire AUDIO_L;
    wire AUDIO_R;
    wire RX_EXT;
    wire TX_EXT;
    wire [7:0] SEG;
    wire [3:0] DIG;
    wire [7:0] GPIO;

   /*ODDR2 #(
      .DDR_ALIGNMENT("NONE"), // Sets output alignment to "NONE", "C0" or "C1" 
      .INIT(1'b0),    // Sets initial state of the Q output to 1'b0 or 1'b1
      .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC" set/reset
   ) ODDR2_inst 
	(
      .Q(O_sdram_clk), // 1-bit DDR output data
      .C0(SDR_CLK),  // 1-bit clock input
      .C1(!SDR_CLK), // 1-bit clock input
      .CE(1'b1), 		// 1-bit clock enable input
      .D0(1'b1), 		// 1-bit data input (associated with C0)
      .D1(1'b0), 		// 1-bit data input (associated with C1)
      .R(1'b0),   	// 1-bit reset input
      .S(1'b0)    	// 1-bit set input
   );*/

   wire SDRAM_DQMH;
   wire SDRAM_DQML;

   assign O_sdram_dqm[1] = SDRAM_DQMH;
   assign O_sdram_dqm[0] = SDRAM_DQML;
   assign O_sdram_dqm[3:2] = 2'b11; 

   wire [5:0] VGA_R6, VGA_G6, VGA_B6;
   wire vdma_tvalid;
   wire vdma_tready;
   wire [24-1:0] vdma_tdata;	// SVO_BITS_PER_PIXEL = 24
   wire [0:0] vdma_tuser;
   wire [3:0] enc_tuser;
   wire hsync_ns,vsync_ns;
   wire hblnk;

   wire pll_lock;
   wire breset = BTN_RES;
   wire resetn = 1'b1;
   wire clk_pixel = clk_p;
   wire clk_p;
   wire clk_p5;

   // Adjust Hsync & Vsync Position
   assign hsync_n = hsync_ns;
   //assign vsync_n = vsync_ns;
   reg vsync_n; 

   reg hblnk_n;

   svo_hdmi_out u_hdmi (
	  //.clk(clk_p),
	  .resetn(~breset),//(sys_resetn),
	  // video clocks
	  .clk_pixel(clk_p),
	  .clk_5x_pixel(clk_p5),
	  .locked(pll_lock),
 	  // input VGA
	  .rout(VGA_R6),
	  .gout(VGA_G6),
	  .bout(VGA_B6),
	  .hsync_n(hsync_n),
	  .vsync_n(vsync_n),
	  .hblnk_n(hblnk_n),
	  // output signals
	  .tmds_clk_n(tmds_clk_n),
	  .tmds_clk_p(tmds_clk_p),
	  .tmds_d_n(tmds_d_n),
	  .tmds_d_p(tmds_d_p),
	  .tmds_ts()
   );

	wire hblnk_ns;
	reg hblnk_nsd, hsync_nsd;
	reg [5:0] hblnk_dct;
	reg [15:0] hblnk_sft;
	always @ (posedge clk_pixel) begin
		//hblnk_sft <= { hblnk_sft[14:0], hblnk_ns};
		//hblnk_n <= hblnk_sft[15];
		hblnk_nsd <= hblnk_ns;
		if(hblnk_ns!=hblnk_nsd) hblnk_dct <= 18;
		else begin
			if(hblnk_dct==1) begin
				hblnk_n <= hblnk_ns;
			end
			hblnk_dct <= hblnk_dct - 1;
		end
		//
		hsync_nsd <= hsync_ns;
		if(hsync_ns && ~hsync_nsd) vsync_n <= vsync_ns;
	end

	reg [7:0] pixel_div;
	always @ (posedge clk_pixel) pixel_div <= pixel_div + 1;

    wire [7:0]LEDs;

    assign LED[4:2]={1'b1,1'b1,1'b0};
    assign LED[0] = LEDs[0];
    assign LED[1] = LEDs[1];

	system sys_inst
	(
		.CLK_27MHZ(CLK_27M),
        .CLK_125M_P5(clk_p5),
        .CLK_25M_P(clk_p),
        .LOCKED(pll_lock),
		.VGA_R(VGA_R6),
		.VGA_G(VGA_G6),
		.VGA_B(VGA_B6),
		.VGA_HSYNC(hsync_ns),
		.VGA_VSYNC(vsync_ns),
        .VGA_HBLNK(hblnk_ns),
		.sdr_CLK_out(O_sdram_clk), //SDR_CLK
		.sdr_n_CS_WE_RAS_CAS({O_sdram_cs_n, O_sdram_wen_n, O_sdram_ras_n, O_sdram_cas_n}),
		.sdr_BA(O_sdram_ba),
		.sdr_ADDR(O_sdram_addr),
		.sdr_DATA(IO_sdram_dq[15:0]),
		.sdr_DQM({SDRAM_DQMH, SDRAM_DQML}),
		.LED(LEDs),
		.BTN_RESET(BTN_RES),
		.BTN_NMI(1'b0), // (BTN_WEST),
		.RS232_DCE_RXD(UART_RXD),
		.RS232_DCE_TXD(UART_TXD),
		.SD_n_CS(SD_nCS),
		.SD_DI(SD_DI),
		.SD_CK(SD_CK),
		.SD_DO(SD_DO),
		.AUD_L(AUDIO_L),
		.AUD_R(AUDIO_R),
	 	.PS2_CLK1(PS2CLKA),
		.PS2_CLK2(PS2CLKB),
		.PS2_DATA1(PS2DATA),
		.PS2_DATA2(PS2DATB),
		.RS232_EXT_RXD(RX_EXT),
		.RS232_EXT_TXD(TX_EXT),
		.RS232_HOST_RXD(),
		.RS232_HOST_TXD(),
		.RS232_HOST_RST(),
		.SEG(SEG),
		.DIG(DIG),
		.GPIO(GPIO)
	);

endmodule
