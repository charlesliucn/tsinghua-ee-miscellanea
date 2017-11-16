#include<iostream>
#include<windows.h>
#define OperationNum 6
using namespace std;

//定义全局变量，信号量用于实现同步
HANDLE trac = CreateSemaphore(NULL,0,OperationNum,NULL);	//信号量trac,完成一次内存分配操作后被释放，Tracker线程输出此时的内存信息
HANDLE allo = CreateSemaphore(NULL,0,OperationNum,NULL);	//信号量allo,Tracker输出完内存信息后被释放，Allocator进行下一次内存分配操作
LPVOID Mem_Addr;											//用于存储内存的地址
DWORD PAGE_SIZE;

void WINAPI Tracker(LPVOID lpParam)							//Tracker线程，跟踪内存分配后的内存状态
{
	SYSTEM_INFO sysinfo;									//系统信息变量
	GetSystemInfo(&sysinfo);								//使用GetSystemInfo获取当前系统信息
	PAGE_SIZE = sysinfo.dwPageSize;							//Windows操作系统的页大小
	//输出当前操作系统的相关信息
	cout<<"System Information:"<<endl<<endl;	
	cout<<"	OEM ID:"<<sysinfo.dwOemId<<endl;				//输出OemId
	cout<<"	Number of Processors:"<<sysinfo.dwNumberOfProcessors<<endl;	//输出逻辑处理器数目
	cout<<"	Page Size:"<<sysinfo.dwPageSize<<endl;						//输出页面大小
	cout<<"	Processor Type:"<<sysinfo.dwProcessorType<<endl;			//输出处理器类型
	cout<<"	Processor Level:"<<sysinfo.wProcessorLevel<<endl;			//输出处理器级别
	cout<<"	Active Processor Mask:"<<sysinfo.dwActiveProcessorMask<<endl;				//输出活跃的处理器(序号)
	cout<<"	Minimum Application Address:"<<sysinfo.lpMinimumApplicationAddress<<endl;	//应用程序范围的最小地址
	cout<<"	Maximum Application Address:"<<sysinfo.lpMaximumApplicationAddress<<endl;	//应用地址范围的最大地址
	cout<<endl<<endl;

	MEMORY_BASIC_INFORMATION meminfo;		//获取内存基本信息
	char *allopro,*protect,*state,*type;	//字符串用于内存状态信息的输出
	for(int  i = 0;i < OperationNum;i++)	//6次内存分配操作
	{
		ReleaseSemaphore(allo,1,NULL);		//释放信号量allo
		if(WaitForSingleObject(trac,INFINITE) == WAIT_OBJECT_0)
		{
			VirtualQuery(Mem_Addr,&meminfo,sizeof(meminfo));		//查询内存信息
			cout<<"	Allocation Base:"<<meminfo.AllocationBase<<endl;//获取指向内存区域基址的指针
			cout<<"	Base Address:"<<meminfo.BaseAddress<<endl;		//内存区域的基址
			cout<<"	Region Size:"<<meminfo.RegionSize<<endl;		//内存区域的大小(字节数)
			switch(meminfo.AllocationProtect)						//将内存分配的保护转为字符串
			{
			case PAGE_EXECUTE:allopro = "EXECUTE";break;
			case PAGE_EXECUTE_READ:allopro = "EXECUTE_READ";break;
			case PAGE_EXECUTE_READWRITE:allopro = "EXECUTE_READWRITE";break;
			case PAGE_EXECUTE_WRITECOPY:allopro = "EXECUTE_WRITECOPY";break;
			case PAGE_GUARD:allopro = "GUARD";break;
			case PAGE_NOACCESS:allopro = "NOACCESS";break;
			case PAGE_NOCACHE:allopro = "NOCACHE";break;
			case PAGE_READONLY:allopro = "READONLY";break;
			case PAGE_READWRITE:allopro = "READWRITE";break;
			case PAGE_WRITECOPY:allopro = "WRITECOPY";break;
			case PAGE_WRITECOMBINE:allopro = "WRITECOMBINE";break;
			default: allopro = "Cannot Access!";
			}
			cout<<"	Allocation Protect:"<<allopro<<endl;			//输出内存分配的保护机制
			switch(meminfo.Protect)									//内存区域对页访问的保护
			{
			case PAGE_EXECUTE:protect = "EXECUTE";break;			
			case PAGE_EXECUTE_READ:protect = "EXECUTE_READ";break;
			case PAGE_EXECUTE_READWRITE:protect = "EXECUTE_READWRITE";break;
			case PAGE_EXECUTE_WRITECOPY:protect = "EXECUTE_WRITECOPY";break;
			case PAGE_GUARD:protect = "GUARD";break;
			case PAGE_NOACCESS:protect = "NOACCESS";break;
			case PAGE_NOCACHE:protect = "NOCACHE";break;
			case PAGE_READONLY:protect = "READONLY";break;
			case PAGE_READWRITE:protect = "READWRITE";break;
			case PAGE_WRITECOPY:protect = "WRITECOPY";break;
			case PAGE_WRITECOMBINE:protect = "WRITECOMBINE";break;
			default: protect = "Cannot Access!";
			}
			cout<<"	Protect:"<<protect<<endl;						//输出内存区域对页访问的保护
			switch(meminfo.State)									//内存区域中页的状态
			{
			case MEM_COMMIT: state = "MEMORY COMMIT";break;
			case MEM_FREE: state = "MEMORY FREE";break;
			case MEM_RESERVE: state = "MEMORY RESERVE";break;
			default: state = "Cannot Access!";
			}
			cout<<"	State:"<<state<<endl;							//输出当前内存区域中页的状态
			switch(meminfo.Type)									//内存区域中页的类型
			{
			case MEM_IMAGE: type = "MEMORY IMAGE";break;
			case MEM_MAPPED:type = "MEMORY MAPPED";break;
			case MEM_PRIVATE:type = "MEMORY PRIVATE";break;
			default:type = "Cannot Access!";
			}
			cout<<"	Type:"<<type<<endl<<endl<<endl;					//输出当前内存区域中的页的类型
		}
	}
}

