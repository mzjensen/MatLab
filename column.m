% column.m
% Matlab script for calculated the capacity of a concrete column with n layers of steel
% Zachri Jensen
% ENGR 442 Reinforced Concrete Design
% February 22, 2017

% Start of user input
	
% Material properties

fc = 3; 			% Compressive strength of concrete (ksi)
eu = 0.003;			% Strain of concrete at ultimate condition
fy = 60;			% Yield strength of steel reinforcement (ksi)
Es = 29000;			% Modulus of elasticity for steel (ksi)

% Section geometry

b = 10;				% Width of column cross-section (in)
h = 18;				% Height of column cross-section (in)
n = 5;				% Number of layers of steel

d = zeros(n,1);		% Array of steel layer depths
d(1) = 2;			% Depths are in inches
d(2) = 4;
d(3) = 9;
d(4) = 14;
d(5) = 16;

As = zeros(n,1);	% Array of cross-sectional areas of each steel layer
As(1) = 0.44;		% Areas are in square inches
As(2) = 0.44;
As(3) = 0.44;
As(4) = 0.44;
As(5) = 0.44;
  
% Enter number of c values

numcvals = 51;

% End of user input
	
% Preliminary calculations
	
if fc <= 4
	beta1 = 0.85;
elseif fc > 4 && fc < 8
	beta1 = 0.85-0.05*fc;
else
	beta1 = 0.65;
end

% Set variables

Pn = zeros(numcvals+1,1);
Mn = zeros(numcvals+1,1);
phiPn = zeros(numcvals+1,1);
phiMn = zeros(numcvals+1,1);

% Loop over the c values
	
for i = 1:numcvals;
	sumTs = 0;
	sumTsmom = 0;
	c = (i-1)*(h/beta1)/(numcvals-1);
	
	if i == 1
        c = 0.001;  % Prevent c from being zero so we are not dividing by zero
    end
		
	for j = 1:n
		es = (c-d(j))/c*eu;
		fs = Es*es;
		
		if abs(fs) > fy
			fs = fs/abs(fs)*fy;
		end
		
		if fs > 0
			fs = fs-0.85*fc;
		end
		
		sumTs = sumTs + fs*As(j);
		sumTsmom = sumTsmom + fs*As(j)*(h/2-d(j));
	end
		
	Pn(i) = sumTs + 0.85*fc*beta1*c*b;
	Mn(i) = sumTsmom + 0.85*fc*beta1*c*b*(h/2-beta1*c/2);
	dmax = max(d);
	et = (dmax-c)/c*eu;
	phi = 0.483+83.3*et;
	
	if phi > 0.9
		phi = 0.9;
	elseif phi < 0.65
		phi = 0.65;
	end
	
	phiPn(i) = phi*Pn(i);
	phiMn(i) = phi*Mn(i);
	
end

% Add in case of Mn = 0

Asum = sum(As);
phi = 0.65;
Pn(numcvals+1) = 0.85*fc*(b*h-Asum)+Asum*fy;
phiPn(numcvals+1) = phi*Pn(numcvals+1);
Mn(numcvals+1) = 0;
phiMn(numcvals+1) = 0;

% Plot the interaction diagram
	
plot(Mn,Pn,'b');
hold on
plot(phiMn,phiPn,'k.-');
grid on
legend('(M_n , P_n)','(\phiM_n , \phiP_n)');
xlabel('M_n , \phiM_n (kip-in)');
ylabel('P_n , \phiP_n, (kips)');
title('Concrete Column Interaction Diagram');