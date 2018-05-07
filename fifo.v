module fifo (
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
	reg [4:0] wPtr, rPtr
	reg [5:0] length;
	reg [7:0] datatoutReg;
	reg fullReg, emptyReg;

	wire writeEn, readEn;
	
	assign dataout = dataoutReg;
	assign full = fullReg;
	assign empty = emptyReg;
	
	assign writeEn = ~full & write;
	assign readEn = ~empty & read;
		
	always @(length) begin
		if (length == 5'd0) emptyReg = 1'b1;
		else if (length == 5'd32) fullReg = 1'b1;
		else begin
			emptyReg = 1'b0;
			fullReg = 1'b0;
		end
	end
	
	always @(posedge clock) begin
		if (writeEn && readEn) begin
			buffer[wPtr] <= datain;
			dataoutReg <= buffer[rPtr];
			wPtr <= wPtr + 1'b1;
			rPtr <= rPtr + 1'b1;
		end
		else if (writeEn) begin
			buffer[wPtr] <= datain;
			wPtr <= wPtr + 1'b1;
			length <= length + 1'b1;
		end
		else if (readEn) begin
			dataoutReg <= buffer[rPtr];
			rPtr <= rPtr + 1'b1;
			length <= length - 1'b1;
		end
		else dataoutReg <= 8'b0;
	end
	
endmodule