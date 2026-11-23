
module sdes(
    input clk, input ctrl1, input ctrl2,input ctrl3,input ctrl4,input ctrl5,input ctrl6,
    input ctrl7, input ctrl8,
    input [1:4] message_sw,   // Short message input (4-bit)
    input [1:3] K1_sw,        // Short Key 1 (3-bit)
    input [1:3] K2_sw,        // Short Key 2 (3-bit)
    input mode,               // Mode: 0 = Encryption, 1 = Decryption
    output [1:64] encrypt_value,output [1:64] decrypt_value,
    output y // Final encrypted or decrypted output
  );
   wire [31:0] err = 32'b11111111111111111111111111111111;
    wire [1:64] message, K1, K2; // Expanded versions of inputs
    wire [1:64] encrypted_message, decrypted_message;
    wire [31:0] j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16;
       wire [16:1] ft;

    // Convert short inputs to full 64-bit message and keys
    tdes_demux_2025 inp(clk, message_sw, K1_sw, K2_sw, message, K1, K2);

    // Encryption Module (Takes expanded inputs)
   
  SingleDES_jap_2025 sd1(clk,message_sw,K1_sw,K2_sw, decrypt_value, encrypt_value,
       j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16);
   
   
 sdes_compare_2025_err1 sd2(clk,ctrl1, ctrl2,ctrl3,ctrl4,err,
       j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,ft[8:1]);
  
   
  sdes_compare_2025_err1 sd3(clk,ctrl5, ctrl6,ctrl7,ctrl8,err,
       j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,ft[16:9]);
        
     tdes_fault_2025 sd4(clk,ft,y);

endmodule



module tdes_demux_2025(input clk, 
    input [3:0] message_sw,  // Adjusted width
    input [2:0] key1_sw,     // Adjusted width
    input [2:0] key2_sw,     // Adjusted width
    output reg [63:0] y,
    output reg [63:0] z,
    output reg [63:0] x
);

    // Message selection
    always @(posedge clk) begin
        case (message_sw)
            4'b0000: y = 64'b0001001000110100010101101010101111001101000100110010010100110110;
            4'b0001: y = 64'b0100010000100001101010111111101000110111010001011101111011001010;
            4'b0010: y = 64'b0101010000110010100010011100110110111010111111110110011100110010;
            4'b0011: y = 64'b1010101100010001101111000010001000110100110111010101011010101111;
            4'b0100: y = 64'b0001001000110100001100111101110101000100111111111001100001010001;
            4'b0101: y = 64'b1110111111101111111110101111101010111100101111001101101011011011;
            4'b0110: y = 64'b1011101000010100111110100110010100100011010000010110100001010111;
            4'b0111: y = 64'b1101110001111000101110100110010100010010111011110011010001000011;
            4'b1000: y = 64'b1001100011001101010000100001001111001010101111011111111010101011;
            4'b1001: y = 64'b0001010110001001101011001111111000110111010000101101101101100100;
            4'b1010: y = 64'b0100010000100001101010111111101000110111010001011101111011001010;
            4'b1011: y = 64'b0110011110001001111111101101110001000011001000011010101101010100;
            4'b1100: y = 64'b0001000100100010001100110100010010101010101110111110111011011101;
            4'b1101: y = 64'b0001000100010001001000100010001011001100110011001010101111001101;
            4'b1110: y = 64'b0001001000100011101010111011110001000101010101101100110111001101;
            4'b1111: y = 64'b1111111101000100000100100011010011011101001100110100001100100001;
            default: y = 64'b0;
        endcase
    end

    // Key1 selection
    always @(posedge clk) begin
        case (key1_sw)
            3'b000: z = 64'b0001001000110100010101101010101111001101000100110010010100110110;
            3'b001: z = 64'b0100010000100001101010111111101000110111010001011101111011001010;
            3'b010: z = 64'b0101010000110010100010011100110110111010111111110110011100110010;
            3'b011: z = 64'b1010101100010001101111000010001000110100110111010101011010101111;
            3'b100: z = 64'b0001001000110100001100111101110101000100111111111001100001010001;
            3'b101: z = 64'b1110111111101111111110101111101010111100101111001101101011011011;
            3'b110: z = 64'b1011101000010100111110100110010100100011010000010110100001010111;
            3'b111: z = 64'b1101110001111000101110100110010100010010111011110011010001000011;
            default: z = 64'b0;
        endcase
    end

    // Key2 selection
    always @(posedge clk) begin
        case (key2_sw)
            3'b000: x = 64'b0001001000110100010101101010101111001101000100110010010100110110;
            3'b001: x = 64'b0100010000100001101010111111101000110111010001011101111011001010;
            3'b010: x = 64'b0101010000110010100010011100110110111010111111110110011100110010;
            3'b011: x = 64'b1010101100010001101111000010001000110100110111010101011010101111;
            3'b100: x = 64'b0001001000110100001100111101110101000100111111111001100001010001;
            3'b101: x = 64'b1110111111101111111110101111101010111100101111001101101011011011;
            3'b110: x = 64'b1011101000010100111110100110010100100011010000010110100001010111;
            3'b111: x = 64'b1101110001111000101110100110010100010010111011110011010001000011;
            default: x = 64'b0;
        endcase
    end

endmodule


module SingleDES_jap_2025(input clk,
    input [1:4] message_sw,
    input [1:3] K1_sw,
    input [1:3] K2_sw,
    output [1:64] decrypt_value,  output [1:64] encrypt_value, 
    output [31:0]j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16);
    wire [1:64]EM1,EM2;
	 wire [1:64]message,K1,K2;
	tdes_demux_2025 inp(clk, message_sw, K1_sw, K2_sw, message, K1, K2); 
    Single_DES_main_2025 D1(clk,message,K1,EM1,j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16);
    Single_DES_main_decrypt_2025 D2(clk,EM1,K2,EM2,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16);
    	 assign decrypt_value = EM1;
    	 assign encrypt_value = EM2;
endmodule


module Single_DES_main_2025(input clk,
    input [1:64] message,
    input [1:64] key, 
    output  [1:64] encrypted_message,
    output [31:0] j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16);
