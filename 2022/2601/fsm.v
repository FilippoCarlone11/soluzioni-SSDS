module fsm (
	input clk,
	input reset,
	input comb1, 
	input comb2, 
	input enter, 
	output reg error,
	output reg unlock);

parameter idle = 3'b000;
parameter s_firstlock = 3'b001;
parameter s_firstlock_safe = 3'b010; 
parameter closed = 3'b011;
parameter open = 3'b100;

reg [2:0] state, next_state;

always @(posedge clk) begin
	if(reset)
		state <= idle;
	else
		state <= next_state;
end

always @(*) begin
	next_state = state;
	error = 1'b0;
	unlock = 1'b0;
	
	case (state) 
		idle : begin
			if(enter) begin
				if(comb1)
					next_state = s_firstlock_safe;
				else
					next_state = s_firstlock;
			end else
				next_state = idle;
		end
		
		s_firstlock : begin
			if(enter)
				next_state = closed;
			else
				next_state = s_firstlock;
		end
		s_firstlock_safe:  begin
			if(enter) begin
				if(comb2)
					next_state = open;
				else
					next_state = closed;
			end else
				next_state = s_firstlock_safe;
		end
		closed:
			error = 1'b1;
		open:
			unlock = 1'b1;
		default:
			next_state = idle;
	endcase
end
endmodule