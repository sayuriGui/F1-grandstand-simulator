clc;
clear;
prompt = 'Enter 1 to view the route without skid, 2 to view the skid and 3 to view the race with increasing speed: ';
opc = input(prompt);
set(gcf, 'Position', get(0, 'Screensize')); warning('off','all'); %Full screen
%Coefficients
a=0.0000308485776;
b=-0.0434416994824;
c=19.3123869158359;
d=-2344.365583991985;

%Function of the graph modeling and its derivatives
f = @(x) a.*x.^3 + b.*x.^2 + c.*x + d;
d1 = @(x) 3*(a.*x.^2) + 2*(b.*x) + c;   %Calculate arc length
d2 = @(x) 6*(a.*x) + 2*(b);             %Calculate curvature radius

%Function to be integrated to obtain the arc length
arc = @(x) sqrt(1+(3*(a.*x.^2) + 2*(b.*x) + c).^2);

%Define the speed of the vehicle
if opc == 1
    vkm = 60;       %Speed km/h
    iteration = 1;
end
if opc == 2
    vkm = 200;       %Speed km/h
    iteration = 1;
end
if opc == 3
    vkm = 60;       %Speed km/h
    iteration = 6;
end
v = vkm/3.6;    %Speed m/s

%
limin = 227.12; %Minimum limit on x
limax = 762.2;  %Maximum limit on x
h = 1;  %Step
frictioncoeff = 1.6; %Friction coefficient
x1 = limin:h:limax; %Vector x
y1 = f(x1);         %Vector y

hold on;
%Grandstand
patch("Faces", [1,2,3,4], "Vertices", [271.058 418.651; 276.913 410.544; 341.767 457.384; 335.912 465.49], "Facecolor", "blue");
patch("Faces", [1,2,3,4], "Vertices", [539.746, 325.236; 614.688, 353.23; 618.187, 343.863; 543.245, 315.868], "Facecolor", "blue");
%Race Track
plot(x1,y1,"black", "Linewidth", 12);
plot(x1,y1,"--white", "Linewidth", 1);

% Repeat the route 6 times with increasing speed
for i = 1:iteration 
    %   
    for k = 1:2:length(x1) 
        r = abs((1+(d1(x1(k))^2)^(3/2))/d2(x1(k))); %Radius of curvature at point
        dist = integral(arc, x1(1), x1(k)); %Integral of the radius of curvature function, to calculate arc length
        tiempo = dist / v;  %Time
        hold on
        %Speed at the point
        vmax = sqrt(r*9.81*frictioncoeff);
        %Transfer information
        text(400,700,['Speed = ' num2str(v*3.6) 'Km/h'], "Fontsize", 14)
        text(400,680,['Radius of curvature at point = ' num2str(r)], "Fontsize", 14);
        text(400,660,['Maximum speed at point = ' num2str(vmax*3.6) ' Km/h'], "Fontsize", 14);
        text(400,640,['X = ' num2str(x1(k)) ' Y = ' num2str(y1(k))], "Fontsize", 14);
        text(400,620,['Distance traveled = ' num2str(dist)], "Fontsize", 14);
        text(400,600,['Time = ' num2str(tiempo)], "Fontsize", 14);
        patch("Faces", [1,2,3,4], "Vertices", [271.058 418.651; 276.913 410.544; 341.767 457.384; 335.912 465.49], "Facecolor", "blue");
        patch("Faces", [1,2,3,4], "Vertices", [539.746, 325.236; 614.688, 353.23; 618.187, 343.863; 543.245, 315.868], "Facecolor", "blue");
        plot(x1,y1,"black", "Linewidth", 12);
        plot(x1,y1,"--white", "Linewidth", 1);

        %Check if it can continue
        if vmax > v %Yes, it can
            plot(x1(k),y1(k), "r.", "Markersize", 45)
        else %No, it cannot
            p = x1(k):0.5:x1(k)+100;
            
            %Trace the skid line
            for m = 1:1:length(p)
                py = (d1(x1(k)) * p)-(d1(x1(k)) * p(1))+f(x1(k));
                plot(p(m),py(m), "r.", "Markersize", 15);
                pause(0.001);
                text(400,580,'SKID', "Fontsize", 30, "Color", "red");
            end
            break
        end
        pause(0.01);
        hold off
        text(400,700,['Velocity = ' num2str(v*3.6) 'Km/h'], "Fontsize", 14);
        text(400,680,['Radius of curvature at point = ' num2str(r)], "Fontsize", 14);
        patch("Faces", [1,2,3,4], "Vertices", [271.058 418.651; 276.913 410.544; 341.767 457.384; 335.912 465.49], "Facecolor", "blue");
        patch("Faces", [1,2,3,4], "Vertices", [539.746, 325.236; 614.688, 353.23; 618.187, 343.863; 543.245, 315.868], "Facecolor", "blue");
        plot(x1,y1,"black", "Linewidth", 12);
        plot(x1,y1,"--white", "Linewidth", 1);
        
    end 
    hold on
    plot(x1,y1,"black", "Linewidth", 12);
    plot(x1,y1,"--white", "Linewidth", 1);
    text(400,700,['Velocity = ' num2str(v*3.6) 'Km/h'], "Fontsize", 14);
    text(400,680,['Radius of curvature at point = ' num2str(r)], "Fontsize", 14);
    text(400,660,['Maximum speed at the point = ' num2str(vmax*3.6) ' Km/h'], "Fontsize", 14);
    text(400,640,['X = ' num2str(x1(k)) ' Y = ' num2str(y1(k))], "Fontsize", 14);
    text(400,620,['Distance traveled = ' num2str(dist)], "Fontsize", 14);
    text(400,600,['Time = ' num2str(tiempo)], "Fontsize", 14);
    patch("Faces", [1,2,3,4], "Vertices", [271.058 418.651; 276.913 410.544; 341.767 457.384; 335.912 465.49], "Facecolor", "blue");
    patch("Faces", [1,2,3,4], "Vertices", [539.746, 325.236; 614.688, 353.23; 618.187, 343.863; 543.245, 315.868], "Facecolor", "blue");
    
    %Increase speed by 5 m/s
    v = v+5;
    pause(1);
end