void WINAPI Allocator(LPVOID lpParam)			//Allocator线程，用于模拟内存分配活动
{
	//保留一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		Mem_Addr = VirtualAlloc(NULL,PAGE_SIZE,MEM_RESERVE,PAGE_READWRITE);	//返回保留内存区域的基址
		if(Mem_Addr == NULL)
			GetLastError();
		else
		{
			cout<<"Memory State After RESERVE:"<<endl<<endl;				//准备输出“保留一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
	}

	//提交一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		Mem_Addr = VirtualAlloc(NULL,PAGE_SIZE,MEM_COMMIT,PAGE_READWRITE);	//返回提交内存区域的基址
		if(Mem_Addr == NULL)
			GetLastError();
		else
		{
			cout<<"Memory State After COMMIT:"<<endl<<endl;					//准备输出“提交一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
	}

	//锁定一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		if(VirtualLock(Mem_Addr,PAGE_SIZE) != 0)							//锁存一个区域成功
		{
			cout<<"Memory State After LOCK:"<<endl<<endl;					//准备输出“锁存一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
		else GetLastError();
	}
	
	//解锁一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		if(VirtualUnlock(Mem_Addr,PAGE_SIZE) != 0)							//解锁一个区域成功
		{
			cout<<"Memory State After UNLOCK:"<<endl<<endl;					//准备输出“解锁一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
		else GetLastError();
	}

	//回收一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		if(	VirtualFree(Mem_Addr,PAGE_SIZE,MEM_DECOMMIT) != 0)				//回收一个区域成功
		{
			cout<<"Memory State After DECOMMIT:"<<endl<<endl;				//准备输出“回收一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
		else GetLastError();

	}

	//释放一个区域
	if(WaitForSingleObject(allo,INFINITE) == WAIT_OBJECT_0)
	{
		if(VirtualFree(Mem_Addr,0,MEM_RELEASE) != 0)						//释放一个区域成功
		{
			cout<<"Memory State After RELEASE:"<<endl<<endl;				//准备输出“释放一个区域”后的内存信息
			ReleaseSemaphore(trac,1,NULL);									//释放信号量trac,通知Tracker进程开始输出内存信息
		}
		else GetLastError();
	}
}

int main()
{
	HANDLE allohandle = CreateThread(NULL,0,LPTHREAD_START_ROUTINE(Allocator),NULL,0,NULL);	//创建Allocator线程
	HANDLE trachandle = CreateThread(NULL,0,LPTHREAD_START_ROUTINE(Tracker),NULL,0,NULL);	//创建Tracker线程
	WaitForSingleObject(trachandle,INFINITE);				//等待所有信息输出完毕，程序即可结束
	CloseHandle(allohandle);	CloseHandle(trachandle);	//关闭两个线程句柄
	return 0;
}

