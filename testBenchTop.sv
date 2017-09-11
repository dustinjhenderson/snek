`timescale 1ns/1ps
module testBenchTop(
	output wire testOut
);
	
	assign testOut = 1'b0;

	reg reset;
	reg clk;
	reg setUpDone;
	reg [1:0] moveLogic;
	reg replay;
	reg upSig;
	reg downSig;
	reg leftSig;
	reg rightSig;
	reg [3:0] delayCounter;
	wire map [0:11][0:8];
	
	wire moveGo;
	wire spawnGo;
	wire loseGo;
	wire delayGo;
	wire setUpGo;
	wire delayDone;
	wire [3:0] randomNumberX;
	wire [3:0] randomNumberY;
	wire [1:0] nextMove;
	wire [3:0] xcord;
	wire [3:0] ycord;
	
	initial
	begin
		#0	
				reset 		= 1'b1;
				clk 			= 1'b0;
				setUpDone 	= 1'b0;
				upSig			= 1'b0;
				downSig		= 1'b0;
				leftSig 		= 1'b0;
				rightSig		= 1'b0;
				//moveLogic 	= 2'b00;
				//replay 		= 1'b0;
				//delayDone 	= 1'b0;
		#5	
				reset 		= 1'b0;
		#6	
				setUpDone	= 1'b1;
	end
	
	always
	begin
		#2	clk <= ~clk;
	end
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)			moveLogic <= 2'b00;
		else
		begin
			if(moveGo == 1'b1)	moveLogic <= moveLogic + 1'b1;
			else						moveLogic <= moveLogic;
		end
	end
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)			replay <= 1'b0;
		else
		begin
			if(loseGo == 1'b1)	replay <= 1'b1;
			else						replay <= 1'b0;
		end
	end
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1)
		begin
										delayCounter <= 4'h0;
										//delayDone <= 1'b0;
		end
		else
		begin
			if(delayGo == 1'b1)	delayCounter <= delayCounter + 1'b1;
			else						delayCounter <= delayCounter;
		end
	end
	
	assign delayDone = delayCounter[0] & delayCounter[1] & delayCounter[2] & delayCounter[3];
	
	mainStateMachine MainMachine(
											.clk(clk),
											.reset(reset),
											.setUpDone(setUpDone),
											.movementLogic(moveLogic[1:0]),
											.replay(replay),
											.delayDone(delayDone),
											.setUpGo(setUpGo),
											.moveGo(moveGo),
											.spawnGo(spawnGo),
											.loseGo(loseGo),
											.delayGo(delayGo)
	);

	moveMentLogic moveMentLogicYo(
											.clk(clk),
											.reset(reset),
											.setUpGo(setUpGo),
											.upSig(upSig),
											.downSig(downSig),
											.leftSig(leftSig),
											.rightSig(rightSig),
											.map(map),
											.nextMove(nextMove[1:0])
	);
	
	moveRandomGenX generatePos(
											.clk(clk),
											.reset(reset),
											.nextMove(nextMove[1:0]),
											.xcord(xcord[3:0]),
											.ycord(ycord[3:0])
	);
	
//	module moveRandomGen(
//	input wire clk,
//	input wire reset,
//	input wire [1:0] nextMove,
//	output reg [3:0] xcord,
//	output reg [3:0] ycord
//	);
	
//	randomNumberGen generateX(
//		.clk(clk),
//		.reset(reset),
//		.outPutNum(randomNumberX[3:0])
//	);
//	
//	randomNumberGen generateY(
//		.clk(clk),
//		.reset(reset),
//		.outPutNum(randomNumberY[3:0])
//	);

endmodule 