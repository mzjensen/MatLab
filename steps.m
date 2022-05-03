%Title: steps.m
%Author: Zachri Jensen
%Class: ENGR 325 Instrumentation
%Date: 1/17/17
%Description: This script creates multiple plots for walking step
%distance, velocity, and acceleration over time. Random noise is introduced
%to illustrate the powerful effect of noisy position data on
%velocity and acceleration.

%Declare variables
step = 2.75*12;                     %step size, in inches
t_min = 0;                          %time value lower bound, in seconds
t_max = 100;                        %time value upper bound, in seconds
deltaT = 1;                         %time step, in seconds
t = t_min:deltaT:t_max;             %time values matrix

%Calculate position, velocity and acceleration
pos = step*t;      
vel = pos./t;
vel(1)=0;

for i=t_min:t_max-2;
    accl(i+2)=(vel(i+2)-vel(i+3))/deltaT;
end;
accl(2)=step/deltaT;
accl(101)=0;

%Plot noise
figure
subplot(3,1,1);
plot(t,pos);
title('Walking Distance Over Time');
xlabel('Time (s)');
ylabel('Position (in)');

subplot(3,1,2);
plot(t,vel);
title('Walking Velocity Over Time');
xlabel('Time (s)');
ylabel('Velocity (in/s)');

subplot(3,1,3);
plot(t,accl);
title('Walking Acceleration Over Time');
xlabel('Time (s)');
ylabel('Acceleration (in/s^{2})');

%Add +/- 10% noise in step size
a = -0.1;
b = 0.1;
for i=t_min:t_max-1;
    pos(i+2)=pos(i+1)+step+step*((b-a).*rand + a);
end;

for i=t_min:t_max-2;
    vel(i+2)=(pos(i+3)-pos(i+2))/deltaT;
    vel(1)=0;
end;

for i=t_min:t_max-2;
    accl(i+2)=(vel(i+2)-vel(i+3))/deltaT;
end;
accl(2)=step/deltaT;
accl(101)=0;

%Plot
figure
subplot(3,1,1);
plot(t,pos);
title('Walking Distance Over Time (with noise)');
xlabel('Time (s)');
ylabel('Position (in)');

subplot(3,1,2);
plot(t,vel);
title('Walking Velocity Over Time (with noise)');
xlabel('Time (s)');
ylabel('Velocity (in/s)');

subplot(3,1,3);
plot(t,accl);
title('Walking Acceleration Over Time (with noise)');
xlabel('Time (s)');
ylabel('Acceleration (in/s^{2})');
