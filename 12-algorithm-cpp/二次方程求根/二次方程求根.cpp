#include<iostream>
#include<cstdio>
#include<cmath>
using namespace std;
double Max(double x,double y,double z)
{
	double a,b,c;
	a=abs(x);
	b=abs(y);
	c=abs(z);
	if(b>a)
		a=b;
	if(c>a)
		a=c;
	return sqrt(a);
}
int main()
{
	double a,b,c,t,m,zero,equal,x1,x2;
	cin>>a>>b>>c;
	t=Max(a,b,c);
	a=a/t;
	b=b/t;
	c=c/t;
	zero=0;
	m=b*b-4*a*c;
	if(c==0)
	{
		printf("%.16e\n",zero);
		equal=(-b)/a;
		printf("%.16e\n",equal);
	}
	else
	{
	if(m<0)
	{
		printf("%.16e\n",zero);
		printf("%.16e\n",zero);
	}
	else if(m==0)
	{
		equal=(-b)/(2*a);
		printf("%.16e\n",equal);
		printf("%.16e\n",equal);
	}
	else
	{
		double s=sqrt(m);
			if(b>=0)
			{
				x1=(-b-s)/(2*a);
				printf("%.16e\n",x1);
				x2=(2*c)/(-b-s);
				printf("%.16e\n",x2);
			}
			else
			{
				x1=(-b+s)/(2*a);
				printf("%.16e\n",x1);
				x2=(2*c)/(-b+s);
				printf("%.16e\n",x2);
			}
		}
	}
}