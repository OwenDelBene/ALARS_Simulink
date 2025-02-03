% Extract theta and yt values
theta = out.thetadata(:);
yt = out.ytdata(:,1);

% Plot y normal vector angle vs direction as Polar Coordinate Plot
polarplot(theta, yt);

