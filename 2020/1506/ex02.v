module fsm(
	input clk,
	input rst, 
	input x,
	output reg u
);

parameter IDLE = 3'b000;
parameter S_0 = 3'b001;
parameter S_01 = 3'b010;
parameter S_010 = 3'b011;
parameter S_0101 = 3'b100;
parameter S_01011 = 3'b101;

reg [2:0] state, next_state;

always @(posedge clk or posedge rst) begin
	if(rst)
		state <= IDLE;
	else
		state <= next_state;
end

always @(*) begin
	next_state = state;
	u = 1'b0;
	
	case (state) 
		IDLE : begin
			if(x)
				next_state = IDLE;
			else
				next_state = S_0;
		end
		S_0: begin
			if(x)
				next_state = S_01;
			else
				next_state = S_0;
		end
		S_01: begin
			if(x)
				next_state = IDLE;
			else
				next_state = S_010;
		end
		S_010: begin
			if(x)
				next_state = S_0101;
			else
				next_state = S_0;
		end
		S_0101: begin
			if(x)
				next_state = S_01011;
			else
				next_state = S_010;
		end
		S_01011: begin
			u = 1'b1;
			if(x)
				next_state = IDLE;
			else
				next_state = S_0;
		end
		default:
			next_state = IDLE;
	endcase
end

endmodule