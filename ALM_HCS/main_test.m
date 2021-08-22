close all; clear; clc;

%% 注测试程序

% %% rgb 和 xyz 转换
% rgb = rand(8,8,3);
% xyz = colorConvert(rgb, 'rgb2xyz');
% rgb1 = colorConvert(xyz, 'xyz2rgb');
% diff = fix(abs(rgb - rgb1) * 1000) / 1000;


% %% equation 1
% lw = 0:250;
% lwmax = max(lw);
% lwa = [1, 50, 100, 150, 200];
% lds = zeros(length(lw), length(lwa));
% cnt = 0;
% legends = cell(length(lwa), 1);
% for a = lwa
%     cnt = cnt + 1;
%     ld = log(lw / a + 1) ./ log(lwmax / a + 1);
%     lds(:, cnt) = ld;
%     legends{cnt} = sprintf('lwa=%d', a);
% end
% fig = figure;
% plot(lw, lds, 'LineWidth', 1.8)
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% legend(legends, 'Location','southeast')
% ax = gca;
% ax.Units = 'pixels';
% pos = ax.OuterPosition; % 整个figure的坐标位置
% rect = [0, 0, pos(3), pos(4)];
% fig_rgb = getframe(fig, rect);
% fig_rgb = fig_rgb.cdata;
% imwrite(fig_rgb, './src/scalemap_function.jpg');


% %% equation 3
% t = 0 : 0.01 : 1;
% bs = [0.1, 0.25, 0.5, 0.75, 0.85, 0.95, 1.0];
% biases = zeros(length(t), length(bs));
% cnt = 0;
% legends = cell(length(bs), 1);
% for b = bs
%     cnt = cnt + 1;
%     bias = t .^ (log(b) / log(0.5));
%     biases(:, cnt) = bias;
%     legends{cnt} = sprintf('base=%.1f', b);
% end
% fig = figure;
% plot(t, biases, 'LineWidth', 1.8)
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% axis([0, 1, 0, 1])
% xticks(0:0.2:1)
% yticks(0:0.2:1)
% legend(legends, 'Location','southeast')
% ax = gca;
% ax.Units = 'pixels';
% pos = ax.OuterPosition; % 整个figure的坐标位置
% rect = [0, 0, pos(3), pos(4)];
% fig_rgb = getframe(fig, rect);
% fig_rgb = fig_rgb.cdata;
% imwrite(fig_rgb, './src/bias_power_function.jpg');


% % equation 4
% lw = 0:255;
% lwmax = max(lw);
% ldmax = 100;

% bs = 0.5:0.1:1;
% lds = zeros(length(lw), length(bs));
% cnt = 0;
% legends = cell(length(bs), 1);
% for b = bs
%     cnt = cnt + 1;
%     base = 2 + ((lw / lwmax) .^ (log(b) / log(0.5))) * 8;
%     ld = ldmax * 0.01 / log10(lwmax+1) * log(lw+1) ./ log(base);
%     lds(:, cnt) = ld;
%     legends{cnt} = sprintf('base=%.1f', b);
% end
% fig = figure;
% plot(lds, 'LineWidth', 1.8)
% hold on, plot(lw, ones(length(lw),1), 'color', 'k')
% axis([0, max(lw), 0, 1.5])
% xticks(0:50:lwmax)
% yticks(0:0.2:1.5)
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% legend(legends, 'Location','southeast')
% ax = gca;
% ax.Units = 'pixels';
% pos = ax.OuterPosition; % 整个figure的坐标位置
% rect = [0, 0, pos(3), pos(4)];
% fig_rgb = getframe(fig, rect);
% fig_rgb = fig_rgb.cdata;
% imwrite(fig_rgb, './src/logmap_bias.jpg');