wire [1:56] key_pc1;       
wire [1:56] k1, k2, k3, k4, k5, k6, k7, k8, 
            k9, k10, k11, k12, k13, k14, k15, k16;
wire [1:48] K1, K2, K3, K4, K5, K6, K7, K8, 
            K9, K10, K11, K12, K13, K14, K15, K16;
wire [1:48*16] key_pc2;
wire [1:32] L;
wire [1:32] R;
wire [1:64] M;
assign M=message;
wire [1:32] L1, L2, L3, L4, L5, L6, L7, L8, 
            L9, L10, L11, L12, L13, L14, L15, L16;
wire [1:32] R1, R2, R3, R4, R5, R6, R7, R8, 
            R9, R10, R11, R12, R13, R14, R15, R16;

//PHASE1(verified)
pc1_2025 PC1_inst(.clk(clk),.key(key),.key_pc1(key_pc1));
IP_2025 IP_inst(.clk(clk),.M(M),.L(L),.R(R));
Lshift_2025 LS(.clk(clk),.key_pc1(key_pc1),.k1(k1), .k2(k2), .k3(k3), .k4(k4), .k5(k5), .k6(k6), .k7(k7), .k8(k8), 
.k9(k9), .k10(k10), .k11(k11),.k12(k12), .k13(k13), .k14(k14), .k15(k15), .k16(k16));

// Permuted Choice 2 (PC2)
pc2_2025 PC2_1(.clk(clk),.k(k1), .subkey(K1));
pc2_2025 PC2_2(.clk(clk),.k(k2),  .subkey(K2));
pc2_2025 PC2_3(.clk(clk),.k(k3),  .subkey(K3));
pc2_2025 PC2_4(.clk(clk),.k(k4),  .subkey(K4));
pc2_2025 PC2_5(.clk(clk),.k(k5),  .subkey(K5));
pc2_2025 PC2_6(.clk(clk),.k(k6),  .subkey(K6));
pc2_2025 PC2_7(.clk(clk),.k(k7),  .subkey(K7));
pc2_2025 PC2_8(.clk(clk),.k(k8),  .subkey(K8));
pc2_2025 PC2_9(.clk(clk),.k(k9),  .subkey(K9));
pc2_2025 PC2_10(.clk(clk),.k(k10), .subkey(K10));
pc2_2025 PC2_11(.clk(clk),.k(k11), .subkey(K11));
pc2_2025 PC2_12(.clk(clk),.k(k12), .subkey(K12));
pc2_2025 PC2_13(.clk(clk),.k(k13), .subkey(K13));
pc2_2025 PC2_14(.clk(clk),.k(k14), .subkey(K14));
pc2_2025 PC2_15(.clk(clk),.k(k15), .subkey(K15));
pc2_2025 PC2_16(.clk(clk),.k(k16), .subkey(K16));
//Phase 1/2 ends

//phase 3
roundbro_2025 rnd1(.clk(clk),.L(L),.R(R),.L_(L1),.R_(R1),.K(K1));

roundbro_2025 rnd2(.clk(clk),.L(L1),.R(R1),.L_(L2),.R_(R2),.K(K2));

roundbro_2025 rnd3(.clk(clk),.L(L2),.R(R2),.L_(L3),.R_(R3),.K(K3));

roundbro_2025 rnd4(.clk(clk),.L(L3),.R(R3),.L_(L4),.R_(R4),.K(K4));

roundbro_2025 rnd5(.clk(clk),.L(L4),.R(R4),.L_(L5),.R_(R5),.K(K5));

roundbro_2025 rnd6(.clk(clk),.L(L5),.R(R5),.L_(L6),.R_(R6),.K(K6));

roundbro_2025 rnd7(.clk(clk),.L(L6),.R(R6),.L_(L7),.R_(R7),.K(K7));

roundbro_2025 rnd8(.clk(clk),.L(L7),.R(R7),.L_(L8),.R_(R8),.K(K8));

roundbro_2025 rnd9(.clk(clk),.L(L8),.R(R8),.L_(L9),.R_(R9),.K(K9));

roundbro_2025 rnd10(.clk(clk),.L(L9),.R(R9),.L_(L10),.R_(R10),.K(K10));

roundbro_2025 rnd11(.clk(clk),.L(L10),.R(R10),.L_(L11),.R_(R11),.K(K11));

roundbro_2025 rnd12(.clk(clk),.L(L11),.R(R11),.L_(L12),.R_(R12),.K(K12));

roundbro_2025 rnd13(.clk(clk),.L(L12),.R(R12),.L_(L13),.R_(R13),.K(K13));

roundbro_2025 rnd14(.clk(clk),.L(L13),.R(R13),.L_(L14),.R_(R14),.K(K14));

roundbro_2025 rnd15(.clk(clk),.L(L14),.R(R14),.L_(L15),.R_(R15),.K(K15));

roundbro_2025 rnd16(.clk(clk),.L(L15),.R(R15),.L_(L16),.R_(R16),.K(K16));

ip_inv_2025 inv(clk, R16, L16, encrypted_message);

assign j1 = L1;
assign j2 = L2;
assign j3 = L3;
assign j4 = L4;
assign j5 = L5;
assign j6 = L6;
assign j7 = L7;
assign j8 = L8;
assign j9 = L9;
assign j10 = L10;
assign j11 = L11;
assign j12 = L12;
assign j13 = L13;
assign j14 = L14;
assign j15 = L15;
assign j16 = L16;

endmodule


