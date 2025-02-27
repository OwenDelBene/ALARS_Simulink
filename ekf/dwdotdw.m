function dw = dwdotdw(w, ekf_data)

J1 = ekf_data.MOI(1,1);
J2 = ekf_data.MOI(2,2);
J3 = ekf_data.MOI(3,3);

dw = [0 w(3)*(J2-J3)/J1 w(2)*(J2-J3)/J1;
      w(3)*(J3-J1)/J2 0 w(1)*(J3-J1)/J2;
      w(2)*(J1-J2)/J3 w(1)*(J1-J2)/J3 0];

end