% % equation 4-2
% lw = 0:255;
% lwmax = max(lw);
% fig = figure;
% T = tiledlayout(2,3);
% T.TileSpacing = 'compact';
% T.Padding = 'compact';
% idx = 0;
% lwas = [10, 20, 30, 50, 100, 200];
% for lwa = lwas
%     idx = idx + 1;
%     bs = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
%     lds = zeros(length(lw), length(bs));
%     cnt = 0;
%     legends = cell(length(bs), 1);
%     for b = bs
%         cnt = cnt + 1;
%         base = 2 + ((lw / lwmax) .^ (log(b) / log(0.5))) * 8;
%         ld = 1 / log10(lwmax/lwa+1) * log(lw/lwa+1) ./ log(base); % log2
%         lds(:, cnt) = ld;
%         legends{cnt} = sprintf('base=%.1f', b);
%     end
%     nexttile(idx);
%     plot(lds, 'LineWidth', 1.8)
%     hold on, plot(lw, ones(length(lw),1), 'color', 'k')
%     axis([0, max(lw), 0, 1.5])
%     title(sprintf('lwa=%d', lwa))
%     set(gcf, 'color', 'white');
%     set(gca, 'color', 'white');
%     set(gca, 'FontName', 'Helvetica');
%     set(gca, 'FontSize', 13);
%     set(gca, 'linewidth', 1.3);
% end
% % legend(legends, 'Location','southeast')
% fig_rgb = getframe(fig);
% fig_rgb = fig_rgb.cdata;
% imwrite(fig_rgb, './src/logmap_bias_lwa.jpg');


% %% test lwa
% b = 0.7:0.05:0.9;
% b1 = 1 ./ (1 + b - 0.85) .^ 5;
% fig = figure;
% plot(b, b1, 'LineWidth', 1.8)
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);


% %% gamma power function ITU-R BT709
% gamma = 0.4:0.2:3;
% L = 0:0.01:1;
% gammas = zeros(length(L), length(gamma));
% gammas1 = L .^ (1 / 2.2); % gamma

% cnt = 0;
% legends = cell(length(gamma), 1);
% for r = gamma
%     cnt = cnt + 1;
%     E = gamma_function(L, r);
%     gammas(:, cnt) = E;
%     legends{cnt} = sprintf('gamma=%.1f', r);
% end
% fig = figure;
% plot(L, gammas, 'LineWidth', 1.8)
% hold on, plot(L, gammas1, 'LineWidth', 1.8)
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);

% axis([0, 1, 0, 1])
% xticks(0:0.2:1)
% yticks(0:0.1:1)
% legend(legends, 'Location','southeast')


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.4);

% lwas = [50, 100, 150];
% alms = cell(length(lwas), 1);
% cnt = 0;
% impair = rgb;
% name_str = '';
% for lwa = lwas
%     cnt = cnt + 1;
%     alm = alm_hcs(rgb, 0.85, lwa);
%     alms{cnt} = alm;
%     impair = cat(2, impair, alm);
%     name_str = strcat(name_str, '_', num2str(lwa));
% end

% imshow(impair)
% imwrite(impair(:, size(rgb,2)+1:end, :), sprintf('./src/lwa_cmp%s.jpg', name_str))


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.4);

% % bs = [0.7, 0.8, 0.9];
% bs = [0.5, 0.7, 0.9];
% alms = cell(length(bs), 1);
% cnt = 0;
% impair = rgb;
% name_str = '';
% for b = bs
%     cnt = cnt + 1;
%     alm = alm_hcs(rgb, b);
%     alms{cnt} = alm;
%     impair = cat(2, impair, alm);
%     name_str = strcat(name_str, '_', num2str(b));
% end

% imshow(impair)
% imwrite(impair(:, size(rgb,2)+1:end, :), sprintf('./src/b_cmp%s.jpg', name_str))


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.5);

