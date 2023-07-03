
create_clock -name CLK_27M -period 37.037 [get_ports {CLK_27M}]       // 27.00 Mhz
//create_clock -name clk_cpu -perid 14.493 [get_nets {clk_cpu}]

// HDMI clocks
//create_clock -name clk_sdr -period 8.008 [get_nets {clk_sdr}]                    // 124.875 Mhz
//create_generated_clock -name clk_p -source [get_nets {clk_sdr}] -master_clock clk_sdr -divide_by 5 [get_nets {clk_p}]     //24.975 MHz// 74.25 Mhz: 720p pixel clock

//set_clock_groups -asynchronous -group [get_clocks {pclk} get_clocks{clk}] -group [get_clocks {clk_p5} get_clocks{clk_p}]
//report_timing -hold -from_clock [get_clocks {clk*}] -to_clock [get_clocks {clk*}] -max_paths 25 -max_common_paths 1
//report_timing -setup -from_clock [get_clocks {clk*}] -to_clock [get_clocks {clk*}] -max_paths 25 -max_common_paths 1