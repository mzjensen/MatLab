%Zachri Jensen
%ENGR 444 Structural Design
%rd.m for class assignment 5/22/17
%
%Rigid Diaphragm Analysis (assumes lateral resisiting elements are parallel to x axis or
%parallel to y axis only)

%This analysis is specifically set up for any type of lateral resisting
%element.  Provide input as required.

%Open output file
fid=fopen('rdout.txt','w');

%User Input Starts Here

%Input resisting element "walls" Information ("walls" could be a braced frame)
nwalls=4; %number of walls***
%Origin starts at bottom left corner of the building(or bottom left corner
%of rectangle that encompasses the building)
xs=zeros(nwalls,1);%x wall start coordinate in feet
xe=zeros(nwalls,1);%x wall end coordinate
ys=zeros(nwalls,1);%y wall start coordinate
ye=zeros(nwalls,1);%y wall end coordinate

xs(1)=0; xe(1)=0; ys(1)=0; ye(1)=50;%***
xs(2)=15; xe(2)=65; ys(2)=50; ye(2)=50;%***
xs(3)=80; xe(3)=80; ys(3)=0; ye(3)=44;%***
xs(4)=60; xe(4)=80; ys(4)=0; ye(4)=0;%***

%Plot the walls
hold on
for i=1:nwalls;
    xw=[xs(i);xe(i)];
    yw=[ys(i);ye(i)];
    plot(xw,yw,'b','linewidth',3);
end;

%Input V and building long dimensions
V=82.14; %kips***
Longx=80;%Longest building x dimension (ft)***
Longy=50;%Longest building y dimension (ft)***

%Input Building perimeter(going around building counterclockwise)
%This is just for plotting.  Start and end on the start point (origin).
xb=[0;80;80;0;0];%coordinates in feet***
yb=[0;0;50;50;0];%***
plot(xb,yb,'k');
XMIN=min(xb);
XMAX=max(xb);
YMIN=min(yb);
YMAX=max(yb);
perc=0.05;
XMIN=XMIN-(XMAX-XMIN)*perc;
XMAX=XMAX+(XMAX-XMIN)*perc;
YMIN=YMIN-(YMAX-YMIN)*perc;
YMAX=YMAX+(YMAX-YMIN)*perc;
axis([XMIN XMAX YMIN YMAX])
axis equal

%Input center of mass information
xcm=40.592;
ycm=26.016;

%Input Rx and Ry (relative rigidities) for each lateral resisiting element
Rx=zeros(nwalls,1);
Ry=zeros(nwalls,1);
%X-direction relative rigidities
Rx(1)=0;%Walls oriented along the y direction will have Rx=0
Rx(2)=1.2898;
Rx(3)=0;
Rx(4)=0.3754;
%Y-direction relative rigidities
Ry(1)=1.2898;%Walls oriented along the x direction will have Ry=0
Ry(2)=0;
Ry(3)=1.1119;
Ry(4)=0;

%End of User Input

%Calculations

%Calculate center of mass for each wall
xwc=zeros(nwalls,1);%variable to hold x center of mass for each wall, ie Xi
ywc=zeros(nwalls,1);%variable to hold y center of mass for each wall, ie Yi
for i=1:nwalls;  
  xwc(i)=(xs(i)+xe(i))/2; %based on wall start and end coordinates
  ywc(i)=(ys(i)+ye(i))/2; %based on wall start and end coordinates
end;

