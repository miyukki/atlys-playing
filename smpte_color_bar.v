`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:49:15 01/08/2015
// Design Name:
// Module Name:    smpte_color_bar
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

module smpte_color_bar (
	input pixel_clk,
	output [3:0] count
);

reg [3:0] data = 4'b0;
assign count = data;

always @(posedge pixel_clk) begin
	data <= data + 1;
end

endmodule
