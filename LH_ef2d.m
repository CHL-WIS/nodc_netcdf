function eft = LH_ef2d(fr,c11,a1,b1,a2,b2)

% set constants 
dtheta = 1.0;
ainc = pi/180 * dtheta;
nang = 360/dtheta;

nfre = length(fr);
dsprdmlm = zeros(nfre,nang);

theta = [0:1:360-1];%theta = theta + 180;ii = theta > 360;theta(ii) = theta(ii) - 360;
a0 = repmat(c11./pi,[1 nang]);
a1 = repmat(a1,[1 nang]);b1 = repmat(b1,[1 nang]);
a2 = repmat(a2,[1 nang]);b2 = repmat(b2,[1 nang]);
theta = repmat(theta,[nfre 1]);
%Dft = 1/pi*(1/2 + r1.*cosd(theta - alp1) + r2.*cosd(2.0*(theta - alp2)));
eft = a0/2 + a1.*a0.^2.*cosd(theta) + b1.*a0.^2.*sind(theta) + a2.*a0.^2.*cosd(2.0*theta) + ...
    b2.*a0.^2.*sind(2.0*theta);
%DD = zeros(size(Dft));
%DD(:,1:180) = Dft(:,181:360);
%DD(:,181:360) = Dft(:,1:180);


%[sint cost sin2t cos2t] = angle_onlns(dtheta,nang);
% a0 = repmat(a0,[1 nang]);a1 = repmat(a1,[1 nang]);
% b1 = repmat(b1,[1 nang]);b2 = repmat(b2,[1 nang]);
% a2 = repmat(a2,[1 nang]);
% sa = size(a0,1);
% sint = repmat(sint,[sa 1]);cost = repmat(cost,[sa 1]);
% sin2t = repmat(sin2t,[sa 1]);cos2t = repmat(cos2t,[sa 1]);
% denom = 0.5*a0 + a1.*cost + b1.*sint + a2.*cos2t + b2.*sin2t;
% dsprdmlm = abs(1./denom);
% sumd = sum(dsprdmlm,2);
% 
% sumd = sumd.* ainc;
% sum2d = repmat(sumd,[1 nang]);
% dsprdmlm = dsprdmlm ./ (sum2d + 1.0e-10);
%   %  end
% %end
% jj = isnan(dsprdmlm);
% dsprdmlm(jj) = 0.0;
% c112d = repmat(c11,[1 nang]);
% eft = Dft.*c112d;
 contourf(eft);