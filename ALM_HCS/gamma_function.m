function [out] = gamma_function(data, gamma)
% gamma_function - gamma 校正, ITU-R BT.709 的改进
%
% input:
%   - data: [0, 1]
%   - gamma: float, gamma>0, 数据变大, gamma<0, 数据变小
% output:
%   - out: [0, 1]
%
% docs:
%

if gamma >= 2.1
    start = 0.018 / ((gamma - 2) * 7.5);
    slope = 4.5 / ((gamma - 2) * 7.5);
elseif gamma <= 1.9
    start = 0.018 / ((2 - gamma) * 7.5);
    slope = 4.5 / ((2 - gamma) * 7.5);
else
    start = 0.018;
    slope = 4.5;
end

out = data;
out(data <= start) = data(data <= start) * slope;
out(data > start) = data(data > start) .^ (0.9/gamma) * 1.099 - 0.099;

end