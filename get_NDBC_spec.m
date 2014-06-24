function [bb cc p] = get_NDBC_spec(fname,payload)
%
%  read NODC netCDF4 file to get spectral information
%  created 07/12 TJ. Hesser
%
try 
    dep = h5readatt(fname,'/','sea_floor_depth_below_sea_level');
catch
    dep = -999.00;
end
% get frequency bands for spectra
try 
    freq(:,1) = h5read(fname,'/wave_wpm');
    dft = h5read(fname,'/_nc4_non_coord_wave_wpm_bnds');
    df(:,1) = dft(2,:) - dft(1,:);
catch
   try
        freq(:,1) = h5read(fname,'/wave_wa');
        dft = h5read(fname,'/_nc4_non_coord_wave_wa_bnds');
        df(:,1) = dft(2,:) - dft(1,:);
   catch
       freq(:,1) = repmat(-99.00,[48 1]);
       df(:,1) = repmat(-99.00,[48 1]);
   end
end
for jj = 2:length(freq)
    si(jj,1) = freq(jj) - freq(jj-1);
end
si(1,1) = freq(1);


% get c11 from file
try
    c11 = h5read(fname,['/',payload,'/wave_sensor_1/c11']);
    c11_info = h5info(fname,['/',payload,'/wave_sensor_1/c11']);
    c11_qc = h5read(fname,['/',payload,'/wave_sensor_1/', ...
        'significant_wave_height_qc']);
    time_spec = double(h5read(fname,'/time'));
    jj = c11_qc ~= 0;
    %c11 = c11(:,jj);
    c11(:,jj) = c11_info.FillValue;
    %time_spec = time_spec(jj,1); 
catch
    fprintf(1,'Wave Spectra information not available for station %5s\n', ...
        fname(end-21:end-17));
    time_spec = double(h5read(fname,'/time'));
    c11 = repmat(-999.00,[length(freq) length(time_spec)]);
    c11_info.FillValue = 0.0;
end

for zz = 1:size(c11,2)
ii = c11(:,zz) == c11_info.FillValue;
c11(ii,zz) = -999.;
end
% check to see if direction components are available
try
    r1 = h5read(fname,['/',payload,'/wave_sensor_1/r1']);
    %r1 = r1(:,jj);
    r2 = h5read(fname,['/',payload,'/wave_sensor_1/r2']);
    %r2 = r2(:,jj);
    alpha1 = h5read(fname,['/',payload,'/wave_sensor_1/alpha1']);
    %alpha1 = alpha1(:,jj);
    alpha2 = h5read(fname,['/',payload,'/wave_sensor_1/alpha2']);
    %alpha2 = alpha2(:,jj);
    p = 2;
    fprintf(1,'Direction information available for %5s \n\n',fname(end-21:end-17));
catch
    fprintf(1,'No direction information available for %5s\n\n',fname(end-21:end-17));
    p = 1;
    r1 = repmat(0,size(c11));r2 = repmat(0,size(c11));
    alpha1 = repmat(0,size(c11));alpha2 = repmat(0,size(c11));
end

for zz = 1:size(c11,2)
    if c11(:,zz) == c11_info.FillValue
        hmo = -999.00;
        fpp = -999.00;fm = -999.00;fp = -999.00;mp = -1;
        tpp = -999.00;tm = -999.00;tp = -999.00;
    elseif sum(c11(:,zz)) > 1000.0 | c11(:,zz) < 0
        hmo = -999.00;
        fpp = -999.00;fm = -999.00;fp = -999.00;mp = -1;
        tpp = -999.00;tm = -999.00;tp = -999.00;
    else
        hmo = 4.0*sqrt(sum(c11(:,zz).*df));
        [fpp,fm,fp,mp] = periods(c11(:,zz),freq,df);
        tpp = 1./(fpp + 1.0e-10);
        tm = 1./(fm + 1.0e-10);
        tp = 1./(fp + 1.0e-10);
    end
    
    r1(r1(:,zz) == c11_info.FillValue,zz) = 0;
    r2(r2(:,zz) == c11_info.FillValue,zz) = 0;
    alpha1(alpha1(:,zz) == c11_info.FillValue,zz) = 0;
    alpha2(alpha2(:,zz) == c11_info.FillValue,zz) = 0;
    
%end
    
    if mp > 0
        [delhmo,delttp,deltm,deltm1,deltm2, ...
            delfspr] = delftsums(c11(:,zz),freq,df);
    else
        delhmo = -999.00;delttp = -999.00;deltm = -999.00;
        deltm1 = -999.00;deltm2 = -999.00;delfspr = -999.00;
    end

     
    if sum(r1(:,zz) > 0) | c11(:,zz) == -999
        if mp > 0
        %[ef2d] = simp_ef2d(freq,c11(:,zz),r1(:,zz), ...
        %    r2(:,zz),alpha1(:,zz),alpha2(:,zz));
        [ef2d] = twodgen(c11(:,zz),freq,df,r1(:,zz), ...
            r2(:,zz),alpha1(:,zz),alpha2(:,zz),dep);
        [wavdvt,wavdvfm,wavpd,wavdmx,wavfmx ...
            ,sumefx,sumefy,summfx,summfy] = ...
            directns(ef2d,freq,df,360,1,mp,dep);
        wavdvt = dir_convert(wavdvt,270);
        wavdvfm = dir_convert(wavdvfm,270);
        wavpd = dir_convert(wavpd,270);
        wavdmx = dir_convert(wavdmx,270);
        
        [delftmdr,delftpdr,delftsprd] = ...
            delftsdrs(ef2d,freq,df,360,1);
        else
        wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
        wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
        sumefy = -999.00;summfx = -999.00;summfy = -999.00;
        delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
        end
    else
        wavdvt = -999.00;wavdvfm = -999.00;wavpd = -999.00;
        wavdmx = -999.00;wavfmx = -999.00;sumefx = -999.00;
        sumefy = -999.00;summfx = -999.00;summfy = -999.00;
        delftmdr = -999.00;delftpdr = -999.00;delftsprd = -999.00;
    end
    bb(zz,:) = [hmo,tp,tpp,tm,wavdvt,wavdvfm,wavpd,wavdmx,delhmo,delttp,deltm, ...
        deltm1,deltm2,delfspr,delftmdr,delftpdr,delftsprd,sumefx,sumefy, ...
        summfx,summfy];
    if c11(:,zz) == -999;
        bb(zz,:) = -999.00;
        c11(:,zz) = -999.00;r1(:,zz) = -9.9999;r2(:,zz) = -9.9999;
        alpha1(:,zz) = -999.00;alpha2(:,zz) = -999.00;
    end
    ir = c11(:,zz) == 0;
        r1(ir,zz) = 0.0000;r2(ir,zz) = 0.0000;
        alpha1(ir,zz) = 000.00; alpha2(ir,zz) = 000.00;
       
end
cc = struct('time',time_spec,'freq',freq,'si',si,'c11',c11, ...
    'r1',r1,'r2',r2,'alpha1',alpha1,'alpha2',alpha2);


