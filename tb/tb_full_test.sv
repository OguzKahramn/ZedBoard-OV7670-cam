`timescale 1ns / 1ps


module tb_full_test();


  reg           CLK_I             ;
  reg           CLK_100           ;
  reg           CLK_50            ;
  reg           RST_N             ;
  reg           ENABLE_I          ;
  reg           HREF_I            ;
  reg [7:0]    PXL_DATA          ;


  wire [3:0]    RED_O             ;
  wire [3:0]    GREEN_O           ;
  wire [3:0]    BLUE_O            ;
  wire          HSYNC_O           ;
  wire          VSYNC_O           ;
  

  localparam T_25 = 40            ;
  localparam T_50 = 20            ;
  localparam T_100 = 10           ;

  always #(T_25/2) CLK_I = ~ CLK_I;
  always #(T_100/2) CLK_100 = ~ CLK_100;
  always #(T_50/2) CLK_50 = ~ CLK_50;

  initial begin
    CLK_I            <= 0         ;
    CLK_100          <= 1         ;
    CLK_50           <= 1         ;
    RST_N            <= 0         ;
    ENABLE_I         <= 0         ;
    HREF_I           <= 0         ;
    data_cnt_r       <= 0         ;
    PXL_DATA         <= 0         ;
    #(T_25 * 40)                  ;
    RST_N            <= 1         ;
    #(T_25 * 40)                  ;
    ENABLE_I         <= 1         ;
  end

  reg [16:0] data_cnt_r           ;
  always @(posedge CLK_50) begin
    if(ENABLE_I)begin
      HREF_I         <= 1         ;
      PXL_DATA       <= $random   ;
      data_cnt_r     <= data_cnt_r + 16'd1;
    end
  end

  design_2_wrapper DUT0(
  .Button       (ENABLE_I )  ,
  .DATA_PXL_I   (PXL_DATA )  ,
  .HREF_I       (HREF_I )  ,
  .HSYNC_O      (HSYNC_O )  ,
  .VGA_B        (BLUE_O )  ,
  .VGA_G        (GREEN_O )  ,
  .VGA_R        (RED_O )  ,
  .VSYNC_O      (VSYNC_O )  ,
  .PXL_CLK_I    (CLK_50),
  .clk_in1      (CLK_100 )
  );


endmodule