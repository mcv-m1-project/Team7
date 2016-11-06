function name_file = make_file_name(name_file)
    name_file=num2str(name_file);
    n=length(name_file);
    % Put 0 at begining in order to create original file name
    for i=1:8-n
        name_file=['0' name_file];
    end
    % Split and merge string file name to insert point into 
    % string file name
    begining = name_file(1:2);
    rest = name_file(3:8);
    name_file = [begining '.' rest];
end