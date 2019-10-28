function A=open_swc(file_name)
%reading swc file, return it to matrix A
fid=fopen(file_name);
i=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    if (tline)&(tline(1)~='#')
        c=sscanf(tline,'%f');
        if isempty(c)
            break;
        else
            A(i,:)=c';
            i=i+1;
        end
    end
end
fclose(fid);