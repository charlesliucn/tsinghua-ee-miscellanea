#include <iostream>
#include <windows.h>
#include <fstream>
#include <ctime>
#include <queue>
#define counter_num 4  
#define time_cycle 1000
using namespace std;

struct Customer			//Customer结构体，存储顾客的一系列信息
{
	int ID;				//顾客序号
	int time_arrive;	//顾客进入银行的时间
	int time_begin;		//顾客开始服务的时间
	int time_need;		//顾客服务所需的时间
	int time_over;		//顾客服务结束离开银行的时间
	int server_counter; //顾客接受服务的柜台号
};
int Get_Cust_Num()		//从文件中获取顾客的数目
{
	fstream input;						//新建文件流
	input.open("input.txt",ios::in);	//打开"input.txt"文件，准备读入数据
	if(input == 0)						//input == 0时，文件打开失败，提示并退出
	{
		cout<<"Sorry, cannot open the file!"<<endl;
		exit(0);
	}
	int cust_num = 0;					//顾客数目初始化为0
	char str[100];						//设置每行的字符数最大值，以此判断文件的行数
	while(!input.eof())					//文件读完之前
	{
		input.getline(str,sizeof(str));	//每读入一行,将顾客数目增加1
		cust_num++;
	}
	input.close();						//关闭input文件流
	return cust_num;					//返回值为顾客的数量
}
void Input(Customer *cust)				//将文件中的信息存入Customer结构体数组
{
	fstream input;						//新建文件流
	input.open("input.txt",ios::in);	//打开"input.txt"文件，准备读入数据
	if(input == 0)						//input == 0时，文件打开失败，提示并退出
	{
		cout<<"Sorry,cannot open the file!"<<endl;
		exit(0);
	}
	int i = 0;							//结构体index初始化
	while(!input.eof())					//逐行读入顾客到银行服务的相关信息
	{
		//依次为顾客序号，到达银行的时间及需要服务的时间
		input>>cust[i].ID>>cust[i].time_arrive>>cust[i].time_need;
		i++;
	}
	input.close();						//关闭文件流
}
void Output(Customer *cust,int cust_num)//将顾客在银行服务涉及的信息输出
{
	ofstream output;					//输出文件流
	output.open("output.txt",ios::out);	//打开文件，准备写入数据
	for(int i=0;i<cust_num;i++)			//逐个写入各顾客的信息
	{
		//依次为：顾客序号，到达银行时间，开始接受服务时间，服务结束离开银行时间，以及接受服务的柜台号
		output<<cust[i].ID<<" "<<cust[i].time_arrive<<" "<<cust[i].time_begin<<" "
			<<cust[i].time_over<<" "<<cust[i].server_counter<<endl;
	}
	output.close();						//关闭文件流
}

queue <Customer*> WaitingQueue;						//队列，用于放置等待的顾客
HANDLE Sema;										//创建同步信号量的句柄对象
HANDLE mutex = CreateMutex(NULL,FALSE,NULL);		//创建互斥信号量
HANDLE *Service_Over;								//创建句柄对象，用于标志顾客接受服务是否完毕

void CustomerIntoQueue(Customer *cust)				//顾客进入等待队列
{ 
	Customer* cust_in = cust;						//来到银行的某一顾客
	Sleep(time_cycle*(cust_in->time_arrive));		//调整时间到该顾客应该到达的时刻
	//若在指定的时间内mutex互斥信号量被触发，函数返回WAIT_OBJECT_0，表明此时新的顾客进入等待队列
	if(WaitForSingleObject(mutex,INFINITE) == WAIT_OBJECT_0)
	{
		WaitingQueue.push(cust_in);					//顾客的数据信息进入等待队列
		ReleaseSemaphore(Sema,1,NULL);				//V操作，释放信号量，等待的顾客数增加1
		ReleaseMutex(mutex);						//V操作，互斥信号量被释放，表明该顾客进入队列
	}
} 

