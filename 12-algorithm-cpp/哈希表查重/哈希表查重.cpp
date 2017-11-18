#include<iostream>
#include<cstdlib>
#include<cstring>
#define PARENT(i) (i)/2
#define LEFT(i) 2*(i)+1
#define RIGHT(i) 2*(i+1)
using namespace std;

struct String_Hash//存储序号和Hash值，这样在排序时才不会造成序号的混乱
{
	int order;
	int Hash;
	int Hash2;
	int Hash3;
	int Hash4;
};

int Hash_Int(char *str)
{
     int b = 378551;
     int a = 63689;
	int hash = 0;
    while (*str)
    {
        hash = hash * a + (*str++);
        a *= b;
    }
    return (hash & 0x7FFFFFFF);
}

 int PJWHash(char *str)
{
   int BitsInUnignedInt = (int)(sizeof(int) * 8);
    int ThreeQuarters    = (int)((BitsInUnignedInt  * 3) / 4);
    int OneEighth = ( int)(BitsInUnignedInt / 8);
    int HighBits = (int)(0xFFFFFFFF) << (BitsInUnignedInt - OneEighth);
     int hash    = 0;
    int test    = 0;
    while (*str)
    {
        hash = (hash << OneEighth) + (*str++);
        if ((test = hash & HighBits) != 0)
        {
            hash = ((hash ^ (test >> ThreeQuarters)) & (~HighBits));
        }
    }
    return (hash & 0x7FFFFFFF);
}
//Hash函数
int BKDRHash(char* str)  
{  
	int len=strlen(str);
   int seed = 13131; /* 31 131 1313 13131 131313 etc.. */  
   int hash = 0;  
   int i    = 0;  
   for(i = 0; i < len; str++, i++)  
   {  
      hash = (hash * seed) + (*str);  
   }  
   return (hash & 0x7FFFFFFF);
}  
//Hash2函数
int ELFHash(char* str)  
{  
	int len=strlen(str);
   int hash = 0;  
   int x  = 0;  
   int i   = 0;  
   for(i = 0; i < len; str++, i++)  
   {  
      hash = (hash << 4) + (*str);  
      if((x = hash & 0xF0000000L) != 0)  
      {  
         hash ^= (x >> 24);  
      }  
      hash &= ~x;  
   }  
   return (hash & 0x7FFFFFFF);
}  

struct LNode
{
	 int data;
	 struct LNode * next;
};
typedef struct LNode *LinkList;

void InitList(LinkList &L)
{
	L=NULL;
}

void HeadInsert(LinkList &L,int n,int *a)
{
	LinkList p;
	L=new LNode;
	L=NULL;
	for(int i=0;i<n;i++)
	{
		p=new LNode;
		p->data=a[i];
		if(L!=NULL)
			p->next=L;
		else p->next=NULL;
		L=p;
	}
}

void ListTraverse(LinkList &L)
{
	LinkList p=L;
	 while(p != NULL)
	 {
		 cout<<p->data<<" ";
		 p = p->next;
	 }
	cout<<endl;
}

void HeapSort(String_Hash *String ,int size);
void BuildHeap(String_Hash *String ,int size);
void PercolateDown(String_Hash *String , int index,int size);
void Swap(String_Hash *String , int v, int u);
void HeapSort2(int *a ,int size);
void BuildHeap2(int *a ,int size);
void PercolateDown2(int *a, int index,int size);
void Swap2(int *a , int v, int u);

 void HeapSort2(int *a ,int size)
{
    int i;
    int iLength=size;
    BuildHeap2(a,size);// 建立小顶堆   
    for (i = iLength - 1; i >= 1; i--) {   
        Swap2(a, 0, i);// 交换   
        size--;// 每交换一次让规模减少一次   
        PercolateDown2(a, 0,size);// 将新的首元素下滤操作 
    }
}

void BuildHeap2(int *a ,int size) 
{ 
    int i; 
    for (i = size / 2 - 1; i >= 0; i--) {// 对前一半的节点（解释为“从最后一个非叶子节点开始，将每个父节点都调整为最小堆”更合理一些）   
        PercolateDown2(a, i,size);// 进行下滤操作
    }   
}   
void PercolateDown2(int *a, int index,int size)
{   
    int min;// 设置最小指向下标   
    while (index * 2 + 1<size) 
	{	// 如果该数有左节点，则假设左节点最小   
        min = index * 2 + 1;// 获取左节点的下标   
        if (index * 2 + 2<size) 
		{// 如果该数还有右节点   
            if (a[min]> a[index * 2 + 2]) {// 就和左节点分出最小者   
                min = index * 2 + 2;// 此时右节点更小，则更新min的指向下标   
            }   
        }   
        // 此时进行该数和最小者进行比较，   
        if (a[index] < a[min]) 
		{// 如果index最小，   
            break;// 停止下滤操作   
        } 
		else 
		{   
            Swap2(a, index, min);// 交换两个数，让大数往下沉   
            index = min;// 更新index的指向   
        }   
    }// while   
}
void Swap2(int *a , int v, int u)
{  
    int temp =a[v];   
    a[v]=a[u];   
    a[u]=temp;  
}   

