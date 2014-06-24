function [delfthmo,delfttp,delfttm,delfttm1,delfttm2, ...
    delftfspr] = delftsums(ef,fr,delf)

nfre = length(fr);
ife = length(fr) - 1;

sumn1 = 0;
sum0 = 0;
sum1 = 0;
sum2 = 0;

sumn1 = sum(0.5*(ef(1:ife-1)./fr(1:ife-1) + ef(2:ife)./fr(2:ife)) .* ...
    delf(1:ife-1));
sum0 = sum(0.5*(ef(1:ife-1) + ef(2:ife)) .* delf(1:ife-1));
sum1 = sum(0.5*(ef(1:ife-1).*fr(1:ife-1) + ef(2:ife).*fr(2:ife)) .* ...
    delf(1:ife-1));
sum2 = sum(0.5*(ef(1:ife-1).*fr(1:ife-1).^2 + ef(2:ife).*fr(2:ife).^2) .* ...
    delf(1:ife-1));

if sum0 > 0
    delfthmo = 4.0*sqrt(sum0);
    ii = find(ef == max(ef));
    etop = ef(ii);
    ift = ii(1);
    
    if ift <= nfre
        delfttp = 1./fr(ift);
        delfttm1 = sum0 / sum1;
        delfttm2 = sqrt(sum0 / sum2);
        delfttm = sumn1 / sum0;
    else
        delfttp = 1/fr(nfre);
        delfttm1 = delfttp;
        delfttm2 = delfttp;
        delfttm = delfttp;
    end
    
    ef1s = ef(1:ife-1).*sin(2.*pi*fr(1:ife-1)*delfttm2);
    ef2s = ef(2:ife).*sin(2.*pi*fr(2:ife)*delfttm2);
    ef1c = ef(1:ife-1).*cos(2.*pi*fr(1:ife-1)*delfttm2);
    ef2c = ef(2:ife).*cos(2.*pi*fr(2:ife)*delfttm2);
    
    sums = sum(0.5*(ef1s + ef2s) .* delf(1:ife-1));
    sumc = sum(0.5*(ef1c + ef2c) .* delf(1:ife-1));
    
    delftfspr = sqrt(sums^2 + sumc ^2) / sum0;
else
    delfthmo = -999.0;
    delfttp = -999.0;
    delfttm1 = -999.0;
    delfttm2 = -999.0;
    delfttm = -999.0;
    delftfspr = -999.0;
end
    