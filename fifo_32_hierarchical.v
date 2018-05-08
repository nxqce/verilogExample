module fifo_32_hierachical(
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

	wire [5:0] writePtr, readPtr;
	wire writeEn, readEn;
	wire [4:0] writeAddr, readAddr;
	
	assign readAddr = readPtr[4:0];
	assign writeAddr = writePtr[4:0];
	
	fifo_read u0 (
		.clock(clock),
		.readEn(readEn)
		.readPtr(readPtr)
		);
		
	fifo_write u1 (
		.clock(clock),
		.writeEn(writeEn),
		.writePtr(writePtr)
		);
		
	buffer u2 (
		.clock(clock),
		.writeEn(writeEn),
		.writeAddr(writeAddr),
		.datain(datain),
		.readEn(readEn),
		.readAddr(readAddr),
		.dataout(dataout)
		);
		
	fifo_status u3 (
		.write(write),
		.writePtr(writePtr),
		.read(read),
		.readPtr(readPtr),
		.writeEn(writeEn),
		.readEn(readEn),
		.full(full),
		.empty(empty)
		);
	
endmodule

////////////////////////////////////////////////////////////////////////////////
// module: fifo_read
////////////////////////////////////////////////////////////////////////////////
module fifo_read (
	clock, 
	readEn, 
	readPtr
	);
	
////////////////////////////////////////////////////////////////////////////////
// Port declarations
	input clock, readEn;
	output [5:0] readPtr;
////////////////////////////////////////////////////////////////////////////////
	
	reg [5:0] readPtrReg;

	
	always @(posedge clock) begin
		if (readEn) begin
			readPtrReg <= readPtrReg + 1'b1;
		end
	end
	
endmodule

////////////////////////////////////////////////////////////////////////////////
// module: fifo_write
////////////////////////////////////////////////////////////////////////////////
module fifo_write (
	clock,
	writeEn,
	writePtr
	);
	
////////////////////////////////////////////////////////////////////////////////
// Port declarations
	input clock, writeEn;
	output [5:0] writePtr;
////////////////////////////////////////////////////////////////////////////////
	
	reg [5:0] writePtrReg;
	
	always @(posedge clock) begin
		if (readEn) begin
			writePtrReg <= writePtrReg + 1'b1;
		end
	end
	
endmodule

////////////////////////////////////////////////////////////////////////////////
// module: buffer
////////////////////////////////////////////////////////////////////////////////
module buffer (
	clock,
	writeEn,
	writeAddr,
	datain,
	readEn,
	readAddr,
	dataout
	);

////////////////////////////////////////////////////////////////////////////////
// Port declarations
	input clock, writeEn, readEn;
	input [4:0] writeAddr, readAddr;
	input [7:0] datain;
	output [7:0] dataout;
////////////////////////////////////////////////////////////////////////////////
	
	reg [7:0] buffer [31:0];
	reg [7:0] datatoutReg;
	
	assign dataout = dataoutReg;
	
	always @(posedge clock) begin
		else if (writeEn) begin
			buffer[wAddr] <= datain;
		end
	end
	
	always @(posedge clock) begin
		else if (readEn) begin
			dataoutReg <= buffer[rAddr];
		end
		else dataoutReg <= 8'b0;
	end
	
endmodule

////////////////////////////////////////////////////////////////////////////////
// module: fifo_status
////////////////////////////////////////////////////////////////////////////////
module fifo_status (
	write,
	writePtr,
	read,
	readPtr,
	writeEn,
	readEn,
	full,
	empty
	);
	
////////////////////////////////////////////////////////////////////////////////
// Port declarations
	input write, writeFlag, read, readFlag;
	output writeEn, readEn, full, empty;
////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
	//Description:
	// Buffer is FULL when wPtr and rPtr are in different rounds and they met each other
	// Buffer is EMPTY when wPtr and rPtr are in the same round and they met each other
	assign full = (writePtr[5] ^ readPtr[5]) & !(writePtr[4:0] ^ readPtr[4:0]);
	assign empty = !(writePtr[5] ^ readPtr[5]) & !(writePtr[4:0] ^ readPtr[4:0]);
	
	assign writeEn = ~full & write;
	assign readEn = ~empty & read;
	
endmodule