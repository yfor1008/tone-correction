function [alm] = alm_hcs(rgb, b, lwa)
% alm_hcs - Adaptive Logarithmic Mapping for Displaying High Contrast Scenes
%
% input:
%   - rgb: h*w*3, [0, 255], rgb图像
%   - b: float, 论文中参数b
%   - lwa: float, 缩放因子, 一般为亮度均值
% output:
%   - alm: h*w*3, [0, 255], 处理后图像
% usage:
%   - alm = alm_hcs(rgb); % b=0.85, lwa=Y均值
%   - alm = alm_hcs(rgb, b); % lwa=Y均值
%   - alm = alm_hcs(rgb, b, lwa);
%
% docs:
%   - 算法原理:
%   - 1. 自适应对数变换
%   - 2. 亮度范围映射
%   - 3. 算法在XYZ空间进行处理, Y为亮度
%

if ~exist('b', 'var')
    b = 0.85;
end

rgb = double(rgb);

% RGB转XYZ
xyz = colorConvert(rgb, 'rgb2xyz');
Y = xyz(:,:,2);

if ~exist('lwa', 'var')
    lwa = mean(Y(:));
end
lwa = lwa / (1 + b - 0.85) ^ 5;
Y = Y / lwa;
lwmax = max(Y(:));

bias_p = log(b)/log(0.5);
div = log10(lwmax + 1);

base = 2 + power(Y / lwmax, bias_p) * 8;
Y_new = log(Y + 1) ./ log(base) / div;

% 同比例处理X,Z通道
scalefactor = Y_new ./ Y / lwa * 255;
scalefactor(Y == 0) = 0;
scalefactor = cat(3, scalefactor, scalefactor, scalefactor);
alm = scalefactor .* xyz;
alm = max(min(alm, 255), 0);

% XYZ转RGB
alm = colorConvert(alm, 'xyz2rgb');
alm = uint8(alm);

end