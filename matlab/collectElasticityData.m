function [ data ] = collectElasticityData( file_name, country_col, ...
                                            commodity_col, cross_col, ...
                                            type_col, elas_col)

% COLLECTELASTICITYDATA collects elasticity data from an excel file
% Reads and processes data from 2017_elasticites_outputs.xlsx and outputs
% a cell array containing data in the format {country, commodity, cross
% commodity, elasticity type, elasticity}
% ========================================================================
% INPUT ARGUMENTS:
%   file name            (string) location of xls file 
%   country_col          (string) column corresponding to country
%   commodity_col        (string) column corresponding to commodity
%   cross_col            (string) column corresponding to cross commodity
%   type_col             (string) column corresponding to elasticity type
%   elas_col             (string) column corresponding to elasticity value
% ========================================================================
% OUTPUT:
%   data                 (cell array) contains an array of cells in the 
%                           following format: {country, commodity, cross,
%                           elasticity_type, elasticity}
% ========================================================================

%% Read data file

% use '/data/2017_elasticities_outputs.xlsx'
[~, ~, xls_raw] = xlsread(file_name);

%% Process data

data = {};

% open waitbar
h = waitbar(0,'Collecting supply and demand data');
data_size = size(xls_raw,1);

for i = 2:size(xls_raw,1)
   
    % update wait bar
    waitbar(i/data_size,h);
    
    % if none of the cells are empty
    if( ~(  isCellEmpty(xls_raw(i,country_col))     || ...
            isCellEmpty(xls_raw(i,commodity_col))   || ...
            isCellEmpty(xls_raw(i,type_col))        || ...
            isCellEmpty(xls_raw(i,elas_col))))
                                                       
        % process code and extract elasticity
        output = {strtrim(cell2mat(xls_raw(i,country_col))),           ...
                  lower(cell2mat(xls_raw(i,commodity_col))),           ...
                  cell2mat(xls_raw(i,cross_col)),                      ...
                  renameElasticityType(cell2mat(xls_raw(i,type_col))), ...
                  cell2mat(xls_raw(i,elas_col)) }; 
        
        % add information collected to data (cell array)
        data = [data; output]; %#ok<AGROW>
                  
    else % if no data 
        
        continue; %move on to next cell
        
    end
    
end

% close waitbar
close(h)

end

%% Local Functions

function [ boolean ] = isCellEmpty( c )

% ISCELLEMPTY checks if a given cell c is empty or contains '.'
% =================================================================

boolean = cellfun(@(C) isequaln(C, NaN), c) || ...
            cellfun(@(C) isequaln(C, '.'), c);

end

function [ output ] = renameElasticityType( elas_type )

% RENAMEELASTICITYTYPE standardizes the format of elasticity types
% =================================================================

switch lower(elas_type)
    
    case 'cross price'
        output = 'demand_C';
    case 'own price'
        output = 'demand_O';
    case 'expenditure'
        output = 'demand_E';
    case 'income'
        output = 'demand_I';
        
    otherwise
        error(['Commodity code [' , lower(elas_type) , '] unknown']);

end

end