module pc1_2025(input clk, input [1:64]key, output reg [1:56]key_pc1);
always@(posedge clk)
begin
 key_pc1[1] = key[57];
 key_pc1[2] = key[49];
 key_pc1[3] = key[41];
 key_pc1[4] = key[33];
 key_pc1[5] = key[25];
 key_pc1[6] = key[17];
 key_pc1[7] = key[9];
 key_pc1[8] = key[1];
 key_pc1[9] = key[58];
 key_pc1[10] = key[50];
 key_pc1[11] = key[42];
 key_pc1[12] = key[34];
 key_pc1[13] = key[26];
 key_pc1[14] = key[18];
 key_pc1[15] = key[10];
 key_pc1[16] = key[2];
 key_pc1[17] = key[59];
 key_pc1[18] = key[51];
 key_pc1[19] = key[43];
 key_pc1[20] = key[35];
 key_pc1[21] = key[27];
 key_pc1[22] = key[19];
 key_pc1[23] = key[11];
 key_pc1[24] = key[3];
 key_pc1[25] = key[60];
 key_pc1[26] = key[52];
 key_pc1[27] = key[44];
 key_pc1[28] = key[36];
 key_pc1[29] = key[63];
 key_pc1[30] = key[55];
 key_pc1[31] = key[47];
 key_pc1[32] = key[39];
 key_pc1[33] = key[31];
 key_pc1[34] = key[23];
 key_pc1[35] = key[15];
 key_pc1[36] = key[7];
 key_pc1[37] = key[62];
 key_pc1[38] = key[54];
 key_pc1[39] = key[46];
 key_pc1[40] = key[38];
 key_pc1[41] = key[30];
 key_pc1[42] = key[22];
 key_pc1[43] = key[14];
 key_pc1[44] = key[6];
 key_pc1[45] = key[61];
 key_pc1[46] = key[53];
 key_pc1[47] = key[45];
 key_pc1[48] = key[37];
 key_pc1[49] = key[29];
 key_pc1[50] = key[21];
 key_pc1[51] = key[13];
 key_pc1[52] = key[5];
 key_pc1[53] = key[28];
 key_pc1[54] = key[20];
 key_pc1[55] = key[12];
 key_pc1[56] = key[4];
 end
endmodule


module IP_2025(input clk, input [1:64]M, output reg [1:32]L, output reg [1:32]R);
    reg [1:64] out;
    always@(posedge clk)
    begin
     out[1] = M[58];
     out[2] = M[50];
     out[3] = M[42];
     out[4] = M[34];
     out[5] = M[26];
     out[6] = M[18];
     out[7] = M[10];
     out[8] = M[2];
     out[9] = M[60];
     out[10] = M[52];
     out[11] = M[44];
     out[12] = M[36];
     out[13] = M[28];
     out[14] = M[20];
     out[15] = M[12];
     out[16] = M[4];
     out[17] = M[62];
     out[18] = M[54];
     out[19] = M[46];
     out[20] = M[38];
     out[21] = M[30];
     out[22] = M[22];
     out[23] = M[14];
     out[24] = M[6];
     out[25] = M[64];
     out[26] = M[56];
     out[27] = M[48];
     out[28] = M[40];
     out[29] = M[32];
     out[30] = M[24];
     out[31] = M[16];
     out[32] = M[8];
     out[33] = M[57];
     out[34] = M[49];
     out[35] = M[41];
     out[36] = M[33];
     out[37] = M[25];
     out[38] = M[17];
     out[39] = M[9];
     out[40] = M[1];
     out[41] = M[59];
     out[42] = M[51];
     out[43] = M[43];
     out[44] = M[35];
     out[45] = M[27];
     out[46] = M[19];
     out[47] = M[11];
     out[48] = M[3];
     out[49] = M[61];
     out[50] = M[53];
     out[51] = M[45];
     out[52] = M[37];
     out[53] = M[29];
     out[54] = M[21];
     out[55] = M[13];
     out[56] = M[5];
     out[57] = M[63];
     out[58] = M[55];
     out[59] = M[47];
     out[60] = M[39];
     out[61] = M[31];
     out[62] = M[23];
     out[63] = M[15];
     out[64] = M[7];

     L = out[1:32];
     R = out[33:64];
   end
endmodule



module Lshift_2025 (input clk,
    input [1:56] key_pc1, 
    output reg [1:56] k1, 
    output reg [1:56] k2,
    output reg [1:56] k3, 
    output reg [1:56] k4,
    output reg [1:56] k5, 
    output reg [1:56] k6, 
    output reg [1:56] k7, 
    output reg [1:56] k8,
    output reg [1:56] k9, 
    output reg [1:56] k10,
    output reg [1:56] k11, 
    output reg [1:56] k12,
    output reg [1:56] k13, 
    output reg [1:56] k14, 
    output reg [1:56] k15, 
    output reg [1:56] k16
);
    reg [1:28] C [0:16]; 
    reg [1:28] D [0:16]; 
    integer i;

   
    always @(posedge clk) begin
        
        C[0] = key_pc1[1:28];
        D[0] = key_pc1[29:56];

       
        for (i = 1; i <= 16; i = i + 1) begin
            if (i == 1 || i == 2 || i == 9 || i == 16) begin
               
                C[i] = {C[i-1][2:28], C[i-1][1]}; 
                D[i] = {D[i-1][2:28], D[i-1][1]}; 
            end 
            else begin
                
                C[i] ={C[i-1][3:28], C[i-1][1:2]}; 
                D[i] ={D[i-1][3:28], D[i-1][1:2]}; 
            end
        end
        k1 = {C[1],D[1]};
        k2 = {C[2],D[2]};
        k3 = {C[3],D[3]};
        k4 = {C[4],D[4]};
        k5 = {C[5],D[5]};
        k6 = {C[6],D[6]};
        k7 = {C[7],D[7]};
        k8 = {C[8],D[8]};
        k9 = {C[9],D[9]};
        k10 = {C[10],D[10]};
        k11 = {C[11],D[11]};
        k12 = {C[12],D[12]};
        k13 = {C[13],D[13]};
        k14 = {C[14],D[14]};
        k15 = {C[15],D[15]};
        k16 = {C[16],D[16]};
    end
endmodule


