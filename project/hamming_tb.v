module hamming_tb();
  integer i;
  reg [10:0] data [0:2047];
  reg clk_tb, endereco_tb, mudanca_tb, encode_tb, enviar_tb, reset_tb;
  reg [7:0] mensagem_tb;
  wire [7:0] resultado_tb;
  wire [6:0] out0_tb, out1_tb, out2_tb, out3_tb, out4_tb, out5_tb, out6_tb, out7_tb;


  hamming ham(.clk(clk_tb), .endereco(endereco_tb) , .mudanca(mudanca_tb), .mensagem(mensagem_tb), .resultado(resultado_tb), .out0(out0_tb), .out1(out1_tb), .out2(out2_tb), .out3(out3_tb), .out4(out4_tb), .out5(out5_tb), .out6(out6_tb), .out7(out7_tb), .encode(encode_tb), .enviar(enviar_tb), .reset(reset_tb));

  always begin
    #1 clk_tb = ~clk_tb;
  end

  initial begin
    clk_tb = 1'b0;
    $readmemb("inputs.txt", data);
    for (i = 0; i < 2048; i = i + 1) begin
      encode_tb = 1'b0;
      endereco_tb = 1'b0;
      enviar_tb = 1'b0;
      mensagem_tb[0] = 1'b0;
      mensagem_tb[1] = 1'b0;
      mensagem_tb[2] = 1'b0;
      mensagem_tb[3] = 1'b0;
      mensagem_tb[4] = 1'b0;
      mensagem_tb[5] = 1'b0;
      mensagem_tb[6] = 1'b0;
      mensagem_tb[7] = 1'b0;
      reset_tb = 1'b1;
      #2;
      reset_tb = 1'b0;
      {encode_tb, endereco_tb, enviar_tb, mensagem_tb[7], mensagem_tb[6], mensagem_tb[5], mensagem_tb[4], mensagem_tb[3], mensagem_tb[2], mensagem_tb[1], mensagem_tb[0]} = {data[i][10], data[i][9], data[i][8], data[i][7], data[i][6], data[i][5], data[i][4], data[i][3], data[i][2], data[i][1], data[i][0]};
      //$display("Resultado[%0d]: encode:%b endereco:%b enviar:%b mensagem: %b", i, encode_tb, endereco_tb, enviar_tb, mensagem_tb);
      #2;
      //$display("Resultado[%0d]: %b%b%b%b", i, ham.slave1, ham.slave2, ham.hamming, mensagem_tb);
      $display("%b%b%b%b", ham.slave1, ham.slave2, ham.hamming, mensagem_tb);
    end
    $finish;
  end
endmodule