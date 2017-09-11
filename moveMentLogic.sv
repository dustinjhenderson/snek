module moveMentLogic(
	input wire clk,
	input wire reset,
	input wire setUpGo,
	input wire upSig,	//11 in the case statement and nextMove register
	input wire downSig,	//10 in the case statement and nextMove register
	input wire leftSig,	//01 in the case statement and nextMove register
	input wire rightSig,	//00 in the case statement and nextMove register
	output reg map [0:11] [0:8],
	output reg [1:0] nextMove
);

	localparam	nxUp 		= 2'b11,
				nxDown		= 2'b10,
				nxLeft		= 2'b01,
				nxRight		= 2'b00;

	//reg map [0:8] [0:11];
	reg [3:0] xCord [0:53];
	reg [3:0] yCord [0:53];
	reg [1:0] moves [0:53];
	reg [5:0] score;
	//reg [1:0] nextMove;
	
	//reg [7:0] score;
	
	integer mapSetUp;
	integer setUpInt;
	integer shiftInt;
	integer moveCordInt;
	integer updateMap;
	integer updateMapIner;
	integer updateMapLoc;
	
	initial
	begin
		score <= 6'b000010;
	end
	
	always_ff @ (posedge clk)
	begin
		if(reset == 1'b1 || setUpGo == 1'b1)
		begin
			//map <= '{12'b0, 12'b0, 12'b000010000000, 12'b000010000000, 12'b000010000000, 12'b0, 12'b0, 12'b0, 12'b0};
			/* for(mapSetUp = 0; mapSetUp <= 11; mapSetUp = mapSetUp + 1)
			begin
				map[mapSetUp][0] <= 1'b0;
				map[mapSetUp][1] <= 1'b0;
				map[mapSetUp][2] <= 1'b0;
				map[mapSetUp][3] <= 1'b0;
				map[mapSetUp][4] <= 1'b0;
				map[mapSetUp][5] <= 1'b0;
				map[mapSetUp][6] <= 1'b0;
				map[mapSetUp][7] <= 1'b0;
				map[mapSetUp][8] <= 1'b0;
			end */
			for(setUpInt = 0; setUpInt <= 53; setUpInt = setUpInt + 1)
			begin
				moves[setUpInt] <= 2'b11;
				case(setUpInt)
					0:	
					begin
						yCord[setUpInt] <= 4'h4;
						xCord[setUpInt] <= 4'h4;
					end
					1:	
					begin
						yCord[setUpInt] <= 4'h3;
						xCord[setUpInt] <= 4'h4;
					end
					2:	
					begin
						yCord[setUpInt] <= 4'h2;
						xCord[setUpInt] <= 4'h4;
					end
					default:
					begin
						xCord[setUpInt] <= 4'hF;
						yCord[setUpInt] <= 4'hF;
					end
				endcase