module pc2_2025(input clk,
    input [1:56] k,
    output reg [1:48] subkey
);
  always@(posedge clk)
  begin
     subkey[1]  = k[14];
     subkey[2]  = k[17];
     subkey[3]  = k[11];
     subkey[4]  = k[24];
     subkey[5]  = k[1];
     subkey[6]  = k[5];
     subkey[7]  = k[3];
     subkey[8]  = k[28];
     subkey[9]  = k[15];
     subkey[10] = k[6];
     subkey[11] = k[21];
     subkey[12] = k[10];
     subkey[13] = k[23];
     subkey[14] = k[19];
     subkey[15] = k[12];
     subkey[16] = k[4];
     subkey[17] = k[26];
     subkey[18] = k[8];
     subkey[19] = k[16];
     subkey[20] = k[7];
     subkey[21] = k[27];
     subkey[22] = k[20];
     subkey[23] = k[13];
     subkey[24] = k[2];
     subkey[25] = k[41];
     subkey[26] = k[52];
     subkey[27] = k[31];
     subkey[28] = k[37];
     subkey[29] = k[47];
     subkey[30] = k[55];
     subkey[31] = k[30];
     subkey[32] = k[40];
     subkey[33] = k[51];
     subkey[34] = k[45];
     subkey[35] = k[33];
     subkey[36] = k[48];
     subkey[37] = k[44];
     subkey[38] = k[49];
     subkey[39] = k[39];
     subkey[40] = k[56];
     subkey[41] = k[34];
     subkey[42] = k[53];
     subkey[43] = k[46];
     subkey[44] = k[42];
     subkey[45] = k[50];
     subkey[46] = k[36];
     subkey[47] = k[29];
     subkey[48] = k[32];
   end
endmodule


module roundbro_2025(input clk,
    input [1:32] L,
    input [1:32] R,
    output [1:32] L_,
    output [1:32] R_,
    input [1:48] K
    //output [1:32] rint,
    //output [1:48] o
    );
    wire [1:48]E,O;
    wire [1:32]rint;
    assign L_=R;
    expand_2025 E1(clk,R,K,O);
    subs_box_2025 s(clk,O,L,R_);  //works fine   
endmodule


module expand_2025( input clk,
    input [1:32] R,
    input [1:48]k,
    output reg [1:48]o
    );
    reg [1:48] E;
    always@(posedge clk)
    begin
      E[1] = R[32];
      E[2] = R[1];
      E[3] = R[2];
      E[4] = R[3];
   E[5] = R[4];
   E[6] = R[5];
   E[7] = R[4];
   E[8] = R[5];
   E[9] = R[6];
   E[10] = R[7];
   E[11] = R[8];
   E[12] = R[9];
   E[13] = R[8];
   E[14] = R[9];
   E[15] = R[10];
   E[16] = R[11];
   E[17] = R[12];
   E[18] = R[13];
   E[19] = R[12];
   E[20] = R[13];
   E[21] = R[14];
   E[22] = R[15];
   E[23] = R[16];
   E[24] = R[17];
   E[25] = R[16];
   E[26] = R[17];
   E[27] = R[18];
   E[28] = R[19];
   E[29] = R[20];
   E[30] = R[21];
   E[31] = R[20];
   E[32] = R[21];
   E[33] = R[22];
   E[34] = R[23];
   E[35] = R[24];
   E[36] = R[25];
   E[37] = R[24];
   E[38] = R[25];
   E[39] = R[26];
   E[40] = R[27];
   E[41] = R[28];
   E[42] = R[29];
   E[43] = R[28];
   E[44] = R[29];
   E[45] = R[30];
   E[46] = R[31];
   E[47] = R[32];
   E[48] = R[1];
   o=E^k; //this is right for sure
  end
endmodule



module subs_box_2025(input clk,
    input [1:48] o,
    input [1:32] l,
    output [1:32] R_
    );
    wire [1:6]b1,b2,b3,b4,b5,b6,b7,b8;
    assign {b1,b2,b3,b4,b5,b6,b7,b8}= o;
    wire [1:4]oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8;
    
//48 bit result now to be split into 8 groups of 6 bits
    S1_2025 s1(clk,oo1,b1);
    S2_2025 s2(clk,oo2,b2);
    S3_2025 s3(clk,oo3,b3);
    S4_2025 s4(clk,oo4,b4);
    S5_2025 s5(clk,oo5,b5);
    S6_2025 s6(clk,oo6,b6);
    S7_2025 s7(clk,oo7,b7);
    S8_2025 s8(clk,oo8,b8);
    wire [1:32] r;
    assign r={oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8};
    assign R_=r^l; 
    
endmodule


module S1_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk) 
    case (in)
    0 : out = 14;
    1 : out = 0;
    2 : out = 4;
    3 : out = 15;
    4 : out = 13;
    5 : out = 7;
    6 : out = 1;
    7 : out = 4;
    8 : out = 2;
    9 : out = 14;
    10 : out = 15;
    11 : out = 2;
    12 : out = 11;
    13 : out = 13;
    14 : out = 8;
    15 : out = 1;
    16 : out = 3;
    17 : out = 10;
    18 : out = 10;
    19 : out = 6;
    20 : out = 6;
    21 : out = 12;
    22 : out = 12;
    23 : out = 11;
    24 : out = 5;
    25 : out = 9;
    26 : out = 9;
    27 : out = 5;
    28 : out = 0;
    29 : out = 3;
    30 : out = 7;
    31 : out = 8;
    32 : out = 4;
    33 : out = 15;
    34 : out = 1;
    35 : out = 12;
    36 : out = 14;
    37 : out = 8;
    38 : out = 8;
    39 : out = 2;
    40 : out = 13;
    41 : out = 4;
    42 : out = 6;
    43 : out = 9;
    44 : out = 2;
    45 : out = 1;
    46 : out = 11;
    47 : out = 7;
    48 : out = 15;
    49 : out = 5;
    50 : out = 12;
    51 : out = 11;
    52 : out = 9;
    53 : out = 3;
    54 : out = 7;
    55 : out = 14;
    56 : out = 3;
    57 : out = 10;
    58 : out = 10;
    59 : out = 0;
    60 : out = 5;
    61 : out = 6;
    62 : out = 0;
    63 : out = 13;
   endcase
endmodule


