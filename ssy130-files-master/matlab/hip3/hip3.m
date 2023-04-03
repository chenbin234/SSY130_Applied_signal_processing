%NO_PFILE
% HIP3

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

% Set up ground-truth motion
x = 0:0.01:9.99;
y = sin(0.5*x);
Y = [x;y];
Z = Y + 0.1*randn(size(Y));

% Plot input motion
figure(1);
plot(Y(1,:), Y(2,:), 'x');
xlabel('x');
ylabel('y');
title('Noise-free position');
xlim([-2 12]);
ylim([-1.5 1.5]);
grid on;

figure(2);
plot(Z(1,:), Z(2,:),'x');
xlabel('x');
ylabel('y');
title('Measured position');
xlim([-2 12]);
ylim([-1.5 1.5]);
grid on;
box on;
% Set up A, C, Q, R, x0, P0 here
T = 0.01;
N = 1000;
A = [1 T 0 0;0 1 0 0;0 0 1 T;0 0 0 1];
C = [1 0 0 0;0 0 1 0];
Q = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
R = 10000*[1  0; 0 1];
x0 = zeros(4,1);
P0 = 1e6*eye(4);

% Call your fancy kalman filter using the syntax
[Xfilt, Pp] = funs.kalm_filt(Z,A,C,Q,R,x0,P0);

figure(3);
subplot(3,1,1)
plot(Xfilt(1,:),Xfilt(3,:));
xlabel('x');
ylabel('y');
title('Estimated object trajectory');
xlim([-2 12]);
ylim([-1.5 1.5]);
grid on;


subplot(3,1,2);
plot(x,Xfilt(2,:))
xlabel('time(s)');
ylabel('Speed');
title('Estimated speed in x direction');
grid on;

subplot(3,1,3);
plot(x,Xfilt(4,:))
xlabel('time(s)');
ylabel('Speed');
title('Estimated speed in y direction');
grid on;
