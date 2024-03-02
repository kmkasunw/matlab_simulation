clear all;
close all;
clc;

N = 10^6; %Number of bits
Ps = 1 ; %Transmission power of the source
snr_db = -5:1:15; %Transmission SNR[dB]

%----BPSK data generation-----%

binary_data = randsrc(1,N,[0,1]);%Generation of random bits
BPSK_data = 2*binary_data - 1; %BPSK data

%-----------------------------%

%----Random AWGN noise--------%

n_SD = AWGNNoise(N);
%-----------------------------%


for k = 1:length(snr_db)
   
  %-----Noise power calculation-----%
  
  SNR(k) = 10.^(snr_db(k)/10); %SNR value in linear
  
  Noise_power(k) = Ps./SNR(k); %calculation of noise power
  
  %---------------------------------%
  
  %----Received signal from source to destination-----%
  
  y_SD = sqrt(Ps).*BPSK_data + sqrt(Noise_power(k)).*n_SD;
  %---------------------------------------------------%
  
  %------------------Zero force decode---------------%
  
  data_SD = real(y_SD) > 0 ; % real(y_SD) > 0 ---> 1 , otherwise --> 0 
  %--------------------------------------------------%
  
  %-----------Calculation of error bits--------------%
  
  error_SD(k) = size(find(binary_data - data_SD),2);
  
  %--------------------------------------------------%
    
end


%-----BER calculation - Practical ------%

BER_SD_prac = error_SD./N;

%----------------------------------------%

%-----BER calculation - Theoritical ------%

BER_SD_theo = qfunc(sqrt(SNR));

%----------------------------------------%

%-----------Plot-------------------------%

figure(1)
semilogy(snr_db,BER_SD_prac,'r-*');
hold on;
semilogy(snr_db,BER_SD_theo,'k-+');
legend('Practical','Theoritical');
title('Comparision of BER performance on AWGN channel');
xlabel('SNR[dB]');
ylabel('BER');
grid on;
datacursormode on;
hold off;

%-----------------------------------------%

function n = AWGNNoise(N)

n = randn(1,N);

end
 