void HeapSort(String_Hash *String ,int size)
{
    int i;
    int iLength=size;
    BuildHeap(String,size);// 建立小顶堆   
    for (i = iLength - 1; i >= 1; i--) {   
        Swap(String, 0, i);// 交换   
        size--;// 每交换一次让规模减少一次   
        PercolateDown(String, 0,size);// 将新的首元素下滤操作 
    }
}

void BuildHeap(String_Hash *String ,int size) { 
    int i; 
    for (i = size / 2 - 1; i >= 0; i--) {// 对前一半的节点（解释为“从最后一个非叶子节点开始，将每个父节点都调整为最小堆”更合理一些）   
        PercolateDown(String, i,size);// 进行下滤操作
    }   
}   
void PercolateDown(String_Hash *String , int index,int size)
{   
    int min;// 设置最小指向下标   
    while (index * 2 + 1<size) 
	{// 如果该数有左节点，则假设左节点最小   
        min = index * 2 + 1;// 获取左节点的下标   
        if (index * 2 + 2<size) 
		{// 如果该数还有右节点   
            if (String[min].Hash > String[index * 2 + 2].Hash) {// 就和左节点分出最小者   
                min = index * 2 + 2;// 此时右节点更小，则更新min的指向下标   
            }   
        }   
        // 此时进行该数和最小者进行比较，   
        if (String[index].Hash < String[min].Hash) 
		{// 如果index最小，   
            break;// 停止下滤操作   
        } else 
		{   
            Swap(String, index, min);// 交换两个数，让大数往下沉   
            index = min;// 更新index的指向   
        }   
    }// while   
}
void Swap(String_Hash *String , int v, int u)
{  
	String_Hash temp;
	temp=String[v];
	String[v]=String[u];
	String[u]=temp;
}   

void MaxHeapAjust3(LinkList *L, int i, int len)            //调整节点i满足最大堆性质
{
    int l = 2*i;
    int r = 2*i+1;
    int largest;
	LinkList tmp;
	if (l <= len &&L[l - 1]->data > L[i - 1]->data)
    {
        largest = l;
    }
    else
    {
        largest = i;
    }
	if (r <= len && L[r - 1]->data> L[largest - 1]->data)
    {
        largest = r;
    }

    if (i != largest)
    {
		tmp = L[i - 1];                        
		L[i - 1]=L[largest - 1];
		L[largest - 1]= tmp;
        MaxHeapAjust3(L, largest, len);
    }
}

void BuildMaxHeap3(LinkList *L, int len)                    //构造最大堆
{
    for (int i = len / 2; i > 0; i--)
    {
        MaxHeapAjust3(L, i, len);
    }
}

void HeapSort3(LinkList *L, int len)                        //堆排序
{
    LinkList tmp;
    BuildMaxHeap3(L, len);
    for (int i = len; i > 1; i--)
    {
		tmp = L[i - 1];
		L[i - 1]= L[0];
		L[0]= tmp;
        MaxHeapAjust3(L, 1, i - 1);
    }
}

int main()
{
	int i,Num,flag=0,k,piece=0;
	cin>>Num;
	String_Hash *String=new String_Hash[Num];
	for(i=0;i<Num;i++)
	{
		String[i].order=i;
		char *temp=new char[1000000];
		cin>>temp;
		String[i].Hash=BKDRHash(temp);
		String[i].Hash2=ELFHash(temp);
		String[i].Hash3=Hash_Int(temp);
		String[i].Hash4=PJWHash(temp);
		delete []temp;
	}
	HeapSort(String ,Num);
	/*for(i=0;i<Num;i++)
		cout<<String[i].order<<" ";
	cout<<endl;
	for(i=0;i<Num;i++)
		cout<<String[i].Hash<<" ";
	cout<<endl;
	for(i=0;i<Num;i++)
		cout<<String[i].Hash2<<" ";
	for(i=0;i<Num;i++)
		cout<<String[i].Hash3<<" ";
	cout<<endl;*/
	LinkList *L=new LinkList[Num];
	for(int s=0;s<Num;s++)
		InitList(L[s]);
//找到每个片区，堆排序，存到链表里，最后得到链表数组，delete原来的String数组.再根据头指针大小堆排序；依次输出即可
	i=1;
	while(i<Num)
	{
		if(String[i-1].Hash!=String[i].Hash||String[i-1].Hash2!=String[i].Hash2||String[i-1].Hash3!=String[i].Hash3||String[i-1].Hash4!=String[i].Hash4)
		{
			flag+=0;
			i++;
		}
		else
		{
			flag=1;
			k=2;
			while(i+k-1<Num)
			{
				if(String[i].Hash==String[i+k-1].Hash&&String[i].Hash2==String[i+k-1].Hash2&&String[i].Hash3==String[i+k-1].Hash3&&String[i].Hash4==String[i+k-1].Hash4)
					k++;
				else break;
			}
			int *m=new int[k];
			for(int f=0;f<k;f++)
				m[f]=String[i+f-1].order;
			HeapSort2(m ,k);
			for(int f=0;f<k;f++)
			{
				HeadInsert(L[piece],k,m);
			}
			delete []m;
			i+=k;
			piece++;
		}
	}
	delete[]String;
	if(flag==0)
		cout<<-1;
	HeapSort3(L,piece);
	for(int l=0;l<piece;l++)
			ListTraverse(L[l]);
}