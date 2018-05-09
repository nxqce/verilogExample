module fifo_32(
	clock,
	write,
	datain,
	read,
	dataout,
	full,
	empty
	);
	
////////////////////////////////////////////////////////////////////////////////
// Port declarations	
	input clock;
	input write, read;
	input [7:0] datain;
	output [7:0] dataout;
	output full, empty;

////////////////////////////////////////////////////////////////////////////////
	
	reg [7:0] buffer [31:0];
	reg [5:0] wPtr, rPtr;
	reg [7:0] datatoutReg;

	wire writeEn, readEn;
	wire [4:0] wAddr, rAddr;
	
	assign dataout = dataoutReg;
	assign rAddr = rPtr[4:0];
	assign wAddr = wPtr[4:0];
	
	////////////////////////////////////////////////////////////////////////////////
	//Description:
	// Buffer is FULL when wPtr and rPtr are in different rounds and they met each other
	// Buffer is EMPTY when wPtr and rPtr are in the same round and they met each other
	assign full = (wPtr[5] != rPtr[5]) && (wAddr == rAddr);
	assign empty = (wPtr == rPtr);
	
	assign writeEn = ~full & write;
	assign readEn = ~empty & read;
	
	always @(posedge clock) begin
		if (writeEn) begin
			buffer[wAddr] <= datain;
			wPtr <= wPtr + 1'b1;
		end
	end
	
	always @(posedge clock) begin
		if (readEn) begin
			dataoutReg <= buffer[rAddr];
			rPtr <= rPtr + 1'b1;
		end
		else dataoutReg <= 8'b0;
	end
	
endmodule