%Display input center of mass coordinates
fprintf(fid,'Rigid Diaphragm Analysis Calculations\n\n');
fprintf(fid,'*** Input Center of Mass\n');
fprintf(fid,'%5s%12.1f ft, %5s%12.1f ft\n\n','Xcm =',xcm,'Ycm =',ycm);
% 
%Calculate the center of rigidity
Rxsum=0;
Rysum=0;
Rxysum=0;
Ryxsum=0;
Rxywc=zeros(nwalls,1);
Ryxwc=zeros(nwalls,1);
fprintf(fid,'*** Calculate Center of Rigidity\n');
fprintf(fid,'%7s%12s%12s%12s%12s%12s%12s\n','Element','Rx','Ry','Xi(ft)','Yi(ft)','XiRy','YiRx');
%Calculate the relative rigidities
for i=1:nwalls;
    if i==1 && Ry(1)>0;
        rnormal=Ry(1);
    elseif i==1
        rnormal=Rx(1);
    end;
    Rx(i)=Rx(i);%/rnormal;
    Ry(i)=Ry(i);%/rnormal;
    Rxsum=Rxsum+Rx(i);
    Rysum=Rysum+Ry(i);
    Rxywc(i)=Rx(i)*ywc(i);
    Rxysum=Rxysum+Rxywc(i);
    Ryxwc(i)=Ry(i)*xwc(i);
    Ryxsum=Ryxsum+Ryxwc(i);
    fprintf(fid,'%5i%12.2f%12.2f%12.1f%12.1f%12.1f%12.1f\n',i,Rx(i),Ry(i),xwc(i),ywc(i),Ryxwc(i),Rxywc(i));
end;
%print relevant sums
fprintf(fid,'%5s%12.2f%12.2f%24s%12.1f%12.1f\n\n','sum =',Rxsum,Rysum,' ',Ryxsum,Rxysum);
%Calculate and print center of rigidity
xcr=Ryxsum/Rysum;
ycr=Rxysum/Rxsum;
fprintf(fid,'%5s%12.1f ft, %5s%12.1f ft\n\n','Xcr =',xcr,'Ycr =',ycr);

%Calculate Jp, the polar moment of inertia
x2ysum=0;
y2xsum=0;
x2y=zeros(nwalls,1);
y2x=zeros(nwalls,1);
xstar=zeros(nwalls,1);
ystar=zeros(nwalls,1);
fprintf(fid,'*** Calculate Jp, X* = Xi-Xcr, Y* = Yi-Ycr\n');
fprintf(fid,'%7s%12s%12s%12s%12s%12s%12s\n','Element','Rx','Ry','X*(ft)','Y*(ft)','X*^2Ry','Y*^2Rx');
%Construct table to calculate Jp
for i=1:nwalls;
    xstar(i)=xwc(i)-xcr;
    ystar(i)=ywc(i)-ycr;
    x2y(i)=xstar(i)^2*Ry(i);
    y2x(i)=ystar(i)^2*Rx(i);
    x2ysum=x2ysum+x2y(i);
    y2xsum=y2xsum+y2x(i);
    fprintf(fid,'%5i%12.2f%12.2f%12.1f%12.1f%12.1f%12.1f\n',i,Rx(i),Ry(i),xstar(i),ystar(i),x2y(i),y2x(i));
end;
%print relevant sums
fprintf(fid,'%5s%48s%12.1f%12.1f\n\n','sum =',' ',x2ysum,y2xsum);
%Calculate and print Jp
Jp=x2ysum+y2xsum;
fprintf(fid,'%5s%12.1f\n\n','Jp =',Jp);

%Calculate direct shears for x and y loading
Vxdirect=zeros(nwalls,1);
Vydirect=zeros(nwalls,1);
for i=1:nwalls;
    Vxdirect(i)=V*Rx(i)/Rxsum;
    Vydirect(i)=V*Ry(i)/Rysum;
end;    

%Calculate the 5% accidental eccentricities
ex=0.05*Longx;
ey=0.05*Longy;

%From here down is modified 5-9-14
%Calculate the Torsion cases for x loading
Txreal=V*(ycm-ycr); %due to real eccentricity
Txaccid=V*ey; %due to +accidental eccentricity

