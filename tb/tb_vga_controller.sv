`timescale 1ns / 1ps


module tb_vga_controller();


  reg           CLK_I             ;
  reg           RST_N             ;
  reg           ENABLE_I          ;
  wire [11:0]    PXL_DATA          ;


  wire [3:0]    RED_O             ;
  wire [3:0]    GREEN_O           ;
  wire [3:0]    BLUE_O            ;
  wire          HSYNC_O           ;
  wire          VSYNC_O           ;
  wire [15:0]   ADDRESS_O         ;
  wire          ENABLE_O          ;

  localparam T_25 = 40            ;

  always #(T_25/2) CLK_I = ~ CLK_I;

  initial begin
    CLK_I            <= 0         ;
    RST_N            <= 0         ;
    ENABLE_I         <= 0         ;
//    PXL_DATA         <= 0         ;
    #(T_25 * 10)                  ;
    RST_N            <= 1         ;
    #(T_25 * 10)                  ;
    ENABLE_I         <= 1         ;
  end

  // always @(posedge CLK_I) begin
  //   if(ENABLE_O)begin
  //     PXL_DATA       <= $random   ;
  //   end
  // end

  vga_controller  DUTO(
    .CLK_25_I     ( CLK_I    ),   // 25 Mhz input clock
    .RST_N_I      ( RST_N    ),   // Active-low reset
    .ENABLE_I     ( ENABLE_I ),   // Start the controller
    .VIDEO_PXL_I  ( PXL_DATA ),   // {[3:0] RED, [3:0] GREEN, [3:0] BLUE} PIXELS

    .RED_O        ( RED_O    ),   // Red pixels of video
    .GREEN_O      ( GREEN_O  ),   // Green pixels of video
    .BLUE_O       ( BLUE_O   ),   // Blue pixels of video
    .HSYNC_O      ( HSYNC_O  ),   // Horizontal synchronization 
    .VSYNC_O      ( VSYNC_O  ),   // Vertical synchronization
    .VIDEO_EN_O   ( ENABLE_O ),   // Display pixel time 
    .ADDRESS_O    ( ADDRESS_O)    // Read video pixel from BRAM
  );

  pixel_provider pixel_provider_0(
    .CLK_25_I     ( CLK_I    ),   // 25 Mhz input clock
    .RST_N_I      ( RST_N    ),   // Active-low reset
    .ENABLE_I     ( ENABLE_O ),   // Start the give data

    .PIXEL_OUT_O   (PXL_DATA)  // 12 bit rgb data 444 
  );


endmodule