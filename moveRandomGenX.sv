module moveRandomGenX(
	input wire clk,
	input wire reset,
	input wire [1:0] nextMove,
	output reg [3:0] xcord,
	output reg [3:0] ycord
);
	
	//max x 4b1011
	//max y 4b1000
	/*
	localparam	nxUp 		= 2'b11,
				nxDown		= 2'b10,
				nxLeft		= 2'b01,
				nxRight		= 2'b00;
	*/

	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)
		begin
			xcord <= 4'h0;
			ycord <= 4'h0;
		end
		else
		begin
			case(nextMove)
				2'b00:
				begin
					if(ycord < 4'b1000) ycord <= ycord + 1'b1;
					else				ycord <= 4'h0;
					xcord <= xcord;
				end
				2'b01:
				begin
					if(ycord > 4'b0000)	ycord <= ycord - 1'b1;
					else				ycord <= 4'b1000;
					xcord <= xcord;
				end
				2'b10:
				begin
					if(xcord < 4'b1011)	xcord <= xcord + 1'b1;
					else				xcord <= 4'b0000;
					ycord <= ycord;
				end
				2'b11:
				begin
					if(xcord > 4'b0000)	xcord <= xcord - 1'b1;
					else				xcord <= 4'b1011;
					ycord <= ycord;
				end
				default:
				begin
					ycord <= ycord;
					xcord <= xcord;
				end
			endcase
		end
	end
	
	
	
endmodule 