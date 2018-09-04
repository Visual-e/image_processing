module median_node
#(
    parameter DATA_WIDTH = 8,
    parameter LOW_MUX = 1, // disable low output
    parameter HI_MUX = 1 // disable high output
)(
    input wire [DATA_WIDTH-1:0] data_hi,
    input wire [DATA_WIDTH-1:0] data_li,

    output reg [DATA_WIDTH-1:0] data_ho,
    output reg [DATA_WIDTH-1:0] data_lo
);

wire sel0;
    alt_compare cmp(
        .dataa(data_hi),
        .datab(data_li),
        .agb(sel0),
        .alb()
    );


    always @(*)
    begin : mux_lo_hi
        case (sel0)
            1'b0 :
            begin
                if(LOW_MUX == 1)
                    data_lo = data_hi;
                if(HI_MUX == 1)
                    data_ho = data_li;
            end
            1'b1 :
            begin
                if(LOW_MUX == 1)
                    data_lo = data_li;
                if(HI_MUX == 1)
                    data_ho = data_hi;
            end
            default :
            begin
                data_lo = {DATA_WIDTH{1'b0}};
                data_ho = {DATA_WIDTH{1'b0}};
            end
        endcase
    end

endmodule