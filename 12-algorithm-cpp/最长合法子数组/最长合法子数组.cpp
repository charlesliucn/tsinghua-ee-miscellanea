#include <iostream>
#include <cmath>
#define Num 2000000//定义Num
using namespace std;

struct Element//表示数组的一个元素，由数值和位置构成
{
  int data;
  int pos;
};

struct Queue//队列
{
  int head;
  int tail;
  Element n[Num];
};

static Queue Max, Min;//静态全局变量

void Max_Queue(int pos, int data) //将每个新输入的数据进行判断之后插入到存储Max的数组之中此处的Max为极大值点
{
  while (1) 
  {
    if (Max.head != Max.tail)//比较之后决定是否插入队列之中
	{
		if (Max.n[Max.tail-1].data< data) 
		Max.tail--;
		else
		{
			Max.n[Max.tail].data = data;
			Max.n[Max.tail].pos = pos;
			Max.tail++;
			break;
		}
	}
    else //如果队列为空，直接将新插入的数放在队列内
	{
		Max.n[Max.tail].data = data;
		Max.n[Max.tail].pos = pos;
		Max.tail++;
		break;
    }
  }
}
void Min_Queue(int pos, int data)//将每个新输入的数据进行判断之后插入到存储Min的数组之中此处的Min为极小值点
{
  while (1)
  {
    if (Min.head!=Min.tail)//比较之后决定是否插入队列之中
	{
		if (Min.n[Min.tail - 1].data> data) 
			Min.tail--;
		else 
		{
			Min.n[Min.tail].data = data;
			Min.n[Min.tail].pos = pos;
			Min.tail++;
			break;
		}
	}
    else //如果队列为空，直接将新插入的数放在队列内
	{
       Min.n[Min.tail].data = data;
	   Min.n[Min.tail].pos = pos;
	   Min.tail++;
	   break;
    }
  }
}

int main()
{
  int N,m,data;
  int count=0, Mincount=Num, Maxcount = 0;
  cin>>N>>m;
  int *mark=new int[2];
  int i=0;
  for(i=0;i<2;i++)
  {
	  cin>>data;
	  mark[i]=data;
  }
  if(abs(mark[0]-mark[1])>=m)
  {
		for(i=2;i<N;i++)
		{
			 cin>>data;
		}
		cout<<1<<endl<<0;
  }
  else
  {
	  for(i=0;i<2;i++)
	  {
		  data=mark[i];
		  count++;
		  Max_Queue(i,data);
		  Min_Queue(i,data);
		  if(Max.n[Max.head].data-Min.n[Min.head].data >= m)
		  {
			  while (Max.n[Max.head].data-Min.n[Min.head].data >= m && count>0) 
			  {
				  if (Mincount>count) 
					  Mincount =count;
				  count--;
				  while (Max.n[Max.head].pos <= i-count) 
					  Max.head++;
				  while (Min.n[Min.head].pos <= i-count)
					  Min.head++;
			  }
		  }
		  else
		  {
			  if (Maxcount < count) 
				  Maxcount = count;
		  }
	  }
	  for(i=2;i<N;i++)
	  {
		  cin>>data;
		  count++;
		  Max_Queue(i,data);
		  Min_Queue(i,data);
		  if (Max.n[Max.head].data-Min.n[Min.head].data >= m)
		  {
			  while (Max.n[Max.head].data-Min.n[Min.head].data >= m && count>0) 
			  {
				  if (Mincount>count) 
					  Mincount =count;
				  count--;
				  while (Max.n[Max.head].pos <= i-count) 
					  Max.head++;
				  while (Min.n[Min.head].pos <= i-count)
					  Min.head++;
			  }
		  }
		  else
		  {
			  if (Maxcount < count) 
				  Maxcount = count;
		  }
	  }
	  if (Mincount == Num) 
		  Mincount = 0;
	  cout<<Mincount<<endl;
	  cout<<Maxcount<<endl;
  }
}