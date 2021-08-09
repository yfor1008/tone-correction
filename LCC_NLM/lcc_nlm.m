function [lcc, mask] = lcc_nlm(gray, radius)
% lcc_nlm - Local Color Correction Using Non-Linear Masking
%
% input:
%   - gray: H*W, 灰度图像, uint8
%   - radius: int, 滤波窗口半径
% output:
%   - lcc: H*W, 校正后的图像
%   - mask: H*W, 值>128, 增加像素值, 值<128, 减小像数值
%
% doc:
%   - 2000, <Local Color Correction Using Non-Linear Masking>
%   - 算法原理:
%   - 1. 取反, 滤波得到mask
%   - 2. 使用公式进行 gamma 矫正
%   - 滤波方法使用快速均值滤波, 详见 https://github.com/yfor1008/image_processing_as_you_know_it
%
% usage:
%   lcc = lcc_nlm(gray, radius);
%   lcc = lcc_nlm(gray);
%   [lcc, mask] = lcc_nlm(gray, radius);
%   [lcc, mask] = lcc_nlm(gray);
%

if ~exist('radius', 'var')
    radius = 15;
end

gray = double(gray);

gray_inv = 255 - gray;
mask1 = meanFilterSat(gray_inv, radius);
if nargout == 2
    mask = mask1;
end

lcc = 255 * (gray / 255) .^ (2 .^((128 - mask1) / 128));

end