function thpeak = peakdr(ef2d,mp,nfre,nang,dtheta)

[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
ainc =  pi/180 * dtheta;
ii = find(ef2d(mp,:) == max(ef2d(mp,:)));
emaxdr = ef2d(mp,ii(1));
kp = ii(1);

mpk = mp;
kpk = kp;
kpl1 = kpk + 1;
kpm1 = kpk - 1;

if kpl1 > nang 
    kpl1 = kpl1 - nang;
end
if kpm1 <= 0
    kpm1 = kpm1 + nang;
end

thpeak = ainc*kp;
thpkk = thpeak*180/pi;
difefpm = abs(ef2d(mpk,kpl1) - ef2d(mpk,kpm1));
if difefpm > 1.0e-05
    vdx1 = (cost(kpk) - cost(kpl1)) * (cost(kpm1) - cost(kpk));
    denvdx = cost(kpm1) - cost(kpl1);
    if abs(denvdx) < 1.0e-20
        return
    end
    vdx2 = (ef2d(mpk,kpm1) - ef2d(mpk,kpl1)) * (cost(kpm1) - cost(kpk)) ...
        / (cost(kpm1) - cost(kpl1));
    if abs(vdx1) < 1.0e-20
        return
    end
    adx = (ef2d(mpk,kpm1) - ef2d(mpk,kpk) - vdx2) / vdx1;
    denomx = (cost(kpm1) - cost(kpl1)) - adx * (cost(kpm1) + cost(kpl1));
    if abs(denomx) < 1.0e-20
        return
    end
    bdx = (ef2d(mpk,kpm1) - ef2d(mpk,kpl1)) / (cost(kpm1) - cost(kpl1)) ...
        - adx * (cost(kpm1) + cost(kpl1));
    if abs(adx) < 1.0e-20
        return
    end
    xcomp = -0.5*bdx/adx;
    
    vdy1 = (sint(kpk) - sint(kpl1)) * (sint(kpm1) - sint(kpk));
    denvdy = sint(kpm1) - sint(kpl1);
    if abs(denvdy) < 1.0e-20
        return
    end
    vdy2 = (ef2d(mpk,kpm1) - ef2d(mpk,kpl1)) * (sint(kpm1) - sint(kpk)) ...
        / (sint(kpm1) - sint(kpl1));
    if abs(vdy1) < 1.0e-20
        return
    end
    ady = (ef2d(mpk,kpm1) - ef2d(mpk,kpk) - vdy2) / vdy1;
    denomy = (sint(kpm1) - sint(kpl1)) - ady * (sint(kpm1) + sint(kpl1));
    if abs(denomy) < 1.0e-20
        return
    end
    bdy = (ef2d(mpk,kpm1) - ef2d(mpk,kpl1)) / (sint(kpm1) - sint(kpl1)) - ...
        ady * (sint(kpm1) + sint(kpl1));
    
    if abs(ady) < 1.0e-20
       return
    end
    ycomp = -0.5*bdy/ady;
    thpeak = atan2(ycomp,xcomp + 1.0e-10);
    if thpeak < 0
        thpeak = thpeak + 2*pi;
    end
end
end