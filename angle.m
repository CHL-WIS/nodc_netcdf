function [sint cost sin2t cos2t] = angle(dtheta,nang)

theta = 270 - dtheta.*[0:nang-1];
anguse = 270 - theta;
tmp1 = pi/180 * anguse;
sint = sin(tmp1);
cost = cos(tmp1);
sin2t = sin(2.*tmp1);
cos2t = cos(2.*tmp1);
