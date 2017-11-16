/*Q-M算法的实现*/
#include<iostream>
using namespace std;

int Pow(int a,int b)//整数的整数幂函数(使用VS自带的pow时发现可能出现浮点错误)
{
	int num=1;
	for(int i=0;i<b;i++)//计算a的b次方，a、b均为整数
		num*=a;
	return num;
}
int num_prime_implicant=0;//记录本原蕴含项的数目

class Term//表示“项”类，用于存储最小项和无关项
{ 
public:
	Term(){next=NULL;}//构造函数
	void Newt(int n,int num);//设置（初步处理）一个新项
	int Get_One()		{	return  num_of_ones;	}
	void Set_com(Term *t,int *mark,int n);
	void SetNULL(Term **t,int num);
	int *binary;//binary数组用于存放序数的二进制表示，用“-1”表示“-”
	Term *next;//指向1的数目相同的下一个Term项
	int num_of_ones;//num_of_ones用于记录二进制表示的序数中含有的1的个数
	bool status;//true表示这是一个本原蕴含项
};

void Term::Newt(int n,int num)//设定新的项（初步处理）
{
	binary=new int[n];//动态申请数组，用于存储项的二进制形式编号
	int temp=num,count=0;//count为该项中1的数目
	for(int i=0;i<n;i++)//将编号num转换为二进制形式
	{
		binary[i]=temp%2;
		if(binary[i]==1) 
			count++;
		temp=temp/2;
	}
	num_of_ones=count;//得到1的数目
	status=1;//先假设为本原蕴含项
	next=NULL;//先置指向NULL
}

void Term::Set_com(Term *t,int *mark,int n)//设置合并项
{
	status=1;//先假设合并项为本原蕴含项
	num_of_ones=t->num_of_ones;//t中1的个数即为合并项的1的个数
	next=NULL;
	binary=new int[n];
	for(int i=0;i<n;i++)//先将t的二进制形式赋给合并项
		binary[i]=t->binary[i];
	binary[*mark]=-1;//再将做了标记不同的那一bit赋值为-1，表示-
}
void SetNULL(Term **t,int num)//将每项的指针设为NULL
{
	for(int i=0;i<num;i++)
		t[i]=NULL;
}

void cout_binary(Term *t, int n)//输出函数
{
	for(int i=n-1;i>=0;i--)//从高位到低位输出的才是二进制形式
	{
		if(t->binary[i]==-1)//最后形式输出“-”
			cout<<'-';
		else cout<<t->binary[i];
	}
}

int Compare(Term *t1,Term *t2,int n,int *mark)//比较两项不同1的个数，便于确定是否可以合并
{
	int count=0;//用于计数(t1、t2中不同的1的个数)
	for(int j=0;j<n;j++)
	{
		if(t1->binary[j]!=t2->binary[j]) 
		{
			count++;
			*mark=j;//标记不同的那个bit
		}
	}
	return(count);//返回值为1时，表明a、b两项只有1bit不同，则可以合并
}

void Linkterm(int i,Term *sameone,Term **head,Term **current)//通过指针将具有相同个1的最小项(或无关项)连在一起；i表示二进制形式中1的个数，便于向链表中接入新项
{
	if(head[i]!=NULL) //如果链表不为空
	{
		current[i]->next=sameone;//如果链表中已存在1的个数为i的项，加入链表中
		current[i]=sameone;//当前指针指向新加的项
	}
	else//链表为空时
	{	//头指针和当前指针均指向该项
		head[i]=sameone;
		current[i]=sameone;
	}
}

bool Check_UnREP(Term *t,Term**prime_implicant,int n)//检验新生成的本原蕴含项是否有重复,重复返回false，无重复返回true
{
	int *m=new int;
	if (num_prime_implicant==0) 
		return true;//此时没有本原蕴含项
	for(int i=0;i<num_prime_implicant;i++)
	{
		if(Compare(t,prime_implicant[i],n,m)==0) 
			return false;//此时存在重复
	}
	return true;//?
}