% lw = 0:255;
% lwmax = max(lw);
% fig = figure;
% T = tiledlayout(2,3);
% T.TileSpacing = 'compact';
% T.Padding = 'compact';
% lwas = [10, 20, 30, 50, 100, 200];
% bs = [0.4, 0.5, 0.6, 0.7, 0.9, 1.0];
% idx = 0;
% for lwa = lwas
%     idx = idx + 1;
%     alms = cell(length(bs), 1);
%     cnt = 0;
%     for b = bs
%         cnt = cnt + 1;
%         alm = alm_hcs(rgb, b, lwa);
%         alms{cnt} = alm;
%     end
%     impair1 = cat(2, alms{1}, alms{2}, alms{3});
%     impair2 = cat(2, alms{4}, alms{5}, alms{6});
%     impair = cat(1, impair1, impair2);
%     nexttile(idx);
%     imshow(impair);
%     title(sprintf('lwa=%d', lwa))
%     set(gcf, 'color', 'white');
%     set(gca, 'color', 'white');
%     set(gca, 'FontName', 'Helvetica');
%     set(gca, 'FontSize', 13);
%     set(gca, 'linewidth', 1.3);
% end

% fig_rgb = getframe(fig);
% fig_rgb = fig_rgb.cdata;
% % imwrite(fig_rgb, './src/lwa_b_cmp1.jpg')


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.5);
% rgb = double(rgb) / 255;
% 
% lw = 0:255;
% lwmax = max(lw);
% fig = figure;
% T = tiledlayout(2,3);
% T.TileSpacing = 'compact';
% T.Padding = 'compact';
% lwas = [10, 20, 30, 50, 100, 200]/255;
% bs = [0.4, 0.5, 0.6, 0.7, 0.9, 1.0];
% idx = 0;
% for lwa = lwas
%     idx = idx + 1;
%     alms = cell(length(bs), 1);
%     cnt = 0;
%     for b = bs
%         cnt = cnt + 1;
%         alm = alm_hcs_float(rgb, b, lwa);
%         alms{cnt} = alm;
%     end
%     impair1 = cat(2, alms{1}, alms{2}, alms{3});
%     impair2 = cat(2, alms{4}, alms{5}, alms{6});
%     impair = cat(1, impair1, impair2);
%     nexttile(idx);
%     imshow(impair);
%     title(sprintf('lwa=%d', lwa))
%     set(gcf, 'color', 'white');
%     set(gca, 'color', 'white');
%     set(gca, 'FontName', 'Helvetica');
%     set(gca, 'FontSize', 13);
%     set(gca, 'linewidth', 1.3);
% end
% 
% fig_rgb = getframe(fig);
% fig_rgb = fig_rgb.cdata;
% % imwrite(fig_rgb, './src/lwa_b_cmp1.jpg')


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.5);
% alm = alm_hcs(rgb);
% alm_g = double(alm) / 255;
% alm_g = gamma_function(alm_g, 2.2);
% alm_g = uint8(alm_g * 255);
% impair = cat(2, rgb, alm, alm_g);
% imshow(impair)
% imwrite(impair, './src/alm_result.jpg')


% %% image test
% img_path = './src/test.jpg';
% rgb = imread(img_path);
% rgb = imresize(rgb, 0.5);
% rgb = double(rgb) / 255;
% alm = alm_hcs_float(rgb);
% impair = cat(2, rgb, alm);
% imshow(impair)
% imwrite(impair, './src/alm_float_result.jpg')


%% image test
img_path = './src/test.jpg';
rgb = imread(img_path);
rgb = imresize(rgb, 0.5);

lw = 0:255;
lwmax = max(lw);
fig = figure;
bs = [0.5, 0.7, 0.9];
impair = rgb;
cnt = 0;
for b = bs
    cnt = cnt + 1;
    alm = alm_hcs(rgb, b);
    alm = double(alm) / 255;
    alm = gamma_function(alm, 2.2);
    alm = uint8(alm * 255);
    impair = cat(2, impair, alm);
end
imshow(impair);
imwrite(impair, './src/final_result.jpg')

