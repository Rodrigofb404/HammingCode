module hamming (clk, endereco , mudanca, mensagem, resultado, out0, out1, out2, out3, out4, out5, out6, out7, encode, enviar, reset);
input clk;
input endereco;
input enviar;
output [7:0] resultado;
input [7:0] mensagem; 
input mudanca;
input encode;
input reset;
reg [3:0] aleatorio;
reg [3:0] aleatorio2;
reg[11:0] hamming;
reg[7:0] final;
reg [3:0] detectar;
reg [3:0] deteccao;
reg [3:0] concat;
reg mudanca_prev;
reg[7:0] slave1;
reg[7:0] slave2;
reg[11:0] semifinal;
output reg [6:0] out0;
output reg [6:0] out1;
output reg [6:0] out2;
output reg [6:0] out3;
output reg [6:0] out4;
output reg [6:0] out5;
output reg [6:0] out6;
output reg [6:0] out7;


	always @(posedge encode or posedge reset) begin
		  if(reset) begin
				hamming[2] = 1'bx;
				hamming[4] = 1'bx; 
				hamming[5] = 1'bx;
				hamming[6] = 1'bx;
				hamming[8] = 1'bx;
				hamming[9] = 1'bx;
				hamming[10] = 1'bx;
				hamming[11] = 1'bx;
				hamming[0] = 1'bx;
				hamming[1] = 1'bx;
				hamming[3] = 1'bx;
				hamming[7] = 1'bx;
			end else begin
				hamming[2] = mensagem[0];
				hamming[4] = mensagem[1];
				hamming[5] = mensagem[2];
				hamming[6] = mensagem[3];
				hamming[8] = mensagem[4];
				hamming[9] = mensagem[5];
				hamming[10] = mensagem[6];
				hamming[11] = mensagem[7];
				hamming[0] = mensagem[0] ^ mensagem[1] ^ mensagem[3] ^ mensagem[4] ^ mensagem[6];
				hamming[1] = mensagem[0] ^ mensagem[2] ^ mensagem[3] ^ mensagem[5] ^ mensagem[6];
				hamming[3] = mensagem[1] ^ mensagem[2] ^ mensagem[3] ^ mensagem[7];
				hamming[7] = mensagem[4] ^ mensagem[5] ^ mensagem[6] ^ mensagem[7];
				if(mudanca) begin
					hamming[aleatorio] <= !hamming[aleatorio];
				end
		 end
	end
initial begin
	aleatorio = 4'b0000;
end

