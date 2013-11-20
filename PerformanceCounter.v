	
	
	
	
	always @(posedge clock or posedge reset)
	begin
		if (reset) counter <= 0;
	end