module S2_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 15;
    1 : out = 3;
    2 : out = 1;
    3 : out = 13;
    4 : out = 8;
    5 : out = 4;
    6 : out = 14;
    7 : out = 7;
    8 : out = 6;
    9 : out = 15;
    10 : out = 11;
    11 : out = 2;
    12 : out = 3;
    13 : out = 8;
    14 : out = 4;
    15 : out = 14;
    16 : out = 9;
    17 : out = 12;
    18 : out = 7;
    19 : out = 0;
    20 : out = 2;
    21 : out = 1;
    22 : out = 13;
    23 : out = 10;
    24 : out = 12;
    25 : out = 6;
    26 : out = 0;
    27 : out = 9;
    28 : out = 5;
    29 : out = 11;
    30 : out = 10;
    31 : out = 5;
    32 : out = 0;
    33 : out = 13;
    34 : out = 14;
    35 : out = 8;
    36 : out = 7;
    37 : out = 10;
    38 : out = 11;
    39 : out = 1;
    40 : out = 10;
    41 : out = 3;
    42 : out = 4;
    43 : out = 15;
    44 : out = 13;
    45 : out = 4;
    46 : out = 1;
    47 : out = 2;
    48 : out = 5;
    49 : out = 11;
    50 : out = 8;
    51 : out = 6;
    52 : out = 12;
    53 : out = 7;
    54 : out = 6;
    55 : out = 12;
    56 : out = 9;
    57 : out = 0;
    58 : out = 3;
    59 : out = 5;
    60 : out = 2;
    61 : out = 14;
    62 : out = 15;
    63 : out = 9;
  endcase
endmodule

module S3_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 10;
    1 : out = 13;
    2 : out = 0;
    3 : out = 7;
    4 : out = 9;
    5 : out = 0;
    6 : out = 14;
    7 : out = 9;
    8 : out = 6;
    9 : out = 3;
    10 : out = 3;
    11 : out = 4;
    12 : out = 15;
    13 : out = 6;
    14 : out = 5;
    15 : out = 10;
    16 : out = 1;
    17 : out = 2;
    18 : out = 13;
    19 : out = 8;
    20 : out = 12;
    21 : out = 5;
    22 : out = 7;
    23 : out = 14;
    24 : out = 11;
    25 : out = 12;
    26 : out = 4;
    27 : out = 11;
    28 : out = 2;
    29 : out = 15;
    30 : out = 8;
    31 : out = 1;
    32 : out = 13;
    33 : out = 1;
    34 : out = 6;
    35 : out = 10;
    36 : out = 4;
    37 : out = 13;
    38 : out = 9;
    39 : out = 0;
    40 : out = 8;
    41 : out = 6;
    42 : out = 15;
    43 : out = 9;
    44 : out = 3;
    45 : out = 8;
    46 : out = 0;
    47 : out = 7;
    48 : out = 11;
    49 : out = 4;
    50 : out = 1;
    51 : out = 15;
    52 : out = 2;
    53 : out = 14;
    54 : out = 12;
    55 : out = 3;
    56 : out = 5;
    57 : out = 11;
    58 : out = 10;
    59 : out = 5;
    60 : out = 14;
    61 : out = 2;
    62 : out = 7;
    63 : out = 12;
  endcase
endmodule


module S4_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 7;
    1 : out = 13;
    2 : out = 13;
    3 : out = 8;
    4 : out = 14;
    5 : out = 11;
    6 : out = 3;
    7 : out = 5;
    8 : out = 0;
    9 : out = 6;
    10 : out = 6;
    11 : out = 15;
    12 : out = 9;
    13 : out = 0;
    14 : out = 10;
    15 : out = 3;
    16 : out = 1;
    17 : out = 4;
    18 : out = 2;
    19 : out = 7;
    20 : out = 8;
    21 : out = 2;
    22 : out = 5;
    23 : out = 12;
    24 : out = 11;
    25 : out = 1;
    26 : out = 12;
    27 : out = 10;
    28 : out = 4;
    29 : out = 14;
    30 : out = 15;
    31 : out = 9;
    32 : out = 10;
    33 : out = 3;
    34 : out = 6;
    35 : out = 15;
    36 : out = 9;
    37 : out = 0;
    38 : out = 0;
    39 : out = 6;
    40 : out = 12;
    41 : out = 10;
    42 : out = 11;
    43 : out = 1;
    44 : out = 7;
    45 : out = 13;
    46 : out = 13;
    47 : out = 8;
    48 : out = 15;
    49 : out = 9;
    50 : out = 1;
    51 : out = 4;
    52 : out = 3;
    53 : out = 5;
    54 : out = 14;
    55 : out = 11;
    56 : out = 5;
    57 : out = 12;
    58 : out = 2;
    59 : out = 7;
    60 : out = 8;
    61 : out = 2;
    62 : out = 4;
    63 : out = 14;
  endcase
endmodule


module S5_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 2;
    1 : out = 14;
    2 : out = 12;
    3 : out = 11;
    4 : out = 4;
    5 : out = 2;
    6 : out = 1;
    7 : out = 12;
    8 : out = 7;
    9 : out = 4;
    10 : out = 10;
    11 : out = 7;
    12 : out = 11;
    13 : out = 13;
    14 : out = 6;
    15 : out = 1;
    16 : out = 8;
    17 : out = 5;
    18 : out = 5;
    19 : out = 0;
    20 : out = 3;
    21 : out = 15;
    22 : out = 15;
    23 : out = 10;
    24 : out = 13;
    25 : out = 3;
    26 : out = 0;
    27 : out = 9;
    28 : out = 14;
    29 : out = 8;
    30 : out = 9;
    31 : out = 6;
    32 : out = 4;
    33 : out = 11;
    34 : out = 2;
    35 : out = 8;
    36 : out = 1;
    37 : out = 12;
    38 : out = 11;
    39 : out = 7;
    40 : out = 10;
    41 : out = 1;
    42 : out = 13;
    43 : out = 14;
    44 : out = 7;
    45 : out = 2;
    46 : out = 8;
    47 : out = 13;
    48 : out = 15;
    49 : out = 6;
    50 : out = 9;
    51 : out = 15;
    52 : out = 12;
    53 : out = 0;
    54 : out = 5;
    55 : out = 9;
    56 : out = 6;
    57 : out = 10;
    58 : out = 3;
    59 : out = 4;
    60 : out = 0;
    61 : out = 5;
    62 : out = 14;
    63 : out = 3;
  endcase
endmodule


