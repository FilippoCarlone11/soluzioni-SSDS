module fsm_mealy (
	input x,
	input clk,
	input rst,
	output reg z
);

parameter IDLE = 2'b00;
parameter S_0 = 2'b01;
parameter S_01 = 2'b10;

reg [1:0] state, next_state;

always @(posedge clk) begin
	if(rst)
		state <= IDLE;
	else
		state <= next_state;
end

always @(*) begin
	next_state = state;
	z = 1'b0;
	
	case (state)
		IDLE:
			if(x)
				next_state = IDLE;	
			else
				next_state = S_0;
		S_0:
			if(x)
				next_state = S_01;	
			else
				next_state = S_0;

		S_01:
			if(x) begin
				next_state = IDLE;	
				z = 1'b1;
			end else
				next_state = S_01;

	endcase
end


endmodule