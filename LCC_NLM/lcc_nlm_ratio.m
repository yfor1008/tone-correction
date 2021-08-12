function [lcc, mask] = lcc_nlm_ratio(gray, radius)
% lcc_nlm_ratio - Local Color Correction Using Non-Linear Masking
%
% input:
%   - gray: H*W, 灰度图像, uint8
%   - radius: int, 滤波窗口半径
% output:
%   - lcc: H*W, 校正后的图像
%   - mask: H*W, 值>128, 减小像素值, 值<128, 增加像数值
%
% doc:
%   - 对算法进行调整:
%   - 1. 滤波得到mask
%   - 2. 使用公式进行 gamma 矫正, 公式更改为: Oxy=255(Ixy/ratio)^(2^((Mxy-127)/128))
%   - 3. ratio 为抛出 1% 后的最大值
%   - 滤波方法使用快速均值滤波, 详见 https://github.com/yfor1008/image_processing_as_you_know_it
%
% usage:
%   lcc = lcc_nlm_modify(gray, radius);
%   lcc = lcc_nlm_modify(gray);
%   [lcc, mask] = lcc_nlm_modify(gray, radius);
%   [lcc, mask] = lcc_nlm_modify(gray);
%

if ~exist('radius', 'var')
    radius = 15;
end

gray = double(gray);
mask1 = meanFilterSat(gray, radius);
if nargout == 2
    mask = mask1;
end

h_gray = hist_count(gray); % 直方图
ranges = getRanges(h_gray, 0.01); % 动态范围

lcc = 255 * (gray / ranges(2)) .^ (2 .^((mask1 - 127) / 128));

end