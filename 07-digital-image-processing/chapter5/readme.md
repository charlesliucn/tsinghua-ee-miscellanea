# 第五章 图像校正和修补
+ 图像恢复
	- 原因：图像质量在某种条件下退化了，需要根据退化模型和知识恢复原始的图象
	- 方法：将图像退化的过程模型化，根据确定的图像对原始图像进行复原。

* * *

+ 图像仿射变换
	- 一般仿射变换
		* 一个非奇异线性变换接一个平移变换
		* 一个平面上的仿射变换有6个自由度
		* 分解：
		a)	一般仿射变换可以认为是一个非各向同性的放缩和一个旋转的组合
		b)	甚至可以认为是平移、放缩、旋转和剪切的一种综合
		* 性质：
		a)	仿射变换能建立一对一的关系
		b)	放射变化下，(平行)直线仍然映射为(平行)直线
		c)	两个没有退化的三角形A和B，只有唯一的仿射变换将A映射为B
		d)	仿射变换会导致区域面积的变化

	- 特殊仿射变换
		* 相似变换
		* 等距变换(刚体变换)
		* 欧氏变换	

* * *

+ 几何失真校正
	- 几何失真模型:
		* 线性失真
		* 二次失真(非线性失真)
	- 空间变换方法：
		* 约束对应点，找到足够多的位置确切知道的点，建立失真图与校正图之间点的对应关系
	- 灰度插值方法：
		* 最近邻插值(零阶插值)
		* 前向映射：失真图 → 非失真图
		* 后向映射：非失真图 → 失真图
		* 比较：后向映射能避免不失真图像产生孔洞，也不需要重复计算，应用更加广泛
		* 双线性插值：逐个方向插值计算
		* 三次线性插值
		[参考资料](http://www.cnblogs.com/yingying0907/archive/2012/11/21/2780092.html)

* * * 

+ 图像修复
	- 问题描述：
		* 图像缺失
		* 灰度改变
		* 有损压缩
		* 覆盖文字或划痕

	- 图像修补：
		* 修复/插补：修补尺度较小的区域
		* 补全/填充：考虑整体纹理信息
		* 病态问题：解是不确定的

	- 全变分模型：
		* 优点：保持图像中线性结构
		* 缺点：不一定保持图像细节

* * *

+ 区域填充
	- 基于样本的方法
	- 结合稀疏表达的方法
		










