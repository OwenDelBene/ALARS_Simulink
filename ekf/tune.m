nSweep = 100;
Qsweep = linspace(1,1e5,nSweep);
errorTunedSea = zeros(1,nSweep);
errorTunedUav = zeros(1,nSweep);
for i = 1:nSweep
    ProcessNoise = Qsweep(i);
    Rmag = ProcessNoise;
    Qmag = 1;
    states = simulator(Qmag, Rmag, 0);
    errorTunedSea(i) = rms(vecnorm(states.ekf - states.true(1:2,:)));
    %states = main_simulator(Rmag, Qmag);
    %errorTunedUav(i) = rms(vecnorm(states.ekf - states.true(1:2,:)));
end
plot(Qsweep,errorTunedSea,'-',Qsweep,errorTunedUav,'-');
legend("Sea","Uav")
xlabel("Process Noise (Q)")
ylabel("RMS position error");