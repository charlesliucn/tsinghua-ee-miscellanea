
//学生成绩管理系统.cpp
#include"Class.h"
using namespace std;
void Student_Continue()
{
	int command;Teacher T;
	cout<<"请输入您要执行的操作序号"<<endl;
	cin>>command;
	switch(command)
	{
	case 1:
		T.Search_Student();break;
	case 2:
		T.Sort_Teacher();break;
	case 3:
		exit(0);break;
	default:
		cout<<"对不起，您的输入有误！"<<endl;
	}
	Student_Continue();
}
void Start_Student()
{
	Manage MA;
	MA.Login_Student();
	cout<<"*********************     欢迎使用学生成绩管理系统    *********************"<<endl;
	cout<<"*********************              菜 单             *********************"<<endl;
	cout<<"*********************          1.查询个人成绩         *********************"<<endl;
	cout<<"*********************          2.学生成绩排序         *********************"<<endl;
	cout<<"*********************          3.退出   系统         *********************"<<endl;
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
	Student_Continue();	
}
void Continue_Teacher()
{
	Teacher T;
	int command;
	cout<<"请输入您要执行的操作序号"<<endl;
	cin>>command;
	switch(command)
	{
	case 1:
		T.In_Student_File();
		T.Add();
		break;
	case 2:
		int number;
		T.In_Student_File();
		cout<<"您需要删除多少名同学？"<<"请输入数字"<<endl;
		cin>>number;
		if(number>T.GetNum())
			cout<<"对不起！系统中现在只存入了"<<T.GetNum()<<"位学生的信息及成绩"<<endl;
		else 
		{
			for(int i=0;i<number;i++)
				T.Delete();
		}	
		break;
	case 3:
		cout<<"******【注意不允许批量修改】*****"<<endl;
		T.Change();break;
	case 4:
		T.Search_Teacher();break;
	case 5:
		T.Sort_Teacher();break;
	case 6:
		T.In_File_Data();break;
	case 7:
		T.All_Student_Display();break;
	case 8:
		cout<<"平均成绩为:"<<T.GetAverage()<<endl;	break;
	case 9:
		exit(0);break;
	default:cout<<"对不起，您的输入有误！"<<endl;
	}
	Continue_Teacher();
}
void Start_Teacher()
{
	Director A;
	A.Login_Teacher();
	cout<<"*********************     欢迎使用学生成绩管理系统    *********************"<<endl;
	cout<<"*********************             菜 单              *********************"<<endl;
	cout<<"*********************         1.添加学生成绩          *********************"<<endl;
	cout<<"*********************         2.删除学生成绩          *********************"<<endl;
	cout<<"*********************         3.修改学生成绩          *********************"<<endl;
	cout<<"*********************         4.查询学生成绩          *********************"<<endl;
	cout<<"*********************         5.学生成绩排序          *********************"<<endl;
	cout<<"*********************         6.导入外部文件          *********************"<<endl;
	cout<<"*********************         7.显示所有成绩          *********************"<<endl;
	cout<<"*********************         8.显示平均成绩          *********************"<<endl;
	cout<<"*********************         9.退出   系统          *********************"<<endl;
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
	Continue_Teacher();
}
int main()
{
	system("color 0E");
	char c;
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
	cout<<"**********************        学生成绩管理系统      ***********************"<<endl;
	cout<<"**********************          欢迎您的使用        ***********************"<<endl;
	for(int i=0;i<76;i++)
		cout<<"*";
	cout<<endl;
	cout<<"*********  请问您的身份是学生，还是教师？学生请输入S，教师请输入T  *********"<<endl;
	cout<<"请输入："<<endl;
	cin>>c;
	if(c=='S'||c=='s')
	{
		system("cls");
		Start_Student();
	}
	else if(c=='T'||c=='t')
	{	
		system("cls");
		Start_Teacher();
	}
	else
	{
		system("cls");
		cout<<"对不起输入有误！"<<endl;
		main();
	}
}
