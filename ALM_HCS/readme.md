# [论文阅读] ALM-HCS(高对比场景自适应对数映射)

文章: [Adaptive Logarithmic Mapping for Displaying High Contrast Scenes](http://resources.mpi-inf.mpg.de/tmo/logmap/)

## 1. 论文目的

将高动态范围图像映射到机器可以显示的动态范围, 作者提出了几个要求:

> The design of our tone mapping technique was guided by a few rules. 
>
> 1. It must provide consistent results despite the vast diversity of natural scenes and the possible radiance value inaccuracy found in HDR photographs. 
> 2. Additionally, it should be adaptable and extensible to address the current capabilities ofdisplaying methods and their future evolution. 
> 3. Tone mapping must capture the physical appearance of the scene, while avoiding the introduction of artifacts such as contrast reversal or black halos. 
> 4. The overall brightness of the output image must be faithful to the context. It must be “user-friendly” i.e., automatic in most cases, with a few in- tuitive parameters which provide possibility for adjustments. 
> 5. It must be fast for interactive and realtime applications while avoiding any trade-off between speed versus quality

总结起来就是:

1. 具有普适性, 对所有图像都能适用, 而不是仅适用于某些特定的图像;
2. 具有自适应性, 可以根据图像自身的情况调整参数;

## 2. 论文方法

论文方法归纳起来就是自适应对数变换(Adaptive Logarithmic Mapping) + gamma校正, 同时满足上述要求:

1. 对于普适性, 论文中使用公式1, 将图像输出调整[0, 1], 再根据需要调整需要显示的动态范围(一般是[0,255]).

![](https://gitee.com/yfor1008/pictures/raw/master/scale_function.png)

2. 对于自适应性, 论文中使用对数变换 $log_{base}(L_w+1)$ 来对图像的对比度进行调整, 其中, `base` 是根据图像自身的信息来进行调整的.

论文中的公式4就是上述过程的综合:

![](https://gitee.com/yfor1008/pictures/raw/master/ada_logmap_function.png)

其中, `Lw`为图像中每个像素的亮度, `Lwmax`为图像中亮度最大值, `Ldmax`为显示最大值, 一般 `Ldmax*0.01=1`, 参数`b`对数函数的基底进行调整.

然后使用gamma校正来进一步调整图像. 因而论文方法步骤可以概括为:

1. 自适应对数变换;
2. gamma校正;

## 3. 论文核心

### 3.1 场景亮度映射到图像亮度-缩放因子很关键

论文中使用了一个缩放因子来调整图像映射后的整体亮度, 根据论文中的说明, 公式1可以更改为:

![](https://gitee.com/yfor1008/pictures/raw/master/scale_function1.png)

其中, 参数 `Lwa` 是很关键的, 这个会影响到图像最终的亮度, 如下图所示为上述公式的在不同 `Lwa` 下的曲线:

![](https://gitee.com/yfor1008/pictures/raw/master/scalemap_function.jpg)

图中, 最上边蓝色的曲线为 `Lwa=1` 的情况, 与公式1是完全一样的. 我们可以看到, **当 `Lwa=1` 时, 曲线斜率很大, 映射后像素的亮度值会增加很大, 会导致图像整体偏亮, 对比度降低, 所以必须要有这个缩放因子**.

如下所示图像测试结果(从左到右依次为: 原图, lwa=1的图像, lwa=50的图像):

![](https://gitee.com/yfor1008/pictures/raw/master/lwa_cmp_1_50.jpg)

可以看到, 当`Lwa=1` 时, 图像亮度亮度过高, 对比度低.

### 3.2 自适应对数映射-基底很关键

为方便理解, 这里将公式4调整为如下公式:

![](https://gitee.com/yfor1008/pictures/raw/master/ada_logmap_function1.png)

其中,  `Ldmax*0.01=1` 省略了, 然后利用文中的换底公式2($log_{base}(x)=log(x)/log(base)$), 可以将上式变换成公式4.

从上述调整后的公式可以看到, 对数变换的基底 `base` 很重要, 下图为论文中给出的 log2(左图) 和 log10(右图) 的对比效果:

![](https://gitee.com/yfor1008/pictures/raw/master/log2_log10.png)

从图中可以看到:

- log2 时图像整体偏亮, 对比度更强, 如右上角的暗部区域细节增强较好, 但对于较亮的区域, 如几个窗户则过度增强了, 出现了饱和, 丢失了细节; 
- log10时图像整体偏暗, 对比度要低一些, 如右上角的暗部区域细节没有得到很好的增强, 但对于较亮区域的细节则保持的很好, 如几个窗户的细节清晰;

因而, 如果使用固定的基底, 则适应所有图像, 不具备普适性, 所以基底很重要, 需要具有自适应性.

这里对自适应性说明一下: 

- 当亮度 `Lw` 越小, 公式中计算出来的基底 `base` 就越小, 对数变换 $log_{base}(L_w+1)$ 的值就越大, 亮度增加的越多;
- 当亮度 `Lw` 越大, 公式中计算出来的基底 `base` 就越大, 对数变换 $log_{base}(L_w+1)$ 的值就越小, 亮度增加的越少;

对于不同的亮度, 计算出来的基底在[2,10]内取值, 因而可以做到自适应.

### 3.3 gamma校正

在自适应对数变换后, 论文中还使用了gamma校正来进一步调整图像亮度, 原因应该就是论文中的自适应对数变换效果还不够好. 论文中使用的gamma变换为[`ITU-R BT.709`](https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-4-200003-S!!PDF-E.pdf)的改进, 其公式如下所示:

![](https://gitee.com/yfor1008/pictures/raw/master/gamma_power_function_itu-r-bt709.png)

下图所示为论文中方法实现的效果, gamma=2.2:

![](https://gitee.com/yfor1008/pictures/raw/master/alm_result.jpg)

上图依次为原图, 自适应对数变换, 自适应对数变换+gamma校正, 可以看到, 自适应对数变化的效果还不够好, 需要使用gamma校正来进一步提高图像效果.

## 4. 核心参数说明

### 4.1 缩放因子lwa

论文中使用场景亮度均值 `Lwa` 作为景亮度到图像亮度的缩放因子, 这是由于图像显示的整体亮度由场景的整体亮度决定的, 从3.1中的曲线图可以看到, 处理后图像的亮度与 `lwa` 成反相关:

- `lwa` 越小, 处理后图像越亮提升越多
- `lwa` 越大, 处理后图像越亮提升越少

上面的关系可以这么来解释:  `Lwa` 越小, 场景亮度越低, 亮度需要提高的就越多;  `Lwa` 越大, 场景亮度越高, 亮度需要提升的就越少. 如下图所示为不同 `Lwa` 的效果, b固定为0.85, 依次为50, 100, 150:

![](https://gitee.com/yfor1008/pictures/raw/master/lwa_cmp_50_100_150.jpg)

从图中可以看到, 图像的亮度是依次降低的. 同时从3.1中的曲线图可以看到,  `Lwa` 越大, 变换曲线越接近于直线, 起到的作用也就越低.

### 4.2 偏置参数b

来看看参数b对图像亮度的影响, 如下图所示为公式4在不同参数b的情况:

![](https://gitee.com/yfor1008/pictures/raw/master/logmap_bias.jpg)

从上图可以看到, b的情况与lwa情况有点类似, 都与图像亮度成反相关:

- b越小, 斜率越大, 处理后图像亮度提升越多
- b越大, 斜率越小, 处理后图像亮度提升越少

但b不能小于0.7. 从上图可以看到, 当b<0.7是, 曲线不是单调函数, 且最终结果会大于1, 这样处理后的图像有副作用, 如图像太亮, 且不能保持图像中像素的相对大小. 论文中作者推荐b=0.85.

如下图所示为不同b的效果, lwa固定为亮度均值, 依次为0.5, 0.7, 0.9:

![](https://gitee.com/yfor1008/pictures/raw/master/b_cmp_0.5_0.7_0.9.jpg)

从上图可以看到, 当b=0.5时, 处理后图像并没有太亮, 且也没有出现副作用, 可能是由于lwa影响了b的效果.

### 4.3 lwa 与 b关系

从公式4中可以看到, 并没有lwa, 这里对公式改写如下:

![](https://gitee.com/yfor1008/pictures/raw/master/ada_logmap_function2.png)

下图为更改后, 不同参数的情况(b=0.5, 0.6, 0.7, 0.8, 0.9, 1.0):

![](https://gitee.com/yfor1008/pictures/raw/master/logmap_bias_lwa.jpg)

![](https://gitee.com/yfor1008/pictures/raw/master/lwa_b_cmp.jpg)

从图中可以看到, lwa的效果比b的效果要明显些. 为了保持处理后的图像亮度的稳定性, 作者使用了如下公式来调整lwa:

![](https://gitee.com/yfor1008/pictures/raw/master/lwa_b_function.jpg)

对于公式4, b越小, 处理后图像越亮, 使用上述公式后, lwa越大, 图像亮度越小, b使图像亮度增加, lwa使图像亮度降低, 二者相互抵消. 如下图所示:

![](https://gitee.com/yfor1008/pictures/raw/master/lwa_b_cmp1.jpg)

从图中可以看到, 图像亮度基本是恒定的, 但效果不是很理想, 因而还需要后续进行gamma校正处理.

### 4.4 最大数对数基底

如公式4中, 对最大数取对数时, 使用基底为10, 至于为什么取10, 论文中给出的解释是: 

> In the denominator decimal logarithm is used since the maximum luminance value in the scene is always re-sampled to decimal logarithm by the bias function. 

而真正的原因应该是自适应 `base` 的取值为[2,10], 最大数对数基底要取这个里面的最大值, 否则得到最大数就被放大, 会压缩图像的亮度. 如下所示为基底为2的情况:

![](https://gitee.com/yfor1008/pictures/raw/master/logmap_bias_lwa1.jpg)

从图中可以看到, 当最大值对数取基底为2时, 处理后图像亮度没有达到最大值1, 图像亮度被压缩.

### 4.5 参数设置小结

对于上述分析, 这里总结下:

- 缩放因子lwa: 取图像亮度均值, 对处理后图像亮度影响较大, 对于较暗图像, 处理效果不是太理想, 需结合gamma校正;
- 参数b: 配合lwa使用, 对处理后图像亮度影响没有lwa大; 
- 最大数对数基底: 需取base取值范围内的最大值, 否则图像亮度会被压缩;
- gamma校正: gamma值, 目前仅测试了gamma=2.2, 根据图像亮度进行调整(需研究方法)效果应该会更好;

## 5. 最终实现

### 5.1 效果

使用参数为: lwa=亮度均值, b=[0.5, 0.7, 0.9], gamma=2.2, 最大数对数为log10, 最终效果如下(从左到右依次为: 原图, b=0.5, b=0.7, b=0.9):

![](https://gitee.com/yfor1008/pictures/raw/master/final_result.jpg)

### 5.2 代码

作者开源了代码, 详见这里: [http://resources.mpi-inf.mpg.de/tmo/logmap/](http://resources.mpi-inf.mpg.de/tmo/logmap/). 这里使用matlab实现了, 代码如下:

```matlab
img_path = './src/test.jpg';
rgb = imread(img_path);
alm = alm_hcs(rgb);
alm_g = double(alm) / 255;
alm_g = gamma_function(alm_g, 2.2);
alm_g = uint8(alm_g * 255);
impair = cat(2, rgb, alm, alm_g);
imshow(impair)
```

```matlab
function [alm] = alm_hcs(rgb, b, lwa)
rgb = double(rgb);
% RGB转XYZ
xyz = colorConvert(rgb, 'rgb2xyz');
Y = xyz(:,:,2);

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
```



唯一觉得美中不足是, 论文使用的是全局映射, 没有考虑局部信息来进一步增加对比度.