module S6_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 12;
    1 : out = 10;
    2 : out = 1;
    3 : out = 15;
    4 : out = 10;
    5 : out = 4;
    6 : out = 15;
    7 : out = 2;
    8 : out = 9;
    9 : out = 7;
    10 : out = 2;
    11 : out = 12;
    12 : out = 6;
    13 : out = 9;
    14 : out = 8;
    15 : out = 5;
    16 : out = 0;
    17 : out = 6;
    18 : out = 13;
    19 : out = 1;
    20 : out = 3;
    21 : out = 13;
    22 : out = 4;
    23 : out = 14;
    24 : out = 14;
    25 : out = 0;
    26 : out = 7;
    27 : out = 11;
    28 : out = 5;
    29 : out = 3;
    30 : out = 11;
    31 : out = 8;
    32 : out = 9;
    33 : out = 4;
    34 : out = 14;
    35 : out = 3;
    36 : out = 15;
    37 : out = 2;
    38 : out = 5;
    39 : out = 12;
    40 : out = 2;
    41 : out = 9;
    42 : out = 8;
    43 : out = 5;
    44 : out = 12;
    45 : out = 15;
    46 : out = 3;
    47 : out = 10;
    48 : out = 7;
    49 : out = 11;
    50 : out = 0;
    51 : out = 14;
    52 : out = 4;
    53 : out = 1;
    54 : out = 10;
    55 : out = 7;
    56 : out = 1;
    57 : out = 6;
    58 : out = 13;
    59 : out = 0;
    60 : out = 11;
    61 : out = 8;
    62 : out = 6;
    63 : out = 13;
  endcase
endmodule


module S7_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
      always @(posedge clk)
     case (in)
    0 : out = 4;
    1 : out = 13;
    2 : out = 11;
    3 : out = 0;
    4 : out = 2;
    5 : out = 11;
    6 : out = 14;
    7 : out = 7;
    8 : out = 15;
    9 : out = 4;
    10 : out = 0;
    11 : out = 9;
    12 : out = 8;
    13 : out = 1;
    14 : out = 13;
    15 : out = 10;
    16 : out = 3;
    17 : out = 14;
    18 : out = 12;
    19 : out = 3;
    20 : out = 9;
    21 : out = 5;
    22 : out = 7;
    23 : out = 12;
    24 : out = 5;
    25 : out = 2;
    26 : out = 10;
    27 : out = 15;
    28 : out = 6;
    29 : out = 8;
    30 : out = 1;
    31 : out = 6;
    32 : out = 1;
    33 : out = 6;
    34 : out = 4;
    35 : out = 11;
    36 : out = 11;
    37 : out = 13;
    38 : out = 13;
    39 : out = 8;
    40 : out = 12;
    41 : out = 1;
    42 : out = 3;
    43 : out = 4;
    44 : out = 7;
    45 : out = 10;
    46 : out = 14;
    47 : out = 7;
    48 : out = 10;
    49 : out = 9;
    50 : out = 15;
    51 : out = 5;
    52 : out = 6;
    53 : out = 0;
    54 : out = 8;
    55 : out = 15;
    56 : out = 0;
    57 : out = 14;
    58 : out = 5;
    59 : out = 2;
    60 : out = 9;
    61 : out = 3;
    62 : out = 2;
    63 : out = 12;
  endcase
endmodule


module S8_2025(input clk,
    output reg [1:4] out,
    input [1:6] in
    );
    always @(posedge clk)
    case (in)
    0 : out = 13;
    1 : out = 1;
    2 : out = 2;
    3 : out = 15;
    4 : out = 8;
    5 : out = 13;
    6 : out = 4;
    7 : out = 8;
    8 : out = 6;
    9 : out = 10;
    10 : out = 15;
    11 : out = 3;
    12 : out = 11;
    13 : out = 7;
    14 : out = 1;
    15 : out = 4;
    16 : out = 10;
    17 : out = 12;
    18 : out = 9;
    19 : out = 5;
    20 : out = 3;
    21 : out = 6;
    22 : out = 14;
    23 : out = 11;
    24 : out = 5;
    25 : out = 0;
    26 : out = 0;
    27 : out = 14;
    28 : out = 12;
    29 : out = 9;
    30 : out = 7;
    31 : out = 2;
    32 : out = 7;
    33 : out = 2;
    34 : out = 11;
    35 : out = 1;
    36 : out = 4;
    37 : out = 14;
    38 : out = 1;
    39 : out = 7;
    40 : out = 9;
    41 : out = 4;
    42 : out = 12;
    43 : out = 10;
    44 : out = 14;
    45 : out = 8;
    46 : out = 2;
    47 : out = 13;
    48 : out = 0;
    49 : out = 15;
    50 : out = 6;
    51 : out = 12;
    52 : out = 10;
    53 : out = 9;
    54 : out = 13;
    55 : out = 0;
    56 : out = 15;
    57 : out = 3;
    58 : out = 3;
    59 : out = 5;
    60 : out = 5;
    61 : out = 6;
    62 : out = 8;
    63 : out = 11;
  endcase
endmodule


module ip_inv_2025(input clk, input [1:32]R_16, input [1:32]L_16, output reg [1:64]CIPHER);
    wire [1:64]in={R_16[1:32],L_16[1:32]};
    reg [1:64] out;
    always@(posedge clk)
    begin
     out[1] = in[40];
     out[2] = in[8];
     out[3] = in[48];
     out[4] = in[16];
     out[5] = in[56];
     out[6] = in[24];
     out[7] = in[64];
     out[8] = in[32];
     out[9] = in[39];
     out[10] = in[7];
     out[11] = in[47];
     out[12] = in[15];
     out[13] = in[55];
     out[14] = in[23];
     out[15] = in[63];
     out[16] = in[31];
     out[17] = in[38];
     out[18] = in[6];
     out[19] = in[46];
     out[20] = in[14];
     out[21] = in[54];
     out[22] = in[22];
     out[23] = in[62];
     out[24] = in[30];
     out[25] = in[37];
     out[26] = in[5];
     out[27] = in[45];
     out[28] = in[13];
     out[29] = in[53];
     out[30] = in[21];
     out[31] = in[61];
     out[32] = in[29];
     out[33] = in[36];
     out[34] = in[4];
     out[35] = in[44];
     out[36] = in[12];
     out[37] = in[52];
     out[38] = in[20];
     out[39] = in[60];
     out[40] = in[28];
     out[41] = in[35];
     out[42] = in[3];
     out[43] = in[43];
     out[44] = in[11];
     out[45] = in[51];
     out[46] = in[19];
     out[47] = in[59];
     out[48] = in[27];
     out[49] = in[34];
     out[50] = in[2];
     out[51] = in[42];
     out[52] = in[10];
     out[53] = in[50];
     out[54] = in[18];
     out[55] = in[58];
     out[56] = in[26];
     out[57] = in[33];
     out[58] = in[1];
     out[59] = in[41];
     out[60] = in[9];
     out[61] = in[49];
     out[62] = in[17];
     out[63] = in[57];
     out[64] = in[25];
     CIPHER = out;
   end