always @(posedge clk) begin
	aleatorio <= aleatorio + 1'b1;
	if (aleatorio == 4'b1011)begin
		aleatorio <= 4'b0000;
	end
end
task bcd7seg_bl;
output reg [6:0] out0;
output reg [6:0] out1;
output reg [6:0] out2;
output reg [6:0] out3;
output reg [6:0] out4;
output reg [6:0] out5;
output reg [6:0] out6;
output reg [6:0] out7;
input [7:0] final;
begin
   case(final[0])
        1'b0: out0 <= 7'b1000000;
        1'b1: out0 <= 7'b1111001;     
        default: out0 <= 7'b0000110;  // 0 
   endcase 
   case(final[1])
        1'b0: out1 <= 7'b1000000;
        1'b1: out1 <= 7'b1111001;     
        default: out1 <= 7'b0000110;  // 0 
   endcase 
   case(final[2])
        1'b0: out2 <= 7'b1000000;
        1'b1: out2 <= 7'b1111001;     
        default: out2 <= 7'b0000110;  // 0 
   endcase 
   case(final[3])
        1'b0: out3 <= 7'b1000000;
        1'b1: out3 <= 7'b1111001;     
        default: out3 <= 7'b0000110;  // 0 
   endcase 
   case(final[4])
        1'b0: out4 <= 7'b1000000;
        1'b1: out4 <= 7'b1111001;     
        default: out4 <= 7'b0000110;  // 0 
   endcase 
   case(final[5])
        1'b0: out5 <= 7'b1000000;
        1'b1: out5 <= 7'b1111001;     
        default: out5 <= 7'b0000110;  // 0 
   endcase 
   case(final[6])
        1'b0: out6 <= 7'b1000000;
        1'b1: out6 <= 7'b1111001;     
        default: out6 <= 7'b0000110;  // 0 
   endcase
   case(final[7])
        1'b0: out7 <= 7'b1000000;
        1'b1: out7 <= 7'b1111001;     
        default: out7 <= 7'b0000110;  // 0 
   endcase
end
endtask 

always @(posedge clk) begin
    deteccao[0] <= hamming[0] ^ hamming[2] ^ hamming[4] ^ hamming[6] ^ hamming[8] ^ hamming[10];
    deteccao[1] <= hamming[1] ^ hamming[2] ^ hamming[5] ^ hamming[6] ^ hamming[9] ^ hamming[10];
    deteccao[2] <= hamming[3] ^ hamming[4] ^ hamming[5] ^ hamming[6] ^ hamming[11];
    deteccao[3] <= hamming[7] ^ hamming[8] ^ hamming[9] ^ hamming[10] ^ hamming[11];
	 if(reset)begin
		deteccao[0] <= 1'bx;
		deteccao[1] <= 1'bx;
		deteccao[2] <= 1'bx;
		deteccao[3] <= 1'bx;
	 end
end

always @(posedge clk) begin
    concat <= {deteccao[3], deteccao[2], deteccao[1], deteccao[0]};
    if (concat != 4'b0000) begin
        case(concat) 
			4'b0001: detectar <= 4'd1;
			4'b0010: detectar <= 4'd2;
			4'b0011: detectar <= 4'd3;
			4'b0100: detectar <= 4'd4;
			4'b0101: detectar <= 4'd5;
			4'b0110: detectar <= 4'd6;
			4'b0111: detectar <= 4'd7;
			4'b1000: detectar <= 4'd8;
			4'b1001: detectar <= 4'd9;
			4'b1010: detectar <= 4'd10;
			4'b1011: detectar <= 4'd11;
			4'b1100: detectar <= 4'd12;
			4'b1101: detectar <= 4'd13;
			4'b1110: detectar <= 4'd14;
			4'b1111: detectar <= 4'd15;
			default: detectar <= 4'd0;
		endcase
   end
end
always @(*) begin // correção do código
	semifinal[11:0] = hamming[11:0];
	semifinal[detectar-1] = !semifinal[detectar-1];
	final[0] = semifinal[2];
	final[1] = semifinal[4];
	final[2] = semifinal[5];
	final[3] = semifinal[6];
	final[4] = semifinal[8];
	final[5] = semifinal[9];
	final[6] = semifinal[10];
	final[7] = semifinal[11];
	if (reset) begin
		final[7:0] = 8'bxxxxxxxx;
		semifinal[11:0] = 12'bxxxxxxxxxxxx;
	end
end
always @(posedge clk) begin
	if (reset)begin
		out0 <= 7'bxxxxxxx;
		out1 <= 7'bxxxxxxx;
		out2 <= 7'bxxxxxxx;
		out3 <= 7'bxxxxxxx;
		out4 <= 7'bxxxxxxx;
		out5 <= 7'bxxxxxxx;
		out6 <= 7'bxxxxxxx;
		out7 <= 7'bxxxxxxx;
		slave1 <= 8'bxxxxxxxx;
		slave2 <= 8'bxxxxxxxx;
	end
	if (endereco == 1'b0) begin
		if (enviar == 1'b1) begin
			slave1[7:0] <= final[7:0];
		end
		bcd7seg_bl(out0, out1, out2, out3, out4, out5, out6, out7, slave1);
	end
	if (endereco == 1'b1) begin
		if (enviar == 1'b1) begin
			slave2[7:0] <= final[7:0];
		end
		bcd7seg_bl(out0, out1, out2, out3, out4, out5, out6, out7, slave2);
	end
end

endmodule