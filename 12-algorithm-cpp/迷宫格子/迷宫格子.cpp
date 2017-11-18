#include<iostream>
#define INF 2147483647
using namespace std;

int length=0,NodeNum,begin;
class Graph
{
public://公有成员，供main访问
	int *Position,*func,*weight,*heap;//保存权值及寻找最短路径的堆
	bool *visited;//保存每个顶点是否被遍历的bool型
	Graph();//构造函数
	~Graph();//析构函数
	void Weight_Swap(int l);//交换权值
	void heapAdd(int l,int price);//向堆中增加
	int heapOut();//从堆中取出
};

Graph::Graph()//构造函数，动态申请数组
{
	heap=new int[NodeNum+1];
	visited=new bool[NodeNum+1];
	visited[0]=true;
	Position=new int[NodeNum+1];
	Position[0]=0;
	func=new int[NodeNum+1];
	func[0]=0;
	weight=new int[NodeNum+1];
	weight[0]=0;
}
Graph::~Graph()//析构函数，释放动态内存
{
	delete []heap;
	delete []visited;
	delete []Position;
	delete []func;
	delete []weight;
}

void Graph::Weight_Swap(int l)//交换权值
{
	int vec=l;
	bool flag=true;
	int swap,min;
	while(vec/2>=1&&flag)
	{
		if(heap[vec/2]>heap[vec])
		{
			swap=heap[vec/2];//交换权值
			heap[vec/2]=heap[vec];
			heap[vec]=swap;
			swap=func[Position[vec]];//交换Position到heap
			func[Position[vec]]=func[Position[vec/2]];
			func[Position[vec/2]]=swap;
			swap=Position[vec/2];//交换heap到Position
			Position[vec/2]=Position[vec];
			Position[vec]=swap;
			vec=vec/2;
			flag=true;
		}
		else flag=false;
	}
	flag=true;
	while(vec*2<=length&&flag)
	{
		min=vec*2;
		if(min+1<=length&&heap[min+1]<heap[min]) 
			min++;
		if(heap[vec]>heap[min])
		{
			swap=heap[min];//交换权值
			heap[min]=heap[vec];
			heap[vec]=swap;
			swap=func[Position[vec]];//交换Positionition->heap
			func[Position[vec]]=func[Position[min]];
			func[Position[min]]=swap;
			swap=Position[min];//交换heap->Positionition
			Position[min]=Position[vec];
			Position[vec]=swap;
			vec=min;
			flag=true;
		}
		else flag=false;
	}
}
void  Graph::heapAdd(int l,int price)
{  
	Position[length]=l;
	func[l]=length;
	Weight_Swap(length);
	length++;
	heap[length]=price;
}
int Graph::heapOut()
{
	int vec;
	begin=Position[1];
	visited[begin]=true;
	vec=heap[1];
	heap[1]=heap[length];
	func[Position[length]]=1;
	Position[1]=Position[length];
	length--;
	Weight_Swap(1);
	return vec;//return min weight
}
int main()
{
	int vec,end,price,Num,edge,i=1;
	bool flag=true;
	cin>>Num;
	edge=Num;
	NodeNum=Num*Num;
	cin>>begin;
	cin>>end;
	Graph G;
	for(i=1;i<=NodeNum;i++)//从输到NodeNum，存储所有点的序号
	{
		G.visited[i]=false;
		G.func[i]=i;
		G.Position[i]=i;
	}
	for(i=1;i<=NodeNum;i++)//将每个点对周围各点的权值存入数组
	{
		cin>>vec;
		if(vec>0) 
			G.weight[i]=vec;//权值＞，正常读入
		else if(vec==0)//权值为，要另外读入一个数值，该数值表示可以跳跃到的顶点
		{
			cin>>vec;
			G.weight[i]=(-1)*vec;
		}
		else G.weight[i]=0;//其他情况即为vec=-1，则表示该格子内是墙，无法通过
	}
	length=NodeNum;
	if(G.weight[end]==0) //输入的终点的权值为，表示该点是墙，无法达到
		cout<<INF;//输出最大值
	else G.weight[end]=0;//当终点权值不为，置为0
	for(int i=1;i<=begin-1;i++)//除了起始点之外，其余各点置为0
		G.heap[i]=INF;
	for(int i=begin+1;i<=NodeNum;i++)
		G.heap[i]=INF;
	if(G.func[begin]==0) G.heap[begin]=0;//起始点是能跳跃的点
	else G.heap[begin]=G.weight[begin];//堆里存的也是起始点权值
	G.Weight_Swap(begin);
	while(length)
	{
		price=G.heapOut();
		//根据起点的不同位置，分类讨论（分类依据是：该顶点周围有几个邻接的顶点）
		if(begin==end)//源点与终点相同
		{
			cout<<price;
			return 0;
		}
		if(G.weight[begin]<0&&!G.visited[-1*G.weight[begin]])
		{
			if(G.weight[(-1)*G.weight[begin]]<0&&price<G.heap[G.func[(-1)*G.weight[begin]]]) 
			{
				G.heap[G.func[(-1)*G.weight[begin]]]=price;
				G.Weight_Swap(G.func[(-1)*G.weight[begin]]);
			}
			else if((G.weight[(-1)*G.weight[begin]]>0||(-1)*G.weight[begin]==end)&&price+G.weight[(-1)*G.weight[begin]]<G.heap[G.func[(-1)*G.weight[begin]]])
			{
					G.heap[G.func[(-1)*G.weight[begin]]]=price+G.weight[(-1)*G.weight[begin]];
					G.Weight_Swap(G.func[(-1)*G.weight[begin]]);
			}
		}
		if(begin%edge!=1&&!G.visited[begin-1])
		{
			if((G.weight[begin-1]>0||begin-1==end)&&G.weight[begin-1]+price<G.heap[G.func[begin-1]])
			{
				G.heap[G.func[begin-1]]=G.weight[begin-1]+price;
				G.Weight_Swap(G.func[begin-1]);
			}
			else if(G.weight[begin-1]<0&&price<G.heap[G.func[begin-1]])
			{
				G.heap[G.func[begin-1]]=price;
				G.Weight_Swap(G.func[begin-1]);
			}
		}
		if(begin%edge!=0&&!G.visited[begin+1])
		{
			if((G.weight[begin+1]>0||begin+1==end)&&G.weight[begin+1]+price<G.heap[G.func[begin+1]])
			{
				G.heap[G.func[begin+1]]=G.weight[begin+1]+price;
				G.Weight_Swap(G.func[begin+1]);
			}
			else if(G.weight[begin+1]<0&&price<G.heap[G.func[begin+1]])
			{
					G.heap[G.func[begin+1]]=price;
					G.Weight_Swap(G.func[begin+1]);
			}
		}
		if(begin-edge>0&&!G.visited[begin-edge])
		{
			if((G.weight[begin-edge]>0||begin-edge==end)&&G.weight[begin-edge]+price<G.heap[G.func[begin-edge]])
			{
					G.heap[G.func[begin-edge]]=G.weight[begin-edge]+price;
					G.Weight_Swap(G.func[begin-edge]);
			}
			else if(G.weight[begin-edge]<0&&price<G.heap[G.func[begin-edge]])
			{
					G.heap[G.func[begin-edge]]=price;
					G.Weight_Swap(G.func[begin-edge]);
			}
		}
		if(begin+edge<=NodeNum&&!G.visited[begin+edge])
		{
			if((G.weight[begin+edge]>0||begin+edge==end)&&G.weight[begin+edge]+price<G.heap[G.func[begin+edge]])
			{
					G.heap[G.func[begin+edge]]=G.weight[begin+edge]+price;
					G.Weight_Swap(G.func[begin+edge]);
			}
			else if(G.weight[begin+edge]<0&&price<G.heap[G.func[begin+edge]])
			{
				G.heap[G.func[begin+edge]]=price;
				G.Weight_Swap(G.func[begin+edge]);
			}
		}
	}
	}