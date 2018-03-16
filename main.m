%%
%main.m
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
transmitted=pskmod(code,2); %BPSK modulation

%%
%AWGN Noise.Comparison with Uncoded vs Convolutional Coding
snr=-2:9;
for i=1:length(snr)
    snr(i)
    noisy_signal=awgn(transmitted,snr(i),'measured');
    demod=pskdemod(noisy_signal,2); 
    [~,ber(i)]=biterr(code,demod); 
    %Convert message from binary into states for input to viterbi decoding
    transmitted_states=bin_to_states(demod);
    %Decoding using my Viterbi Algorithm
    [~,~,~,decoded_data] = viterbidec(K,transmitted_states);
    [~,codedber(i)]=biterr(msg,decoded_data);
    ebn0(i)=snr(i)-10*log10(1/2);%Rate-1/2 convolutional code
end
%%
%Plotting
semilogy(snr,ber,'x-.',ebn0,codedber,'xk-')
axis([1 10 0.0001 0.1])
xlabel('E_b/N_0 (dB)'); 
ylabel('BER');
title('BER of rate 1/2 K=3 Convolutional Code') 
legend('Uncoded BPSK','Conv Code') 




 
