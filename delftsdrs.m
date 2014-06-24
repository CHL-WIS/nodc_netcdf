function [delftmdr,delftpdr,delftsprd] = delftsdrs(ef2d,fr,delf,nang,dtheta)

ainc =  pi/180 * dtheta;
nfre = length(fr);
ife = nfre - 1;
ide = nang;
idt = -1;

dire = 270 - dtheta.*[0:ide-1];
dfsq = repmat(delf,[1 nang]);
etf = sum(dfsq(1:ife,:).*(ef2d(1:ife,:) + ef2d(2:ife+1,:)));

ii = find(etf == max(etf));
etop = etf(ii);
idt = ii;

if idt > 0
    delftpdr = dire(max(idt));
    if delftpdr < 0
        delftpdr = delftpdr + 360;
    else
        delftpdr = -999.;
    end
end

[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
edt = etf*ainc;
sum0 = sum(edt);
eex = sum(cost.*edt);
eey = sum(sint.*edt);

if sum0 > 0 
    ff = sqrt((eex*eex + eey*eey)/(sum0*sum0));
    if ff <= 1.0
        delftsprd = 180/pi*sqrt(2.0 - 2.0*ff);
    else
        delftsprd = 0.0;
    end
    
    delftmdr = 180/pi*atan2(eey,eex+1.0e-10);
    delftmdr = 270 - delftmdr;
    if delftmdr < 0 
        delftmdr = delftmdr + 360;
    end
else
    delftmdr = -999.;
    delfttpdr = -999.;
    delftsprd = -999.;
end

