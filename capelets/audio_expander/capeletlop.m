function capeletlop
% Frequency range for plot
f = 50:44100;
w = f*(2*pi);
ax = [-40, 10, f(1), f(end)];

% input second-order low pass
R1 = 27400;
R3 = 27400;
C2 = 330 * 1e-12;
C4 = 330 * 1e-12;
K = 1 + 16.2/27.4;

Hi = componentsToTransferFunction(R1, C2, R3, C4, K, w);

% Output second-order low pass
R1 = 28700;
R3 = 28700;
C2 = 440 * 1e-12;
C4 = 220 * 1e-12;
K = 1;
Ho = componentsToTransferFunction(R1, C2, R3, C4, K, w);

Htot = Hi .* Ho;
Hall = [Ho', Hi', Htot'];
magnitude = abs(Hall);
phase = angle(Hall);

subplot(2,1,1)
semilogx(f, 20*log10(magnitude))
title('Bela audio expander capelet analog filters frequency response')
axis([f(1) f(end) -50 10])
ylabel('Amplitude (dB)')
xlabel('Frequency (Hz)')
legend('Input filter', 'Output filter', 'Combined')
legend('Location', 'Southwest')
grid on

subplot(2,1,2)
semilogx(f, phase)
ylabel('Phase (rad)')
xlabel('Frequency (Hz)')
xlim([f(1) f(end)])
ylim([-pi, pi])
legend('Input filter', 'Output filter', 'Combined')
legend('Location', 'Southwest')
grid on

print('-dsvg', 'filter-response')
end

function H = componentsToTransferFunction(R1, C2, R3, C4, K, w)
% thanks http://hasler.ece.gatech.edu/Courses/ECE6414/Unit1/Discrete_01.pdf, page 1-15
B = 1/(R1*R3*C2*C4);
A = [1, (1/(R3*C4)+1/(R1*C2)+1/(R3*C2)-K/(R3*C4)), 1/(R1*R3*C2*C4)];
H = freqs(B, A, w);
end
