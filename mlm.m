function eftmlm = mlm(fr,c11,a0,a1,b1,a2,b2)
%function eftmlm = mlm(fr,c11,c22,c33,c23,q12,q13)
%
%  Maximum Likelihood Method (MLM) directional wave analysis
%  Transformed from Fortran to Matlab 20120207 by tjh

% set constants 
dtheta = 1.0;
ainc = pi/180 * dtheta;
nang = 360/dtheta;

nfre = length(fr);
dsprdmlm = zeros(nfre,nang);
% c11 = repmat(a0/pi,[1 nang]);
% %find values where c11 is large enough for analysis
% ii = a0 < 1.0e-5;
%for ii = 1:length(c11)
%    if c11(ii) < 1e-5
%        dsprdmlm(ii,:) = 0.0;
%    else
% % wave number from spectra
% xk = sqrt((c22(ii) + c33(ii)) ./ c11(ii));
% 
% d = c11(ii).*c22(ii).*c33(ii) - c11(ii).*c23(ii).^2 - ...
%     q12(ii).^2.*c33(ii) - q13(ii).^2.*c22(ii) + 2* ...
%     q12(ii).*q13(ii).*c23(ii);
% 
% a0 = 2*(c22(ii).*c33(ii) - c23(ii).^2)./d + (c11(ii).*c22(ii) + ...
%     c11(ii).*c33(ii) - q12(ii).^2 - q13(ii).^2).*xk.^2./d;
% a1 = -2*(q12(ii).*c33(ii) - q13(ii).*c23(ii)).*xk./d;
% b1 = 2*(q12(ii).*c23(ii) - q13(ii).*c22(ii)).*xk./d;
% a2 = 0.5*(c11(ii).*c33(ii) - c11(ii).*c22(ii) - q13(ii).^2 + ...
%     q12(ii).^2).*xk.^2./d;
% b2 = -(c11(ii).*c23(ii) - q12(ii).*q13(ii)).*xk.^2./d;

[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
a0 = repmat(a0,[1 nang]);a1 = repmat(a1,[1 nang]);
b1 = repmat(b1,[1 nang]);b2 = repmat(b2,[1 nang]);
a2 = repmat(a2,[1 nang]);
sa = size(a0,1);
sint = repmat(sint,[sa 1]);cost = repmat(cost,[sa 1]);
sin2t = repmat(sin2t,[sa 1]);cos2t = repmat(cos2t,[sa 1]);
denom = 0.5*a0 + a1.*cost + b1.*sint + a2.*cos2t + b2.*sin2t;
dsprdmlm = abs(1./denom);
sumd = sum(dsprdmlm,2);

sumd = sumd.* ainc;
sum2d = repmat(sumd,[1 nang]);
dsprdmlm = dsprdmlm ./ (sum2d + 1.0e-10);
  %  end
%end
jj = isnan(dsprdmlm);
dsprdmlm(jj) = 0.0;
c112d = repmat(c11,[1 nang]);
eftmlm = dsprdmlm.*c112d;
% for ii = 1:length(c11)
%     eftmlm(ii,:) = c11(ii) .* dsprdmlm(ii,:);
% end
% eftmlm(ii) = 0;

