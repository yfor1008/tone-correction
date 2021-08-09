# Local color correction using non-linear masking

## 原理

详细可以查看: https://blog.csdn.net/j05073094/article/details/119543657

## 使用方法

```matlab
lcc = lcc_nlm(gray, radius);
lcc = lcc_nlm(gray);
[lcc, mask] = lcc_nlm(gray, radius);
[lcc, mask] = lcc_nlm(gray);
```

