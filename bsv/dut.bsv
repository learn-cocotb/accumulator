import FIFOF::*;
interface Ifc_dut;
	(*ready="din_rdy",enable="din_en"*)
method Action din(Bit#(8) value);
(*ready="dout_rdy",enable="dout_en",result="dout_data"*)
method ActionValue#(Bit#(8)) dout();
 (*ready="len_rdy",enable="len_en"*)
method Action len(Bit#(8) value);
 (*ready="cfg_rdy",enable="cfg_en",result="cfg_data_out"*)
method ActionValue#(Bit#(32)) cfg(Bit#(8) address,Bit#(32)data_in,Bool op);
endinterface

(*synthesize*)
module dut(Ifc_dut);
	Reg#(Bit#(8)) current_count <-mkRegA(0);
	Reg#(Bit#(8)) programmed_length <-mkRegA(0);
	Reg#(Bool) busy <-mkRegA(False);
	Reg#(Bool) sw_override <-mkRegA(False);
	Reg#(Bit#(8)) len_reg <-mkRegA(0);
	Reg#(Bit#(8)) sum <-mkRegA(0);
	FIFOF#(Bit#(8)) dout_ff <-mkFIFOF();
	Wire#(Bool) w_sw_override <-mkWire();
	Wire#(Bit#(8)) w_len_reg <-mkWire();

	rule set_len_reg;
		len_reg<= w_len_reg;
	endrule
	rule set_sw_override;
		sw_override<= w_sw_override;
	endrule

	(*descending_urgency="din,restart"*)
	rule restart (!busy && sw_override);
		programmed_length <= len_reg;
	endrule

method Action din(Bit#(8) value);
	let next_count=current_count+1;
	let next_sum = sum+value;
	if (next_count == programmed_length) begin
		if(sw_override) programmed_length <= len_reg;
		busy<=False;
		dout_ff.enq(next_sum);
	end
	else begin
		busy <= True;
		current_count <= next_count;
		sum <= next_sum;

	end
	endmethod
method ActionValue#(Bit#(8)) dout();
	let x = dout_ff.first();
	dout_ff.deq();
	return x;
endmethod
method Action len(Bit#(8) value);
	if(!sw_override && !busy)
		programmed_length <= value;
endmethod
method ActionValue#(Bit#(32)) cfg(Bit#(8) address,Bit#(32)data,Bool op);
	let rv=0;
	if(op) begin// Write
		case(address)
			4: w_sw_override<=(unpack(data[0]));
			8: w_len_reg <= data[7:0];
		endcase
	end else begin
		rv= case(address)
			0: return zeroExtend({pack(busy),programmed_length,current_count});
			4: return zeroExtend(pack(sw_override));
				8: return zeroExtend(len_reg);
		endcase;
	end
	return rv;
endmethod

endmodule
