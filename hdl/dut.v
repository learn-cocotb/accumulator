//
// Generated by Bluespec Compiler (build d05342e3)
//
// On Sun Dec  4 15:04:14 IST 2022
//
//
// Ports:
// Name                         I/O  size props
// RDY_din                        O     1 reg
// dout                           O     8 reg
// RDY_dout                       O     1 reg
// RDY_len                        O     1 const
// cfg                            O    32
// RDY_cfg                        O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// din_value                      I     8
// len_value                      I     8
// cfg_address                    I     8
// cfg_data                       I    32 reg
// cfg_op                         I     1
// EN_din                         I     1
// EN_len                         I     1
// EN_dout                        I     1
// EN_cfg                         I     1
//
// Combinational paths from inputs to outputs:
//   (cfg_address, cfg_op) -> cfg
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module dut(CLK,
	   RST_N,

	   din_value,
	   EN_din,
	   RDY_din,

	   EN_dout,
	   dout,
	   RDY_dout,

	   len_value,
	   EN_len,
	   RDY_len,

	   cfg_address,
	   cfg_data,
	   cfg_op,
	   EN_cfg,
	   cfg,
	   RDY_cfg);
  input  CLK;
  input  RST_N;

  // action method din
  input  [7 : 0] din_value;
  input  EN_din;
  output RDY_din;

  // actionvalue method dout
  input  EN_dout;
  output [7 : 0] dout;
  output RDY_dout;

  // action method len
  input  [7 : 0] len_value;
  input  EN_len;
  output RDY_len;

  // actionvalue method cfg
  input  [7 : 0] cfg_address;
  input  [31 : 0] cfg_data;
  input  cfg_op;
  input  EN_cfg;
  output [31 : 0] cfg;
  output RDY_cfg;

  // signals for module outputs
  wire [31 : 0] cfg;
  wire [7 : 0] dout;
  wire RDY_cfg, RDY_din, RDY_dout, RDY_len;

  // inlined wires
  wire w_len_reg$whas, w_sw_override$whas;

  // register busy
  reg busy;
  wire busy$D_IN, busy$EN;

  // register current_count
  reg [7 : 0] current_count;
  wire [7 : 0] current_count$D_IN;
  wire current_count$EN;

  // register len_reg
  reg [7 : 0] len_reg;
  wire [7 : 0] len_reg$D_IN;
  wire len_reg$EN;

  // register programmed_length
  reg [7 : 0] programmed_length;
  reg [7 : 0] programmed_length$D_IN;
  wire programmed_length$EN;

  // register sum
  reg [7 : 0] sum;
  wire [7 : 0] sum$D_IN;
  wire sum$EN;

  // register sw_override
  reg sw_override;
  wire sw_override$D_IN, sw_override$EN;

  // ports of submodule dout_ff
  wire [7 : 0] dout_ff$D_IN, dout_ff$D_OUT;
  wire dout_ff$CLR, dout_ff$DEQ, dout_ff$EMPTY_N, dout_ff$ENQ, dout_ff$FULL_N;

  // rule scheduling signals
  wire WILL_FIRE_RL_restart;

  // inputs to muxes for submodule ports
  wire MUX_programmed_length$write_1__SEL_2,
       MUX_programmed_length$write_1__SEL_3;

  // remaining internal signals
  reg [31 : 0] CASE_cfg_address_0_0_CONCAT_x39_4_0_CONCAT_sw__ETC__q1;
  wire [16 : 0] x__h939;
  wire [7 : 0] next_count__h529;
  wire current_count_1_PLUS_1_2_EQ_programmed_length_3___d14;

  // action method din
  assign RDY_din = dout_ff$FULL_N ;

  // actionvalue method dout
  assign dout = dout_ff$D_OUT ;
  assign RDY_dout = dout_ff$EMPTY_N ;

  // action method len
  assign RDY_len = 1'd1 ;

  // actionvalue method cfg
  assign cfg =
	     cfg_op ?
	       32'd0 :
	       CASE_cfg_address_0_0_CONCAT_x39_4_0_CONCAT_sw__ETC__q1 ;
  assign RDY_cfg = 1'd1 ;

  // submodule dout_ff
  FIFO2 #(.width(32'd8), .guarded(1'd1)) dout_ff(.RST(RST_N),
						 .CLK(CLK),
						 .D_IN(dout_ff$D_IN),
						 .ENQ(dout_ff$ENQ),
						 .DEQ(dout_ff$DEQ),
						 .CLR(dout_ff$CLR),
						 .D_OUT(dout_ff$D_OUT),
						 .FULL_N(dout_ff$FULL_N),
						 .EMPTY_N(dout_ff$EMPTY_N));

  // rule RL_restart
  assign WILL_FIRE_RL_restart = !busy && sw_override && !EN_din ;

  // inputs to muxes for submodule ports
  assign MUX_programmed_length$write_1__SEL_2 =
	     EN_len && !sw_override && !busy ;
  assign MUX_programmed_length$write_1__SEL_3 =
	     EN_din &&
	     current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 &&
	     sw_override ;

  // inlined wires
  assign w_sw_override$whas = EN_cfg && cfg_op && cfg_address == 8'd4 ;
  assign w_len_reg$whas = EN_cfg && cfg_op && cfg_address == 8'd8 ;

  // register busy
  assign busy$D_IN = !current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 ;
  assign busy$EN = EN_din ;

  // register current_count
  assign current_count$D_IN = next_count__h529 ;
  assign current_count$EN =
	     EN_din &&
	     !current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 ;

  // register len_reg
  assign len_reg$D_IN = cfg_data[7:0] ;
  assign len_reg$EN = w_len_reg$whas ;

  // register programmed_length
  always@(WILL_FIRE_RL_restart or
	  len_reg or
	  MUX_programmed_length$write_1__SEL_2 or
	  len_value or MUX_programmed_length$write_1__SEL_3)
  case (1'b1)
    WILL_FIRE_RL_restart: programmed_length$D_IN = len_reg;
    MUX_programmed_length$write_1__SEL_2: programmed_length$D_IN = len_value;
    MUX_programmed_length$write_1__SEL_3: programmed_length$D_IN = len_reg;
    default: programmed_length$D_IN = 8'b10101010 /* unspecified value */ ;
  endcase
  assign programmed_length$EN =
	     EN_din &&
	     current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 &&
	     sw_override ||
	     EN_len && !sw_override && !busy ||
	     WILL_FIRE_RL_restart ;

  // register sum
  assign sum$D_IN = sum + din_value ;
  assign sum$EN =
	     EN_din &&
	     !current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 ;

  // register sw_override
  assign sw_override$D_IN = cfg_data[0] ;
  assign sw_override$EN = w_sw_override$whas ;

  // submodule dout_ff
  assign dout_ff$D_IN = sum + din_value ;
  assign dout_ff$ENQ =
	     EN_din && current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 ;
  assign dout_ff$DEQ = EN_dout ;
  assign dout_ff$CLR = 1'b0 ;

  // remaining internal signals
  assign current_count_1_PLUS_1_2_EQ_programmed_length_3___d14 =
	     next_count__h529 == programmed_length ;
  assign next_count__h529 = current_count + 8'd1 ;
  assign x__h939 = { busy, programmed_length, current_count } ;
  always@(cfg_address or len_reg or x__h939 or sw_override)
  begin
    case (cfg_address)
      8'd0:
	  CASE_cfg_address_0_0_CONCAT_x39_4_0_CONCAT_sw__ETC__q1 =
	      { 15'd0, x__h939 };
      8'd4:
	  CASE_cfg_address_0_0_CONCAT_x39_4_0_CONCAT_sw__ETC__q1 =
	      { 31'd0, sw_override };
      default: CASE_cfg_address_0_0_CONCAT_x39_4_0_CONCAT_sw__ETC__q1 =
		   { 24'd0, len_reg };
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK or `BSV_RESET_EDGE RST_N)
  if (RST_N == `BSV_RESET_VALUE)
    begin
      busy <= `BSV_ASSIGNMENT_DELAY 1'd0;
      current_count <= `BSV_ASSIGNMENT_DELAY 8'd0;
      len_reg <= `BSV_ASSIGNMENT_DELAY 8'd0;
      programmed_length <= `BSV_ASSIGNMENT_DELAY 8'd0;
      sum <= `BSV_ASSIGNMENT_DELAY 8'd0;
      sw_override <= `BSV_ASSIGNMENT_DELAY 1'd0;
    end
  else
    begin
      if (busy$EN) busy <= `BSV_ASSIGNMENT_DELAY busy$D_IN;
      if (current_count$EN)
	current_count <= `BSV_ASSIGNMENT_DELAY current_count$D_IN;
      if (len_reg$EN) len_reg <= `BSV_ASSIGNMENT_DELAY len_reg$D_IN;
      if (programmed_length$EN)
	programmed_length <= `BSV_ASSIGNMENT_DELAY programmed_length$D_IN;
      if (sum$EN) sum <= `BSV_ASSIGNMENT_DELAY sum$D_IN;
      if (sw_override$EN)
	sw_override <= `BSV_ASSIGNMENT_DELAY sw_override$D_IN;
    end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    busy = 1'h0;
    current_count = 8'hAA;
    len_reg = 8'hAA;
    programmed_length = 8'hAA;
    sum = 8'hAA;
    sw_override = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // dut

