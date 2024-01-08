`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2024 08:17:16 PM
// Design Name: 
// Module Name: ZED_VGA_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ZED_VGA_TOP
  ( input            Button,
    output           HSYNC_O,
    output  [3:0]    VGA_B,
    output  [3:0]    VGA_G,
    output  [3:0]    VGA_R,
    output           VSYNC_O,
    input            clk_in1
  );

  wire RST_25_N_I;
  wire CLK_25_I;
  wire [11:0] pixel_value_w;
  wire [3:0] vga_r_w;
  wire [3:0] vga_g_w;
  wire [3:0] vga_b_w;
  wire  hsync_w;
  wire  vsync_w;
  wire  video_en_w;

  vga_clk_wiz_0 vga_clk_wiz_0(
    .clk_25     (CLK_25_I ) ,
    .locked     (RST_25_N_I ) ,
    .clk_in1    (clk_in1 )
  );

  vga_controller VGA_CONTOLLER_0(
    .CLK_25_I    ( CLK_25_I),   // 25 Mhz input clock
    .RST_N_I     ( RST_25_N_I),   // Active-low reset
    .ENABLE_I    ( Button),   // Start the controller
    .VIDEO_PXL_I ( pixel_value_w),   // {[3:0] RED, [3:0] GREEN, [3:0] BLUE} PIXELS

    .RED_O       ( vga_r_w),   // Red pixels of video
    .GREEN_O     ( vga_g_w),   // Green pixels of video
    .BLUE_O      ( vga_b_w),   // Blue pixels of video
    .HSYNC_O     ( hsync_w),   // Horizontal synchronization 
    .VSYNC_O     ( vsync_w),   // Vertical synchronization
    .VIDEO_EN_O  ( video_en_w),   // Display pixel time 
    .ADDRESS_O   ( )    // Read video pixel from BRAM
  );

  pixel_provider pixel_provider_0(
    .CLK_25_I    ( CLK_25_I),   // 25 Mhz input clock
    .RST_N_I     ( RST_25_N_I),   // Active-low reset
    .ENABLE_I    ( video_en_w),   // Start the give data

    .PIXEL_OUT_O (pixel_value_w)    // 12 bit rgb data 444 
  );




endmodule
