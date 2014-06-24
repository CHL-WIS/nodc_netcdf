function NDBC_hdf5_2_vsp(idd,year,mon,statname)
deg2rad = 0.017453;
itadjust = 0;
payload = {'payload_1';'payload_2'};

%idd = input('Do you need to download data (y,n): ','s');
if strcmp(idd,'y')
    %year = input('What year to download (yyyy): ');
    %mon = input('What month to download (mm): ');
    %statname = input('What is the station id (46001 or CLSM4): ','s');
    %if isempty(statname)
    %    get_nodc_buoy(year,mon)
    %else
        get_nodc_buoy(year,mon,statname)
    %end
else
    cd([num2str(year),'/',num2str(mon)]);
    %statname = input('What is the station id (46001 or CLSM4): ','s');
end

if isempty(statname)

    files = dir('NDBC*.nc');
else
    files = dir(['NDBC_',statname,'*.nc']);
end
onlform = ['%5s%6i%3i%3i%3i%3i%5i%5i%5i%5i%5i%5i%7.1f%6.2f%6.2f%6.2f', ...
    '%6.1f%7.2f%7.2f%7.1f%8.2f%8.2f%8.2f%8.2f%7.1f%7.1f%7.1f%7.1f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%10.4f%7.1f%7.1f%8.2f% 14.5E% 14.5E', ...
    '% 14.5E% 14.5E\n'];


sp1form1 = ['%5s%6i%3i%3i%3i%3i'];
%payload = input('What is the payload for this analysis:  ','s');
for zz = 1:size(files,1)
    nn = 1;
    fname = files(zz).name;
    fprintf(1,'Analyizing Station %5s\n',fname);
    %Get attributes distributed
    fileatt = h5info(fname);
    fatt = {fileatt.Attributes.Name};
    
    % Get time out of the file and convert to year mon day hour min sec
    times = double(h5read(fname,'/time'));
    [year,mon,day,hour,min,sec] = datevec( ...
        datenum(1970,1,1)+times./86400);
    
    % Get lat and lon out of file and convert to deg min sec
    latm = strcmp(fatt,'nominal_latittude');
    lat = h5readatt(fname,'/','nominal_latitude');
    [lad,lam,las] = deg2dms(abs(lat));
    lam = abs(lam);las = round(las);las = abs(las);
    lad = repmat(lad,[length(year) 1]);lam = repmat(lam,[length(year) 1]);
    las = repmat(las,[length(year) 1]);
    lon = h5readatt(fname,'/','nominal_longitude');
    [lod,lom,los] = deg2dms(abs(lon));
    lom = abs(lom);los = abs(los);los = round(los);
    lod = repmat(lod,[length(year) 1]);lom = repmat(lom,[length(year) 1]);
    los = repmat(los,[length(year) 1]);
    if lon < 0
        lod = -lod;
    end
    if lat < 0
        lat = -lat;
    end
    
    if zz > 1 & files(zz).name(6:10) == stat
        nn = 2;
    end
    stat = files(zz).name(6:10);
    
    try 
        payid = h5readatt(fname,'/payload_2','payload_id');
        numpay = 2;
    catch
        numpay = 1;
    end
    
    for rpay = 1:numpay
    [cc p] = get_NDBC_spec(files(zz).name,payload{rpay});
    if size(files,1) == 1
    fout = ['n',files(zz).name(6:17),'_',payload{rpay},'.vsp'];
    else
        fout = ['n',files(zz).name(6:17),'_',payload{rpay},'_D',num2str(zz),...
            '.vsp'];
        ffull{rpay} = ['n',files(zz).name(6:17),'_',payload{rpay},'.vsp'];
    end
    fid10 = fopen(fout,'wt');
    
    nfrq = size(cc.freq,1);
    cr = 0;
    for qq = 1:size(cc.c11,2)
        if cc.c11(:,qq) == -999
            continue
        else
        fprintf(fid10,'%8i%8i%8i%8i%8i%8i%8i\n',year(qq),mon(qq),day(qq) ...
            ,hour(qq),min(qq),itadjust,nfrq);
        for ii = 1:nfrq
            a1 = cc.r1(ii,qq)*cos(cc.alpha1(ii,qq)*deg2rad); 
            b1 = cc.r1(ii,qq)*sin(cc.alpha1(ii,qq)*deg2rad);
            a2 = cc.r2(ii,qq)*cos(2.0*cc.alpha2(ii,qq)*deg2rad);
            b2 = cc.r2(ii,qq)*sin(2.0*cc.alpha2(ii,qq)*deg2rad);
        
            fprintf(fid10,'%6.4f %8.4f %11.4f %16.4f %9.4f %9.4f %9.4f %7.2f\n', ...
            cc.freq(ii,1),cc.si(ii,1),cc.c11(ii,qq),a1,b1,a2,b2,cr);
        end
        end
    end
    fclose(fid10);
    end
end  
if size(files,1) > 1
for rpay = 1:numpay
    bbop = ['type ',ffull{rpay}(1:end-4),'*.vsp > ',ffull{rpay}];
    system(bbop);
end
end
cd ../../