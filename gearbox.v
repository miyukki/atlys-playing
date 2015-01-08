`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    01:08:08 01/09/2015
// Design Name:
// Module Name:    gearbox
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

module gearbox # (
	parameter DATA_IN_SIZE = 4'd10
) (
	input wire ref_clk,
	input wire [DATA_IN_SIZE-1:0] data_in,
	output wire data_out
);

reg out_state = 1'b0;
reg [3:0] counter = 1'b0;

assign data_out = out_state;

always @(posedge ref_clk) begin
	out_state <= data_in[counter];

	if (counter == DATA_IN_SIZE - 1) begin
		counter <= 0;
	end
	else begin
		counter <= counter + 1;
	end
end

endmodule
