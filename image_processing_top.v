module image_processing_top(
		input wire reset,
		input wire clk_50,	//50MHz
		//VGA output
		output wire hsync,
		output wire vsync,
 		output wire [3:0]r,
		output wire [3:0]g,
		output wire [3:0]b
);

wire pclk;
wire active;
wire [7:0]pic_rgb;
reg [7:0]pic_rgb_out_r;
reg [7:0]pic_rgb_out_g;
reg [7:0]pic_rgb_out_b;
wire [8:0]row;
wire [9:0]col;
wire row0,col0;
reg [14:0]mem_addr;
reg data_ok;

wire [7:0] median_out_t, sobel_out_t, gaus_out_t;


vga vga_inst(
 .Reset (~reset), 
 .Clk50 (clk_50),
 .VSync (vsync), 
 .HSync (hsync), 
 .PClk (pclk), 
 .Row (row), 
 .Col (col), 
 .Row0 (row0), 
 .Col0 (col0), 
 .Active (active)
 );
 
pic_rom	pic_rom (
	.address (mem_addr),
	.clock (pclk),
	.q (pic_rgb)
);

//------------------------------------------------------------------
wire data_in_en;
wire [7:0] line3_data;	

assign data_in_en=data_ok;
assign line3_data=pic_rgb;


wire line2_wr_rq = (data_in_en && !line2_data_ready);
wire line2_rd_rq = (line2_data_valid && !line1_data_ready);
wire line2_data_ready;
wire line2_empty;
wire line2_data_valid = !line2_empty;
wire [7:0] line2_data;


// row 2 FIFO
fifo_bufer LINE2_FIFO (
	.aclr(),
	.clock(pclk),
	.data(line3_data),
	.rdreq(line2_rd_rq),
	.wrreq(line2_wr_rq),
	.almost_full(line2_data_ready),
	.empty(line2_empty),
	.full(),
	.q(line2_data),
	.usedw()
	);


wire line1_wr_rq = (line2_data_valid && !line1_data_ready);
wire line1_rd_rq = (line1_data_valid); 	
wire line1_data_ready;
wire line1_empty;
wire line1_data_valid = !line1_empty;
wire [7:0] line1_data;

// row 1 FIFO
fifo_bufer LINE1_FIFO (
	.aclr(),
	.clock(pclk),
	.data(line2_data),
	.rdreq(line1_rd_rq),
	.wrreq(line1_wr_rq),
	.almost_full(line1_data_ready),
	.empty(line1_empty),
	.full(),
	.q(line1_data),
	.usedw()
);
	 
//-------------------------------------------------------------------
reg [7:0] a0,b0,c0,a1,b1,c1,a2,b2,c2;

always @(posedge pclk or negedge reset)
    if (!reset) begin
        a0 <= 8'd0; b0 <= 8'd0; c0 <= 8'd0;
        a1 <= 8'd0; b1 <= 8'd0; c1 <= 8'd0;
        a2 <= 8'd0; b2 <= 8'd0; c2 <= 8'd0;
    end else begin
        a0 <= line1_data;
        b0 <= line2_data;
        c0 <= line3_data;
        //pipeline step 1
        a1 <= a0;
        b1 <= b0;
        c1 <= c0;
        //pipeline step 2
        a2 <= a1;
        b2 <= b1;
        c2 <= c1;
end

//-------------------------------------------------------------------
median_top
#(
 .DATA_WIDTH(8)
) median_top (
 .clk(pclk),
 .a0(a0),
 .b0(b0),
 .c0(c0),
 .a1(a1),
 .b1(b1),
 .c1(c1),
 .a2(a2),
 .b2(b2),
 .c2(c2),
 .median(median_out_t)
);

//-------------------------------------------------------------------
sobel_detector sobel (
  .clk(pclk),
  .z0(a0),
  .z1(a1),
  .z2(a2),
  .z3(b0),
  .z4(b1),
  .z5(b2),
  .z6(c0),
  .z7(c1),
  .z8(c2),
  .edge_out(sobel_out_t)
);

//-------------------------------------------------------------------
gaus_filter
#(
 .DATA_IN_WIDTH(8)
) gaus_filter_inst(
 .d00_in    (a0),
 .d01_in    (a1),
 .d02_in    (a2),
 .d10_in    (b0),
 .d11_in    (b1),
 .d12_in    (b2),
 .d20_in    (c0),
 .d21_in    (c1),
 .d22_in    (c2),
 .ftr_out   (gaus_out_t),
);
	 
//-------------------------------------------------------------------
reg [26:0] mode_cnt;

always @(posedge pclk) begin
mode_cnt <= mode_cnt + 1;
end

parameter width = 176,
          height = 176,
			 x_start = 100,
			 y_start = 100;

always @(posedge pclk) begin
if(row>=y_start && col>=x_start && row<y_start+height && col<x_start+width)
	begin
	if(row>=y_start && col>=x_start && row<y_start+16 && col<x_start+16)
		begin
		data_ok<=1`b;
		mem_addr<=15'b000000000000000;
		case(mode_cnt[26:25])
			2'b00:
				begin
				pic_rgb_out_r<=8'b11111111;
				pic_rgb_out_g<=8'b00000000;
				pic_rgb_out_b<=8'b00000000;
				end
			2'b01:
				begin
				pic_rgb_out_r<=8'b00000000;
				pic_rgb_out_g<=8'b11111111;
				pic_rgb_out_b<=8'b00000000;
				end
			2'b10:
				begin
				pic_rgb_out_r<=8'b00000000;
				pic_rgb_out_g<=8'b00000000;
				pic_rgb_out_b<=8'b11111111;
				end
			2'b11:
				begin
				pic_rgb_out_r<=8'b11111111;
				pic_rgb_out_g<=8'b11111111;
				pic_rgb_out_b<=8'b11111111;
				end
		endcase
		end
	else
		begin
		data_ok<=1`b1;
		mem_addr<=(row-y_start)*width+col-x_start;
		case(mode_cnt[26:25])
			2'b00:
				begin
				pic_rgb_out_r<=pic_rgb;
				pic_rgb_out_g<=pic_rgb;
				pic_rgb_out_b<=pic_rgb;
				end
			2'b01:
				begin
				pic_rgb_out_r<=median_out_t;
				pic_rgb_out_g<=median_out_t;
				pic_rgb_out_b<=median_out_t;
				end
			2'b10:
				begin
				pic_rgb_out_r<=sobel_out_t;
				pic_rgb_out_g<=sobel_out_t;
				pic_rgb_out_b<=sobel_out_t;
				end
			2'b11:
				begin
				pic_rgb_out_r<=gaus_out_t;
				pic_rgb_out_g<=gaus_out_t;
				pic_rgb_out_b<=gaus_out_t;
				end
		endcase
		end
	end
else
	begin
	data_ok<=1'b0;
	mem_addr<=15'b000000000000000;
	pic_rgb_out_r<=8'b00000000;
	pic_rgb_out_g<=8'b00000000;
	pic_rgb_out_b<=8'b00000000;
	end
end

assign r = (pic_rgb_out_r >> 4) & 8'b00001111;
assign g = (pic_rgb_out_g >> 4) & 8'b00001111;
assign b = (pic_rgb_out_b >> 4) & 8'b00001111;

endmodule