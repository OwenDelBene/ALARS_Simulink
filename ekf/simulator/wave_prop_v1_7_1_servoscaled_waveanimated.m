% Script developed by Marcus Facundo and Ozzy Cortes
% marcfacundo@tamu.edu, ocortes0811@tamu.edu
% Aero-401 - 2023

%{
user_seastate = input('Sea State: ');

% Prompting user for sea conditions for 2-d model
%}
% Valid Sea States integers 0 -> 8 in increasing 'roughness'

seastate = 8;
time_length = 30; % time in seconds
step_size = 0.05;    % How fast the pi receives instructions
boat_length = 33; % YP boatt length in m
data_points = time_length * 1/step_size; % (minimum 120 data points)
figure;

if seastate ~= 0
    [height_std, beta0,windvelocity] = searoughness(seastate);
    [height_std_max, beta0_max,windvelocity_max] = searoughness(8);
    % From Radar equations from modern radar chapt 9 models of sea clutter
    v = windvelocity;
    mean_h = 2.6*height_std;
    mean_h_max = 2.6*height_std_max;
    larg_third_h = 4*height_std;
    larg_tenth_h = 5.2*height_std;
    F0 = mean_h; % crest to trough is 2 x mean h
    F0_max = mean_h_max;
    
    switch seastate
        case {1,3,6}
            wave_length = mod((100 - 80)*rand(), (100 - 80)) + 80;
            freq = mod(rand(), (1/2.5 - 1/4)) + 1/4;     % 2.5 to 4 seconds
            freq_rad = freq * 6.28;
            velocity = wave_length * freq;
        case {4,7}
            wave_length = mod((200 - 100)*rand(), (200 - 100)) + 100;
            freq = mod(rand(), (1/7 - 1/9)) + 1/9;     % 7 to 9 seconds
            freq_rad = freq * 6.28;
            velocity = wave_length * freq;
        case {2,5,8}
            wave_length = mod((300 - 200)*rand(), (300 - 200)) + 200;
            freq = mod(rand(), (1/13 - 1/15)) + 1/15;    % Wave every 13 to 15 seconds
            freq_rad = freq * 6.28;
            velocity = wave_length * freq;
    end
     
    
    t1 = linspace(0,time_length,data_points);

    figure(1); clf;
    if boat_length >= F0
        wslope = asin(F0/boat_length) * 180/pi; % slope of the wave
    else
        wslope = 1;
    end
    pitch_wave = wslope * cos(freq_rad*t1); % Plot the position
    pitch_wave_rad = pitch_wave * pi/180;
    %plot(t, x); hold on;
    p1 = plot(t1,pitch_wave);
    yyaxis left
    xlabel('Time (s)');
    ylabel('Beta0 (degs)');
    title('Pitch')

    %for i=1:data_points
      %set(p1, 'YData', circshift(get(p1, 'YData'), 1)) 
      %you may want -1 here                       ^
      %depending on which direction you want to scroll
      %drawnow
    %end

    hold on;
    wave = (F0 / F0_max) * 6 * sin(freq_rad*t1); % + 0.0375 * A1 * sin(omega1*t1) + 0.0125 * A2 * sin(omega2*t1) Extra noise
    % Plot the position
    %plot(t, x); hold on;
    p2 = plot(t1,wave, 'color','red', 'LineStyle','-');
    yyaxis right
    ylim([-12 12]); 
    xlabel('Time (s)');
    ylabel('Position Y(t) scaled to Servo (in)');
    %legend('OG', 'Sample');
    %title('Mass-Spring-Damper System with Multiple Sinusoidal Forcing Terms');
    title('Exact Solution of Boat Dynamics')
    legend('Pitch Angle', 'Heave Height')

    %for i=1:data_points
      %set(p2, 'YData', circshift(get(p2, 'YData'), 1)) 
      % you may want -1 here                       ^
      % depending on which direction you want to scroll
      %drawnow
    %end

    


    %3d plot for heave in xyz space
    figure(3); clf;

    % Heading angle where 0 degrees aligns with x axis
    heading = 160; % limit angle between 0 and 180 degrees due to symmetry

    % Different Frequency in a 3d plot because its a heave vs XY plot
    threeD_freq = 6.28 / (wave_length);   % 1 Meter = 39.3701 in

    [x,y] = meshgrid(0:boat_length/6:600);  % Meters
    if heading <= 90
            z = F0 * sin((1 - heading/90)* threeD_freq * x + (heading/90)* threeD_freq *y);
        elseif heading > 90 && heading <= 180heading
            z = F0 * sin(-(heading/180)* threeD_freq *x + (1-heading/180)* threeD_freq *y);
        else
            fprintf("Choose a Heading that is between 0 and 180")
    end
    
    zlabel("Heave")
    
    p3 = surf(x,y,z);
    xlabel("Surge")
    ylabel("Sway")
    zlabel("Heave")
    zlim([-1.7*seastate, 20]);
    
   
end

t1_T = transpose(t1);
wave_T = transpose(wave);
pitch_wave_T = transpose(pitch_wave);
pitch_wave_rad_T = transpose(pitch_wave_rad);

out_array_heave = table(t1_T,wave_T);
out_array_pitch = table(t1_T,pitch_wave_T);
out_array_pitch_rad = table(t1_T,pitch_wave_rad_T);
    
writetable(out_array_heave,'heaveSol_SS8.txt','Delimiter','\t');
type heaveSol_SS8.txt

writetable(out_array_pitch,'pitchSol_SS8.txt','Delimiter','\t');
type pitchSol_SS8.txt

writetable(out_array_pitch_rad,'pitchSol_rad_SS8.txt','Delimiter','\t');
type pitchSol_rad_SS8.txt
