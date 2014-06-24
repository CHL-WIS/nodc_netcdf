function [peakfpf,fmean,fm,mpeak] = periods(ef,fr,delf)

% compute peak frequency 

emax = 0;
peakfpf = 0;
mpeak = 0;
etot = 0;
fmean = 0;

etot = sum(ef.*delf);
fmean = sum((ef.*delf)./fr);
ii = find(ef == max(ef));
mpeak = ii(1);

if mpeak > 1 & mpeak < length(fr)
    fmean = etot / (fmean + 1.0e-10);
    
    fm = fr(mpeak);
    peakfpf = fr(mpeak);
    mpk = mpeak;
    mpl1 = mpk + 1;
    mpm1 = mpk - 1;
    
    eneck = ef(mpl1) + ef(mpk) + ef(mpm1);
    if eneck > 1.0e-05
       v1 = (fr(mpk) - fr(mpl1)) * (fr(mpm1) - fr(mpk)); 
       v2 = (ef(mpm1) - ef(mpl1)) * (fr(mpm1) - fr(mpk))/ ...
           (fr(mpm1) - fr(mpl1)); 

       if (v2 ~= 0) 
          a = (ef(mpm1) - ef(mpk) - v2) / v1; 
          b = (ef(mpm1) -ef(mpl1)) / (fr(mpm1) - fr(mpl1)) ... 
              - a * (fr(mpm1) + fr(mpl1)); 

          if a ~= 0
              peakfpf = -0.5 * b / a; 
          end 
       end
    end
	else
       peakfpf = -999.;
	   fmean   = -999;
	   fm      = -999;
	   mpeak   = -1;
    end
end