module moveRandomGen(
	input wire clk,
	input wire reset,
	input wire [1:0] nextMove,
	output reg [3:0] num
);
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)
		begin
			num <= 4'h0;
		end
		else
		begin
			case(nextMove)
				2'b00:
				begin
					
				end
				2'b01:
				2'b10:
				2'b11:
				default:
				begin
				
				end
			endcase
		end
	end
	
endmodule 