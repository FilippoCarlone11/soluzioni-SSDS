module fsm (
	input clk,
	input rst,
	input x,
	output reg z);


parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or posedge rst) begin
	if(rst) 
		state <= S1;
	else
		state <= next_state;

end

always @(*) begin
	next_state = state;
	z = 1'b0;

	case (state)
		S1: begin
			z = 1'b0;
			if(x)	
				next_state = S2;
			else
				next_state = S1;
		end
		S2: begin
			z = 1'b0;
			if(x)	
				next_state = S3;
			else
				next_state = S1;
		end
		S3: begin
			z = 1'b1;
			if(x)	
				next_state = S3;
			else
				next_state = S1;
		end

		default:
			next_state = S1;
	endcase 
	
end



endmodule