function states = ekf_simulator(time_length, step_size, seastate)


%seastate = 8;
%time_length = 30; % time in seconds
%step_size = 0.05;    % How fast the pi receives instructions
boat_length = 33; % YP boatt length in m
data_points = time_length * 1/step_size; % (minimum 120 data points)

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

    if boat_length >= F0
        wslope = asin(F0/boat_length) * 180/pi; % slope of the wave
    else
        wslope = 1;
    end
    pitch_phase = pi/12 * 0;
    roll_phase =  pi/12 * 0;
    pitch_noise = 5e-3
    pitch_wave = wslope * sin(freq_rad*t1 - pitch_phase); % Plot the position
    pitch_wave_rad = pitch_wave * pi/180 + rand(size(pitch_wave))*pitch_noise;
    roll_wave  = wslope * sin(freq_rad*t1 - roll_phase);
    roll_wave_rad = roll_wave * pi/180 + rand(size(pitch_wave))*1e-4 ;
    
    pitch_dot = wslope * freq_rad * cos(freq_rad*t1 - pitch_phase);
    pitch_dot_rad = pitch_dot * pi/180 + rand(size(pitch_wave))*pitch_noise ;
    roll_dot  = wslope * freq_rad * cos(freq_rad*t1 - roll_phase);
    roll_dot_rad = roll_dot * pi/180 + rand(size(pitch_wave))*1e-4 ;

    

    %plot(t, x); hold on;

    %for i=1:data_points
      %set(p1, 'YData', circshift(get(p1, 'YData'), 1)) 
      %you may want -1 here                       ^
      %depending on which direction you want to scroll
      %drawnow
    %end

    wave = (F0 / F0_max) * 6 * sin(freq_rad*t1); % + 0.0375 * A1 * sin(omega1*t1) + 0.0125 * A2 * sin(omega2*t1) Extra noise
    % Plot the position
    %plot(t, x); hold on;
    %states = [roll_wave_rad; pitch_wave_rad; roll_dot_rad; pitch_dot_rad];
    states = [roll_wave_rad; pitch_wave_rad; roll_dot_rad; pitch_dot_rad];
end