void CounterCallCustomer(int *counter_ID)			//表示柜台叫号
{ 
	time_t time_base,time_begin;					//获取时间，依次为初始（基准）时间和开始接受服务的时间
	time(&time_base);								//获取程序初始的时间
	int* counter_id = counter_ID;					//获取柜台编号
	while(1)
	{ 
		//如果Sema信号量和mutex互斥信号量同时被触发，即既有等待的顾客，同时柜台又有空闲，即可使用P操作，进行同步
		if(WaitForSingleObject(Sema,INFINITE) ==WAIT_OBJECT_0 && WaitForSingleObject(mutex,INFINITE) == WAIT_OBJECT_0)
		{
			Customer* cust_out=WaitingQueue.front();//被叫到的顾客是最先进入队列，即最先拿号的顾客
			WaitingQueue.pop();						//将被叫号的顾客从队列中pop出
			ReleaseMutex(mutex);					//V操作，取出被叫号的顾客之后，等待队列需要释放互斥信号量
			cust_out->server_counter=*counter_id;	//为该顾客服务的柜台号
			time(&time_begin);						//获取被叫号（开始服务）的时间
			cust_out->time_begin =int(time_begin) - time_base;	//开始服务的时间（相对于基准时间）
			Sleep(time_cycle*cust_out->time_need);	//Sleep直到该顾客服务完成
			cust_out->time_over = cust_out->time_begin + cust_out->time_need;	//顾客服务结束（离开银行）的时间
			SetEvent(Service_Over[cust_out->ID-1]);	//此处设置了一个事件信号，当顾客完成服务之后触发产生信号
		}
	} 
} 

int main()
{
	/**********************************准备工作********************************/
	int counter_ID[counter_num];					//保存柜台号
	for(int i = 0;i < counter_num; i++)				//依次对柜台编号
	{
		counter_ID[i] = i+1;			
	}	
	int cust_num = Get_Cust_Num();					//从文件获取顾客的数目
	Customer *cust = new Customer[cust_num];		//创建顾客结构体数组
	Sema = CreateSemaphore(NULL, 0, cust_num, NULL);//创建最大资源数为顾客总数的信号量，用于同步
	HANDLE *customer_thread = new HANDLE[cust_num];	//每个顾客也作为一个线程
	HANDLE *counter_thread = new HANDLE[counter_num];//每个柜台作为一个线程
	Service_Over = new HANDLE[cust_num];			//每个顾客对应一个句柄对象，服务完成时触发信号

	/****************************顾客在银行服务的过程**************************/
	Input(cust);									//将顾客各类信息导入结构体数组
	for (int i = 0;i<cust_num;i++)
	{
		//为每个顾客创建一个线程，其中第三个参数表示第i个顾客进入银行后的函数(进入等待队列)
		customer_thread[i]=CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(CustomerIntoQueue),&(cust[i]),0,NULL);
		//为每个顾客创建一个事件信号对象，等待该顾客服务完成
		Service_Over[i]=CreateEvent(NULL,FALSE,FALSE,NULL);	
	} 
	for(int i = 0;i < counter_num;i++)	
	{
		//为每个柜台创建一个进程，其中，第三个参数表示该柜台叫号的过程（空闲时检测等待队列，等待队列信信号量大于1时叫号）
		counter_thread[i] = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(CounterCallCustomer),&(counter_ID[i]),0,NULL);
	}	
	WaitForMultipleObjects(cust_num,customer_thread,TRUE,INFINITE);	//等待多线程全部完成
	WaitForMultipleObjects(cust_num,Service_Over,TRUE,INFINITE);	//等待每个顾客服务完毕后的事件信号
	Output(cust,cust_num);							//输出各顾客接受服务的相关信息
	cout<<"请打开与input.txt文件同一目录下的output.txt文件查看输出结果"<<endl;

	/**********************************收尾工作******************************/
	//清空动态数组及信号量
	delete cust;							
	delete customer_thread;
	delete counter_thread;
	delete Service_Over;
	CloseHandle(Sema);
	CloseHandle(mutex);
} 