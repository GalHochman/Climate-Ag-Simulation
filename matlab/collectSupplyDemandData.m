function [ data ] = collectSupplyDemandData( file_name, sheet,          ...
                                             c_code_col, country_col,   ...
                                             commodity_col, year_col,   ...
                                             price_col, quantity_col)

% COLLECTSUPPLYDEMANDDATA collects supply and demand data from an xls file
% ========================================================================
% INPUT ARGUMENTS:
%   file name            (string) location of xls file 
%   c_code_col           (int)    column corresponding to the country code
%   country_col          (int) column corresponding to country
%   commodity_col        (int) column corresponding to the commodity
%   year_col             (int) column corresponding to year of data
%   price_col            (int) column corresponding to price
%   quantity_col         (int) column corresponding to quantity
% ========================================================================
% OUTPUT:
%   data                 (cell array) contains an array of cells in the 
%                           following format: {country, commodity, year,
%                           supply, demand}
% ========================================================================

%% Read data file

[~, ~, xls_raw] = xlsread(file_name,sheet);

%% Process data

data = {};

% open waitbar
h = waitbar(0, ['Collecting supply and demand data from sheet ', ...
                   num2str(sheet)]);
data_size = size(xls_raw,1);

for i = 2:size(xls_raw,1)
   
    % update wait bar
    waitbar(i/data_size,h);
    
    % if none of the cells are empty
    if ( ~(   isequal(cell2mat(xls_raw(i,c_code_col)),'')     || ...
              isCellEmpty(xls_raw(i,country_col))             || ...
              isCellEmpty(xls_raw(i,commodity_col))           || ...
              isCellEmpty(xls_raw(i,year_col))                || ...
              isCellEmpty(xls_raw(i,price_col))               || ...
              isCellEmpty(xls_raw(i,quantity_col))))
        
        % process code and extract elasticity
        output = {cell2mat(xls_raw(i,c_code_col)),    	...
                  cell2mat(xls_raw(i,country_col)),     ...
                  cell2mat(xls_raw(i,commodity_col)),   ...
                  cell2mat(xls_raw(i,year_col)),        ...
                  cell2mat(xls_raw(i,price_col)),       ...
                  cell2mat(xls_raw(i,quantity_col)) };
        
        % add information collected to data (cell array)
        data = [data; output]; %#ok<AGROW>
                  
    else % if no data 
        
        continue; %move on to next cell
        
    end
    
end

% sort data by country code
data = sortrows(data,1);

% close waitbar
close(h)

end

%% Local Functions

function [ boolean ] = isCellEmpty( c )

% ISCELLEMPTY checks if a given cell c is empty or contains '.'
% ========================================================================

boolean = cellfun(@(C) isequaln(C, NaN), c) || ...
            cellfun(@(C) isequaln(C, '.'), c);

end