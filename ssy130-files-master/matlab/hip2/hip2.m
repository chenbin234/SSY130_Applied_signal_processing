%NO_PFILE
% HIP2

% Perform the following steps:
%   1) In student_sols.m, update the student_id variable as described
%   there.
%
%   2) In student_sols.m, complete all the partially-complete functions.
%   (Indicated by a '%TODO: ...' comment). Note that all the functions you
%   need to complete are located in student_sols.m (and only in
%   student_sols.m). You can test these functions by running this file,
%   which will apply a self-test to your functions. When all functions pass
%   the self-test, a unique password will be printed in the terminal. Be
%   sure to include this password in your submission.
%
%   3) Now that the functions in student_sols.m are completed, continue
%   working with this file. Notably, your finished functions will be used
%   to evaluate the behavior of the assignment.
%
% -------------------------------------------------------------------------
%                    Note on function handles
% -------------------------------------------------------------------------
% In this file, we will make use of function handles. A function handle is
% a variable that refers to a function. For example:
%
% x = @plot
%
% assigns a handle to the plot function to the variable x. This allows to
% for example do something like
%
% x(sin(linspace(0,2*pi)))
%
% to call the plot function. Usefully for you, there exist function handles
% to all the functions you've written in student_sols.m. See below for
% exactly how to call them in this assignment.
%
% -------------------------------------------------------------------------
%                    Final notes
% -------------------------------------------------------------------------
%
% The apply_tests() function will set the random-number generator to a
% fixed seed (based on the student_id parameter). This means that repeated
% calls to functions that use randomness will return identical values. This
% is in fact a "good thing" as it means your code is repeatable. If you
% want to perform multiple tests you will need to call your functions
% several times after the apply_tests() function rather than re-running
% this entire file.
%
% Note on debugging: if you wish to debug your solution (e.g. using a
% breakpoint in student_sols.m), comment out the line where the apply_tests
% function is called in the hand-in/project script. If you do not do this
% then you'll end up debugging your function when it is called during the
% self-test routine, which is probably not what you want. (Among other
% things, you won't be able to control the input to your functions).
%
% Files with a .p extension are intentionally obfusticated (they cannot
% easily be read). These files contain the solutions to the tasks you are
% to solve (and are used in order to self-test your code). Though it is
% theoretically possible to break into them and extract the solutions,
% doing this will take you *much* longer than just solving the posed tasks
% =)

% Do some cleanup
clc
clear variables
format short eng

% Perform all self-tests of functions in student_sol.m
apply_tests();

% Load student-written functions
funs = student_sols();

% Call your function to get the generated filter coefficients
h = funs.gen_filter();

% Load the reference signals
load hip2.mat

% Here are some sample plots to illustrate the behavior of your filter.
% Feel free to modify, re-use, or completely remove the following lines.

freq_sample = 1;%Hz
w_sample = 2*pi*freq_sample; %rad/s

% Plot the filter coefficiencts and magnitude/phase response
figure(1);
stem(h);
title('Filter coefficients');
xlabel('n','FontSize', 15);
ylabel('h(n)','FontSize', 15);


figure(2);
N_fft = 1e3;    %Zero-pad FFT for increased frequency resolution
plot(abs(fft(h, N_fft)));
title('Filter magnitude response');
xlabel('A frequency unit (which?)');
ylabel('|H|');


figure(3);
plot(unwrap(angle(fft(h, N_fft))));
title('Filter phase response');
xlabel('A frequency unit (which?)');
ylabel('arg(H)');

% Plot the reference signals
figure(4);
plot(noisy_position);
hold on;
plot(true_position);
title('Reference signals');
ylabel('Some unit?');
xlabel('Some unit?');
legend('Noisy position', 'True position');

% Generate a plot of the noise frequency distribution
% We can "cheat" and get the noise by subtracting the true signal from the
%  measured position
n = noisy_position - true_position;
figure(5);
plot(abs(fft(n)).^2);
xlabel('Some frequency unit?');
ylabel('Periodogram of noise');
title('Frequency distribution of noise in measured position');

close all;

% Filter the true_position and noisy_position signals 
% through the designed filter.
% 1 m/s = 3.6 km/h
speed_designed_filter_true = conv(h,true_position)*3.6;
speed_designed_filter_noisy = conv(h,noisy_position)*3.6;
N = length(true_position);
figure(7);
plot(1:N,speed_designed_filter_true(31:31+N-1))%compensate the polts for the delay 30s
hold on;
plot(1:N,speed_designed_filter_noisy(31:31+N-1))%compensate the polts for the delay 30s
axis([0 600 -100 220])
title('Estimate vehicle speed using designed filter');
legend('true signal','noisy signal','FontSize', 15)
xlabel('Time','FontSize', 15)
ylabel('Estimated Speed (km/h)','FontSize', 15)
disp(['the maximum of the vehicle found from observed signal is:',num2str(max(speed_designed_filter_noisy(31:N-1))),' km/h'])
disp(['the maximum of the vehicle found from true signal is:',num2str(max(speed_designed_filter_true(31:N-1))),' km/h'])

% Filter the true_position and noisy_position signals 
% through the trivial Euler filter.
h_Euler = [1 -1];
speed_Euler_filter_true = conv(h_Euler,true_position)*3.6;
speed_Euler_filter_noisy = conv(h_Euler,noisy_position)*3.6;
N = length(true_position);
figure(8);
plot(1:N,speed_Euler_filter_true(2:end))%compensate the polts for the delay 1s
hold on;
plot(1:N,speed_Euler_filter_noisy(2:end))%compensate the polts for the delay 1s
axis([0 600 -200 600])
title('Estimate vehicle speed using Euler filter');
legend('true signal','noisy signal','FontSize', 15)
xlabel('Time','FontSize', 15)
ylabel('Estimated Speed (km/h)','FontSize', 15)


% At the end of the filter output very large oscillations occur. 
% Why? Hint: test filtering with the signals
y1 = [noisy_position; flip(noisy_position)];
y2 = [noisy_position; zeros(length(noisy_position),1)];
filter_y1 = conv(y1,h)*3.6;
filter_y2 = conv(y2,h)*3.6;
figure(9);
plot(1:N,filter_y1(31:31+N-1),'LineWidth',2,Color='y')
hold on;
plot(1:N,filter_y2(31:31+N-1),Color='r')
axis([0 600 -100 220])
title('output of filtering the signal y1 and y2');
legend('filter y1','filter y2','FontSize', 15)
% xlabel('Time','FontSize', 15)
% ylabel('Estimated Speed','FontSize', 15)
