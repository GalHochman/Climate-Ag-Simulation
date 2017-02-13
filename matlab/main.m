% Reads and processes data from 2017_elasticites_outputs.xlsx and outputs
% a cell array containing data in the format {country, commodity, cross
% commodity, elasticity type, elasticity}

%% Read data file
[~,~,xls_raw] = xlsread('data/2017_elasticities_outputs.xlsx');

%% Process data
data = {};

for i = 2:size(xls_raw,1)
   
    % check if cells contain any data
    if (~cellfun(@(C) isequaln(C, NaN), xls_raw(i,8))) && ...
            (~cellfun(@(C) isequaln(C, NaN), xls_raw(i,9)))
        
        % process code and extract elasticity
        output = cell(1,5);
        output(1:4) = convertIDcode(char(xls_raw(i,8)));
        output(5) = xls_raw(i,9);
        
        temp = (char(output(1)));
        if temp(1) == '_'
           %disp(char(xls_raw(i,8)));
        end
        
        data = [data; output];
                  
    else % if no data 
        
        continue; %move on to next cell
        
    end
    
end

disp('complete')