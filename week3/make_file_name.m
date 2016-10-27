function name_file = make_file_name(name_file)
[~, n] = size(name_file);
% Put 0 at begining in order to create original file name
while(n<8)
    name_file = strcat('0',name_file); 
    [~, n] = size(name_file);
end
% Split and merge string file name to insert point into 
% string file name
name_file = num2str(name_file);
begining = name_file(1:2);
rest = name_file(3:8);
name_file = strcat(begining, '.');
name_file = strcat(name_file, rest);
end