endmodule


module Single_DES_main_decrypt_2025(input clk,
    input [1:64] message,
    input [1:64] key, 
    output [1:64] encrypted_message,
    output [31:0] a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16);
wire [1:56] key_pc1;       
wire [1:56] k1, k2, k3, k4, k5, k6, k7, k8, 
            k9, k10, k11, k12, k13, k14, k15, k16;
wire [1:48] K1, K2, K3, K4, K5, K6, K7, K8, 
            K9, K10, K11, K12, K13, K14, K15, K16;
wire [1:48*16] key_pc2;
wire [1:32] L;
wire [1:32] R;
wire [1:64] M;
assign M=message;
wire [1:32] L1, L2, L3, L4, L5, L6, L7, L8, 
            L9, L10, L11, L12, L13, L14, L15, L16;
wire [1:32] R1, R2, R3, R4, R5, R6, R7, R8, 
            R9, R10, R11, R12, R13, R14, R15, R16;

//PHASE1(verified)
pc1_2025 PC1_inst(clk,key,key_pc1);
IP_2025 IP_inst(clk,M,L,R);
Lshift_2025 LS(clk,key_pc1,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16);

// Permuted Choice 2 (PC2)
pc2_2025 PC2_1(.clk(clk),.k(k1), .subkey(K1));
pc2_2025 PC2_2(.clk(clk),.k(k2),  .subkey(K2));
pc2_2025 PC2_3(.clk(clk),.k(k3),  .subkey(K3));
pc2_2025 PC2_4(.clk(clk),.k(k4),  .subkey(K4));
pc2_2025 PC2_5(.clk(clk),.k(k5),  .subkey(K5));
pc2_2025 PC2_6(.clk(clk),.k(k6),  .subkey(K6));
pc2_2025 PC2_7(.clk(clk),.k(k7),  .subkey(K7));
pc2_2025 PC2_8(.clk(clk),.k(k8),  .subkey(K8));
pc2_2025 PC2_9(.clk(clk),.k(k9),  .subkey(K9));
pc2_2025 PC2_10(.clk(clk),.k(k10), .subkey(K10));
pc2_2025 PC2_11(.clk(clk),.k(k11), .subkey(K11));
pc2_2025 PC2_12(.clk(clk),.k(k12), .subkey(K12));
pc2_2025 PC2_13(.clk(clk),.k(k13), .subkey(K13));
pc2_2025 PC2_14(.clk(clk),.k(k14), .subkey(K14));
pc2_2025 PC2_15(.clk(clk),.k(k15), .subkey(K15));
pc2_2025 PC2_16(.clk(clk),.k(k16), .subkey(K16));
//Phase 1/2 ends

//phase 3
roundbro_2025 rnd1(.clk(clk),
    .L(L), .R(R),
    .L_(L1), 
    .R_(R1),
    .K(K16)
);

roundbro_2025 rnd2(.clk(clk),
    .L(L1), .R(R1),
    .L_(L2), 
    .R_(R2),
    .K(K15)
);

roundbro_2025 rnd3(.clk(clk),
    .L(L2), .R(R2),
    .L_(L3), 
    .R_(R3),
    .K(K14)
);

roundbro_2025 rnd4(.clk(clk),
    .L(L3), .R(R3),
    .L_(L4), 
    .R_(R4),
    .K(K13)
);

roundbro_2025 rnd5(.clk(clk),
    .L(L4), .R(R4),
    .L_(L5), 
    .R_(R5),
    .K(K12)
);

roundbro_2025 rnd6(.clk(clk),
    .L(L5), .R(R5),
    .L_(L6), 
    .R_(R6),
    .K(K11)
);

roundbro_2025 rnd7(.clk(clk),
    .L(L6), .R(R6),
    .L_(L7), 
    .R_(R7),
    .K(K10)
);

roundbro_2025 rnd8(.clk(clk),
    .L(L7), .R(R7),
    .L_(L8), 
    .R_(R8),
    .K(K9)
);

roundbro_2025 rnd9(.clk(clk),
    .L(L8), .R(R8),
    .L_(L9), 
    .R_(R9),
    .K(K8)
);

roundbro_2025 rnd10(.clk(clk),
    .L(L9), .R(R9),
    .L_(L10), 
    .R_(R10),
    .K(K7)
);

roundbro_2025 rnd11(.clk(clk),
    .L(L10), .R(R10),
    .L_(L11), 
    .R_(R11),
    .K(K6)
);

roundbro_2025 rnd12(.clk(clk),
    .L(L11), .R(R11),
    .L_(L12), 
    .R_(R12),
    .K(K5)
);

roundbro_2025 rnd13(.clk(clk),
    .L(L12), .R(R12),
    .L_(L13), 
    .R_(R13),
    .K(K4)
);

roundbro_2025 rnd14(.clk(clk),
    .L(L13), .R(R13),
    .L_(L14), 
    .R_(R14),
    .K(K3)
);

roundbro_2025 rnd15(.clk(clk),
    .L(L14), .R(R14),
    .L_(L15), 
    .R_(R15),
    .K(K2)
);

roundbro_2025 rnd16(.clk(clk),
    .L(L15), .R(R15),
    .L_(L16), 
    .R_(R16),
    .K(K1)
);

ip_inv_2025 inv(clk, R16, L16, encrypted_message);

