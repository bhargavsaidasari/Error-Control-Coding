%%
%main.m
clear all
close all
%Convolutional Encoding
K=3;  %Constraint Length
t = poly2trellis(K,[7 5]);
%size of input data msg
%IT SHOULD BE EVEN
N=100000;
%generate random sequence
msg=randi([0,1],1,N);
%Flush bits-Add Two zeros at the end
msg=[msg 0 0];
code = convenc(msg,t);%Encode
transmitted=pskmod(code,2,pi); %BPSK modulation

%%
%AWGN Noise.Comparison with Uncoded vs Convolutional Coding
snr=-2:7;
for i=1:length(snr)
    snr(i)
    noisy_signal=awgn(transmitted,snr(i),'measured');
    demod=pskdemod(noisy_signal,2,pi); 
    [~,ber(i)]=biterr(code,demod); 
    %Convert message from binary into states for input to viterbi decoding
    transmitted_states=bin_to_states(demod);
    %Decoding using my Viterbi Algorithm
    [~,~,~,decoded_data_soft_l4] = viterbidechard(K,lloyd_quantization(real(noisy_signal),4));
%     [~,~,~,decoded_data_hard] = viterbidec(K,transmitted_states);
    [~,~,~,decoded_data_soft_l8] = viterbidechard(K,lloyd_quantization(real(noisy_signal),8));
    [~,codedbersoftl4(i)]=biterr(msg,decoded_data_soft_l4);
    [~,codedbersoftl8(i)]=biterr(msg,decoded_data_soft_l8);
end
ebn0=snr-10*log10(1/2);%Rate-1/2 convolutional code
%%
%Plotting
semilogy(snr,ber,'x-.',ebn0,codedbersoftl4,'xk--',ebn0,codedbersoftl8,'xr-')
axis([0 7 0.0001 0.1])
xlabel('E_b/N_0 (dB)'); 
ylabel('BER');
title('BER of rate 1/2 K=3 Convolutional Code') 
legend('Uncoded BPSK','Uniform 4 bits','Uniform 8 bits') 




 
