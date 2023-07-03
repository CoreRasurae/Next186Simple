//////////////////////////////////////////////////////////////////////////////////
//
// This file is part of the Next186 Soc PC project
// http://opencores.org/project,next186
//
// Filename: cache_controller.v
// Description: Part of the Next186 SoC PC project, cache controller
// Version 1.0
// Creation date: Jan2012
//
// Author: Nicolae Dumitrache 
// e-mail: ndumitrache@opencores.org
//
/////////////////////////////////////////////////////////////////////////////////
// 
// Copyright (C) 2012 Nicolae Dumitrache
// 
// This source file may be used and distributed without 
// restriction provided that this copyright statement is not 
// removed from the file and that any derivative work contains 
// the original copyright notice and the associated disclaimer.
// 
// This source file is free software; you can redistribute it 
// and/or modify it under the terms of the GNU Lesser General 
// Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any 
// later version. 
// 
// This source is distributed in the hope that it will be 
// useful, but WITHOUT ANY WARRANTY; without even the implied 
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
// PURPOSE. See the GNU Lesser General Public License for more 
// details. 
// 
// You should have received a copy of the GNU Lesser General 
// Public License along with this source; if not, download it 
// from http://www.opencores.org/lgpl.shtml 
// 
///////////////////////////////////////////////////////////////////////////////////
// Additional Comments: 
//
// preloaded with bootstrap code
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`define WAYS	2	// 2^ways
`define SETS	6	// 2^sets
`define LINE	6	// 2^LINE bytes / cache line
`define ADDR	21

