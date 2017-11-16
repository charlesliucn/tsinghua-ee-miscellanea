#include <iostream>
#include <windows.h>
using namespace std;

DWORD num_of_bytes = sizeof(int);   //ReadFile和WriteFile函数中的参数，表示要读取或写入的字节数。
HANDLE HREAD_fF;					//f和F之间的管道读句柄
HANDLE HWRITE_fF;					//f和F之间的管道写句柄
HANDLE HREAD_gF;					//g和F之间的管道读句柄
HANDLE HWRITE_gF;					//g和F之间的管道写句柄

//f函数(功能是计算阶乘）
int Func_f(int m)
{
	if( m == 1 )
		return 1;
	else return ( m*Func_f(m-1) );
}
//g函数(斐波那契数列)
int Func_g(int n)
{
	if( n ==1 || n ==2 )
		return 1;
	else return (Func_g(n-1) + Func_g(n-2));
}

//f函数与F函数之间有1个管道
//对f来说，f向F传递数据相当于向管道写入数据;f从F得到数据相当于从管道读入数据
void WINAPI f_PIPE_RW(PVOID pvParam)	//实现f函数从管道读取和向管道写入数据
{
	DWORD read_dword,write_dword;			//返回实际读取或写入的字节数
	int para_m;							//管道内的数据，即为参数m
	while(!ReadFile(HREAD_fF,&para_m,num_of_bytes,&read_dword,NULL));	//从管道中读取参数m，使用while表示等待数据直到成功读入
	int f_result = Func_f(para_m);		//对读取的参数m使用f函数，得到结果
	while(!WriteFile(HWRITE_fF,&f_result,num_of_bytes,&write_dword,NULL)); //将f函数的结果写入管道，使用while表示直到成功写入
}

//同样，g函数与F函数之间有1个管道
//对g来说，g向F传递数据相当于向管道写入数据;g从F得到数据相当于从管道读入数据
void WINAPI g_PIPE_RW(PVOID pvParam)	//实现g函数从管道读取和向管道写入数据
{
	DWORD read_dword,write_dword;		//返回实际读取或写入的字节数
	int para_n;							//管道内的数据,即为参数n
	while(!ReadFile(HREAD_gF,&para_n,num_of_bytes,&read_dword,NULL));	//从管道中读取参数n，使用while表示等待数据直到成功读入
	int g_result = Func_g(para_n);		//对读取的参数n使用g函数，得到结果
	while(!WriteFile(HWRITE_gF,&g_result,num_of_bytes,&write_dword,NULL));//将g函数的结果写入管道，使用while表示直到成功写入
}

//对F来说，F向f传递数据相当于向管道写入数据;F从f得到数据相当于从管道读入数据(此处管道指f和F之间的管道)
//对F来说，F向g传递数据相当于向管道写入数据;F从g得到数据相当于从管道读入数据(此处管道指g和F之间的管道)
void WINAPI F_PIPE_RW(PVOID pvParam)	//实现F函数从两个管道中读取数据，以及向两个管道写入数据	
{
	int *para = (int*)pvParam;			//参数对应m和n，即F函数要写入管道的数据
	//安全性参数设置
	SECURITY_ATTRIBUTES safF,sagF;		//对应于两个管道的安全性
	//安全性的参数设置,建立f和F之间的管道
	safF.nLength = sizeof(SECURITY_ATTRIBUTES);	
	safF.lpSecurityDescriptor = NULL;
	safF.bInheritHandle = TRUE;
	CreatePipe(&HREAD_fF,&HWRITE_fF,&safF,0);
	//安全性的参数设置,建立g和F之间的管道
	sagF.nLength = sizeof(SECURITY_ATTRIBUTES);
	sagF.lpSecurityDescriptor = NULL;
	sagF.bInheritHandle = TRUE;
	CreatePipe(&HREAD_gF,&HWRITE_gF,&sagF,0);

	//将输入的两个参数写入管道
	int m = para[0];
	int n = para[1];
	DWORD dword_fF,dword_gF;			//返回实际读入的字节数
	while(!WriteFile(HWRITE_fF,&m,num_of_bytes,&dword_fF,NULL));//F函数向管道写入f函数的参数m
	while(!WriteFile(HWRITE_gF,&n,num_of_bytes,&dword_gF,NULL));//F函数向管道写入g函数的参数n
	HANDLE f_thread = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(f_PIPE_RW),NULL,0,NULL);//建立f函数读写的线程
	HANDLE g_thread = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(g_PIPE_RW),NULL,0,NULL);//建立g函数读写的线程
	WaitForSingleObject(f_thread,INFINITE);//f_thread线程结束时，已经将f(m)的值写入管道
	WaitForSingleObject(g_thread,INFINITE);//g_thread线程结束时，已经将g(n)的值写入管道

	int f_result,g_result;	//分别表示f函数和g函数的返回值
	while(!ReadFile(HREAD_fF,&f_result,num_of_bytes,&dword_fF,NULL));	//F函数从管道中读取f函数的返回值
	while(!ReadFile(HREAD_gF,&g_result,num_of_bytes,&dword_gF,NULL));	//F函数从管道中读取g函数的返回值

	int F_result = f_result + g_result;		//F(m,n)=f(m)+g(n)
	cout<<endl<<"**************输出结果**************"<<endl
		<<"F("<<para[0]<<","<<para[1]<<")="<<F_result<<endl<<endl;		//输出最终的计算结果
	//关闭所有的句柄
	CloseHandle(f_thread);		CloseHandle(g_thread);
	CloseHandle(HREAD_fF);		CloseHandle(HWRITE_fF);
	CloseHandle(HREAD_gF);		CloseHandle(HWRITE_gF);
}

int main() 
{ 
	int para[2];							//函数的参数
	cout<<"********请输入两个自然数m和n********"<<endl;	//输入参数
	cin>>para[0]>>para[1];					//输入两个参数
	if(para[0]<=0 || para[0]<=0)			//判断参数是否合乎要求
	{
		cout<<"Error:输入有误！请输入两个自然数!"<<endl;
		exit(0);
	}
	HANDLE F_thread = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)(F_PIPE_RW),&para,0,NULL);
	WaitForSingleObject(F_thread,INFINITE);	//F函数的线程结束时，已经输出了函数返回值
	CloseHandle(F_thread);					//关闭句柄
	return 0; 
} 