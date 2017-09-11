module mainStateMachine(
	input wire			clk,
	input wire			reset,
	input wire			setUpDone,
	input wire	[1:0]	movementLogic,
	input wire 			replay,
	input wire			delayDone,
	output wire			setUpGo,
	output wire			moveGo,
	output wire 		spawnGo,
	output wire			loseGo,
	output wire			delayGo
);
	
	reg [2:0] state;
	localparam 	setUp	= 3'b000,
					move 	= 3'b001,
					spawn 	= 3'b010,
					lose	= 3'b011,
					delay	= 3'b100;

/*****************************************************************************************
***************************** NEXT STATE LOGIC *******************************************
*****************************************************************************************/
			
	always_ff @ (posedge clk)
	begin
		if(reset  == 1'b1)
		begin
			state <= setUp;
		end//end if reset 1
		else
		begin
			case(state)
				setUp:
				begin
					if (setUpDone == 1'b1)	state <= move;
					else 							state <= setUp;
				end//setup
				move:
				begin
					case(movementLogic[1:0])
						2'b00:					state <= move;
						2'b01:					state <= delay;
						2'b10:					state <= spawn;
						2'b11:					state <= lose;
						default:					state <= move;
					endcase//end subcase
				end//move
				spawn:
				begin
					state <= delay;
				end
				lose:
				begin
					if(replay == 1'b1)		state <= setUp;
					else							state <= lose;
				end//lose
				delay:
				begin
					if(delayDone == 1'b1)	state <= move;
					else							state <= delay;
				end//delay
				default:
				begin
					state <= setUp;
				end//default
			endcase
		end//end if reset 0
	end//always posedge clk
	
/*****************************************************************************************
******************************** Output Logic ********************************************
*****************************************************************************************/

	assign setUpGo 	= ~state[2] & ~state[1] & ~state[0];	//000
	assign moveGo 		= ~state[2] & ~state[1] & state[0];		//001
	assign spawnGo 	= ~state[2] & state[1] & ~state[0];		//010
	assign loseGo	 	= ~state[2] & state[1] & state[0];		//011
	assign delayGo 	= state[2] & ~state[1] & ~state[0];		//100
	
endmodule 