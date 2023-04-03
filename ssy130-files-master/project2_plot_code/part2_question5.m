f0 = 440;
fs = 16000;

k = 1:50;
y = sin(2*pi*f0*k./fs);

% figure(1);
% plot(k,y);


figure(2);
subplot(2,1,1);
plot(abs(fft(y,fs))); 
subplot(2,1,2)
plot(angle(fft(y,fs)));

figure(3);
subplot(2,1,1);
plot(abs(fft([0 250],fs)));
subplot(2,1,2)
plot(angle(fft([0 250],fs)));

