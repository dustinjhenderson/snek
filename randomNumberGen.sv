module randomNumberGen(
	input wire clk,
	input wire reset,
	output wire [3:0] outPutNum
);

	//wire [2:0] newBit;
	reg [3:0] shiftReg;
	
	integer i;
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)
		begin
			shiftReg <= 4'h1;
		end
		else
		begin
			shiftReg[3] <= shiftReg[1] ^ shiftReg[0];
			for(i = 3; i > 0 ; i = i - 1)
			begin
				shiftReg[i - 1] <= shiftReg[i];
			end
		end
	end
	
	//assign newBit[0] = shiftReg[2] ^ shiftReg[0];
	//assign newBit[1] = shiftReg[3] ^ newBit[0];
	//assign newBit[2] = shiftReg[4] ^ newBit[1];
	assign outPutNum[3:0] = shiftReg[3:0];
	
endmodule 