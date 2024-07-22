module or1k_procedural_exception_vector_mem
  #(parameter TRANSLATED_VECTOR_BASE = 32'h00002000,
    parameter TRANSLATED_VECTOR_STRIDE = 3)
   (
              clk_i,
              rst_i,
              wb_adr_i,
              wb_cyc_i,
              wb_stb_i,
              wb_dat_o,
              wb_ack_o
   );

   input clk_i;
   input rst_i;

   input [12:0] wb_adr_i;
   input wb_cyc_i;
   input wb_stb_i;

   output [31:0] wb_dat_o;
   output wb_ack_o;

   wire [4:0] vector_number;
   wire [31:0] translated_vector_offset;
   wire [31:0] target_address;
   wire [31:0] target_address_offset;

   assign vector_number = wb_adr_i[12:8];
   assign translated_vector_offset = { vector_number,
				       {TRANSLATED_VECTOR_STRIDE{1'b0}} };
   assign target_address = TRANSLATED_VECTOR_BASE + translated_vector_offset;
   assign target_address_offset = target_address - { {19{1'b0}}, wb_adr_i };

   assign wb_dat_o = ( wb_adr_i[2] ?
		       { 8'b00010101 /* l.nop */, 8'h00, 16'h0000 } :
		       { 6'b000000 /* l.j */, target_address_offset[27:2] } );

   assign wb_ack_o = wb_cyc_i & wb_stb_i;

endmodule // or1k_procedural_exception_vector_mem