/* 				if(setUpInt <= 2)
				begin
					xCord[setUpInt] <= 4'h4;
					yCord[setUpInt] <= setUpInt[3:0] + 4'h2;
				end
				else
				begin
					xCord[setUpInt] <= 4'hF;
					yCord[setUpInt] <= 4'hF;
				end// */
			end//end for loop for reset logic
			//$display("reset");
		end//end of if reset 1
		else
		begin
			for(shiftInt = 0; shiftInt >= 52; shiftInt = shiftInt - 1)
			begin
				moves[setUpInt + 1] <= moves[shiftInt]; 
			end//end of shift for loop
			moves[0] <= nextMove;				/////score[4:0] worked here//////////////////////////////////////////////
			for(moveCordInt = 0; moveCordInt <= score[4:0]; moveCordInt = moveCordInt + 1'b1)
			begin
				case(moves[moveCordInt])
					nxUp:
					begin
						if(yCord[moveCordInt] < 4'b1000)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt] + 1'b1;
						end
						else if(yCord[moveCordInt] == 4'b1000)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= 4'h0;
						end
						else
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
					end
					nxDown:
					begin
						if(yCord[moveCordInt] > 4'b0000)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt] - 1'b1;
						end
						else if(yCord[moveCordInt] == 4'b0000)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= 4'b1000;
						end
						else
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
					end
					nxLeft:
					begin
						if(xCord[moveCordInt] > 4'b0000)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt] - 1'b1;
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
						else if(score[5:0] > moveCordInt[5:0] && xCord[moveCordInt] == 4'b0000)
						begin
							xCord[moveCordInt] <= 4'b1011;
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
						else
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
					end
					nxRight:
					begin
						if(xCord[moveCordInt] < 4'b1011)
						begin
							xCord[moveCordInt] <= xCord[moveCordInt] + 1'b1;
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
						if(xCord[moveCordInt] == 4'b1011)
						begin
							xCord[moveCordInt] <= 4'b0000;
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
						else
						begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt];
						end
					end
					default:
					begin
							xCord[moveCordInt] <= xCord[moveCordInt];
							yCord[moveCordInt] <= yCord[moveCordInt];
					end
				endcase
			end//end of for loop for updating cordnates
		/*	
			for(updateMap = 0; updateMap <= 8; updateMap = updateMap + 1)
			begin
				for(updateMapIner = 0; updateMapIner <= 11; updateMapIner = updateMapIner + 1)
				begin
					for(updateMapLoc = 0; updateMapLoc <= 53; updateMapLoc = updateMapLoc + 1)
					begin
						//if(score[5:0] > updateMap[5:0])
						//begin
							if(xCord[updateMapLoc] == updateMapIner[3:0] && yCord[updateMapLoc] == updateMap[3:0])
							begin
								map [updateMapIner] [updateMap] <= 1'b1;
								break;
							end//
							else
							begin
								map [updateMapIner][updateMap] <= 1'b0;
							end//
						//end//in side score
						//else
						//begin
							//map [updateMapIner][updateMapLoc] <= map [updateMapIner][updateMapLoc];
						//end//if else if outside of score
					end//end
				end//end
			end								*/ //end of for loop for regenerating map
		end//end of else reset
	end//end of always block
	
	/****************************************************************************
	*******************Combinational Logic For Next Move Rules*******************
	*****************************************************************************/
	always_comb//look at using x in case statement
	begin
		casex({upSig, downSig, leftSig, rightSig})
			4'b1XXX:	//Up
			begin
				if(moves[0] == 10)	nextMove = moves[0];	//think about changing this to not be the move register for timing...
				else				nextMove = 2'b11;
			end
			4'b01XX:	//Down
			begin
				if(moves[0] == 11)	nextMove = moves[0];
				else				nextMove = 2'b10;
			end	
			4'b001X:	//left
			begin
				if(moves[0] == 00)	nextMove = moves[0];
				else				nextMove = 2'b01;
			end	
			4'b0001:	//right
			begin
				if(moves[0] == 01)	nextMove = moves[0];
				else				nextMove = 2'b00;
			end
			default:
			begin
				nextMove = moves[0];
			end
		endcase
	end//combinational Output for nextMove
	
	always_comb
	begin
			for(updateMap = 0; updateMap <= 8; updateMap = updateMap + 1)
			begin
				for(updateMapIner = 0; updateMapIner <= 11; updateMapIner = updateMapIner + 1)
				begin
					for(updateMapLoc = 0; updateMapLoc <= 53; updateMapLoc = updateMapLoc + 1)
					begin
						//if(score[5:0] > updateMap[5:0])
						//begin
							if(xCord[updateMapLoc] == updateMapIner[3:0] && yCord[updateMapLoc] == updateMap[3:0])
							begin
								map [updateMapIner] [updateMap] = 1'b1;
								break;
							end//
							else
							begin
								map [updateMapIner][updateMap] = 1'b0;
							end//
						//end//in side score
						//else
						//begin
							//map [updateMapIner][updateMapLoc] <= map [updateMapIner][updateMapLoc];
						//end//if else if outside of score
					end//end
				end//end
			end//end of for loop for regenerating map
	end
	
	
endmodule//end of the module









