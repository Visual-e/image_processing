module sobel_detector (clk,z0,z1,z2,z3,z4,z5,z6,z7,z8,edge_out);
   input clk;
   input [7:0] z0,z1,z2,z3,z4,z5,z6,z7,z8;
   output [7:0] edge_out;
 
   reg signed [10:0] Gx;  
   reg signed [10:0] Gy;  
   reg signed [10:0] abs_Gx;
   reg signed [10:0] abs_Gy;
   reg [10:0]          sum;
   
always @ (posedge clk) begin
    //original
    //Gx<=((z2-z0)+((z5-z3)<<1)+(z8-z6)); //masking in x direction
    //Gy<=((z0-z6)+((z1-z7)<<1)+(z2-z8)); //masking in y direction
    // modified
    Gx <= (z4-z3);
    Gy <= (z4-z1);
    
    abs_Gx <= (Gx[10]?~Gx+1'b1:Gx);//if negative, then invert and add  to make pos.
    abs_Gy <= (Gy[10]?~Gy+1'b1:Gy);//if negative, then invert and add  to make pos.
    sum <= abs_Gx+abs_Gy;
end
//Apply Threshold
assign edge_out = (sum > 20) ? 8'hff : 8'h00;

endmodule