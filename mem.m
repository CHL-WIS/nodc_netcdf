function [eftmem] = mem(fr,c11,c22,c33,c23,q12,q13)

dtheta = 1.0;
ainc = pi/180 * dtheta;
nang = 360/dtheta;

nfre = length(fr);
dsprdmem = zeros(nfre,nang);

ii = c11 >= 1.0e-4;
tmp1 = c22(ii) + c33(ii);
tmp2 = sqrt(tmp1.*c11(ii));

d1 = q12(ii)./tmp2;
d2 = q13(ii)./tmp2;
d3 = (c22(ii) - c33(ii))./tmp1;
d4 = (2.0 * c23(ii))./tmp1;

c1 = complex(d1,d2);
c2 = complex(d3,d4);
c1star = conj(c1);
c2star = conj(c2);

ph1 = (c1 - c2.*c1star)./(1.0 - c1.*c1star);
ph2 = c2 - c1.*ph1;
ctmp1 = 1.0 - ph1.*c1star - ph2.*c2star;

si = length(tmp1);
[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
ph1 = repmat(ph1,[1 nang]);ph2 = repmat(ph2,[1 nang]);
ctmp1 = repmat(ctmp1,[1 nang]);c11 = repmat(c11,[1 nang]);

sint = repmat(sint,[si 1]);cost = repmat(cost,[si 1]);
sin2t = repmat(sin2t,[si 1]);cos2t = repmat(cos2t,[si 1]);

expt = complex(cost,-sint);
expt2 = complex(cos2t,-sin2t);
ctmp2 = 1.0 - ph1.*expt - ph2.*expt2;
ctmp3 = conj(ctmp2);
ctmp4 = ctmp1./(ctmp2.*ctmp3);

ctmp4 = ctmp4./(360);
dsprdmem(ii,:) = abs(real(ctmp4));
dsprdsum = sum(dsprdmem,2) .* pi/180;
dsprdsum = repmat(dsprdsum,[1 nang]);
dsprdmem(ii,:) = dsprdmem(ii,:)./dsprdsum(ii,:);

try
    eftmem = dsprdmem.*c11;
catch
    1
end
