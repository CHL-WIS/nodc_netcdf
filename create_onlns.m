function create_onlns(stat,year,mon,aa,sdir)

if isunix
    slash = '/';
else
    slash = '\';
end

onlform = ['%5s%6i%3i%3i%3i%3i%5i%5i%5i%5i%5i%5i%7.1f%7.2f%7.2f%7.2f', ...
    '%7.1f%7.2f%7.2f%7.1f%8.2f%8.2f%8.2f%8.2f%7.1f%7.1f%7.1f%7.1f', ...
    '%8.2f%8.2f%8.2f%8.2f%8.2f%10.4f%7.1f%7.1f%8.2f% 14.5E% 14.5E', ...
    '% 14.5E% 14.5E\n'];
sp1form1 = ['%5s%6i%3i%3i%3i%3i'];

if ~exist(sdir,'dir')
    mkdir(sdir);
end
fout = [sdir,slash,'n',stat,'_',year,'_',mon];
foutone = [fout,'.onlns'];
fid = fopen(foutone,'w');
for qq = 1:size(aa,1)
   fprintf(fid,onlform,stat,aa(qq,:));
end
fclose(fid);
        % print spec1d file
%     if p == 1
%         fspec1 = [fout,'.spe1d'];
%         if nn == 1
%             fid = fopen(fspec1,'w');
%         else
%             fid = fopen(fspec1,'a+');
%         end
%         for qq = 1:size(cc.c11,2)
%             fprintf(fid,sp1form1,stat,aa(qq,1:5));
%             for jj = 1:length(cc.freq)
%                 fprintf(fid,'%8.4f%12.6f',cc.freq(jj),cc.c11(jj,qq));
%             end
%             fprintf(fid,'\n');
%         end
%         fclose(fid);
%     else
%     % print spec2d file
%         fspec1 = [fout,'.spe1d'];
%         fspec2 = [fout,'.spe2e'];
%         if nn == 1
%             fid  = fopen(fspec1,'w');
%             fid2 = fopen(fspec2,'w');
%         else
%             fid = fopen(fspec1,'a+');
%             fid2 = fopen(fspec2,'a+');
%         end
%         for qq = 1:size(cc.c11,2)
%             fprintf(fid,sp1form1,stat,aa(qq,1:5));
%             fprintf(fid2,sp1form1,stat,aa(qq,1:5));
%             for jj = 1:length(cc.freq)
%                 fprintf(fid,'%8.4f%12.6f',cc.freq(jj),cc.c11(jj,qq));
%                 fprintf(fid2,'%8.4f%8.4f%8.4f%6.1f%6.1f%12.6f',cc.freq(jj), ...
%                     cc.r1(jj,qq),cc.r2(jj,qq),cc.alpha1(jj,qq), ...
%                     cc.alpha2(jj,qq),cc.c11(jj,qq));
%             end
%             fprintf(fid,'\n');
%             fprintf(fid2,'\n');
%         end
%         fclose(fid);
%         fclose(fid2);
%     end