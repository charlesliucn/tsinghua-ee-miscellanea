#include<iostream>
#include<cstdlib>
#include<cstdio>//注意因为要从输入的表达式字符串中一个个读入并进行判断和处理，因而使用getchar()函数比较好，需要兼容C语言的头文件
using namespace std;
struct Expression//存储一个字符，表示表达式链表中的一个结点
{
	char character;//数值域，存储一个字符
	Expression *next;//指针域，指向下一结点
	Expression(char c='0',Expression *n=NULL)//对结点进行初始化
	{
		character=c;
		next=n;
	}
};
struct BiDirect_List//双向链表，存储一个运算的表达式在链表的两端进行元素（字符）插入操作
{
	Expression *Left;//目前表达式最左边结点的指针
	Expression  *Right;//目前表达式最右边结点的指针
	BiDirect_List *Next;//指向下一个运算表达式
	char Operator_Rank;//存储运算符，并且在后面的函数中根据操作符（优先级）的不同添加括号
	BiDirect_List(Expression *L=NULL,Expression *R=NULL,char operator_rank='0',BiDirect_List *N=NULL)//对双向链表进行初始化
	{
		Left=L;
		Right=R;
		Next=N;
		Operator_Rank=operator_rank;
	}
};
void Add_Left(struct BiDirect_List *BL,char c)//在现有表达式的左边添加一个字符
{
	if(BL->Left==NULL)//该开始链表左指针为空时，给左指针指向的结点存入新字符
	{
		BL->Left=new Expression;//申请结点的内存空间
		BL->Right=BL->Left;//右指针和左指针指向同一结点
		BL->Left->character=c;//给左指针指向结点的数值域赋值（字符）
	}
	else//当双向链表不为空时，使双向链表向左延伸
	{
		Expression *temp=BL->Left;
		BL->Left=new Expression;//申请结点的内存空间
		BL->Left->character=c;
		BL->Left->next=temp;
	}//实质是将左指针指向左侧申请的结点，原来结点存入新字符
}
void Add_Right(struct BiDirect_List *BL,char c)//在现有表达式的右边添加一个字符
{
	if(BL->Right==NULL)
	{
		BL->Left=new Expression;//申请结点的内存空间
		BL->Right=BL->Left;//右指针和左指针指向同一结点
		BL->Left->character=c;//给左指针指向结点的数值域赋值（字符）
	}
	else
	{
		Expression *temp=BL->Right;
		BL->Right=new Expression;//申请结点的内存空间
		BL->Right->character=c;
		temp->next=BL->Right;
	}//实质是将右指针指向左侧申请的结点，原来结点存入新字符
}
void print(struct BiDirect_List *BL)//按顺序输出链表中的所有字符
{
	Expression *temp=BL->Left;//从双向链表最左端输出
	while(temp!=NULL)
	{
		cout<<temp->character;//输出链表中的字符
		temp=temp->next;//指向下一字符
	}
}

struct All_List//存储整个完整的表达式
{
	BiDirect_List *head;//头指针
	All_List(BiDirect_List *h=NULL)//对All_List进行初始化
	{
		head=h;
	}
};
void In_Operator(struct All_List *AL,char c)//加一个操作数到链表顶
{
	if(AL->head==NULL)
	{
		AL->head=new BiDirect_List;//完整的链表为空时，申请一个（小表达式）结点
		Add_Right(AL->head,c);
	} 
	else
	{
		BiDirect_List *temp=new BiDirect_List;
		Add_Left(temp,c);
		temp->Next=AL->head;
		AL->head=temp;
	}
}
void Out_Operand(struct All_List *AL,char c)//取链表靠前的两个操作数对运算符c进行运算，如果c是阶乘就只取一个
{
	if(c=='!') 
	{
		if(AL->head->Operator_Rank=='0'||AL->head->Operator_Rank=='!') 
			Add_Right(AL->head,c);
		else 
		{
			Add_Left(AL->head,'(');
			Add_Right(AL->head,')');
			Add_Right(AL->head,c);
		}
		AL->head->Operator_Rank=c;
	}
	else if(c=='+'||c=='-')
	{
		if(AL->head->Operator_Rank=='+'||AL->head->Operator_Rank=='-') 
		{
			Add_Left(AL->head,'(');
			Add_Right(AL->head,')');}
			BiDirect_List *temp=AL->head;
			Add_Right(AL->head->Next,c);
			AL->head->Next->Right->next=AL->head->Left;
			AL->head->Next->Right=AL->head->Right;
			AL->head=AL->head->Next;
			AL->head->Operator_Rank=c;
			delete []temp;
		}
		else
		{
			if(AL->head->Operator_Rank!='0'&&AL->head->Operator_Rank!='!') 
			{
				Add_Left(AL->head,'(');
				Add_Right(AL->head,')');
			}
			if(AL->head->Next->Operator_Rank=='+'||AL->head->Next->Operator_Rank=='-')
			{
				Add_Left(AL->head->Next,'(');
				Add_Right(AL->head->Next,')');
			}
			BiDirect_List *temp=AL->head;
			Add_Right(AL->head->Next,c);
			AL->head->Next->Right->next=AL->head->Left;
			AL->head->Next->Right=AL->head->Right;
			AL->head=AL->head->Next;
			AL->head->Operator_Rank=c;
			delete []temp;
	}
}
int main()
{
	char c;
	All_List al, *AL;
	AL=&al;
	c=getchar();
	while((c>='a'&&c<='z')||c=='+'||c=='-'||c=='*'||c=='/'||c=='!')
	{
		if(c>='a'&&c<='z') 
			In_Operator(AL,c);
		else 
			Out_Operand(AL,c);
	    c=getchar();
	}
	print(AL->head);
}