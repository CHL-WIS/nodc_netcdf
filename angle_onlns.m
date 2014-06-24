function [sint,cost,sin2t,cos2t] = angle_onlns(dtheta,nang)

anguse = 270 - dtheta.*(0:nang-1);
theta = 270 - anguse;
tmp1 = pi/180 * theta;
sint = sin(tmp1);
cost = cos(tmp1);
sin2t = sin(2.*tmp1);
cos2t = cos(2.*tmp1);
