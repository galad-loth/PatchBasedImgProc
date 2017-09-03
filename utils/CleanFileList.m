function [file_list_new, num_file]=CleanFileList(file_list, ext_set)
num_file=length(file_list);
valid_flag=zeros(1, num_file);
for i=1:num_file
    if (IsReserve(file_list(i).name, ext_set))
        valid_flag(i)=1;
    end
end

file_list_new=file_list(valid_flag==1);
num_file=sum(valid_flag);

function flag=IsReserve(file_name, ext_set)
flag=0;
[fpath, fname, fext]=fileparts(file_name);
for i=1:length(ext_set)
    if strcmp(fext, ext_set{i})
        flag=1;
        break;
    end
end
