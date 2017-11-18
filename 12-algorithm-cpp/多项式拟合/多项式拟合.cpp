//多项式拟合与矩阵分解
#include<iostream>
#include<cmath>
using namespace std;
void QR(double **M,int n,int m,double *y)
{
	double cond,U,V,W;
	double* v=new double[n];
	for(int i=0;i<m;i++)//矩阵中一共有m个需要变的向量
	{
		cond=0;//存储每个向量的二次范数(模)		
		for(int j=i;j<n;j++)
		{
			cond+=M[i][j]*M[i][j];
		}
		cond=sqrt(cond);
		if(M[i][i]>0)//元素值大于0时，选择模的负数，可以避免不必要的精度损失
			cond=-cond;
		v[i]=M[i][i]+cond;
		V=v[i]*v[i];
		for(int j=i+1;j<n;j++)
		{
			v[j]=M[i][j];
			V+=v[j]*v[j];
		}
		for(int j=i;j<m;j++)//Household矩阵处理第i列之后的向量
		{
			U=0;
			for(int k=i;k<n;k++)//调整了矩阵相乘的顺序，避免用矩阵的计算量
			{
				U+=v[k]*M[j][k];
			}
			for(int k=i;k<n;k++)
			{
				M[j][k]-=2*U*v[k]/V;
			}
		}
		W=0;
		for(int j=i;j<n;j++)
			W+=v[j]*y[j];
		for(int j=i;j<n;j++)
			y[j]-=2*W*v[j]/V;
	}
	for(int i=m-1;i>=0;i--)
	{
		for(int j=i+1;j<m;j++)
		{
			y[i]-=M[j][i]*y[j];
		}
		y[i]/=M[i][i];
	}
}

int main()
{
	int n,m;
	cin>>n>>m;//输入点的坐标和要拟合出来的多项式的次数
	double* x=new double[n];//存储x坐标，自变量
	double* y=new double[n];//存储y坐标，函数值
	double** M=new double*[m];//M矩阵是由输入数据得到的矩阵
	for(int i=0;i<m;i++)//构建m*n矩阵
	{
		M[i]=new double[n];
	}
	for(int i=0;i<n;i++)//依次输入n组数据
	{
		cin>>x[i]>>y[i];
	}
	for(int i=0;i<m;i++)
	{
		for(int j=0;j<n;j++)//自变量的幂存入数组
		{
			M[i][j]=pow(x[j],i);
		}
	}
	QR(M,n,m,y);//QR分解
	for(int i=0;i<m;i++)//迭代求上三角方程组的解
	{
		cout<<int(0.5+y[i])<<endl;
	}
}