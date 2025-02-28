% Extract theta and yt values
theta = out.thetadata(:);
yt = out.ytdata(:,1);

% Plot y normal vector angle vs direction as a Polar Coordinate Plot
polarplot(theta(1000:end), yt(1000:end));

title('Distal Plate Normal Vector Angle vs Direction');
