module median_top
#(
 parameter DATA_WIDTH = 8
)
(
 input wire clk,
 input wire [DATA_WIDTH-1:0] a0,
 input wire [DATA_WIDTH-1:0] b0,
 input wire [DATA_WIDTH-1:0] c0,
 input wire [DATA_WIDTH-1:0] a1,
 input wire [DATA_WIDTH-1:0] b1,
 input wire [DATA_WIDTH-1:0] c1,
 input wire [DATA_WIDTH-1:0] a2,
 input wire [DATA_WIDTH-1:0] b2,
 input wire [DATA_WIDTH-1:0] c2,
 output wire [DATA_WIDTH-1:0] median
);

//-------------------------Связи---------------------------------------
wire [DATA_WIDTH-1:0] n1ho_n7hi;
wire [DATA_WIDTH-1:0] n1lo_n4hi;
wire [DATA_WIDTH-1:0] n2ho_n8hi;
wire [DATA_WIDTH-1:0] n2lo_n5hi;
wire [DATA_WIDTH-1:0] n3ho_n9hi;
wire [DATA_WIDTH-1:0] n3lo_n6hi;
wire [DATA_WIDTH-1:0] n4ho_n7li;
wire [DATA_WIDTH-1:0] n4lo_n15hi;
wire [DATA_WIDTH-1:0] n5ho_n8li;
wire [DATA_WIDTH-1:0] n5lo_n12hi;
wire [DATA_WIDTH-1:0] n6ho_n9li;
wire [DATA_WIDTH-1:0] n6lo_n12li;
wire [DATA_WIDTH-1:0] n7ho_n10hi;
wire [DATA_WIDTH-1:0] n7lo_n11hi;
wire [DATA_WIDTH-1:0] n8ho_n10li;
wire [DATA_WIDTH-1:0] n8lo_n11li;
wire [DATA_WIDTH-1:0] n9ho_n13li;
wire [DATA_WIDTH-1:0] n9lo_n14li;
wire [DATA_WIDTH-1:0] n10lo_n13hi;
wire [DATA_WIDTH-1:0] n11ho_n16hi;
wire [DATA_WIDTH-1:0] n11lo_n14hi;
wire [DATA_WIDTH-1:0] n12ho_n15li;
wire [DATA_WIDTH-1:0] n13lo_n17hi;
wire [DATA_WIDTH-1:0] n14ho_n16li;
wire [DATA_WIDTH-1:0] n15ho_n18li;
wire [DATA_WIDTH-1:0] n16lo_n17li;
wire [DATA_WIDTH-1:0] n17ho_n19hi;
wire [DATA_WIDTH-1:0] n17lo_n18hi;
wire [DATA_WIDTH-1:0] n18ho_n19li;

//-------------------------Ноды----------------------------------------
//Нода 1
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node1 (
    .data_hi(a0),
    .data_li(b0),

    .data_ho(n1ho_n7hi),
    .data_lo(n1lo_n4hi)
);

//Нода 2
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node2 (
    .data_hi(a1),
    .data_li(b1),

    .data_ho(n2ho_n8hi),
    .data_lo(n2lo_n5hi)
);

//Нода 3
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node3 (
    .data_hi(a2),
    .data_li(b2),

    .data_ho(n3ho_n9hi),
    .data_lo(n3lo_n6hi)
);

//Нода 4
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node4 (
    .data_hi(n1lo_n4hi),
    .data_li(c0),

    .data_ho(n4ho_n7li),
    .data_lo(n4lo_n15hi)
);

//Нода 5
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node5 (
    .data_hi(n2lo_n5hi),
    .data_li(c1),

    .data_ho(n5ho_n8li),
    .data_lo(n5lo_n12hi)
);

//Нода 6
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node6 (
    .data_hi(n3lo_n6hi),
    .data_li(c2),

    .data_ho(n6ho_n9li),
    .data_lo(n6lo_n12li)
);

//Нода 7
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node7 (
    .data_hi(n1ho_n7hi),
    .data_li(n4ho_n7li),

    .data_ho(n7ho_n10hi),
    .data_lo(n7lo_n11hi)
);

//Нода 8
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node8 (
    .data_hi(n2ho_n8hi),
    .data_li(n5ho_n8li),

    .data_ho(n8ho_n10li),
    .data_lo(n8lo_n11li)
);

//Нода 9
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node9 (
    .data_hi(n3ho_n9hi),
    .data_li(n6ho_n9li),

    .data_ho(n9ho_n13li),
    .data_lo(n9lo_n14li)
);

//Нода 10
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(0) // disable high output
)
median_node10 (
    .data_hi(n7ho_n10hi),
    .data_li(n8ho_n10li),

    .data_ho(),
    .data_lo(n10lo_n13hi)
);

//Нода 11
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node11 (
    .data_hi(n7lo_n11hi),
    .data_li(n8lo_n11li),

    .data_ho(n11ho_n16hi),
    .data_lo(n11lo_n14hi)
);

//Нода 12
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(0), // disable low output
    .HI_MUX(1) // disable high output
)
median_node12 (
    .data_hi(n5lo_n12hi),
    .data_li(n6lo_n12li),

    .data_ho(n12ho_n15li),
    .data_lo()
);

//Нода 13
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(0) // disable high output
)
median_node13 (
    .data_hi(n10lo_n13hi),
    .data_li(n9ho_n13li),

    .data_ho(),
    .data_lo(n13lo_n17hi)
);

//Нода 14
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(0), // disable low output
    .HI_MUX(1) // disable high output
)
median_node14 (
    .data_hi(n11lo_n14hi),
    .data_li(n9lo_n14li),

    .data_ho(n14ho_n16li),
    .data_lo()
);

//Нода 15
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(0), // disable low output
    .HI_MUX(1) // disable high output
)
median_node15 (
    .data_hi(n4lo_n15hi),
    .data_li(n12ho_n15li),

    .data_ho(n15ho_n18li),
    .data_lo()
);

//Нода 16
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(0) // disable high output
)
median_node16 (
    .data_hi(n11ho_n16hi),
    .data_li(n14ho_n16li),

    .data_ho(),
    .data_lo(n16lo_n17li)
);

//Нода 17
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(1) // disable high output
)
median_node17 (
    .data_hi(n13lo_n17hi),
    .data_li(n16lo_n17li),

    .data_ho(n17ho_n19hi),
    .data_lo(n17lo_n18hi)
);

//Нода 18
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(0), // disable low output
    .HI_MUX(1) // disable high output
)
median_node18 (
    .data_hi(n17lo_n18hi),
    .data_li(n15ho_n18li),

    .data_ho(n18ho_n19li),
    .data_lo()
);

//Нода 19
median_node
#(
    .DATA_WIDTH(8),
    .LOW_MUX(1), // disable low output
    .HI_MUX(0) // disable high output
)
median_node19 (
    .data_hi(n17ho_n19hi),
    .data_li(n18ho_n19li),

    .data_ho(),
    .data_lo(median)
);

endmodule