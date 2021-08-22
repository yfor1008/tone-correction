function color2 = colorConvert(color1, mode)
% colorConvert - 颜色转换
%
% input:
%   - color1: H*W*3, [0,1]
%   - mode: str, 颜色转换模式, rgb2xyz, xyz2rgb, ...
% output:
%   - color2: H*W*3, [0,1]
%

mode = lower(mode);
funcs = struct('rgb2xyz', @rgb2xyz, 'xyz2rgb', @xyz2rgb);
if ~ isfield(funcs, mode)
    error('mode not correct!');
end

func = funcs.(mode);
color2 = func(color1);

end

function color2 = rgb2xyz(color1)
    color2 = color1;
    color2(:,:,1) = (0.4124 * color1(:,:,1) + 0.3576 * color1(:,:,2) + 0.1805 * color1(:,:,3));
    color2(:,:,2) = (0.2126 * color1(:,:,1) + 0.7152 * color1(:,:,2) + 0.0722 * color1(:,:,3));
    color2(:,:,3) = (0.0193 * color1(:,:,1) + 0.1192 * color1(:,:,2) + 0.9505 * color1(:,:,3));
end

function color2 = xyz2rgb(color1)
    color2 = color1;
    color2(:,:,1) =  3.2410 * color1(:,:,1) - 1.5374 * color1(:,:,2) - 0.4986 * color1(:,:,3);
    color2(:,:,2) = -0.9692 * color1(:,:,1) + 1.8760 * color1(:,:,2) + 0.0416 * color1(:,:,3);
    color2(:,:,3) =  0.0556 * color1(:,:,1) - 0.2040 * color1(:,:,2) + 1.0570 * color1(:,:,3);
end