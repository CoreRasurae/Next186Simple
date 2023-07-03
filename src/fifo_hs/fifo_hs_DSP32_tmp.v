//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.8.05
//Part Number: GW2AR-LV18QN88C8/I7
//Device: GW2AR-18C
//Created Time: Wed Jun 28 15:36:02 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	FIFO_HS_Top_DSP32 your_instance_name(
		.Data(Data_i), //input [16:0] Data
		.WrClk(WrClk_i), //input WrClk
		.RdClk(RdClk_i), //input RdClk
		.WrEn(WrEn_i), //input WrEn
		.RdEn(RdEn_i), //input RdEn
		.Q(Q_o), //output [16:0] Q
		.Empty(Empty_o), //output Empty
		.Full(Full_o) //output Full
	);

//--------Copy end-------------------