%Calculate torsional shears for x loading
Vtxaccid=zeros(nwalls,1); %for x direction walls
Vtxreal=zeros(nwalls,1); %for x direction walls
Vtyaccid=zeros(nwalls,1); %for y direction walls
Vtyreal=zeros(nwalls,1); %for y direction walls
xvmax=zeros(nwalls,1); %max shear for given wall due to x loading
for i=1:nwalls;
    Vtxaccid(i)=Txaccid*ystar(i)*Rx(i)/Jp;    
    Vtxreal(i)=Txreal*ystar(i)*Rx(i)/Jp;
    Vtyaccid(i)=Txaccid*xstar(i)*Ry(i)/Jp;
    Vtyreal(i)=Txreal*xstar(i)*Ry(i)/Jp;

    if Ry(i)>0 %if y wall, record shears due to x loading caused torques in Vtx variables
        Vtxreal(i)=Vtyreal(i);
        Vtxaccid(i)=Vtyaccid(i);
    end;

    xv=(Vxdirect(i)+Vtxreal(i)+abs(Vtxaccid(i)));
    yv=(Vtyreal(i)+abs(Vtyaccid(i)));
    xvmax(i)=max(xv,yv);        
end;

%Print results for xloading
fprintf(fid,'*** Calculate Shears Due To X-Direction Loading\n');
fprintf(fid,'Tx real = %10.1f, ',Txreal);
fprintf(fid,'Tx accidental = %10.1f, ',Txaccid);
fprintf(fid,'real ey = %7.1f, ',ycm-ycr);
fprintf(fid,'accid. ey = %7.1f\n',ey);

fprintf(fid,'%7s%12s%12s%12s%12s\n','Element','Vx direct','Vtx real','Vtx accid','Vxmax');
for i=1:nwalls;
    fprintf(fid,'%7i%12.1f%12.1f%12.1f%12.1f\n',i,Vxdirect(i),Vtxreal(i),Vtxaccid(i),xvmax(i));
end;
fprintf(fid,'\n');

%Calculate the Torsion cases for y loading
Tyreal=V*(xcm-xcr); %due to real eccentricity
Tyaccid=V*ex; %due to accidental eccentricity

%Calculate torsional shears for y loading
Vtyaccid=zeros(nwalls,1); %for y direction walls
Vtyreal=zeros(nwalls,1); %for y direction walls
Vtxaccid=zeros(nwalls,1); %for x direction walls
Vtxreal=zeros(nwalls,1); %for x direction walls
yvmax=zeros(nwalls,1); %max shear for given wall due to y loading
for i=1:nwalls;
    Vtyaccid(i)=Tyaccid*xstar(i)*Ry(i)/Jp;
    Vtyreal(i)=Tyreal*xstar(i)*Ry(i)/Jp;
    Vtxaccid(i)=Tyaccid*ystar(i)*Rx(i)/Jp;
    Vtxreal(i)=Tyreal*ystar(i)*Rx(i)/Jp;  
    if Rx(i)>0 %if x wall, record shears due to y loading caused torques in Vty variables
        Vtyreal(i)=Vtxreal(i);
        Vtyaccid(i)=Vtxaccid(i);
    end;
    xv=(Vtxreal(i)+abs(Vtxaccid(i)));
    yv=(Vydirect(i)+Vtyreal(i)+abs(Vtyaccid(i)));
    yvmax(i)=max(xv,yv);
end;

%Print results for yloading
fprintf(fid,'*** Calculate Shears Due To Y-Direction Loading\n');
fprintf(fid,'Ty real = %10.1f, ',Tyreal);
fprintf(fid,'Ty accidental = %10.1f, ',Tyaccid);
fprintf(fid,'real ex = %7.1f, ',xcm-xcr);
fprintf(fid,'accid. ex = %7.1f\n',ex);

fprintf(fid,'%7s%12s%12s%12s%12s\n','Element','Vy direct','Vty real','Vty accid','Vymax');
for i=1:nwalls;
    fprintf(fid,'%7i%12.1f%12.1f%12.1f%12.1f\n',i,Vydirect(i),Vtyreal(i),Vtyaccid(i),yvmax(i));
end;
fprintf(fid,'\n');

%Print summary of overall maximum shears
fprintf(fid,'*** Summary of Maximum Element Shears\n');
fprintf(fid,'%7s   %12s\n','Element','V max(kips)');
Vmax=zeros(nwalls,1);
for i=1:nwalls;
    Vmax(i)=max(abs(xvmax(i)),abs(yvmax(i)));
    fprintf(fid,'%7i   %12.1f\n',i,Vmax(i));
end;
%fprintf(fid,'\n');

%Close ouput file
fclose(fid);    


