/*经过分析，哥德巴赫数可分为两个大类，即①偶数（由哥德巴赫猜想）；
②偶质数2+任一奇质数；所以该题目的难点在于寻找一定范围的质数*/
#include<iostream>
#include<cmath>
using namespace std;
int main()
{
	int iN,i,j,iRoot,Count=0;
	cin>>iN;//输入整数iN（第iN个哥德巴赫数）
	iRoot=(int)(sqrt(double(2*iN+3)));//求得算术平方根，作为寻找质数的上限
	char *Num=new char[2*iN+3];//申请char型数组的动态内存。【注意】之所以申请2*iN+3个char，是因为2n+3里已经包含了n个非2偶数，已满足了要寻找的哥德巴赫数的量
	for(i=0;i<2*iN+3;i++)//先将所有大于3的正整数标记为‘y’，表示“是哥德巴赫数”
	{
		Num[i]='y';
	}
	for(i=3;i<=iRoot;i=i+2)//将奇数中的合数标记为'n'
	{
		if(Num[i]=='y')
		{
			for(j=i;i*j<=2*iN+3;j=j+2)/*对于每一个大于等于3的质数的奇数倍（该奇倍数大于等于质数本身）
															标记为合数，奇数中剩下的即质数*/
			{
			Num[i*j]='n';
			}
		}
	}
	if(iN==1)//输入1和2为特殊情况，可单独罗列
		cout<<4;
	else if(iN==2)
		cout<<5;
	else 
	{
		for(i=4;i<2*iN+3;i++) //遍历整个2iN+3个char型，遇到哥德巴赫数，累加器Count加1
		{  
			if(Num[i]=='y')   
			{    
				Count++; 
			}   
			if(Count==iN-2)  //判断累加器中的哥德巴赫数量与输入iN相等，则输出此时的哥德巴赫数
			{  
				cout<<i+2;   
				break;
			}  
		}
	}
}