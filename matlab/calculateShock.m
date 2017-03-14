function [ output ] = calculateShock( price, quantity, alpha_d, beta_d, ...
                                            alpha_s, beta_s, supply_shock)

% CALCULATESHOCK finds the change in consumer and producer surplus given a
% shock to a linear demand and supply schedule
% ========================================================================
% INPUT ARGUMENTS:
%   price                (scalar) current price ($/tonne)
%   quantity             (scalar) control (tonne)
%   alpha_d              (scalar) intercept of demand curve
%   beta_d               (scalar) slope of demand curve
%   alpha_s              (scalar) intercept of supply curve
%   beta_s               (scalar) slope of supply curve
%   supply_shock         (scalar) shift in supply curve
% ========================================================================

%% Calculate Original Surpluses

% Consumer surplus
surplus_C1 = (1/2)*(quantity)*((-alpha_d/beta_d)-price);

% Producer surplus
surplus_S1 = (1/2)*(max(0,alpha_s)+quantity)...
             *(price-max(0,-alpha_s/beta_s));

%% Introduce Supply Shock

% New supply schedule: Q = (alpha_s + supply_shock) + beta_s*P

new_price =  ((alpha_s + supply_shock) - (alpha_d)) / (beta_d - beta_s);
new_quantity = alpha_d + beta_d*new_price;

%% Calculate New Surpluses

if (new_price > 0 && new_quantity > 0)
    % New Consumer surplus
    surplus_C2 = (1/2)*(new_quantity)*((-alpha_d/beta_d)-new_price);

    % New Producer surplus
    surplus_S2 = (1/2)*(max(0,alpha_s+supply_shock)+new_quantity)...
                 *(new_price-max(0,-(alpha_s+supply_shock)/beta_s));
else
    surplus_C2 = 0;
    surplus_S2 = 0;
end

surplus_S2

end