bool Compare_Term(Term *t,Term *&head1,Term *&head2,Term**prime_implicant,int n)//比较项目，是否还存在能够合并的项
{
	int *mark=new int;
	Term *current1=head1;//current1指向拿来对比的项
	Term *current2=head2;//current2指向新生成的项
	while(current2!=NULL&&current2->next!=NULL)//将current2移到链尾
	{
		current2=current2->next;
	}
	while(current1->next!=NULL)//遍历整个链表
	{
		if(Compare(t,current1,n,mark)==1)//若该项t和被拿来对比的项current1可以合并，则两项都不是本原蕴含项
		{
			//标记t和current1项不是本原蕴含项
			t->status=0;
			current1->status=0;
			if(head2==NULL)//链表head2为空，则生成表头结点，当前指针指向表头
			{
				head2=new Term;
				current2=head2;
			}
			else//链表不为空时，链表尾增加新项，当前指针指向新项
			{
				current2->next=new Term;
				current2=current2->next;
			}
			current2->Set_com(t,mark,n);
		}
		current1=current1->next;
	}
	if(Compare(t,current1,n,mark)==1)//若该项t和被拿来对比的项current1可以合并，则两项都不是本原蕴含项
	{
		//标记t和current1项不是本原蕴含项
		t->status=0;
		current1->status=0;
		if(head2==NULL)//链表head2为空，则生成表头结点，当前指针指向表头
		{
			head2=new Term;
			current2=head2;
		}
		else//链表不为空时，链表尾增加新项，当前指针指向新项
		{
			current2->next=new Term;
			current2=current2->next;
		}
		current2->Set_com(t,mark,n);
	}
	if(t->status==1)//本原蕴含项
	{
		if(Check_UnREP(t,prime_implicant,n))//若没有重复项
		{
			prime_implicant[num_prime_implicant]=t;
			num_prime_implicant++;
		}
		return true;//返回true 表示t是本原蕴含项
	}
	else return false;
}

void Check_prime_implicant(Term *t,Term**prime_implicant,int n)//检查本原蕴含项并存入数组中
{
	while(t->next!=NULL)//遍历链表
	{
		if(t->status==1&&Check_UnREP(t,prime_implicant,n))//是本原蕴含项且不存在重复
		{
			prime_implicant[num_prime_implicant]=t;//存入本原蕴含项数组
			num_prime_implicant++;//计数+1
		}
		t=t->next;//下一项（遍历）
	}
	if(t->status==1&&Check_UnREP(t,prime_implicant,n))
	{
		prime_implicant[num_prime_implicant]=t;
		num_prime_implicant++;
	}
}

void QM(Term**t_head,Term**t_current,Term**prime_implicant,int n)
{
	bool flag=0;
	while(flag==0)//表示存在非本原蕴含项，仍要进行合并
	{
		flag=1;
		for(int i=0;i<=n;i++)//所有链表头指针指向下一链表
		{
			t_current[i]=t_head[i];
			t_head[i]=NULL;
		}
		for(int i=0;i<n;i++)
		{
			if(t_current[i]==NULL) 
				continue;//指针为空，不存在项
			if(t_current[i+1]==NULL)
			{
				 Check_prime_implicant(t_current[i],prime_implicant,n);//检查是否为本原蕴含项
				 continue;
			}
			while(t_current[i]->next!=NULL)//比较每一项是否为本原蕴含项
			{
				if(Compare_Term(t_current[i],t_current[i+1],t_head[i],prime_implicant,n)==0)//不存在能够合并的项
					flag=0;
				t_current[i]=t_current[i]->next;//遍历
			}
			if(Compare_Term(t_current[i],t_current[i+1],t_head[i],prime_implicant,n)==0)//不存在能够合并的项
				flag=0;
		}
	}
}

