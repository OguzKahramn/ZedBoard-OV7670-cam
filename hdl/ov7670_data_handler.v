`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2024 01:55:16 PM
// Design Name: 
// Module Name: ov7670_data_handler
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

module ov7670_data_handler(
    input         CLK_25_I            ,
    input         PXL_CLK_I           ,
    input         RST_25_N_I          ,
    input         CAM_RST_I           ,
    input [7:0]   DATA_PXL_I          ,
    input         HREF_I              ,
    output        RST_O               ,
    output        PWDN_O              ,
    output        XCLK_O              ,
    output [11:0] RGB_DATA_O          ,
    output        DATA_VALID_O        ,
    output [14:0] BRAM_ADDR_O         
  );

  localparam [1:0]   IDLE_S       = 2'd0                   ;
  localparam [1:0]   FIRST_BYTE_S = 2'd1                   ;
  localparam [1:0]   SECOND_BYTE_S= 2'd2                   ;

  reg  [1:0]   data_handler_state                          ;
  reg  [11:0]  pixel_data_r                                ;
  reg          pixel_data_valid_r                          ;

  assign RGB_DATA_O     = pixel_data_r                     ;
  assign DATA_VALID_O   = pixel_data_valid_r               ;
  assign XCLK_O         = CLK_25_I                         ;
  assign RST_O          = !CAM_RST_I || RST_25_N_I         ;
  assign PWDN_O         = 1'd0                             ;

  always @(posedge PXL_CLK_I)begin
    if(!RST_25_N_I)begin
      pixel_data_r                     <= 12'd0            ;
      pixel_data_valid_r               <= 1'd0             ;
      data_handler_state               <= IDLE_S           ;
    end // if
    else begin
      case(data_handler_state)

        IDLE_S : begin
          if(HREF_I)begin
            data_handler_state         <= FIRST_BYTE_S     ;
            pixel_data_r[11:8]         <= DATA_PXL_I[3:0]  ;
          end // if
          else begin
            pixel_data_r               <= 12'd0            ;
            pixel_data_valid_r         <= 1'd0             ;
            data_handler_state         <= IDLE_S           ;
          end // else
        end // IDLE_S

        FIRST_BYTE_S : begin
          pixel_data_r[7:0]            <= DATA_PXL_I       ;
          pixel_data_valid_r           <= 1'd1             ;
          data_handler_state           <= SECOND_BYTE_S    ;
        end // FIRST_BYTE_S

        SECOND_BYTE_S : begin
          data_handler_state           <= FIRST_BYTE_S     ;
          pixel_data_valid_r           <= 1'd0             ;
          pixel_data_r[11:8]           <= DATA_PXL_I[3:0]  ;
        end // SECOND_BYTE_S

        default: data_handler_state    <= IDLE_S           ;

      endcase
    end // else
  end // always

  reg  [14:0]    address_cnt_r                             ;
  localparam [14:0] MAX_ADDRESS_C     =  15'd30720         ;

  assign BRAM_ADDR_O                  = address_cnt_r      ;

  always @ (posedge PXL_CLK_I) begin
    if(!RST_25_N_I) begin
      address_cnt_r            <= 15'd0                    ;
    end // if
    else begin
      if(pixel_data_valid_r)begin
        address_cnt_r          <= address_cnt_r + 15'd1    ;
      end // if
      if(address_cnt_r == MAX_ADDRESS_C - 15'd1) begin
        address_cnt_r          <= 15'd0                    ;
      end
    end // else
  end // always

endmodule