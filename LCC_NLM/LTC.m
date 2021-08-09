function toned = LTC(gray)
% LTC - Linear Tone Correction, 线性映射
%
% input:
%   - gray: H*W, 灰度图像, uint8
% output:
%   - toned: H*W, 校正后的图像
%
% doc:
%   - 抛出1%, 得到[low, up], 映射到[a, b]
%   - 转换公式为: out = (in - low) / (up - low) * (b - a) + a
%

[h,w] = size(gray);
h_gray = zeros(256, 1);
for i = 1:h*w
    h_gray(gray(i)+1) = h_gray(gray(i)+1) + 1;
end

cdf = cumsum(h_gray);
thres_low = cdf(end) * 0.01;
thres_up = cdf(end) * (1 - 0.01);
idx_low = find(cdf >= thres_low, 1);
idx_up = find(cdf >= thres_up, 1);

toned = double(gray);
toned(toned < idx_low) = idx_low;
toned(toned > idx_up) = idx_up;
for i = 1:h*w
    toned(i) = (toned(i) - idx_low) / (idx_up - idx_low) * 255;
end

end