void CreateMatrix(bool**minimum,Term*prime_implicant,int *num_m,int m,int n,int row)//将所有本原蕴含项创建成矩阵（本原蕴含图）
{
	int count=0,num_of_ones=1,sum=0,c;//count为“-”的个数，sum为非‘-’元素的和
	for(int i=0;i<n;i++)
	{
		if(prime_implicant->binary[i]==-1) 
			count++;//计数
		else sum+=prime_implicant->binary[i]*Pow(2,i);//转为十进制，sum为非‘-’元素的和
	}
	num_of_ones=Pow(2,count);//表示此合并项合并的最小项或者无关项的总个数
	int *one=new int[num_of_ones];	//记录本原蕴含项所包含的最小项及无关项十进制编号
	int *a=new int[count];//记录‘-’代表的具体数值
	int j=0;
	for(int i=0;i<n;i++)
	{
		if(prime_implicant->binary[i]==-1)
		{
			a[j]=Pow(2,i);
			j++;
		}
	}
	int *help=new int[count];
	for(int i=0;i<num_of_ones;i++)
	{
		c=i;
		one[i]=0;
		for(j=0;j<count;j++)
		{
			one[i]=one[i]+(c%2)*a[j];
			c=c/2;
		}
		one[i]=one[i]+sum;
	}
	for(int i=0;i<num_of_ones;i++)
	{
		for(j=0;j<m;j++)
		{
			if(one[i]==num_m[j]) 
				minimum[row][j]=1;
		}
	}
}
int Matrix_Column(bool**minimum,int column,int &row)
{
	int count=0;
	for(int i=0;i<num_prime_implicant;i++)//本原蕴含项形成矩阵（本原蕴含图）中第column列只有1项
	{
		if(minimum[i][column]==1) 
		{
			count++;
			row=i;
		}
	}
	return(count);
}

void Mini_Cover(bool**minimum,Term**minicover,Term**prime_implicant,int m,int &num)//寻找最小覆盖
{
	int row=0;
	bool *flag=new bool[m];//记录当前的最小项是否被覆盖
	for(int i=0;i<m;i++)//先将所有的最小项全标记为未被覆盖
		flag[i]=0;
	for(int i=0;i<m;i++)
	{
		if(flag[i]==0&&Matrix_Column(minimum,i,row)==1)//在矩阵(本原蕴含图)中，当一列中仅有一个标记出现时，该本原蕴含项就是本质本原蕴含项
		{
			minicover[num]=prime_implicant[row];
			num++;
			for(int j=0;j<m;j++)
			{
				if(minimum[row][j]==1) 
					flag[j]=1;
			}
		}
	}
	for(int i=0;i<m;i++)//当一列中仅有一个标记出现时，该本原蕴含项就是本质本原蕴含项
	{
		if(flag[i]==0)
		{
			Matrix_Column(minimum,i,row);
			minicover[num]=prime_implicant[row];
			num++;
			for(int j=0;j<m;j++)
			{
				if(minimum[row][j]==1)
					flag[j]=1;
			}
		}
	}
	delete flag;
}

void Delete_REP(Term**minicover,Term **mini_com,int *num_m,int m,int n,int num1,int &num2)
{
	bool **min=new bool*[num1];
	for(int i=0;i<num1;i++)
	{
		min[i]=new bool[m];
	}
	for(int i=0;i<num1;i++)//首先将矩阵赋值为0
	{	
		for(int j=0;j<m;j++)
		{
			min[i][j]=0;
		}
	}
	for(int i=0;i<num1;i++)
	{
		CreateMatrix(min,minicover[i],num_m,m,n,i);//使用每一个本原蕴含项来填写矩阵
	}
	bool *flag=new bool[m];//flag用于记录当前的最小项是否已经被覆盖
	for(int i=0;i<num1;i++)
	{
		for(int j=0;j<m;j++)//首先将所有标记置为0
		{
			flag[j]=0;
		}
		for(int k=0;k<num1;k++)
		{
			if(k!=i)
			{
				for(int j=0;j<m;j++)//除去当前考察的项外，用其他项填充一遍矩阵
				{
					if(min[k][j]==1)
						flag[j]=1;
				}
			}
		}
		for(int j=0;j<m;j++)
		{
			if(flag[j]==0) 
			{
				mini_com[num2]=minicover[i];
				num2++;
				break;
			}
		}
	}
}



