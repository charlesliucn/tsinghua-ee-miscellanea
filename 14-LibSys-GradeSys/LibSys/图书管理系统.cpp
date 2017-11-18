//所有功能的实现
#include"Class.h"
using namespace std;
void Start_exe()//登陆界面
{
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
	cout<<"*****************************欢迎使用图书管理系统***************************"<<endl;
	cout<<"***************** 读者登录请输入“R”，管理员登录请输入“M” ***************"<<endl;
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
}
void Start_Reader()//读者登录系统
{
	Manage A;
	A.Login_Reader();
	Manage_Book MB;
	Manage_Reader MR;
	int command;
	cout<<"***************************     欢迎使用图书管理系统  *************************"<<endl;
	cout<<"***************************             菜单          *************************"<<endl;
	cout<<"***************************         1.  查询书籍      *************************"<<endl;
	cout<<"***************************         2.  个人信息      *************************"<<endl;
	cout<<"***************************         3.  借阅书籍      *************************"<<endl;
	cout<<"***************************         4.  归还书籍      *************************"<<endl;
	cout<<"***************************         5.  退出系统      *************************"<<endl;
	cout<<"***请输入您的选项：";
	cin>>command;
	switch(command)
	{
	case 1:
		MB.Search();break;//查询功能
	case 2:
		MR.ShowOneself();	break;//查看个人信息
	case 3:
		MR.Borrow();break;//借书功能
	case 4:
		MR.Return();break;//还书功能
	case 5:
		exit(0);break;
	default:
		system("cls");
		Start_Reader();//重新进入读者登录系统
		cout<<"请重新输入选项："<<endl;
	}
}
void Start_Manage()//管理员登录
{
	Manage A;
	A.Login_Manage();
	Manage_Book MB;
	Manage_Reader MR;
	int command,command2;
	cout<<"***************************          菜单          *************************"<<endl;
	cout<<"***************************         1.图书管理     *************************"<<endl;
	cout<<"***************************         2.读者管理     *************************"<<endl;
	cout<<"****请输入选项：";
	cin>>command;
	if(command==1)//图书管理
	{
		cout<<"***************************  欢迎使用图书管理模块  *************************"<<endl;
		cout<<"***************************            菜单        *************************"<<endl;
		cout<<"***************************          1.查询图书    *************************"<<endl;
		cout<<"***************************          2.添加图书    *************************"<<endl;
		cout<<"***************************          3.删除图书    *************************"<<endl;
		cout<<"***************************          4.全部图书    *************************"<<endl;
		cout<<"***************************       5.清除所有图书   *************************"<<endl;
		cout<<"****请输入选项:";
		cin>>command2;
		if(command2==1)
			MB.Search();//查询功能
		else if(command2==2)
			MB.Add();//增加图书
		else if(command2==3)
			MB.Delete();//删除图书
		else if(command2==4)
			MB.Display();//显示全部书籍
		else if(command2==5)
			MB.All_Clear();//清除全部书籍
		else
		{
			system("cls");
			cout<<"对不起，你的输入有误:"<<endl;
			Start_Manage();
		}
	}
	else if(command=2)//读者（用户管理）
	{
		cout<<"************************** 欢迎使用读者管理模块    *************************"<<endl;
		cout<<"**************************             菜单        *************************"<<endl;
		cout<<"**************************       1.查询读者        *************************"<<endl;
		cout<<"**************************       2.添加读者        *************************"<<endl;
		cout<<"**************************       3.删除读者        *************************"<<endl;
		cout<<"**************************      4.显示全部读者     *************************"<<endl;
		cout<<"**************************      5.清除全部读者     *************************"<<endl;
		cout<<"****请输入选项："<<endl;
		cin>>command2;
		if(command2==1)
			MR.Search();//查询读者
		else if(command2==2)
			MR.Add();//添加读者
		else if(command2==3)
			MR.Delete();//删除读者
		else if(command2==4)
			MR.Display();//显示全部读者
		else if(command2==5)
			MR.All_Clear();//清除全部读者
		else
		{			
			system("cls");
			cout<<"对不起，你的输入有误:"<<endl;
			Start_Manage();//管理员登录
		}
	}
	else 
	{
			system("cls");
			cout<<"对不起，你的输入有误:"<<endl;
			Start_Manage();//管理员登录
	}
}	
int main()
{
	system("color 0B");
	char c;
	Start_exe();//登陆界面
	cout<<"****请输入：";
	cin>>c;	
	if(c=='R'||c=='r')
		Start_Reader();//读者的功能
	else if(c=='M'||c=='m')
		Start_Manage();//管理员的功能
	else
	{
		system("cls");
		main();
		cout<<"对不起您的输入有误！"<<endl;
	}
}