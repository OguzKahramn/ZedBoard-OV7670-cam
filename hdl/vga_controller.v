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
  output           VIDEO_EN_O  ,   // Display pixel time 
  output  [14:0]   ADDRESS_O       // Read video pixel from BRAM
  );

  reg  [11:0]      hsync_cnt_r         ; // horizontal synchronization counter 
  reg  [11:0]      vsync_cnt_r         ; // vertical synchronization counter
  reg              hsync_r             ; // hsync signal
  reg              vsync_r             ; // vsync signal
  reg              count_en_pre_r      ; // the latch of enable signal 
  reg  [1:0]       vga_state_r         ; // vga state machine
  reg  [14:0]      bram_addr_cnt_r     ; // bram address counter

  wire             count_en_w          ;
  wire             hsync_active_w      ;
  wire             vsync_active_w      ;
  wire             video_active_w      ;

  localparam    H_PIXELS_C               =  'd640    ; // horizontal video pixels
  localparam    H_SYNC_PULSE_WIDTH_C     =  'd96     ; 
  localparam    H_FRONT_PORCH_WIDTH_C    =  'd16     ;
  localparam    H_BACK_PORCH_WIDTH_C     =  'd48     ;
  localparam    H_TOTAL_C                =  'd800    ;

  localparam    V_PIXELS_C               =  'd480    ; // vertical video pixels
  localparam    V_SYNC_PULSE_WIDTH_C     =  'd2      ;
  localparam    V_FRONT_PORCH_WIDTH_C    =  'd10     ; 
  localparam    V_BACK_PORCH_WIDTH_C     =  'd33     ;
  localparam    V_TOTAL_C                =  'd525    ;

  localparam    MAX_ADDRESS_C            = 16'd30720 ; // BRAM address for reading pixel value (1/10 frame) (640*480/10)

  
  localparam    IDLE_S                   = 2'd0      ;
  localparam    COUNT_S                  = 2'd1      ;

  assign count_en_w          = ENABLE_I              ;

  assign hsync_active_w      = (vga_state_r == COUNT_S && (hsync_cnt_r >= 12'd0 && hsync_cnt_r <= H_SYNC_PULSE_WIDTH_C - 12'd1)) ? 1'd1 : 1'd0;
  assign vsync_active_w      = (vga_state_r == COUNT_S && (vsync_cnt_r >= 12'd0 && vsync_cnt_r <= V_SYNC_PULSE_WIDTH_C - 12'd1)) ? 1'd1 : 1'd0;
  assign video_active_w      = (vga_state_r == COUNT_S &&(hsync_cnt_r >= H_SYNC_PULSE_WIDTH_C + H_FRONT_PORCH_WIDTH_C  && hsync_cnt_r <= H_TOTAL_C - H_BACK_PORCH_WIDTH_C - 12'd1) &&
                               (vsync_cnt_r >= V_SYNC_PULSE_WIDTH_C + V_FRONT_PORCH_WIDTH_C  && vsync_cnt_r <= V_TOTAL_C - V_BACK_PORCH_WIDTH_C  )) ? 1'd1 : 1'd0;
  
  assign VIDEO_EN_O          = video_active_w                               ;
  assign HSYNC_O             = (hsync_active_w) ? 1'd0 : 1'd1               ;
  assign VSYNC_O             = (vsync_active_w) ? 1'd0 : 1'd1               ;
  assign RED_O               = (video_active_w) ? VIDEO_PXL_I[11:8] : 4'd0  ;
  assign GREEN_O             = (video_active_w) ? VIDEO_PXL_I[7:4]  : 4'd0  ;
  assign BLUE_O              = (video_active_w) ? VIDEO_PXL_I[3:0]  : 4'd0  ;
  assign ADDRESS_O           = bram_addr_cnt_r                              ;

  /*
   @ brief : Counter for vga timing
  */ 

  always @(posedge CLK_25_I) begin 
    if(!RST_N_I)begin
      hsync_cnt_r            <= 12'd0                 ;
      hsync_r                <= 12'd0                 ;
      count_en_pre_r         <= 0'd0                  ;
      vsync_cnt_r            <= 12'd0                 ;  
      vga_state_r            <= IDLE_S                ;
    end // if
    else begin
      count_en_pre_r         <= count_en_w            ; 
      case(vga_state_r)
        IDLE_S : begin
          if(!count_en_pre_r && count_en_w)begin
            vga_state_r      <= COUNT_S               ;
          end
          else begin
            vga_state_r      <= IDLE_S                ;
          end
        end 

        COUNT_S : begin
          hsync_cnt_r        <= hsync_cnt_r + 12'd1   ;
          if(hsync_cnt_r == H_TOTAL_C - 12'd1)begin
            hsync_cnt_r      <= 12'd0                 ;
            vsync_cnt_r      <= vsync_cnt_r + 12'd1   ;
            if(vsync_cnt_r == V_TOTAL_C - 12'd1) begin
              vsync_cnt_r    <= 12'd0                 ;
            end
          end
        end
      endcase
    end //else
  end // always

  /*
   @ brief : The address pointer of frame buffer(BRAM)
  */ 

  always @(posedge CLK_25_I) begin
    if(!RST_N_I)begin
      bram_addr_cnt_r        <= 15'd0                 ;
    end
    else begin
      if(video_active_w)begin
        bram_addr_cnt_r      <= bram_addr_cnt_r + 15'd1;
      end
      if(bram_addr_cnt_r == MAX_ADDRESS_C - 15'd1)begin
        bram_addr_cnt_r      <= 15'd0;
      end
    end
  end


  
endmodule