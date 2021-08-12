# [论文阅读] LCC-NLM(局部颜色校正, 非线性mask)

文章: [Local color correction using non-linear masking](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.99.3447&rep=rep1&type=pdf)

## 1. 算法原理

如下图所示为, 算法原理框图.

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300229.png)

其核心有2个步骤:

1. 对图像进行模糊, 生成mask;
2. 对图像进行gamma校正, 得到输出图像, 校正公式为:

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300251.png)

 对公式含义的解释. 如下图所示, 为不同mask情况下, 输入和输出的关系, 可以看到:

- 当mask>128时, gamma校正幂次为 $2^\frac{128-mask}{128}<1$, 校正后的值会增大, 如图中绿色线条所示
- 当mask=128时, gamma校正幂次为1, 校正不会改变大小, 如图中黄色线条所示
- 当mask<128时, gamma校正幂次为 $2^\frac{128-mask}{128}>1$, 校正后的值会减小, 如图中青色线条所示

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300266.jpg)

## 2. 算法关键

如上述处理过程, 算法关键有2个:

1. 如何生成mask, 是否需要取反滤波?
2. gamma校正公式中使用的是与128进行比较, 对于图像整体偏暗或者偏亮的图像是否有效果?

### 2.1 是否需要滤波

至于是否需要滤波, 文章中一句话已经说明: **滤波可以将同一输入映射成不同的输出**.

> A local color correction will provide a method to map one input value to many different output values, depending on the values of neighboring pixels.

文章中, 另一句话, 更明显地说明了原因: **当mask没有模糊时, 图像的对比度会降低; 反之, 当mask模糊过度时, 就会简化成简单的gamma校正**.

> If the mask is not blurred, then the image contrast will be excessively reduced. In comparison, if the mask is overly blurred then this algorithm reduces to simple gamma correction. 

这里详细说明这句话的意思:

- 当有滤波时, 利用了局部邻域像素的信息: 对于同一个输入, 由于邻域像素不同, mask也不相同, 从而使得输出也不相同; 对于同一邻域内不同的输入, mask相同会使得邻域内输出变化相同;
- 当没有滤波时, 没有利用局部邻域像素的信息, 这里mask可以为固定值或者当前像素的取反值: mask为固定值时, 相当于滤波时窗口半径非常大(滤波后图像为一个常数), 这样相当于对图像做了一个全局的gamma校正, 效果可能不理想; mask为当前像素取反时, 邻域内每个像素的mask都不相同, 输出变化也不相同, 可能会降低图像对比度;

因而, 是需要滤波的. 如下所示, 为不同参数滤波后的效果:

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300285.jpg)

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300302.jpg)

如上所示, 为使用了**快速均值滤波**不同参数情况下的效果:

- 滤波半径为0时, 相当于没有滤波, mask为输入取反; 从图中可以看到, 图像中的草皮细节被模糊, 可能就是邻域内的变化不相同导致的;
- 滤波半径为15时, mask得到了图像大致结构; 从图中可以看到, 图像整体效果较好;
- 滤波半径为300时, mask基本为一个常数; 从图中可以看到, 效果不是太好;

**这里有个问题, 如何选取合适的滤波参数?**

### 2.2 算法适用性

从公式1中可以看到, 当图像整体亮度<128, 或者整体亮度>128时, 效果不太好, 如下图所示.

![](https://gitee.com/yfor1008/pictures/raw/master/202108111304425.jpg)

为了使的算法更具一般性, 可以先对图像进行**线性拉伸**, 然后再进行处理, 如下图所示结果:

![](https://gitee.com/yfor1008/pictures/raw/master/202108111313911.jpg)

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300335.jpg)

这里线性拉伸不一定是最好的方法, 有可能只用线性拉伸已经有足够好的效果了.

## 3. 算法改善

### 3.1 公式调整1

算法在计算mask时, 进行了取反, 在进行gamma校正时, 也是做了取反, 实际上做了重复的工作, 因而可以进行简化, 简化后的校正公式为:
$$
O_{xy} = 255 * (\frac{I_{xy}}{255}) ^ {2 ^ {\frac{m_{xy}-127}{128}}}
$$
更改后, 与原始算法是等效的, 更改前后结果对比如下所示.

![](https://gitee.com/yfor1008/pictures/raw/master/202108111300351.jpg)

可以看到, 二者完全是一样的效果.

### 3.2 公式调整2

结合上面说的拉伸方法, 可以直接在公式中进行更改, 更改后公式如下:
$$
O_{xy} = 255 * (\frac{I_{xy}}{ratio}) ^ {2 ^ {\frac{m_{xy}-127}{128}}}
$$
其中, ratio 为抛出一定比例后的最大值, 下图所示为抛出1%后的效果:

![pout_ratio_cmp](https://gitee.com/yfor1008/pictures/raw/master/pout_ratio_cmp.jpg)

![test_ratio_cmp](https://gitee.com/yfor1008/pictures/raw/master/test_ratio_cmp.jpg)

## 4. 代码

原始方法:

```matlab
gray = double(gray);
gray_inv = 255 - gray;
mask = meanFilterSat(gray_inv, radius);
lcc = 255 * (gray / 255) .^ (2 .^((128 - mask) / 128));
```

调整后:

```matlab
gray = double(gray);
mask = meanFilterSat(gray, radius);
lcc = 255 * (gray / 255) .^ (2 .^((mask - 127) / 128));
```

最后, 使用ratio的方法为:

```matlab
gray = double(gray);
mask = meanFilterSat(gray, radius); % 快速均值滤波
h_gray = hist_count(gray); % 直方图
ranges = getRanges(h_gray, 0.01); % 动态范围
lcc = 255 * (gray / ranges(2)) .^ (2 .^((mask - 127) / 128));
```



