function [wavdvt,wavdvfm,wavpd,wavdmx,wavfmx,sumefx, ...
    sumefy,summfx,summfy] = directns(ef2d,fr,delf,nang,dtheta,mp,dep)
ainc =  pi/180 * dtheta;
nfre = length(fr);

omgg = (2*pi*fr).^2/9.81;
yy = omgg*dep;
xx = 1.0 + yy.*(0.66667 + yy.*(0.35550 + yy.*(0.16084 + yy.*(0.06320 + yy.* ...
    (0.02174 + yy.*(0.00654 + yy.*(0.00171 + yy.*(0.00039 + yy.*0.00011))))))));

x2 = 1./(yy + 1./xx);
x = sqrt(x2*9.81*dep);

wk = 2*pi*fr./x;
wavlen = 2*pi./wk;
cphz = wavlen.*fr;
tkh = 2.0*wk*dep;

ii = tkh > 20;
tkh(ii) = 20;
cgg = 0.5.*cphz.*(1.0 + tkh./sinh(tkh));

[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
sa = length(fr);
sint = repmat(sint,[sa 1]);cost = repmat(cost,[sa 1]);
sin2t = repmat(sin2t,[sa 1]);cos2t = repmat(cos2t,[sa 1]);
delsq = repmat(delf,[1 nang]);

xsum = sum(cost.*ef2d.*delsq,2);
ysum = sum(sint.*ef2d.*delsq,2);

sumefx = sum(cgg.*xsum.*ainc);
sumefy = sum(cgg.*ysum.*ainc);
summfx = sum(cgg.*xsum.*ainc./cphz);
summfy = sum(cgg.*ysum.*ainc./cphz);

sumx = sum(xsum);
sumy = sum(ysum);

wavdvt = atan2(sumy,sumx+1.0e-10);
wavdvt = 180/pi*wavdvt;
if wavdvt < 0
    wavdvt = wavdvt + 360;
elseif wavdvt >= 360 
    wavdvt = wavdvt - 360;
end

xsumfm = sum(cost(mp,:).*ef2d(mp,:));
ysumfm = sum(sint(mp,:).*ef2d(mp,:));
wavdvfm = atan2(ysumfm,xsumfm+1.0e-10);
wavdvfm = 180/pi*wavdvfm;
if wavdvfm < 0
    wavdvfm = wavdvfm + 360;
elseif wavdvfm >= 360
    wavdvfm = wavdvfm - 360;
end

efmax = max(max(ef2d));
qq = find(ef2d == efmax);
col = ceil(qq/nfre);
row = qq - ((col-1)*nfre);
emaxfth = ef2d(row,col);
kangbnd = col;
kangbnd = row;

wavfmx = fr(row(1));
wavdmx = ainc*180/pi*(col(1) - 1);

wavpd = peakdr(ef2d,mp,nfre,nang,dtheta);
wavpd = 180/pi*wavpd;
% % 
% %wavdvt = 270. -  wavdvt;
% %wavdvt = wavdvt - 180;
% if wavdvt < 0
%     wavdvt = wavdvt + 360;
% end
% %wavdvfm = 270 - wavdvfm;
% %wavdvfm = wavdvfm - 180;
% if wavdvfm < 0
%     wavdvfm = wavdvfm + 360;
% end
% wavdmx = 270 - wavdmx;
% %wavdmx = wavdmx - 180;
% if wavdmx < 0
%     wavdmx = wavdmx + 360;
% end
% wavpd = 270 - wavpd;
% %wavpd = wavpd - 180;
% if wavpd < 0
%     wavpd = wavpd + 360;
% end
   