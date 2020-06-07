/*
 * VGA timing generator
 *
 * Original file (C) Arlet Ottens
 * 
 * Slightly modified by Brendan Doms, Sean McBride, Brian Shih, and Mikell Taylor for use in their own project.
 * (The timing was a bit off from official VGA specifications.)
 */

module vga( reset, clk50, vSync, hSync, pClk, row, col, row0, col0, active );
    input reset;
    output vSync;
    output hSync;
    input clk50;

    // outputs to data generator
    output pClk;		// pixel clock
    output row0;		// pulse when Row == 0
    output col0;		// pulse when Col == 0
    output [9:0] col;		// next column
    output [8:0] row;		// next row
    output active;		//

reg pClk;			// pixel clock
reg row0;			// pulse when Row == 0
reg col0;			// pulse when Col == 0
reg [12:0] hClock;
reg [11:0] vClock;
assign col = hClock[9:0];
assign row = vClock[8:0];
assign active = hClock[11] & vClock[10];
assign vSync = vClock[9];
assign hSync = hClock[10];

/*
 * VGA timing information.
 */
parameter 
    HSYNC   = 10'd95,
    HBACK   = 10'd47,
    HACTIVE = 10'd639,
    HFRONT  = 10'd15;

parameter
    VSYNC   = 9'd1,
    VBACK   = 9'd32,
    VACTIVE = 9'd479,
    VFRONT  = 9'd9;

wire hStart = ( hClock == {3'b101, HBACK} );
wire vStart = ( vClock == {3'b101, VBACK} );

/*
 * make 25 MHz pixelclock
 */
always @(posedge clk50)
       pClk <= reset ? 0 : ~pClk;

/*
 * Horizontal timing state machine
 */
always @(posedge clk50) begin
    if( reset ) begin
	hClock <= 0;
	col0 <= 0;
    end else if( pClk ) begin
	casex( hClock )
	    { 3'bxx0, HSYNC   } : hClock <= { 3'b101, 10'd0 };
	    { 3'b101, HBACK   } : hClock <= { 3'b011, 10'd0 };
	    { 3'bx11, HACTIVE } : hClock <= { 3'b001, 10'd0 };
	    { 3'b001, HFRONT  } : hClock <= { 3'b100, 10'd0 };

	    default:
		hClock <= { hClock[12:10], hClock[9:0] + 10'd1 };
	endcase
    end
    col0 <= hStart;
end

/*
 * Vertical timing state machine
 */
always @(posedge clk50) begin
    if( reset ) begin
	vClock <= 0;
	row0 <= 0;
    end else if( pClk & hStart ) begin
	casex ( vClock )
	    { 3'bxx0, VSYNC   } : vClock <= { 3'b101, 9'd0 };
	    { 3'b101, VBACK   } : vClock <= { 3'b011, 9'd0 };
	    { 3'bx11, VACTIVE } : vClock <= { 3'b001, 9'd0 };
	    { 3'b001, VFRONT  } : vClock <= { 3'b100, 9'd0 };

	    default:
		vClock <= { vClock[11:9], vClock[8:0] + 9'd1};
	endcase
    end
    row0 <= hStart & vStart;
end

endmodule


