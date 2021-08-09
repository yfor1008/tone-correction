close all; clear; clc;

%% 主要测试程序

%% 不同滤波参数比较
img = './src/paper_image.png';
[img_path, img_name, ~] = fileparts(img);

im = imread(img);
im = imresize(im, 0.5);
if size(im, 3) == 3
    im = rgb2gray(im);
end

radius = [0, 15, 300];
lccs = [];
masks = [];
for r = radius
    [lcc, mask] = lcc_nlm(im, r);
    lccs = cat(2, lccs, lcc);
    masks = cat(2, masks, mask);
end

figure, imshow(uint8(lccs))
for idx = 1:length(radius)
    text(20+(idx-1)*size(im,2), 20, sprintf('半径为 %d', radius(idx)), 'Color','red')
end
ax = gca;
ax.Units = 'pixels';
pos = ax.Position;
rect = [0, 0, pos(3), pos(4)];
fig_rgb = getframe(ax, rect);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, [img_path, '/', img_name, '_results.jpg']);

figure, imshow(uint8(masks))
for idx = 1:length(radius)
    text(20+(idx-1)*size(im,2), 20, sprintf('半径为 %d', radius(idx)), 'Color','red')
end
ax = gca;
ax.Units = 'pixels';
pos = ax.Position;
rect = [0, 0, pos(3), pos(4)];
fig_rgb = getframe(ax, rect);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, [img_path, '/', img_name, '_masks.jpg']);


%% 不同图像测试, 固定滤波半径
close all; clear; clc;

img_path = './src/';
imgs = {'pout.tif', 'test.png'};

for idx = 1:length(imgs)
    img = [img_path, imgs{idx}];
    [~, img_name, ~] = fileparts(img);
    im = imread(img);
    im = imresize(im, 0.5);
    if size(im, 3) == 3
        im = rgb2gray(im);
    end

    [lcc, mask] = lcc_nlm(im, 15);
    ims = cat(2, im, uint8(lcc), uint8(mask));
    imwrite(ims, [img_path, img_name, '_result.jpg'])
    % imshow(ims)
end


%% 算法调整前后对比
close all; clear; clc;

img = './src/paper_image.png';
[img_path, img_name, ~] = fileparts(img);

im = imread(img);
im = imresize(im, 0.5);
if size(im, 3) == 3
    im = rgb2gray(im);
end

[lcc, ~] = lcc_nlm(im);
[lcc_m, ~] = lcc_nlm_modify(im);
ims = cat(2, im, uint8(lcc), uint8(lcc_m));
figure, imshow(ims)
text(20, 20, '原图', 'Color','red')
text(20+size(im,2), 20, '论文中方法', 'Color','red')
text(20+size(im,2)*2, 20, '调整后方法', 'Color','red')
ax = gca;
ax.Units = 'pixels';
pos = ax.Position;
rect = [0, 0, pos(3), pos(4)];
fig_rgb = getframe(ax, rect);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, [img_path, '/', img_name, '_method_cmp.jpg']);


%% 不同mask对比
close all; clear; clc;

input = [0, 51, 102, 153, 204, 255];
mask = [0, 64, 128, 192, 255];
output = zeros(length(input), length(mask));
for row = 1:length(input)
    in = input(row);
    for col = 1:length(mask)
        m = mask(col);
        output(row, col) = 255 * (in / 255) ^ (2 ^((128 - m) / 128));
    end
end
fig = figure;
plot(input, output, '-s', 'linewidth', 1.2)
axis([0, 255, 0, 255])
legend(num2str(mask'))
set(gcf,'color','white');
set(gca,'color','white');
ax = gca;
ax.Units = 'pixels';
pos = ax.OuterPosition; % 整个figure的坐标位置
rect = [0, 0, pos(3), pos(4)];
fig_rgb = getframe(fig, rect);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, './src/different_mask.jpg');


%% 线性拉伸后测试
close all; clear; clc;

img = './src/pout.tif';
[img_path, img_name, img_ext] = fileparts(img);

im = imread(img);
im = imresize(im, 0.5);
if size(im, 3) == 3
    im = rgb2gray(im);
end

im1 = LTC(im);
[lcc_m, ~] = lcc_nlm_modify(im);
[lcc_m1, ~] = lcc_nlm_modify(im1);
ims = cat(2, im, uint8(lcc_m), uint8(lcc_m1));
figure, imshow(ims)
text(20, 20, '原图', 'Color','red')
text(20+size(im,2), 20, '论文中方法', 'Color','red')
text(20+size(im,2)*2, 20, '拉伸后方法', 'Color','red')
ax = gca;
ax.Units = 'pixels';
pos = ax.Position;
rect = [0, 0, pos(3), pos(4)];
fig_rgb = getframe(ax, rect);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, [img_path, '/', img_name, '_ltc_cmp.jpg']);

