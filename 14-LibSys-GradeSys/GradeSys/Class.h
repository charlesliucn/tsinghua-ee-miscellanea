	
//头文件”Class.h”主要包含了所有的类及其成员函数
#include<iostream>
#include<fstream>//文件流
#include<string>//字符串统一用C++的string类
#include<iomanip>// I/O格式控制
#define calculus_score	5 //设置微积分学分
#define linear_score	4 //设置线性代数学分
#define discrete_score	3 //设置离散数学学分
#define english_score	2 //设置英语学分
#define M 500//默认最大学生人数
#define N 20//默认教师人数
using namespace std;
//Person类作为抽象类
class Person
{
public:
	virtual string GetName()=0;
	virtual int GetID()=0;
};
//School_Member类作为虚基类，公有继承Person类，并派生出Student和Teacher类；
class School_Member: public Person
{
public:
	School_Member(string name,int id);
	School_Member();
	string GetName();//取姓名
	int GetID();//取学号或工作号
 protected:
	string Name;
	int ID;
};
School_Member::School_Member(string name,int id)
{
	Name=name;
	ID=id;
}
School_Member::School_Member()
{
	Name=" ";
	ID=0;
}
string School_Member::GetName()
{
	return Name;
}
int School_Member::GetID()
{
	return ID;
}
//学生类，公有继承虚基类School_Member
class Student:virtual public School_Member
{
public:
	Student(string name,int id,double calculus,double linear,double discrete,double english,int code);
	Student();
	bool IsEmpty();//学生状态函数，true表示学生存在，false表示学生信息为空
	//后面个函数分科修改学生成绩
	void Alter_calculus();//修改微积分成绩
	void Alter_linear();//修改线性代数成绩
	void Alter_discrete();//修改离散数学成绩
	void Alter_english();//修改英语成绩
	int GetCode();//取密码（登录时匹配）
	//后面个函数为了得到学生的各科成绩及GPA
	double GetCalculus();//取微积分成绩
	double GetLinear_algebra();//取线性代数成绩
	double GetDicrete_Math();//取离散数学成绩
	double GetEnglish();//取英语成绩
	double GetGPA();//取GPA，包含GPA计算
	void Delete();	//删除学生信息
	void From_File(string name,int id,double caculus,double linear, 
		double discrete, double english,int code);//从文件导入学生信息及成绩
	//为了满足后面不同函数显示成绩的需要，以下个函数满足显示学生成绩的需要
	void Display_Calculus();//显示微积分成绩函数
	void Display_Linear();//显示线性代数成绩函数
	void Display_Discrete();//显示离散数学成绩函数
	void Display_English();//显示英语成绩函数
	void Display_All();//显示所有成绩及GPA
	friend ostream & operator <<(ostream &out, Student &s);
		//操作符重载，输出学生对象即可输出该生的所有信息及成绩
protected://保护成员
	double Calculus,Linear_algebra,Discrete_math,English;
	int Code;
};
Student::Student(string name,int id,double calculus,double linear,double discrete,double english, int code)
{
	School_Member::School_Member(name,id);
	Calculus=calculus;
	Linear_algebra=linear;
	Discrete_math=discrete;
	English=english;
	Code=code;
}
Student::Student()
{
	School_Member::School_Member();
	Calculus=0.0;
	Linear_algebra=0.0;
	Discrete_math=0.0;
	English=0.0;
	Code=0;
}
bool Student::IsEmpty()
{
	if(ID==0)
		return true;
	else return false;
}
//下面个修改成绩
void Student::Alter_calculus()
{
	cout<<"您现在要执行的操作是：修改学生微积分成绩"<<endl;
	double calculus;
	cout<<"请输入微积分成绩"<<endl;
	cin>>calculus;
	Calculus=calculus;
}
void Student::Alter_linear()
{
	cout<<"您现在要执行的操作是：修改学生线性代数成绩"<<endl;
	double linear;
	cout<<"请输入线性代数成绩"<<endl;
	cin>>linear;
	Linear_algebra=linear;
}
void Student::Alter_discrete()
{
	cout<<"您现在要执行的操作是：修改学生离散数学成绩"<<endl;
	double discrete;
	cout<<"请输入离散数学成绩"<<endl;
	cin>>discrete;
	Discrete_math=discrete;
}
void Student::Alter_english()
{
	cout<<"您现在要执行的操作是：修改学生英语成绩"<<endl;
	double english;
	cout<<"请输入英语成绩"<<endl;
	cin>>english;
	English=english;
}
//获取密码
int Student::GetCode()
{
	return Code;
}
//下面个获取各科成绩
double Student::GetCalculus()
{
	return Calculus;
}
double Student::GetLinear_algebra()
{
	return Linear_algebra;
}
double Student::GetDicrete_Math()
{
	return Discrete_math;
}
double Student::GetEnglish()
{
	return English;
}
//获取GPA（包含了GPA的计算）
double Student::GetGPA()
{
	double sum_grade,sum_score,GPA;
	sum_grade=Calculus*calculus_score+Linear_algebra*linear_score
		+Discrete_math*discrete_score+English*english_score;
	sum_score=calculus_score+linear_score+discrete_score+english_score;
	GPA=sum_grade/sum_score;
	return GPA;
}
void Student::Delete()
{
	Name=" ";
	ID=0;
	Calculus=0.0;
	Linear_algebra=0.0;
	Discrete_math=0.0;
	English=0.0;
}
void Student::From_File(string name, int id, double calculus, double linear, double discrete, double english,int code)
{
	Name=name;
	ID=id;
	Calculus=calculus;
	Linear_algebra=linear;
	Discrete_math=discrete;
	English=english;
	Code=code;
}
//后面个显示学生成绩及GPA
void Student::Display_Calculus()
{
	cout<<setiosflags(ios::left)<<setw(15)<<Name<<setw(12)<<ID<<setw(9)<<Calculus<<endl;
}
void Student::Display_Linear()
{
	cout<<setiosflags(ios::left)<<setw(15)<<Name<<setw(12)<<ID<<setw(9)<<Linear_algebra<<endl;
}
void Student::Display_Discrete()
{
	cout<<setiosflags(ios::left)<<setw(15)<<Name<<setw(12)<<ID<<setw(9)<<Discrete_math<<endl;
}
void Student::Display_English()
{
	cout<<setiosflags(ios::left)<<setw(15)<<Name<<setw(12)<<ID<<setw(9)<<English<<endl;
}
void Student::Display_All()
{
	cout<<setiosflags(ios::left)<<setw(15)<<Name<<setw(12)<<ID<<setw(9)
		<<Calculus<<setw(9)<<Linear_algebra<<setw(9)<<Discrete_math
		<<setw(9)<<English<<setw(9)<<GetGPA()<<endl;
}
ostream & operator << (ostream &out,Student &s)//“<<”操作符重载
{
	cout<<setiosflags(ios::left)<<setw(15)<<s.GetName()<<setw(12)<<s.GetID()<<setw(9)
		<<s.GetCalculus()<<setw(9)<<s.GetLinear_algebra ()<<setw(9)<<s.GetDicrete_Math()
		<<setw(9)<<s.GetEnglish()<<setw(9)<<s.GetGPA()<<endl;
	return out;
}
//教师类公有继承虚基类School_Member
class Teacher: virtual public School_Member
{
public:
	Teacher(string name,int id,string subject,int code);//构造函数
	Teacher();
	int GetCode();//获取密码
	string GetSubject();//获取教师教的学科
	void From_File(string name,int id,string subject,int code);//从文件导入教师信息
	void In_Student_File();//向系统导入默认文件中的学生信息及成绩
	void Add();//增加学生信息及成绩
	void Delete();//删除学生信息及成绩
	void Change();//修改学生信息及成绩
	void Search_Student();//学生界面查询学生成绩	
	void Search_Teacher();//教师界面查询学生成绩	
	void Sort_Teacher();//教师和学生界面内“学生成绩排序”
	double GetAverage();//取各科成绩的平均值
	void A_S_D();//显示系统内所有学生所有科目成绩
	void All_Student_Display();//为了多次调用，将“操作提示”单独作为一个成员函数
	void In_File_Data();//从系统外文件导入学生信息及成绩
	int GetNum();//取系统内存入的学生数目
	friend ostream & operator <<(ostream &out, Teacher &t);//操纵俯重载，输出教师信息
protected:
	Student STU[M];//学生类对象作为Teacher类的成员
	int Num;
	int Code;
	string Subject;
};
Teacher::Teacher(string name,int id,string subject,int code)
{
	School_Member::School_Member(name,id);
	Code=code;
	Subject=subject;
}
Teacher::Teacher()
{
	School_Member::School_Member();
}
int Teacher::GetCode()//取密码
{
	return Code;
}
string Teacher::GetSubject()//取科目
{
	return Subject;
}
void Teacher::From_File(string name,int id,string subject,int code)
{
	Name=name;
	ID=id;
	Subject=subject;
	Code=code;
}
void Teacher::In_Student_File()//导入默认文件内的学生信息
{
	ifstream in_File;
	string name;
	int i=0,id,code;
	double caculus, linear, discrete, english;
	in_File.open("G:\\student.txt",ios::in);
	if(in_File==0)
	{
		cout<<"文件打开失败！"<<endl;
		exit(0);
	}
	else	//从文件将学生信息及成绩逐一导入
	{
		Num=0;
		while(in_File&&!in_File.eof())
		{
			in_File>>name>>id>>caculus>>linear>>discrete>>english>>code;
			STU[i].From_File(name,id,caculus,linear,discrete,english,code);
			Num++;
			i++;
		}
		in_File.close();//关闭文件
	}
}
void Teacher::Add()//增加学生信息及成绩
{
	int i,id;i=Num;
	Student ST;
	string _name;
	double calculus, linear, discrete,english;
	cout<<"********添加学生信息及成绩******"<<endl;
	cout<<"学生成绩管理系统中现已存入"<<i<<"条学生成绩信息"<<endl;
	cout<<"现请输入第"<<i+1<<"条学生成绩信息";
	cout<<"请输入学生姓名："<<endl;	cin>>_name;
	cout<<"请输入学生学号："<<endl;	cin>>id;
	cout<<"请添加微积分成绩："<<endl;	cin>>calculus;
	cout<<"请添加线性代数成绩："<<endl;	cin>>linear;
	cout<<"请添加离散数学成绩："<<endl;	cin>>discrete;
	cout<<"请添加英语成绩："<<endl;	cin>>english;
	ST.From_File(_name,id,calculus,linear,discrete,english,id);
	cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
		<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
	cout<<ST;
	cout<<"信息及成绩添加完毕！"<<endl;
}
void Teacher::Delete()//删除学生信息及成绩
{
	int id,i;
	cout<<"********删除学生信息及其成绩********"<<endl;
	cout<<"请输入您要删除的学生的学号"<<endl;//通过学号删除学生
	cin>>id;
	for(i=0;i<M;i++)
	{
		if(!STU[i].IsEmpty()&&STU[i].GetID()==id)
		{
			STU[i].Delete();
			cout<<"学号为"<<id<<"的学生成绩及个人信息均已删除完毕！"<<endl;
			Num--;
		}
		break;
	}
}
void Teacher::Change()//修改学生信息及成绩
{
	In_Student_File();int i,id;
	cout<<"********更改学生信息********"<<endl;
	cout<<"请输入您要修改的学生的学号"<<endl;
	cin>>id;
	for(i=0;i<Num;i++)
	{
		if(id==STU[i].GetID())
		{
			cout<<"该学号学生原来的成绩是："<<endl;
			cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
				<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
			cout<<STU[i];
			STU[i].Alter_calculus();//修改微积分成绩
			STU[i].Alter_linear();//修改线性代数成绩
			STU[i].Alter_discrete();//修改离散数学成绩
			STU[i].Alter_english();//修改英语成绩
			cout<<STU[i].GetName()<<"的同学的成绩更改完毕！"<<endl;
			cout<<"修改后的信息如下："<<endl;
			cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
			    <<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
			cout<<STU[i];
		}
		break;
	}
	if(i==M)
		cout<<"对不起！您输入的学号有误！请查证！"<<endl;
}
void Teacher::Search_Student()//查询学生成绩（学生和教师界面共用）
{
	int i,command;
	int code;
	In_Student_File();
	cout<<"**************查询个人成绩**************"<<endl;
	cout<<"请再次输入您的密码"<<endl;
	cin>>code;
	cout<<"************************************"<<endl;
	cout<<"1.查询微积分成绩"<<endl;
	cout<<"2.查询线性代数成绩"<<endl;
	cout<<"3.查询离散数学成绩"<<endl;
	cout<<"4.查询英语成绩"<<endl;
	cout<<"5.查看GPA"<<endl;
	cout<<"6.退出"<<endl;
	for(i=0;i<M;i++)
	{
		if(STU[i].GetCode()==code)
		{
			cout<<"请输入您的查询方式"<<endl;
			cin>>command;
			switch(command)
			{
			case 1:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"<<endl;
				STU[i].Display_Calculus();break;
			case 2:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"线性代数"<<endl;
				STU[i].Display_Linear();break;
			case 3:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"离散数学"<<endl;
				STU[i].Display_Discrete();break;
			case 4:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"英语"<<endl;
				STU[i].Display_English();break;
			case 5:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
					<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
				cout<<STU[i];break;
			case 6:exit(0);break;
			default:
				cout<<"对不起！您的输入有误"<<endl;
				system("cls");
				Search_Student();
			}
		}
	}
}
void Teacher::Search_Teacher()//查询学生成绩（学生和教师界面共用）
{
	int i,command;
	int id;
	In_Student_File();
	cout<<"**************查询学生成绩**************"<<endl;
	cout<<"请输入您要查询的学生的学号："<<endl;
	cin>>id;
	cout<<"************************************"<<endl;
	cout<<"1.查询微积分成绩"<<endl;
	cout<<"2.查询线性代数成绩"<<endl;
	cout<<"3.查询离散数学成绩"<<endl;
	cout<<"4.查询英语成绩"<<endl;
	cout<<"5.查看GPA"<<endl;
	cout<<"6.退出"<<endl;
	for(i=0;i<M;i++)
	{
		if(STU[i].GetID()==id)
		{
			cout<<"请输入您的查询方式"<<endl;
			cin>>command;
			switch(command)
			{
			case 1:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"<<endl;
				STU[i].Display_Calculus();break;
			case 2:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"线性代数"<<endl;
				STU[i].Display_Linear();break;
			case 3:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"离散数学"<<endl;
				STU[i].Display_Discrete();break;
			case 4:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"英语"<<endl;
				STU[i].Display_English();break;
			case 5:
				cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
					<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
				cout<<STU[i];break;
			case 6:exit(0);break;
			default:
				cout<<"对不起！您的输入有误"<<endl;
				system("cls");
				Search_Teacher();
			}
		}
	}
}
//【注意】为在一定程度上保护个人隐私，显示排名时不显示姓名，只显示学号
void Teacher::Sort_Teacher()//教师和学生界面内“学生成绩排序功能”
{
	int command;
	Student *Stu[M],*s;//使用指向类的对象的指针，用来成绩的排序
	In_Student_File();//先从文件中导入学生信息及成绩
	for(int z=0;z<Num;z++)//指针指向对象
		Stu[z]=&STU[z];
	cout<<"********学生成绩排名********"<<endl;
	cout<<"请输入您的选项"<<endl;
	cout<<"1.微积分成绩排名"<<endl;
	cout<<"2.线性代数成绩排名"<<endl;
	cout<<"3.离散数学成绩排名"<<endl;
	cout<<"4.英语成绩排名"<<endl;
	cout<<"5.GPA排名"<<endl;
	cout<<"6.退出"<<endl;
	cin>>command;
	if(command==1)//微积分排名
	{
		int i,j,flag;
        for(i=1; i<Num; i++) 
		{
			flag=0; 
            for(j=0;j<Num-i;j++) 
				if(Stu[j]->GetCalculus()<Stu[j+1]->GetCalculus()) 
				{
					s=Stu[j];Stu[j]=Stu[j+1];Stu[j+1]=s;
					flag=1; 
				}
			if(!flag)	break;
		}
		cout<<"按照微积分成绩从高到低排序，结果为："<<endl;
		cout<<setiosflags(ios::left)<<setw(6)<<"排名"<<setw(12)<<"学号"<<setw(9)<<"微积分"<<endl;
		for(i=0;i<Num;i++)
		{
			cout<<setw(6)<<i+1;
			cout<<setw(12)<<Stu[i]->GetID()<<setw(9)<<Stu[i]->GetCalculus()<<endl;
		}
	}
	else if(command==2)//线性代数排名
	{
		int i,j,flag;
        for(i=1; i<Num; i++) 
		{
			flag=0; 
            for(j=0;j<Num-i;j++) 
				if(Stu[j]->GetLinear_algebra()<Stu[j+1]->GetLinear_algebra()) 
				{
					s=Stu[j];Stu[j]=Stu[j+1];Stu[j+1]=s;
					flag=1; 
				}
			if(!flag)	break;
		}
		cout<<"按照线性代数成绩从高到低排序，结果为："<<endl;
		cout<<setiosflags(ios::left)<<setw(6)<<"排名"<<setw(12)<<"学号"<<setw(9)<<"线性代数"<<endl;
		for(i=0;i<Num;i++)
		{
			cout<<setw(6)<<i+1;;
			cout<<setw(12)<<Stu[i]->GetID()<<setw(9)<<Stu[i]->GetLinear_algebra()<<endl;
		}
	}
	else if(command==3)//离散数学排名
	{
		int i,j,flag;
        for(i=1; i<Num; i++) 
		{
			flag=0; 
            for(j=0;j<Num-i;j++) 
				if(Stu[j]->GetDicrete_Math()<Stu[j+1]->GetDicrete_Math())
				{
					s=Stu[j];Stu[j]=Stu[j+1];Stu[j+1]=s;
					flag=1; 
				}
			if(!flag)	break;
		}
		cout<<"按照离散数学成绩从高到低排序，结果为："<<endl;
		cout<<setiosflags(ios::left)<<setw(6)<<"排名"<<setw(12)<<"学号"<<setw(9)<<"离散数学"<<endl;
		for(i=0;i<Num;i++)
		{
			cout<<setw(6)<<i+1;
			cout<<setw(12)<<Stu[i]->GetID()<<setw(9)<<Stu[i]->GetDicrete_Math()<<endl;
		}
	}
	else if(command==4)//英语成绩排名
	{
		int i,j,flag;
        for(i=1; i<Num; i++) 
		{
			flag=0; 
            for(j=0;j<Num-i;j++) 
				if(Stu[j]->GetEnglish()<Stu[j+1]->GetEnglish()) 
				{
					s=Stu[j];Stu[j]=Stu[j+1];Stu[j+1]=s;
					flag=1; 
				}
			if(!flag)	break;
		}
		cout<<"按照英语成绩从高到低排序，结果为："<<endl;
		cout<<setiosflags(ios::left)<<setw(6)<<"排名"<<setw(12)<<"学号"<<setw(9)<<"英语"<<endl;
		for(i=0;i<Num;i++)
		{
			cout<<setw(6)<<i+1;
			cout<<setw(12)<<Stu[i]->GetID()<<setw(9)<<Stu[i]->GetEnglish()<<endl;
		}
	}
	else if(command==5)//GPA排名
	{
		int i,j,flag;
        for(i=1; i<Num; i++) 
		{
			flag=0; 
            for(j=0;j<Num-i;j++) 
				if(Stu[j]->GetGPA()<Stu[j+1]->GetGPA()) 
				{
					s=Stu[j];Stu[j]=Stu[j+1];Stu[j+1]=s;
					flag=1; 
				}
			if(!flag)	break;
		}
		cout<<"按照GPA从高到低排序(显示所有)，结果为："<<endl;
		cout<<setiosflags(ios::left)<<setw(6)<<"排名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
			<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
		for(i=0;i<Num;i++)
		{
			cout<<setw(6)<<i+1;
			cout<<setw(12)<<Stu[i]->GetID()<<setw(9)<<Stu[i]->GetCalculus()<<setw(9)<<Stu[i]->GetLinear_algebra()
				<<setw(9)<<Stu[i]->GetDicrete_Math()<<setw(9)<<Stu[i]->GetEnglish()<<setw(9)<<Stu[i]->GetGPA()<<endl;
		}
	}
	else if(command==6)
		exit(0);
	else cout<<"对不起，您输入有误！"<<endl;
}
double Teacher::GetAverage()//获取学生单科或总GPA的平均成绩
{
	int i,command;
	double sum=0,average;
	In_Student_File();
	cout<<"********学生平均成绩********"<<endl;
	cout<<"请问您想查询哪一门(总分)的平均成绩?"<<endl;
	cout<<"1.微积分"<<endl<<"2.线性代数"<<endl<<"3.离散数学"<<endl<<"4.英语"<<endl<<"5.GPA"<<endl;
	cout<<"请输入：";	cin>>command;
	if(command==1)
	{
		for(i=0;i<Num;i++)
			sum+=STU[i].GetCalculus();
		average=sum/Num;
		return average;//微积分平均成绩
	}
	else if(command==2)
	{
		sum=0.0;
		for(i=0;i<Num;i++)
			sum+=STU[i].GetLinear_algebra();
		average=sum/Num;
		return average;//线性代数平均成绩
	}
	else if(command==3)
	{
		sum=0.0;
		for(i=0;i<Num;i++)
			sum+=STU[i].GetDicrete_Math();
		average=sum/Num;
		return average;//离散数学平均成绩
	}
	else if(command=4)
	{
		sum=0.0;
		for(i=0;i<Num;i++)
			sum+=STU[i].GetEnglish();
		average=sum/Num;
		return average;//英语平均成绩
	}
	else if(command=5)
	{
		sum=0.0;
		for(i=0;i<Num;i++)
			sum+=STU[i].GetGPA();
		average=sum/Num;
		return average;//平均GPA
	}
	else return 0;
}
void Teacher::A_S_D()//显示所有成绩函数的主体
{
	cout<<"请输入您的选项："<<endl;
	int i,command;
	In_Student_File();//导入学生信息及成绩
	cin>>command;
	//包含单科显示和整体显示
	if(command==1)
	{
		cout<<"所有学生信息（包括姓名和学号）如下:"<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<endl;
		for(i=0;i<Num;i++)
			cout<<setiosflags(ios::left)<<setw(12)<<STU[i].GetName()<<setw(9)<<STU[i].GetID()<<endl;
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==2)
	{
		cout<<"所有学生信息及微积分成绩如下："<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"<<endl;
		for(i=0;i<Num;i++)			
			STU[i].Display_Calculus();
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==3)
	{
		cout<<"所有学生信息及线性代数成绩如下："<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"线性代数"<<endl;
		for(i=0;i<Num;i++)
			STU[i].Display_Linear();
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==4)
	{
		cout<<"所有学生信息及离散数学成绩如下："<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"离散数学"<<endl;
		for(i=0;i<Num;i++)			
			STU[i].Display_Discrete();	
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==5)
	{
		cout<<"所有学生信息及英语成绩如下："<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"英语"<<endl;
		for(i=0;i<Num;i++)
		{
			
			STU[i].Display_Linear();
		}
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==6)
	{
		cout<<"所有学生信息及各科成绩如下："<<endl;
		cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(12)<<"学号"<<setw(9)<<"微积分"
				<<setw(9)<<"线性代数"<<setw(9)<<"离散数学"<<setw(9)<<"英语"<<setw(9)<<"GPA"<<endl;
		for(i=0;i<Num;i++)
			cout<<STU[i];		
		for(int i=0;i<50;i++)
		{cout<<"*";}
		cout<<endl;
	}
	else if(command==7)
		exit(0);
	else
	{
		cout<<"请按提示正确输入！"<<endl;
		cin.get();
	}
	A_S_D();//循环调用，避免重新登录系统，提高系统效率
}
void Teacher::All_Student_Display()//显示所有成绩的提示部分
{
	
	cout<<"********显示系统内所有学生成绩********"<<endl;
	cout<<"1.显示所有学生信息（包括姓名和学号）"<<endl;
	cout<<"2.显示所有学生信息及微积分成绩"<<endl;
	cout<<"3.显示所有学生信息及线性代数成绩"<<endl;
	cout<<"4.显示所有学生信息及离散数学成绩"<<endl;
	cout<<"5.显示所有学生信息及英语成绩"<<endl;
	cout<<"6.显示所有学生的各科成绩"<<endl;
	cout<<"7.退出"<<endl;
	A_S_D();
}
void Teacher::In_File_Data()//从外部文件导入学生信息及成绩
{
	ifstream in_File;
	char name[20];
	int i=0,id,code;
	char File_Name[20];
	double calculus, linear, discrete, english;
	cout<<"*******从文件导入学生信息及成绩*******"<<endl;
	cout<<"请输入您要导入的文件地址和文件名"<<endl;
	cin>>File_Name;//输入要导入的文件的准确地址&文件名
	in_File.open(File_Name,ios::out);
	if(in_File==0)
	{
		cout<<"文件打开失败！"<<endl;
		exit(0);
	}
	else
	{
		Num=0;
		cout<<File_Name<<"打开成功，正在从文件导入..."<<endl;
		while(in_File&&!in_File.eof())
		{
			in_File>>name>>id>>calculus>>linear>>discrete>>english>>code;
			STU[i].From_File(name,id,calculus,linear,discrete,english,code);
			cout<<"***第"<<i+1<<"条学生信息及成绩导入成功***"<<endl;
			Num++;
			i++;
		}
		cout<<"本次共导入"<<Num<<"条学生信息"<<endl;
		in_File.close();//关闭文件
	}
}
int Teacher::GetNum()//获取目前系统中学生的数目
{
	return Num;
}
ostream & operator <<(ostream &out, Teacher &t)//操作符重载
{
	cout<<setiosflags(ios::left)<<setw(15)<<t.GetName()<<setw(12)<<t.GetID()<<setw(9)
		<<t.GetSubject()<<endl;
	return out;
}
//Manage派生类，主要负责学生的登录，具体学生功能的实现在Teacher类中已包含
class Manage: virtual public Student,virtual public Teacher
{
public:
	Manage(string name,int ID,double caculus,double linear,double discrete,double english,int code);
	Manage();
	void Login_Student();//学生登录成员函数
};
Manage::Manage(string name,int ID,double caculus,double linear,double discrete,double english,int code)
{
	Student::Student(name,ID,caculus,linear,discrete,english,code);
};