int main()
{
	int n,m1,m2,b;
	cout<<"请输入自变量数："<<endl;
	cin>>n;
	if(n<=0||n>10)//非法输入处理：要求输入变量小于等于10
	{
		cout<<"输入有误！请输入1~10之间的整数！"<<endl;
		system("pause");
		return 0;
	}
	cout<<"请输入最小项数目："<<endl;
	cin>>m1;
	if(m1<=0||m1>Pow(2,n))//非法输入处理：最小项的最大个数等于2的n次方
	{
		cout<<"输入有误！"<<endl;
		system("pause");
		return 0;
	}
	int *num_m=new int[m1];
	cout<<"请输入最小项编号列表："<<endl;
	for(int i=0;i<m1;i++)
	{
		cin>>num_m[i];
		if(num_m[i]<0||num_m[i]>=Pow(2,n))//非法输入处理：最小项的编号最大为2的n次方-1
		{
			cout<<"输入有误！"<<endl;
			system("pause");
			return 0;
		}
	}
	cout<<"请输入无关项数目："<<endl;
	cin>>m2;
	int *num_d=new int[m2];//建立num_d,num_m数组用于存储无关项和最小项的序数
	if(m2<0||m2>Pow(2,n))//非法输入处理：最小项的最大个数等于2的n次方
	{
		cout<<"输入有误！"<<endl;
		system("pause");
		return 0;
	}
	//当无关项数目为0时，无关项部分不进行操作。
	else if(m2!=0)
	{
		cout<<"请输入无关项编号列表："<<endl;
		for(int i=0;i<m2;i++)
		{
			cin>>num_d[i];
			if(num_d[i]<0||num_d[i]>=Pow(2,n))//非法输入处理：最小项的编号最大为2的n次方-1
			{
				cout<<"输入有误！"<<endl;
				system("pause");
				return 0;
			}
		}
	}
	/*以上为输入和对非法输入的处理部分*/

	int Sum=m1+m2;
	int min_num=0;//用于记录删去重复之后的最小覆盖包含的本质本原蕴含项的个数
	int num_cover=0;//记录最小覆盖含有的项的个数
	Term *init=new Term[Sum];//Term数组init用于存放初始的Term
	Term **prime_implicant=new Term*[Sum];//动态申请Term指针，标记合并结束之后的本原蕴含项
	Term **mincover=new Term*[m1];//动态申请Term指针，标记最小覆盖项
	Term **t_head=new Term*[n+1];//a,b两组指针用于在合并过程中记录具有相同1数目的项目
	Term **t_current=new Term*[n+1];
	SetNULL(t_head,n+1);
	SetNULL(t_current,n+1);
	Term *current;
	for(int i=0;i<m1;i++)//为初始的最小项设置值
	{
		init[i].Newt(n,num_m[i]);
		current=&init[i];
		b=init[i].Get_One();
		Linkterm(b,current,t_head,t_current);
	}
	for(int i=0;i<m2;i++)//为初始的无关项设置值
	{
		init[i+m1].Newt(n,num_d[i]);
		current=&init[i+m1];
		b=init[i+m1].Get_One();
		Linkterm(b,current,t_head,t_current);//将无关项连在最小项之后
	}
	QM(t_head,t_current,prime_implicant,n);//QM算法
	bool **min=new bool*[num_prime_implicant];//构建最小覆盖矩阵,行数为本原蕴含项的个数，列数为最小项的个数，第一行存放最小项序数
	for(int i=0;i<num_prime_implicant;i++)
	{
		min[i]=new bool[m1];
	}
	for(int i=0;i<num_prime_implicant;i++)//首先将矩阵赋值为0
	{	
		for(int j=0;j<m1;j++)
			min[i][j]=0;
	}
	for(int i=0;i<num_prime_implicant;i++)//使用得到的合并项对矩阵进行赋值
		CreateMatrix(min,prime_implicant[i],num_m,m1,n,i);
	Mini_Cover(min,mincover,prime_implicant,m1,num_cover);
	Term  **mini_com=new Term*[num_cover];//用于记录删去重复之后的最小覆盖包含的本质本原蕴含项
	Delete_REP(mincover,mini_com,num_m,m1,n,num_cover,min_num);
	cout<<"根据QM算法化简结果："<<endl;
	for(int i=0;i<min_num;i++)//输出所有本原蕴含项
	{
		cout_binary(mini_com[i],n);
		cout<<" ";
	}
	cout<<endl;
	system("pause");
}