module cache_controller (
	 input [`ADDR-1:0]addr,
     output [31:0]dout,
	 input [31:0]din,
	 input clk,	
	 input mreq,
	 input [3:0]wmask,
	 output reg ce,	// clock enable for CPU
	 input [15:0]ddr_din,
	 output reg[15:0]ddr_dout,
	 input ddr_clk,
	 input ddr_clkw,
	 input cache_write_data, // 1 when data must be written to cache, on posedge ddr_clk
	 input cache_read_data, // 1 when data must be read from cache, on posedge ddr_clk
	 output reg ddr_rd,
	 output reg ddr_wr,
	 output reg [`ADDR-`LINE-1:0]hiaddr,
	 input flush
    );
	
	initial ce = 1'b1;
    initial ddr_rd = 1'b0;
    initial ddr_wr = 1'b0;
	
	reg [`ADDR-1:0]raddr;
	reg [31:0]rdin;
	reg [3:0]rwmask;
	reg rmreq;
	wire [`ADDR-1:0]maddr = ce ? addr : raddr;
	wire [31:0]mdin = ce ? din : rdin;
	wire [3:0]mwmask = ce ? wmask : rwmask;
	wire mmreq = ce ? mreq : rmreq;
	
	reg flushreq = 1'b0;
	reg [`WAYS+`SETS:0]flushcount = 0;
	wire r_flush = flushcount[`WAYS+`SETS];
	wire [`SETS-1:0]index = r_flush ? flushcount[`SETS-1:0] : maddr[`LINE+`SETS-1:`LINE];
	wire [(1<<`WAYS)-1:0]fit;
	wire [(1<<`WAYS)-1:0]free;   

	reg [(1<<`WAYS)-1:0]cache_dirty[0:(1<<`SETS)-1];
    initial $readmemh("cache_dirty.mem", cache_dirty);

	reg [`WAYS-1:0]cache_lru[0:(1<<`WAYS)-1][0:(1<<`SETS)-1];
    initial begin
        cache_lru[0][0] = 2'h0;
        cache_lru[1][0] = 2'h1;
        cache_lru[2][0] = 2'h2;
        cache_lru[3][0] = 2'h3;

        cache_lru[0][1] = 2'h0;
        cache_lru[1][1] = 2'h1;
        cache_lru[2][1] = 2'h2;
        cache_lru[3][1] = 2'h3;

        cache_lru[0][2] = 2'h0;
        cache_lru[1][2] = 2'h1;
        cache_lru[2][2] = 2'h2;
        cache_lru[3][2] = 2'h3;

        cache_lru[0][3] = 2'h0;
        cache_lru[1][3] = 2'h1;
        cache_lru[2][3] = 2'h2;
        cache_lru[3][3] = 2'h3;

        cache_lru[0][4] = 2'h0;
        cache_lru[1][4] = 2'h1;
        cache_lru[2][4] = 2'h2;
        cache_lru[3][4] = 2'h3;

        cache_lru[0][5] = 2'h0;
        cache_lru[1][5] = 2'h1;
        cache_lru[2][5] = 2'h2;
        cache_lru[3][5] = 2'h3;

        cache_lru[0][6] = 2'h0;
        cache_lru[1][6] = 2'h1;
        cache_lru[2][6] = 2'h2;
        cache_lru[3][6] = 2'h3;

        cache_lru[0][7] = 2'h0;
        cache_lru[1][7] = 2'h1;
        cache_lru[2][7] = 2'h2;
        cache_lru[3][7] = 2'h3;

        cache_lru[0][8] = 2'h0;
        cache_lru[1][8] = 2'h1;
        cache_lru[2][8] = 2'h2;
        cache_lru[3][8] = 2'h3;

        cache_lru[0][9] = 2'h0;
        cache_lru[1][9] = 2'h1;
        cache_lru[2][9] = 2'h2;
        cache_lru[3][9] = 2'h3;

        cache_lru[0][10] = 2'h0;
        cache_lru[1][10] = 2'h1;
        cache_lru[2][10] = 2'h2;
        cache_lru[3][10] = 2'h3;

        cache_lru[0][11] = 2'h0;
        cache_lru[1][11] = 2'h1;
        cache_lru[2][11] = 2'h2;
        cache_lru[3][11] = 2'h3;

        cache_lru[0][12] = 2'h0;
        cache_lru[1][12] = 2'h1;
        cache_lru[2][12] = 2'h2;
        cache_lru[3][12] = 2'h3;

        cache_lru[0][13] = 2'h0;
        cache_lru[1][13] = 2'h1;
        cache_lru[2][13] = 2'h2;
        cache_lru[3][13] = 2'h3;

        cache_lru[0][14] = 2'h0;
        cache_lru[1][14] = 2'h1;
        cache_lru[2][14] = 2'h2;
        cache_lru[3][14] = 2'h3;

        cache_lru[0][15] = 2'h0;
        cache_lru[1][15] = 2'h1;
        cache_lru[2][15] = 2'h2;
        cache_lru[3][15] = 2'h3;

        cache_lru[0][16] = 2'h0;
        cache_lru[1][16] = 2'h1;
        cache_lru[2][16] = 2'h2;
        cache_lru[3][16] = 2'h3;

        cache_lru[0][17] = 2'h0;
        cache_lru[1][17] = 2'h1;
        cache_lru[2][17] = 2'h2;
        cache_lru[3][17] = 2'h3;

        cache_lru[0][18] = 2'h0;
        cache_lru[1][18] = 2'h1;
        cache_lru[2][18] = 2'h2;
        cache_lru[3][18] = 2'h3;

        cache_lru[0][19] = 2'h0;
        cache_lru[1][19] = 2'h1;
        cache_lru[2][19] = 2'h2;
        cache_lru[3][19] = 2'h3;

        cache_lru[0][20] = 2'h0;
        cache_lru[1][20] = 2'h1;
        cache_lru[2][20] = 2'h2;
        cache_lru[3][20] = 2'h3;

        cache_lru[0][21] = 2'h0;
        cache_lru[1][21] = 2'h1;
        cache_lru[2][21] = 2'h2;
        cache_lru[3][21] = 2'h3;

        cache_lru[0][22] = 2'h0;
        cache_lru[1][22] = 2'h1;
        cache_lru[2][22] = 2'h2;
        cache_lru[3][22] = 2'h3;

        cache_lru[0][23] = 2'h0;
        cache_lru[1][23] = 2'h1;
        cache_lru[2][23] = 2'h2;
        cache_lru[3][23] = 2'h3;

        cache_lru[0][24] = 2'h0;
        cache_lru[1][24] = 2'h1;
        cache_lru[2][24] = 2'h2;
        cache_lru[3][24] = 2'h3;

        cache_lru[0][25] = 2'h0;
        cache_lru[1][25] = 2'h1;
        cache_lru[2][25] = 2'h2;
        cache_lru[3][25] = 2'h3;

        cache_lru[0][26] = 2'h0;
        cache_lru[1][26] = 2'h1;
        cache_lru[2][26] = 2'h2;
        cache_lru[3][26] = 2'h3;

        cache_lru[0][27] = 2'h0;
        cache_lru[1][27] = 2'h1;
        cache_lru[2][27] = 2'h2;
        cache_lru[3][27] = 2'h3;

        cache_lru[0][28] = 2'h0;
        cache_lru[1][28] = 2'h1;
        cache_lru[2][28] = 2'h2;
        cache_lru[3][28] = 2'h3;

        cache_lru[0][29] = 2'h0;
        cache_lru[1][29] = 2'h1;
        cache_lru[2][29] = 2'h2;
        cache_lru[3][29] = 2'h3;

        cache_lru[0][30] = 2'h0;
        cache_lru[1][30] = 2'h1;
        cache_lru[2][30] = 2'h2;
        cache_lru[3][30] = 2'h3;

        cache_lru[0][31] = 2'h0;
        cache_lru[1][31] = 2'h1;
        cache_lru[2][31] = 2'h2;
        cache_lru[3][31] = 2'h3;

        cache_lru[0][32] = 2'h0;
        cache_lru[1][32] = 2'h1;
        cache_lru[2][32] = 2'h2;
        cache_lru[3][32] = 2'h3;

        cache_lru[0][33] = 2'h0;
        cache_lru[1][33] = 2'h1;
        cache_lru[2][33] = 2'h2;
        cache_lru[3][33] = 2'h3;

        cache_lru[0][34] = 2'h0;
        cache_lru[1][34] = 2'h1;
        cache_lru[2][34] = 2'h2;
        cache_lru[3][34] = 2'h3;

        cache_lru[0][35] = 2'h0;
        cache_lru[1][35] = 2'h1;
        cache_lru[2][35] = 2'h2;
        cache_lru[3][35] = 2'h3;

        cache_lru[0][36] = 2'h0;
        cache_lru[1][36] = 2'h1;
        cache_lru[2][36] = 2'h2;
        cache_lru[3][36] = 2'h3;

        cache_lru[0][37] = 2'h0;
        cache_lru[1][37] = 2'h1;
        cache_lru[2][37] = 2'h2;
        cache_lru[3][37] = 2'h3;

        cache_lru[0][38] = 2'h0;
        cache_lru[1][38] = 2'h1;
        cache_lru[2][38] = 2'h2;
        cache_lru[3][38] = 2'h3;

        cache_lru[0][39] = 2'h0;
        cache_lru[1][39] = 2'h1;
        cache_lru[2][39] = 2'h2;
        cache_lru[3][39] = 2'h3;

        cache_lru[0][40] = 2'h0;
        cache_lru[1][40] = 2'h1;
        cache_lru[2][40] = 2'h2;
        cache_lru[3][40] = 2'h3;

        cache_lru[0][41] = 2'h0;
        cache_lru[1][41] = 2'h1;
        cache_lru[2][41] = 2'h2;
        cache_lru[3][41] = 2'h3;

        cache_lru[0][42] = 2'h0;
        cache_lru[1][42] = 2'h1;
        cache_lru[2][42] = 2'h2;
        cache_lru[3][42] = 2'h3;

        cache_lru[0][43] = 2'h0;
        cache_lru[1][43] = 2'h1;
        cache_lru[2][43] = 2'h2;
        cache_lru[3][43] = 2'h3;

        cache_lru[0][44] = 2'h0;
        cache_lru[1][44] = 2'h1;
        cache_lru[2][44] = 2'h2;
        cache_lru[3][44] = 2'h3;

        cache_lru[0][45] = 2'h0;
        cache_lru[1][45] = 2'h1;
        cache_lru[2][45] = 2'h2;
        cache_lru[3][45] = 2'h3;

        cache_lru[0][46] = 2'h0;
        cache_lru[1][46] = 2'h1;
        cache_lru[2][46] = 2'h2;
        cache_lru[3][46] = 2'h3;

        cache_lru[0][47] = 2'h0;
        cache_lru[1][47] = 2'h1;
        cache_lru[2][47] = 2'h2;
        cache_lru[3][47] = 2'h3;

        cache_lru[0][48] = 2'h0;
        cache_lru[1][48] = 2'h1;
        cache_lru[2][48] = 2'h2;
        cache_lru[3][48] = 2'h3;

        cache_lru[0][49] = 2'h0;
        cache_lru[1][49] = 2'h1;
        cache_lru[2][49] = 2'h2;
        cache_lru[3][49] = 2'h3;

        cache_lru[0][50] = 2'h0;
        cache_lru[1][50] = 2'h1;
        cache_lru[2][50] = 2'h2;
        cache_lru[3][50] = 2'h3;

        cache_lru[0][51] = 2'h0;
        cache_lru[1][51] = 2'h1;
        cache_lru[2][51] = 2'h2;
        cache_lru[3][51] = 2'h3;

        cache_lru[0][52] = 2'h0;
        cache_lru[1][52] = 2'h1;
        cache_lru[2][52] = 2'h2;
        cache_lru[3][52] = 2'h3;

        cache_lru[0][53] = 2'h0;
        cache_lru[1][53] = 2'h1;
        cache_lru[2][53] = 2'h2;
        cache_lru[3][53] = 2'h3;

        cache_lru[0][54] = 2'h0;
        cache_lru[1][54] = 2'h1;
        cache_lru[2][54] = 2'h2;
        cache_lru[3][54] = 2'h3;

        cache_lru[0][55] = 2'h0;
        cache_lru[1][55] = 2'h1;
        cache_lru[2][55] = 2'h2;
        cache_lru[3][55] = 2'h3;

        cache_lru[0][56] = 2'h0;
        cache_lru[1][56] = 2'h1;
        cache_lru[2][56] = 2'h2;
        cache_lru[3][56] = 2'h3;

        cache_lru[0][57] = 2'h0;
        cache_lru[1][57] = 2'h1;
        cache_lru[2][57] = 2'h2;
        cache_lru[3][57] = 2'h3;

        cache_lru[0][58] = 2'h0;
        cache_lru[1][58] = 2'h1;
        cache_lru[2][58] = 2'h2;
        cache_lru[3][58] = 2'h3;

        cache_lru[0][59] = 2'h0;
        cache_lru[1][59] = 2'h1;
        cache_lru[2][59] = 2'h2;
        cache_lru[3][59] = 2'h3;

        cache_lru[0][60] = 2'h0;
        cache_lru[1][60] = 2'h1;
        cache_lru[2][60] = 2'h2;
        cache_lru[3][60] = 2'h3;

        cache_lru[0][61] = 2'h0;
        cache_lru[1][61] = 2'h1;
        cache_lru[2][61] = 2'h2;
        cache_lru[3][61] = 2'h3;

        cache_lru[0][62] = 2'h0;
        cache_lru[1][62] = 2'h1;
        cache_lru[2][62] = 2'h2;
        cache_lru[3][62] = 2'h3;

        cache_lru[0][63] = 2'h0;
        cache_lru[1][63] = 2'h1;
        cache_lru[2][63] = 2'h2;
        cache_lru[3][63] = 2'h3;
    end

	reg [`ADDR-`SETS-`LINE-1:0]cache_addr[0:(1<<`WAYS)-1][0:(1<<`SETS)-1];
    initial begin
        cache_addr[0][0] = 9'h000;
        cache_addr[1][0] = 9'h001;
        cache_addr[2][0] = 9'h002;
        cache_addr[3][0] = 9'h003;

        cache_addr[0][1] = 9'h000;
        cache_addr[1][1] = 9'h001;
        cache_addr[2][1] = 9'h002;
        cache_addr[3][1] = 9'h003;

        cache_addr[0][2] = 9'h000;
        cache_addr[1][2] = 9'h001;
        cache_addr[2][2] = 9'h002;
        cache_addr[3][2] = 9'h003;

        cache_addr[0][3] = 9'h000;
        cache_addr[1][3] = 9'h001;
        cache_addr[2][3] = 9'h002;
        cache_addr[3][3] = 9'h003;

        cache_addr[0][4] = 9'h000;
        cache_addr[1][4] = 9'h001;
        cache_addr[2][4] = 9'h002;
        cache_addr[3][4] = 9'h003;

        cache_addr[0][5] = 9'h000;
        cache_addr[1][5] = 9'h001;
        cache_addr[2][5] = 9'h002;
        cache_addr[3][5] = 9'h003;

        cache_addr[0][6] = 9'h000;
        cache_addr[1][6] = 9'h001;
        cache_addr[2][6] = 9'h002;
        cache_addr[3][6] = 9'h003;

        cache_addr[0][7] = 9'h000;
        cache_addr[1][7] = 9'h001;
        cache_addr[2][7] = 9'h002;
        cache_addr[3][7] = 9'h003;

        cache_addr[0][8] = 9'h000;
        cache_addr[1][8] = 9'h001;
        cache_addr[2][8] = 9'h002;
        cache_addr[3][8] = 9'h003;

        cache_addr[0][9] = 9'h000;
        cache_addr[1][9] = 9'h001;
        cache_addr[2][9] = 9'h002;
        cache_addr[3][9] = 9'h003;

        cache_addr[0][10] = 9'h000;
        cache_addr[1][10] = 9'h001;
        cache_addr[2][10] = 9'h002;
        cache_addr[3][10] = 9'h003;

        cache_addr[0][11] = 9'h000;
        cache_addr[1][11] = 9'h001;
        cache_addr[2][11] = 9'h002;
        cache_addr[3][11] = 9'h003;

        cache_addr[0][12] = 9'h000;
        cache_addr[1][12] = 9'h001;
        cache_addr[2][12] = 9'h002;
        cache_addr[3][12] = 9'h003;

        cache_addr[0][13] = 9'h000;
        cache_addr[1][13] = 9'h001;
        cache_addr[2][13] = 9'h002;
        cache_addr[3][13] = 9'h003;

        cache_addr[0][14] = 9'h000;
        cache_addr[1][14] = 9'h001;
        cache_addr[2][14] = 9'h002;
        cache_addr[3][14] = 9'h003;

        cache_addr[0][15] = 9'h000;
        cache_addr[1][15] = 9'h001;
        cache_addr[2][15] = 9'h002;
        cache_addr[3][15] = 9'h003;

        cache_addr[0][16] = 9'h000;
        cache_addr[1][16] = 9'h001;
        cache_addr[2][16] = 9'h002;
        cache_addr[3][16] = 9'h003;

        cache_addr[0][17] = 9'h000;
        cache_addr[1][17] = 9'h001;
        cache_addr[2][17] = 9'h002;
        cache_addr[3][17] = 9'h003;

        cache_addr[0][18] = 9'h000;
        cache_addr[1][18] = 9'h001;
        cache_addr[2][18] = 9'h002;
        cache_addr[3][18] = 9'h003;

        cache_addr[0][19] = 9'h000;
        cache_addr[1][19] = 9'h001;
        cache_addr[2][19] = 9'h002;
        cache_addr[3][19] = 9'h003;

        cache_addr[0][20] = 9'h000;
        cache_addr[1][20] = 9'h001;
        cache_addr[2][20] = 9'h002;
        cache_addr[3][20] = 9'h003;

        cache_addr[0][21] = 9'h000;
        cache_addr[1][21] = 9'h001;
        cache_addr[2][21] = 9'h002;
        cache_addr[3][21] = 9'h003;

        cache_addr[0][22] = 9'h000;
        cache_addr[1][22] = 9'h001;
        cache_addr[2][22] = 9'h002;
        cache_addr[3][22] = 9'h003;

        cache_addr[0][23] = 9'h000;
        cache_addr[1][23] = 9'h001;
        cache_addr[2][23] = 9'h002;
        cache_addr[3][23] = 9'h003;

        cache_addr[0][24] = 9'h000;
        cache_addr[1][24] = 9'h001;
        cache_addr[2][24] = 9'h002;
        cache_addr[3][24] = 9'h003;

        cache_addr[0][25] = 9'h000;
        cache_addr[1][25] = 9'h001;
        cache_addr[2][25] = 9'h002;
        cache_addr[3][25] = 9'h003;

        cache_addr[0][26] = 9'h000;
        cache_addr[1][26] = 9'h001;
        cache_addr[2][26] = 9'h002;
        cache_addr[3][26] = 9'h003;

        cache_addr[0][27] = 9'h000;
        cache_addr[1][27] = 9'h001;
        cache_addr[2][27] = 9'h002;
        cache_addr[3][27] = 9'h003;

        cache_addr[0][28] = 9'h000;
        cache_addr[1][28] = 9'h001;
        cache_addr[2][28] = 9'h002;
        cache_addr[3][28] = 9'h003;

        cache_addr[0][29] = 9'h000;
        cache_addr[1][29] = 9'h001;
        cache_addr[2][29] = 9'h002;
        cache_addr[3][29] = 9'h003;

        cache_addr[0][30] = 9'h000;
        cache_addr[1][30] = 9'h001;
        cache_addr[2][30] = 9'h002;
        cache_addr[3][30] = 9'h003;

        cache_addr[0][31] = 9'h000;
        cache_addr[1][31] = 9'h001;
        cache_addr[2][31] = 9'h002;
        cache_addr[3][31] = 9'h003;

        cache_addr[0][32] = 9'h000;
        cache_addr[1][32] = 9'h001;
        cache_addr[2][32] = 9'h002;
        cache_addr[3][32] = 9'h003;

        cache_addr[0][33] = 9'h000;
        cache_addr[1][33] = 9'h001;
        cache_addr[2][33] = 9'h002;
        cache_addr[3][33] = 9'h003;

        cache_addr[0][34] = 9'h000;
        cache_addr[1][34] = 9'h001;
        cache_addr[2][34] = 9'h002;
        cache_addr[3][34] = 9'h003;

        cache_addr[0][35] = 9'h000;
        cache_addr[1][35] = 9'h001;
        cache_addr[2][35] = 9'h002;
        cache_addr[3][35] = 9'h003;

        cache_addr[0][36] = 9'h000;
        cache_addr[1][36] = 9'h001;
        cache_addr[2][36] = 9'h002;
        cache_addr[3][36] = 9'h003;

        cache_addr[0][37] = 9'h000;
        cache_addr[1][37] = 9'h001;
        cache_addr[2][37] = 9'h002;
        cache_addr[3][37] = 9'h003;

        cache_addr[0][38] = 9'h000;
        cache_addr[1][38] = 9'h001;
        cache_addr[2][38] = 9'h002;
        cache_addr[3][38] = 9'h003;

        cache_addr[0][39] = 9'h000;
        cache_addr[1][39] = 9'h001;
        cache_addr[2][39] = 9'h002;
        cache_addr[3][39] = 9'h003;

        cache_addr[0][40] = 9'h000;
        cache_addr[1][40] = 9'h001;
        cache_addr[2][40] = 9'h002;
        cache_addr[3][40] = 9'h003;

        cache_addr[0][41] = 9'h000;
        cache_addr[1][41] = 9'h001;
        cache_addr[2][41] = 9'h002;
        cache_addr[3][41] = 9'h003;

        cache_addr[0][42] = 9'h000;
        cache_addr[1][42] = 9'h001;
        cache_addr[2][42] = 9'h002;
        cache_addr[3][42] = 9'h003;

        cache_addr[0][43] = 9'h000;
        cache_addr[1][43] = 9'h001;
        cache_addr[2][43] = 9'h002;
        cache_addr[3][43] = 9'h003;

        cache_addr[0][44] = 9'h000;
        cache_addr[1][44] = 9'h001;
        cache_addr[2][44] = 9'h002;
        cache_addr[3][44] = 9'h003;

        cache_addr[0][45] = 9'h000;
        cache_addr[1][45] = 9'h001;
        cache_addr[2][45] = 9'h002;
        cache_addr[3][45] = 9'h003;

        cache_addr[0][46] = 9'h000;
        cache_addr[1][46] = 9'h001;
        cache_addr[2][46] = 9'h002;
        cache_addr[3][46] = 9'h003;

        cache_addr[0][47] = 9'h000;
        cache_addr[1][47] = 9'h001;
        cache_addr[2][47] = 9'h002;
        cache_addr[3][47] = 9'h003;

        cache_addr[0][48] = 9'h0ff;
        cache_addr[1][48] = 9'h000;
        cache_addr[2][48] = 9'h001;
        cache_addr[3][48] = 9'h002;

        cache_addr[0][49] = 9'h0ff;
        cache_addr[1][49] = 9'h000;
        cache_addr[2][49] = 9'h001;
        cache_addr[3][49] = 9'h002;

        cache_addr[0][50] = 9'h0ff;
        cache_addr[1][50] = 9'h000;
        cache_addr[2][50] = 9'h001;
        cache_addr[3][50] = 9'h002;

        cache_addr[0][51] = 9'h0ff;
        cache_addr[1][51] = 9'h000;
        cache_addr[2][51] = 9'h001;
        cache_addr[3][51] = 9'h002;

        cache_addr[0][52] = 9'h0ff;
        cache_addr[1][52] = 9'h000;
        cache_addr[2][52] = 9'h001;
        cache_addr[3][52] = 9'h002;

        cache_addr[0][53] = 9'h0ff;
        cache_addr[1][53] = 9'h000;
        cache_addr[2][53] = 9'h001;
        cache_addr[3][53] = 9'h002;

        cache_addr[0][54] = 9'h0ff;
        cache_addr[1][54] = 9'h000;
        cache_addr[2][54] = 9'h001;
        cache_addr[3][54] = 9'h002;

        cache_addr[0][55] = 9'h0ff;
        cache_addr[1][55] = 9'h000;
        cache_addr[2][55] = 9'h001;
        cache_addr[3][55] = 9'h002;

        cache_addr[0][56] = 9'h0ff;
        cache_addr[1][56] = 9'h000;
        cache_addr[2][56] = 9'h001;
        cache_addr[3][56] = 9'h002;

        cache_addr[0][57] = 9'h0ff;
        cache_addr[1][57] = 9'h000;
        cache_addr[2][57] = 9'h001;
        cache_addr[3][57] = 9'h002;

        cache_addr[0][58] = 9'h0ff;
        cache_addr[1][58] = 9'h000;
        cache_addr[2][58] = 9'h001;
        cache_addr[3][58] = 9'h002;

        cache_addr[0][59] = 9'h0ff;
        cache_addr[1][59] = 9'h000;
        cache_addr[2][59] = 9'h001;
        cache_addr[3][59] = 9'h002;

        cache_addr[0][60] = 9'h0ff;
        cache_addr[1][60] = 9'h000;
        cache_addr[2][60] = 9'h001;
        cache_addr[3][60] = 9'h002;

        cache_addr[0][61] = 9'h0ff;
        cache_addr[1][61] = 9'h000;
        cache_addr[2][61] = 9'h001;
        cache_addr[3][61] = 9'h002;

        cache_addr[0][62] = 9'h0ff;
        cache_addr[1][62] = 9'h000;
        cache_addr[2][62] = 9'h001;
        cache_addr[3][62] = 9'h002;

        cache_addr[0][63] = 9'h0ff;
        cache_addr[1][63] = 9'h000;
        cache_addr[2][63] = 9'h001;
        cache_addr[3][63] = 9'h002;
    end

	reg [2:0]STATE = 0;
	reg [`LINE-2:0]lowaddr = 0; //cache mem address
	reg s_lowaddr5 = 0;
	wire [31:0]cache_QA;
	wire [`WAYS-1:0]lru[(1<<`WAYS)-1:0];

	genvar i;
	for(i=0; i<(1<<`WAYS); i=i+1) begin
		assign fit[i] = ~r_flush && (cache_addr[i][index] == maddr[`ADDR-1:`LINE+`SETS]);
		assign free[i] = r_flush ? (flushcount[`WAYS+`SETS-1:`SETS] == i) : ~|cache_lru[i][index];
		assign lru[i] = {`WAYS{fit[i]}} & cache_lru[i][index];
	end

	wire hit = |fit;
	wire st0 = STATE == 3'b000;
	wire dirty = |(free & cache_dirty[index]);	

	wire [`WAYS-1:0]blk = flushcount[`WAYS+`SETS-1:`SETS] | {|fit[3:2], fit[3] | fit[1]};
	wire [`WAYS-1:0]fblk = {|free[3:2], free[3] | free[1]};
	wire [`WAYS-1:0]csblk = lru[0] | lru[1] | lru[2] | lru[3];

	always @(posedge ddr_clk) begin
		if(cache_write_data || cache_read_data) lowaddr <= lowaddr + 1'b1;
		ddr_dout <= lowaddr[0] ? cache_QA[15:0] : cache_QA[31:16];
	end

	cacheRAM cache_mem
	(
		.clka(ddr_clk), // input clka
		.ena(cache_write_data | cache_read_data), // input ena
		.wea({4{cache_write_data}} & {lowaddr[0], lowaddr[0], ~lowaddr[0], ~lowaddr[0]}), // input [3 : 0] wea
		.addra({blk, ~index[`SETS-1:10-`LINE], index[10-`LINE-1:0], lowaddr[`LINE-2:1]}), // input [11 : 0] addra
		.dina({ddr_din, ddr_din}), // input [31 : 0] dina
		.douta(cache_QA), // output [31 : 0] douta
		.clkb(clk), // input clkb
		.enb(mmreq && hit && st0), // input enb
		.web(mwmask), // input [3 : 0] web
		.addrb({blk, ~index[`SETS-1:10-`LINE], index[10-`LINE-1:0], maddr[`LINE-1:2]}), // input [11 : 0] addrb
		.dinb(mdin), // input [31 : 0] dinb
		.doutb(dout) // output [31 : 0] doutb
	);


	for(i=0; i<(1<<`WAYS); i=i+1)
		always @(posedge clk)
			if(st0 && mmreq)
				if(hit) begin
					cache_lru[i][index] <= fit[i] ? {`WAYS{1'b1}} : cache_lru[i][index] - (cache_lru[i][index] > csblk); 
					if(fit[i]) cache_dirty[index][i] <= cache_dirty[index][i] || (|mwmask);
				end else if(free[i]) cache_dirty[index][i] <= 1'b0;

		
	always @(posedge clk) begin
		s_lowaddr5 <= lowaddr[`LINE-2];
		flushreq <= ~flushcount[`WAYS+`SETS] & (flushreq | flush);
		if(ce) begin
			raddr <= addr;
			rdin <= din;
			rwmask <= wmask;
			rmreq <= mreq;
		end
		
		case(STATE)
			3'b000: begin
				hiaddr <= dirty ? {cache_addr[fblk][index], index} : maddr[`ADDR-1:`LINE]; 
				if(mmreq && !hit) begin	// cache miss
					if(!r_flush) cache_addr[fblk][index] <= maddr[`ADDR-1:`LINE+`SETS];
					ddr_rd <= ~dirty & ~r_flush;
					ddr_wr <= dirty;
					STATE <= dirty ? 3'b011 : 3'b100;
					ce <= 1'b0;
				end else begin
					flushcount[`WAYS+`SETS] <= flushcount[`WAYS+`SETS] | flushreq;
					ce <= 1'b1;
				end
			end
			3'b011: begin	// write cache to ddr
				ddr_rd <= ~r_flush; //1'b1;
				if(s_lowaddr5) begin
					ddr_wr <= 1'b0;
					STATE <= 3'b111;
				end
			end
			3'b111: begin // read cache from ddr
				hiaddr <= maddr[`ADDR-1:`LINE];
				if(~s_lowaddr5) STATE <= 3'b100;
			end
			3'b100: begin	
				if(r_flush) begin
					flushcount <= flushcount + 1'b1;
					STATE <= 3'b000;
				end else if(s_lowaddr5) STATE <= 3'b101;
			end
			3'b101: begin
				ddr_rd <= 1'b0;
				if(~s_lowaddr5) begin
					STATE <= 3'b000;
				end
			end
		endcase
	end
	
endmodule


module seg_map(
	 input CLK,
	 input [3:0]cpuaddr,
	 output [8:0]cpurdata,
	 input [8:0]cpuwdata,
	 input [4:0]memaddr,
	 output [8:0]memdata,
	 input WE,
	 input [3:0]seg_addr,
	 output vga_planar_seg
    );

	reg [8:0]map[0:31]; 
    initial $readmemh("segmap.mem", map);
    /*{9'h000, 9'h001, 9'h002, 9'h003, 9'h004, 9'h005, 9'h006, 9'h007, 9'h008, 9'h009,
								 9'h00a, 9'h00b,	// VGA seg 1 and 2
								 9'h012, 9'h013, 9'h014, 9'h015,
								 9'h016,	// HMA
								 9'h001, 9'h002, 9'h003, 9'h004, 9'h005, 9'h006, 9'h007, 9'h008, 9'h009, 
								 9'h00a, 9'h00b, 9'h00c, 9'h00d, 9'h00e, 9'h00f}; // VGA seg 1..6 */
	reg [15:0]vga_seg = 16'h0000;
	assign memdata = map[memaddr];
	assign cpurdata = map[{1'b0, cpuaddr}];
	assign vga_planar_seg = vga_seg[seg_addr];	
	
	always @(posedge CLK) 
		if(WE) begin
			map[{1'b0, cpuaddr}] <= cpuwdata;
			vga_seg[cpuaddr] <= cpuwdata == 9'ha;
		end

endmodule
