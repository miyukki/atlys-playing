`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    00:03:27 12/04/2014
// Design Name:
// Module Name:    program
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module program (
	input wire RESET,
	input wire CLOCK_100M,
	// input wire BUTTON_NORTH,
	input wire [3:0] RX0_TMDS,
	input wire [3:0] RX0_TMDSB,

	output wire [3:0] TX0_TMDS,
	output wire [3:0] TX0_TMDSB,
	// input wire J1_TMDS_CLK,
	// input wire J1_TMDS_CLKB,
	// output wire tmdsclk,
	output wire [3:0] LED
	// output wire LED2
);

/*
 * PIXEL CLOCK GENERATOR
 */

wire px_clk, px_clk_buf, px10_clk, px_clk_busy, px10_clk_busy;

wire initialized = px_clk_busy & px10_clk_busy;

IBUFG clk_ibufg (
	.I(CLOCK_100M),
	.O(clk_in_buf)
);

DCM_CLKGEN #(
	.CLKFX_MULTIPLY(3),
	.CLKFX_DIVIDE(4)
) px_clkgen (
	.FREEZEDCM(1'b0),
	.RST(RESET),
	.CLKIN(clk_in_buf),
	.CLKFX(px_clk),
	.LOCKED(px_clk_busy)
);

DCM_CLKGEN #(
	.CLKFX_MULTIPLY(10)
) px10_clkgen (
	.FREEZEDCM(1'b0),
	.RST(RESET),
	.CLKIN(px_clk),
	.CLKFX(px10_clk),
	.LOCKED(px10_clk_busy)
);

BUFG px_clk_bufg (
	.I(px_clk),
	.O(px_clk_buf)
);


/*
 * TRANSMITTER
 */

wire tx0_tmds_r;

gearbox tx0_tmds_r_convert (
	.ref_clk(px10_clk),
	.data_in(10'd0110001111),
	.data_out(tx0_tmds_r)
);

wire tx0_tmds_g;

gearbox tx0_tmds_g_convert (
	.ref_clk(px10_clk),
	.data_in(10'd0110001111),
	.data_out(tx0_tmds_g)
);

wire tx0_tmds_b;

gearbox tx0_tmds_b_convert (
	.ref_clk(px10_clk),
	.data_in(10'd0110001111),
	.data_out(tx0_tmds_b)
);

OBUFDS #(
	.IOSTANDARD("TMDS_33")
) tx0_tmds_r_obufds (
	.I(tx0_tmds_r), .O(TX0_TMDS[0]), .OB(TX0_TMDSB[0])
);

OBUFDS #(
	.IOSTANDARD("TMDS_33")
) tx0_tmds_g_obufds (
	.I(tx0_tmds_g), .O(TX0_TMDS[1]), .OB(TX0_TMDSB[1])
);

OBUFDS #(
	.IOSTANDARD("TMDS_33")
) tx0_tmds_b_obufds (
	.I(tx0_tmds_b), .O(TX0_TMDS[2]), .OB(TX0_TMDSB[2])
);

OBUFDS #(
	.IOSTANDARD("TMDS_33")
) tx0_tmds_clk_obufds (
	.I(px_clk_buf), .O(TX0_TMDS[3]), .OB(TX0_TMDSB[3])
);

// BUFG clk_bufg (
// 	.I(pixel_clk),
// 	.O(pixel_clk_buf)
// );


  // always @ (posedge clk50m_bufg)
  // begin
  //   if(switch) begin
  //     case (sws_sync_q)
  //       SW_VGA: //25 MHz pixel clock
  //       begin
  //         pclk_M <= 8'd2 - 8'd1;
  //         pclk_D <= 8'd4 - 8'd1;
  //       end

  //       SW_SVGA: //40 MHz pixel clock
  //       begin
  //        pclk_M <= 8'd4 - 8'd1;
  //        pclk_D <= 8'd5 - 8'd1;
  //       end

  //       SW_XGA: //65 MHz pixel clock
  //       begin
  //         pclk_M <= 8'd13 - 8'd1;
  //         pclk_D <= 8'd10 - 8'd1;
  //       end

  //       SW_SXGA: //108 MHz pixel clock
  //       begin
  //         pclk_M <= 8'd54 - 8'd1;
  //         pclk_D <= 8'd25 - 8'd1;
  //       end

  //       default: //74.25 MHz pixel clock
  //       begin
  //         pclk_M <= 8'd37 - 8'd1;
  //         pclk_D <= 8'd25 - 8'd1;
  //       end
  //      endcase
  //   end
  // end

// wire rxclkint;
// IBUFDS  #(.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
// ) ibuf_rxclk (.I(J1_TMDS_CLK), .IB(J1_TMDS_CLKB), .O(rxclkint));

// wire rxclk;
// BUFIO2 #(.DIVIDE_BYPASS("TRUE"), .DIVIDE(1))
// bufio_tmdsclk (.DIVCLK(rxclk), .IOCLK(), .SERDESSTROBE(), .I(rxclkint));

// BUFG tmdsclk_bufg (.I(rxclk), .O(tmdsclk));

// OBUFDS TMDS3 (.I(tmdsclk), .O(TX0_TMDS[3]), .OB(TX0_TMDSB[3]))

// wire rxclkint;
// IBUFDS #(
// 	.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
// ) ibuf_rxclk (
// 	.I(J1_TMDS_CLK), .IB(J1_TMDS_CLKB), .O(rxclkint)
// );

// wire rxclk;
// BUFIO2 #(
// 	.DIVIDE_BYPASS("TRUE"), .DIVIDE(1)
// ) bufio_tmdsclk (
// 	.DIVCLK(rxclk), .IOCLK(), .SERDESSTROBE(), .I(rxclkint)
// );

// wire tmdsclk;
// BUFG tmdsclk_bufg (.I(rxclk), .O(tmdsclk));
// OBUFDS TMDS3 (.I(tmdsclk), .O(J1_TMDS_CLK), .OB(J1_TMDS_CLKB));

wire [3:0] tmds;
IBUFDS #(
	.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
) ibuf3 (
	.I(RX0_TMDS[3]), .IB(RX0_TMDSB[3]), .O(tmds[3])
);
IBUFDS #(
	.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
) ibuf2 (
	.I(RX0_TMDS[2]), .IB(RX0_TMDSB[2]), .O(tmds[2])
);
IBUFDS #(
	.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
) ibuf1 (
	.I(RX0_TMDS[1]), .IB(RX0_TMDSB[1]), .O(tmds[1])
);
IBUFDS #(
	.IOSTANDARD("TMDS_33"), .DIFF_TERM("FALSE")
) ibuf0 (
	.I(RX0_TMDS[0]), .IB(RX0_TMDSB[0]), .O(tmds[0])
);

assign LED = tmds;
// assign LED[1] = J1_TMDS_CLK;
// assign LED[0] = J1_TMDS_CLKB;

// assign LED1 = BUTTON_NORTH;
// assign LED2 = 1'b1;
//reg [25:0] ount = 26'b0;
//reg led_state = 1'b1;
//assign LED = led_state;

//always @(posedge CLOCK_50M) begin
//	count = count + 1;
//	if (count == 50000000) begin
//		led_state <= !led_state;
//		count = 0;
//	end
//end

endmodule
