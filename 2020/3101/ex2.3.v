module fsm (
    	input clk,
    	input bi,
	input rst,
    	output reg bo
);

	parameter IDLE = 2'b00;
	parameter PRESSED = 2'b01;
	parameter WAIT = 2'b10;
	

    	reg [1:0] state, next_state;

    	always @(posedge clk) begin
		if(rst)
			state <= IDLE;
		else
        		state <= next_state;
    	end

    	always @(*) begin
        	next_state = state;
        	bo = 1'b0;          

        	case (state)
            		IDLE: begin     
                		bo <= 1'b0;
                		if (bi)
                    			next_state = PRESSED;
               			else
                    			next_state = IDLE;
			end
            		PRESSED: begin   
               			bo = 1'b1;
                		next_state = WAIT;
			end
			WAIT: begin
				bo = 1'b0;
				if(bi)
					next_state = WAIT;
				else
					next_state = IDLE;
            		end
        	endcase
    	end

endmodule