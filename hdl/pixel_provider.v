`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2024 08:17:16 PM
// Design Name: 
// Module Name: pixel_provider
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


module pixel_provider(
  input            CLK_25_I    ,   // 25 Mhz input clock
  input            RST_N_I     ,   // Active-low reset
  input            ENABLE_I    ,   // Start the give data

  output  [11:0]   PIXEL_OUT_O     // 12 bit rgb data 444 
  );

  // BLACK 000
  // WHITE FFF
  // RED   F00
  // GREEN 0F0
  // BLUE  00F
  // YELLOW FF0
  // PURPLE C0C
  // IDK    0FF

  localparam [11:0] BLACK_C = 12'h000;
  localparam [11:0] WHITE_C = 12'hFFF;
  localparam [11:0] RED_C = 12'hF00;
  localparam [11:0] GREEN_C = 12'h0F0;
  localparam [11:0] BLUE_C = 12'h00F;
  localparam [11:0] YELLOW_C = 12'hFF0;
  localparam [11:0] MAGENTA_C = 12'hC0D;
  localparam [11:0] AQUA_C = 12'h0FF;

  localparam [15:0] LINE_C = 16'd640;
  localparam [15:0] STRIPE_C = 16'd80;

  reg [15:0] counter_r                            ;
  reg [11:0] color_r                              ;

  assign PIXEL_OUT_O = (ENABLE_I) ? color_r : 12'd0   ;

  always @(posedge CLK_25_I)begin
    if(!RST_N_I)begin
      counter_r              <= 16'd0;
    end
    else begin
      if(ENABLE_I)begin
        counter_r            <= counter_r + 16'd1;
      end
      else begin
        counter_r            <= 16'd0;
      end
    end
  end

  always @(posedge CLK_25_I)begin
    if(!RST_N_I)begin
      color_r                <= 12'd0            ;
    end
    else begin
      if(counter_r <= STRIPE_C) begin
        color_r              <= BLACK_C          ;
      end
      else if(counter_r > STRIPE_C && counter_r <= (2 * STRIPE_C))begin
        color_r              <= WHITE_C          ;
      end
      else if(counter_r > (2 * STRIPE_C) && counter_r <= (3 * STRIPE_C))begin
        color_r              <= RED_C          ;
      end
      else if(counter_r > (3 * STRIPE_C) && counter_r <= (4 * STRIPE_C))begin
        color_r              <= GREEN_C          ;
      end
      else if(counter_r > (4 * STRIPE_C) && counter_r <= (5 * STRIPE_C))begin
        color_r              <= BLUE_C          ;
      end
      else if(counter_r > (5 * STRIPE_C) && counter_r <= (6 * STRIPE_C))begin
        color_r              <= YELLOW_C          ;
      end
      else if(counter_r > (6 * STRIPE_C) && counter_r <= (7 * STRIPE_C))begin
        color_r              <= MAGENTA_C          ;
      end
      else begin
        color_r              <= AQUA_C          ;
      end
    end
  end






endmodule