assign a1 = L1;
assign a2 = L2;
assign a3 = L3;
assign a4 = L4;
assign a5 = L5;
assign a6 = L6;
assign a7 = L7;
assign a8 = L8;
assign a9 = L9;
assign a10 = L10;
assign a11 = L11;
assign a12 = L12;
assign a13 = L13;
assign a14 = L14;
assign a15 = L15;
assign a16 = L16;
endmodule


module sdes_compare_2025_err1(clk,ctrl1, ctrl2,ctrl3,ctrl4,err,
       j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,ft);
  input clk,ctrl1, ctrl2,ctrl3,ctrl4;
  input [31:0] j1,j2,j3,j4,j5,j6,j7,j8,j9,j10,j11,j12,j13,j14,j15,j16,
       a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,err;
  wire [16:1] t,tn;
  output [8:1]ft;
  
  //xor_bit_check ch1(clk,j1,a16,t[1],tn[1]); 
  xor_bit_check_ei ch1(clk,ctrl1,err1,j1,a16,t[1],tn[1]);                    
  xor_bit_check ch2(clk,j2,a15,t[2],tn[2]);    
  xor_bit_check ch3(clk,j3,a14,t[3],tn[3]);
  xor_bit_check ch4(clk,j4,a13,t[4],tn[4]);
  
  xor_bit_check ch5(clk,j5,a12,t[5],tn[5]); 
 // xor_bit_check ch6(clk,j6,a11,t[6],tn[6]);    
  xor_bit_check_ei ch6(clk,ctrl2,err1,j6,a11,t[6],tn[6]);                    
  xor_bit_check ch7(clk,j7,a10,t[7],tn[7]);
  xor_bit_check ch8(clk,j8,a9,t[8],tn[8]);
  
  xor_bit_check ch9(clk,j9,a8,t[9],tn[9]);                     
  xor_bit_check ch10(clk,j10,a7,t[10],tn[10]);    
  //xor_bit_check ch11(clk,j11,a6,t[11],tn[11]);
  xor_bit_check_ei ch11(clk,ctrl3,err1,j11,a6,t[11],tn[11]); 
  xor_bit_check ch12(clk,j12,a5,t[12],tn[12]);
  
  xor_bit_check ch13(clk,j13,a4,t[13],tn[13]);                     
  xor_bit_check ch14(clk,j14,a3,t[14],tn[14]);    
  xor_bit_check ch15(clk,j15,a2,t[15],tn[15]);
  //xor_bit_check ch16(clk,j16,a1,t[16],tn[16]);
  xor_bit_check_ei ch16(clk,ctrl4,err1,j16,a1,t[16],tn[16]);
                    
  tdes_decisiontree jt17(clk,t[1],tn[1],t[2],tn[2],t[3],tn[3],t[4],tn[4],ft[2:1]);
  tdes_decisiontree jt18(clk,t[5],tn[5],t[6],tn[6],t[7],tn[7],t[8],tn[8],ft[4:3]);
  tdes_decisiontree jt19(clk,t[9],tn[9],t[10],tn[10],t[11],tn[11],t[12],tn[12],ft[6:5]);
  tdes_decisiontree jt20(clk,t[13],tn[13],t[14],tn[14],t[15],tn[15],t[16],tn[16],ft[8:7]);
endmodule


module xor_bit_check_ei(clk,ctrl, err, x,y,op_eq,op_neq);     
  input clk;
  input ctrl;
  input [31:0] x,y,err;
  integer i=0;
  output reg op_eq,op_neq;
  reg [31:0] z;
  //reg [31:0] e = 32'b11111111111111111111111111111111;
  always @(posedge clk)
  begin
  if (ctrl == 1'b1) 
   
     begin
      for(i=0; i<32; i=i+1)
        z[i] = err[i]^y[i];
      end
    else
      begin
      for(i=0; i<32; i=i+1)
        z[i] = x[i]^y[i];
      end
  end

   always @(posedge clk)
   begin   
        if (z == 32'h00000000) 
          begin 
          op_eq = 1;
          op_neq = 0;
          end 
        else 
          begin
          op_eq = 0;
          op_neq = 1;
      end   
  end
endmodule  



module xor_bit_check(clk,x,y,op_eq,op_neq);     
  input clk;
  input [31:0] x,y;
  integer i=0;
  output reg op_eq,op_neq;
  reg [31:0] z;
  always @(posedge clk)
   begin
      for(i=0; i<32; i=i+1)
        z[i] = x[i]^y[i];
      end
   always @(posedge clk)
   begin   
        if (z == 32'h00000000) 
          begin 
          op_eq = 1;
          op_neq = 0;
          end 
        else 
          begin
          op_eq = 0;
          op_neq = 1;
      end   
  end
endmodule   


module tdes_decisiontree(clk, ie0, ine0, ie1,ine1,ie2,ine2,ie3,ine3,fault);
  input clk,ie0,ine0,ie1,ine1,ie2,ine2,ie3,ine3;
  output reg [1:0] fault;
  parameter noerror = 2'b01, error = 2'b10, na = 2'b11;
  initial 
  fault = 2'b00;
  always@(posedge clk)
  begin
    if (ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = noerror;
      end
    else if(ie0==1 & ine0==1'b1 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
     else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end  
     else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end  
      else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b0)
      begin 
        fault = na;
      end 
      else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1'b1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b1 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b1 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b1 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end       
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b1)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b1 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b1 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b1)
      begin 
        fault = na;
      end
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b1 & ie2== 1'b0)
      begin 
        fault = error;
      end    
      else if(ie0==1'b0 & ine0==1'b0 & ie1==1'b0 & ine1==1'b0 & ie3 == 1'b0 & ine3== 1'b0 & ine2 == 1'b0 & ie2== 1'b0)
      begin 
        fault = error;
      end
      else 
      begin
        fault = error;
      end
      end
    endmodule
    

module tdes_fault_2025(clk,a,y);
  input clk;
  input [16:1]a;
  output reg y;
  always@(posedge clk)
  begin
  if(a == 16'b0101010101010101) 
   begin y = 0; end else begin y = 1;end
 end
 endmodule
