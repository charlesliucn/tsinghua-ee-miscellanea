#include<iostream>
#include<cstdlib>
#include<ctime>
#define M 10000
using namespace std;

double Abs(double x)
{
	if(x>=0)
		return x;
	else return -x;
}

double var(int *A)
{
	double s,sum=0;
	double *temp=new double[M];
	time_t t;
	srand((unsigned)time(&t));
	for(int k=0;k<M;k++)
	 {
		 s=0;
		 for(int j=0;j<10;j++)
		 {
			 double tem=A[(rand()%100)];
			 s+=tem;
		 }
		 temp[k]=s;
		 sum+=s;
	}
	double average=sum/M;
	double var=0;
	 for(int i=0;i<M;i++)
		 var+=(temp[i]-average)*(temp[i]-average);
	 delete []temp;
	 return var/M;
}

int main()
 {
	 double average,sum=0;
	 int *Array0=new int[100];
	 int *Array1=new int[100];
	 for(int i=0;i<100;i++)
		 cin>>Array0[i];
	 double var0_t=var(Array0);
	 for(int i=0;i<100;i++)
		 cin>>Array1[i];
	 double var1_t=var(Array1);
	 double varx=0;
	 int *Intemp=new int[100];
	 for(int i=0;i<1000;i++)
	 {
		 sum=0;
		 for(int j=0;j<100;j++)
		 {
			 cin>>Intemp[j];
			 sum+=Intemp[j];
		 }
		 average=sum/100;
		 for(int j=0;j<100;j++)
			 varx+=(Intemp[j]-average)*(Intemp[j]-average);
		 varx=varx/100;
		 if(Abs(varx-var0_t)>=Abs(varx-var1_t))
			 cout<<1<<endl;
		 else cout<<0<<endl;
	 }
}