Manage::Manage()
{
	Student::Student();
}

void Manage::Login_Student()
{
	int i,id,code;
	Teacher::In_Student_File();
	cout<<"*********请您先登录系统*********"<<endl;
	cout<<"请输入您的学号："<<endl;
	cout<<"学号:";
	cin>>id;
	cout<<"密码:";
	cin>>code;
	for(i=0;i<Teacher::GetNum();i++)
	{
		if(Teacher::STU[i].GetID()==id&&Teacher::STU[i].GetCode()==code)//学生学号和密码匹配之后才能进入系统
		{
			cout<<"恭喜您成功登陆!"<<endl;
			system("cls");//清屏进入学生模块的欢迎界面
			cout<<"****************************************************************************"<<endl;
			cout<<"*********************          "<<Teacher::STU[i].GetName()<<"同学,您好！        *********************"<<endl;
			break;
		}
	}
	if(i==Teacher::GetNum())
	{
		cout<<"对不起，您的用户名或密码有误"<<endl;
		system("cls");
		cout<<"请重新登录："<<endl;
		Login_Student();
	}
}
class Director//Director类主要负责教师登录系统
{
public:
	Director(string name);
	Director();
	void In_Teacher_File();//从默认文件导入教师信息
	void Login_Teacher();//教师登录
private:
	int Count;//教师数量
	Teacher TEA[N];//教师类的对象数组
	string Name;
};
Director::Director(string name)
{
	Name=name;
}
Director::Director()
{
	Name=" ";
}
void Director::In_Teacher_File()
{
	ifstream in_File;
	string name;
	int i=0,id,code;
	string subject;
	in_File.open("G:\\teacher.txt",ios::in);
	if(in_File==0)
	{
		cout<<"文件打开失败！"<<endl;
		exit(0);
	}
	else
	{
		Count=0;
		while(in_File&&!in_File.eof())
		{
			in_File>>name>>id>>subject>>code;
			TEA[i].From_File(name,id,subject,code);
			Count++;
			i++;
		}
		in_File.close();
	}
}

void Director::Login_Teacher()
{
	int i,id,code;
	In_Teacher_File();
	system("cls");
	cout<<"*********请您先登录系统*********"<<endl;
	cout<<"请输入您的工作号："<<endl;
	cout<<"工作号:";
	cin>>id;
	cout<<"密码:";
	cin>>code;
	for(i=0;i<Count;i++)
	{
		if(TEA[i].GetID()==id&&TEA[i].GetCode()==code)
		{
			cout<<"恭喜您成功登陆!"<<endl;
			system("cls");
			cout<<"****************************************************************************"<<endl;
			cout<<"*********************       "<<TEA[i].GetSubject()<<"  "<<TEA[i].GetName()<<"老师,您好！   *********************"<<endl;
			break;
		}
	}
	if(i==Count)
	{
		cout<<"对不起，您的用户名或密码有误"<<endl;
		system("cls");
		cout<<"请重新登录："<<endl;
		Login_Teacher();
	}
}
