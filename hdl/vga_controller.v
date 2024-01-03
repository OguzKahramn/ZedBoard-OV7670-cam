`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2024 08:17:16 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
  input            CLK_25_I    ,   // 25 Mhz input clock
  input            RST_N_I     ,   // Active-low reset
  input            ENABLE_I    ,   // Start the controller
  input   [11:0]   VIDEO_PXL_I ,   // {[3:0] RED, [3:0] GREEN, [3:0] BLUE} PIXELS

  output  [3:0]    RED_O       ,   // Red pixels of video
  output  [3:0]    GREEN_O     ,   // Green pixels of video
  output  [3:0]    BLUE_O      ,   // Blue pixels of video
  output           HSYNC_O     ,   // Horizontal synchronization 
  output           VSYNC_O     ,   // Vertical synchronization
  output  []       ADDRESS_O       // Read video pixel from BRAM
  );

  reg  [11:0]      hsync_cnt_r         ; // horizontal synchronization counter 
  reg  [11:0]      vsync_cnt_r         ; // vertical synchronization counter
  reg              hsync_r             ; // hsync signal
  reg              vsync_r             ; // vsync signal

  localparam    H_PIXELS_C               =  'd640    ; // horizontal video pixels
  localparam    H_SYNC_PULSE_WIDTH_C     =  'd96     ; 
  localparam    H_FRONT_PORCH_WIDTH_C    =  'd16     ;
  localparam    H_BACK_PORCH_WIDTH_C     =  'd48     ;

  localparam    V_PIXELS_C               =  'd480    ; // vertical video pixels
  localparam    V_SYNC_PULSE_WIDTH_C     =  'd2      ;
  localparam    V_FRONT_PORCH_WIDTH_C    =  'd11     ; 
  localparam    V_BACK_PORCH_WIDTH_C     =  'd31     ;
  
  
  
endmodule