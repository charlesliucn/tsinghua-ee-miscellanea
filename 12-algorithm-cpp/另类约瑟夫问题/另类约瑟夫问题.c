/*另类约瑟夫问题*/
#include<stdio.h>
#include<stdlib.h>
struct Node//构建结构体，每一个结构体包括数值域和指针域，共同表示链表中的一个结点
{
    int data;//存储数字
    struct Node *next;
};
void ex_Josephus(int All,int Start_Num,int Length)//All为总数N，Start_Num为起始处，Length为步长
{
    struct Node *pre,*curr,*head=NULL;//先置链表为空
    int i,temp;
    for(i=1;i<=All;i++)//设置所有结点
    {
        curr=(struct Node*)malloc(sizeof(struct Node));//申请一个新的链结点
        curr->data=i;//存放第i个结点的编号i
        if(head==NULL)
            head=curr;//链表为空时，头指针设为当前指针
        else
			pre->next=curr;//链表不为空时，表示当前指针为前面指针的后继指针
		pre=curr;//再将前面的指针改设为当前指针
    }//这实现了单链表的创建，每次都在向后延长。
	curr->next=head;//将头指针设为最后一个结点的后继结点，从而建立一个循环链表
    curr=head;//将当前指针重新移到头指针
    for(i=1;i<Start_Num;i++)//将当前指针移到给定的起始点
    {
        pre=curr;
		curr=curr->next;
    }
	while(curr->next!=curr)//判断条件为链表结点数是否只剩一个
    {
        for(i=1;i<Length;i++)//经过移动，将当前指针移动Length个结点
        {
            pre=curr;
			curr=curr->next;
        }
		temp=curr->data;//temp为第中间变量
		curr->data=pre->data;
		pre->data=temp;
        pre->next=curr->next;//删除掉交换后的第Length个结点
        free(curr);//释放被删除结点的空间
        curr=pre->next;//当前指针指向所删除结点的下一个结点
    }//不断重复操作，直到当前指针指向的结点的后继结点是它本身（即只有一个结点）
    printf("%d",curr->data);//输出最后一个结点的编号
}
void EX_Josephus(int All,int Chosen,int Start_Num,int Length)
{
	struct Node *pre,*curr,*head=NULL;
	struct Node *insert;//设置了一个插入的结点
	int i,k,temp;
	 for(i=1;i<=Chosen;i++)//所形成的链表长度为所选出来的M个
    {
        curr=(struct Node*)malloc(sizeof(struct Node));
        curr->data=i;
        if(head==NULL)
            head=curr;
        else
			pre->next=curr;
        pre=curr;
    }
	 curr->next=head;
	 curr=head;//与之前一样，形成了长度为Chosen(M)的循环链表
	 for(i=1;i<Start_Num;i++)
    {
        pre=curr;
		curr=curr->next;
    }//当前指针移动到设定的起始点
	k=Chosen+1;
	while(k<=All)
	{
		 for(i=1;i<Length+1;i++)
        {
            pre=curr;
			curr=curr->next;
        }//移动了Length+1,将insert插入到pre与curr之间
		 insert=(struct Node*)malloc(sizeof(struct Node));//申请动态内存
		 insert->data=k;//给insert数据域赋值
		 pre->next=insert;
		 insert->next=curr;
		 curr=insert;
		 k++;//进行下一步，下次数据域赋值时加1
	}
	while(curr->next!=curr)//与之前相同的删除操作
    {
        for(i=1;i<Length;i++)
        {
            pre=curr;
			curr=curr->next;
        }//p指向第m个结点,r指向第m-1个结点
		temp=curr->data;
		curr->data=pre->data;
		pre->data=temp;
        pre->next=curr->next;//删除第m个结点
        free(curr);//释放被删除结点的空间
        curr=pre->next;//p指向新的出发结点
    }
    printf("%d",curr->data);//输出最后一个结点的编号
}
main()
{
    int All,Chosen,Start_Num,Length;
    scanf("%d%d%d%d",&All,&Chosen,&Start_Num,&Length);
	if(All==Chosen)
		 ex_Josephus(All,Start_Num,Length);
	else EX_Josephus(All,Chosen,Start_Num,Length);
}