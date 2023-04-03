%NO_PFILE
function [funs, student_id] = student_sols()
%STUDENT_SOLS Contains all student solutions to problems.

% ----------------------------------------
%               STEP 1
% ----------------------------------------
% Set to your birthdate / the birthdate of one member in the group.
% Should a numeric value of format YYYYMMDD, e.g.
% student_id = 19900101;
% This value must be correct in order to generate a valid secret key.
student_id = 19941227;


% ----------------------------------------
%               STEP 2
% ----------------------------------------
% Your task is to implement the following skeleton functions.
% You are free to use any of the utility functions located in the same
% directory as this file as well as any of the standard matlab functions.


    function h = gen_filter()
        delta_t=1;
        freq_cut = 0.05;
        freq_stop = 0.1;
        freq_sample=1/delta_t;
        freq_Nyquist = freq_sample/2;
        f = [0 freq_cut freq_stop freq_Nyquist]/freq_Nyquist; %nomialized frequency
        w = 2*pi*f*freq_Nyquist;
        a = [0 1 0 0].*w;
        h = firpm(60,f,a,"differentiator"); 
        
        %plot the magnitude of the frequency function
        %in linear scale.
        figure(6);
        [h1,w] = freqz(h,1,512);
        plot(f,a,w/pi,abs(h1),'LineWidth',1.5)
        legend('Ideal','firpm Design','FontSize', 15)
        xlabel('Normalized Frequency (\times\pi rad/sample)','FontSize', 15)
        ylabel('Magnitude','FontSize', 15)

    end

funs.gen_filter = @gen_filter;





% This file will return a structure with handles to the functions you have
% implemented. You can call them if you wish, for example:
% funs = student_sols();
% some_output = funs.some_function(some_input);

end

