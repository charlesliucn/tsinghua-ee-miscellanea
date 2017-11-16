# 基于MATLAB的数字图像处理
主要涉及数字图像处理相关原理的MATLAB代码实现，整理常用的函数，并给出一些合适的例子。

### 帮助文档及论坛：
+ [MATLAB中文论坛](http://www.ilovematlab.cn/forum.php)
+ [MATLAB中文官网](https://cn.mathworks.com/help/index.html)

* * * 
## 1. 第一单元  图像增强
  + [第一章  空域增强：点操作](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter1/readme.md)
    - imread
    - imshow
    - imnoise
    - histeq
    - imhist
  + [第二章  空域增强：模板操作](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter2/readme.md)
    - mat2gray
    - imfilter:  symmetric; replicate; circular...
    - fspecial:  average; gaussian; laplacian; log; motion; prewitt; sobel...
    - medfilt2
  + [第三章 频域图像增强](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter3/readme.md)
    - fft
    - fft2
    - fftshift
    - ButterWorth Filter
    - butter
    - buttord

* * * 

## 2. 第二单元 图像恢复
 + [第四章 图像消噪和恢复](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter4/readme.md)
    - wiener2
    - imnoise
    - fspecial
    - filter2
    - ordfilt2
    - [使用样例](http://www.cnblogs.com/xiangshancuizhu/archive/2011/01/04/1925276.html)

 + [第五章 图像校正和修补](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter5/readme.md)
    - interp1: 'method': linear, cubic, nearest, spline
    - interp2
    - interp3
    - interpn
    - fill
    - fill3
    - TV(Total Variation)[使用样例](http://www.cnblogs.com/tiandsp/archive/2013/05/31/3110350.html)
 
 + [第六章 图像投影重建](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter6/readme.md)
    - phantom：生成Shep-Logan头部模型
    - radon:拉东变换
    - iradon:拉东逆变换
    - fanbeam:扇束投影
    - ifanbeam:扇束反投影重建
    - imagesc:将矩阵中的元素数值按大小转化为不同颜色,并在坐标轴对应位置处以这种颜色染色
    - [使用样例](https://wenku.baidu.com/view/89c48fd7be23482fb4da4cac.html)

* * * 

### 3. 第三单元 图像编码
 + [第七章 图像编码基础](https://github.com/charlesliucn/digital-image-processing/tree/master/chapter7/readme.md)
    - huffmanenco
    - huffmandeco
    - huffmandict
 
 + 第八章 图像变换编码
 
 + 第九章 其他图像编码方法
