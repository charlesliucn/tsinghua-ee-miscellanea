//头文件“Class.h”包含了所有的类及成员函数
#include<iostream>
#include<iomanip>//控制输出格式
#include<cstdlib>
#include<string>//本程序中所有的字符串使用C++自带的string类
#include<fstream>//文件流操作
#define M 500//定义系统中书籍最大容纳量
#define N 10//每位读者借阅图书数目的上限
#define Q 20//系统的读者用户数量
using namespace std;
void BF()	//（Beautify）用于美化输出界面的函数[功能是输出“-”，具有层次感]
{
	for(int i=0;i<115;i++)//此处输出115“-”，因而最终exe文件输出框要改变默认长度，80改为150
		cout<<"-";
	cout<<endl;
}
class Base//基类，派生出Book和Reader类
{
public:
	Base(){};
};
class Book:virtual public Base//Book类继承虚基类
{
public:
	Book(string name,string author, string publisher,string subject,string isbn,string price,int year,int month);//构造函数
	Book();//默认构造函数
	void From_File(string name,string author, string publisher,string subject,string isbn,string price,int year,int month);//从文件中按顺序导入图书信息
	string GetName();//获取图书的书名
	string GetSubject();//获取图书所属的学科
	string GetISBN();//获取图书ISBN号
	string GetAuthor();//获取图书作者的姓名
	string GetPublisher();//获取相应出版社
	string GetPrice();//获取图书价格
	int GetYear();//获取出版年份
	int GetMonth();//获取出版月份
	int GetStatus();//获取图书状态（通过图书的状态表示是否可以借阅）
	void Delete();//从图书库里删除该书
	friend ostream & operator << (ostream &out, Book const &book);//通过友元函数进行“<<”操作符重载，一次性输出Book对象的所有信息
private://私有成员，避免遭到更改
	string Name,Author,Publisher,Price,Subject,ISBN;
	int Year,Month;
	int status;//指示图书系统里是否有该书
};
Book::Book(string name,string author,string publisher,string subject,string isbn, string price,int year,int month)
{
	Name=name;		Author=author;	Publisher=publisher;
	Subject=subject;	ISBN=isbn;			Price=price;
	Year=year;			Month=month;		status=1;
}
Book::Book()//默认构造函数，没有图书信息
{
	Name=" ";			Author=" ";			Publisher=" ";
	Subject=" ";			ISBN=" ";				Price=" ";
	Year=0;				Month=0;				status=0;
}
void Book::From_File(string name,string author, string publisher,string subject,string isbn,string price,int year,int month)
{
	Name=name;		Author=author;	Publisher=publisher;
	Subject=subject;	ISBN=isbn;			Price=price;
	Year=year;			Month=month;		status=1;
}
string Book::GetName()
{
	return Name;
}
string Book::GetSubject()
{
	return Subject;
}
string Book::GetISBN()
{
	return ISBN;
}
string Book::GetAuthor()
{
	return Author;
}
string Book::GetPublisher()
{
	return Publisher;
}
string Book::GetPrice()
{
	return Price;
}
int Book::GetYear()
{
	return Year;
}
int Book::GetMonth()
{
	return Month;
}
int Book::GetStatus()
{
	return status;
}
void Book::Delete()
{
	status=0;//将状态变量置为0,表示该图书已经不存在系统中
}
ostream & operator << (ostream &out, Book &book)//输出图书的所有信息
{
	cout<<setiosflags(ios::left)<<setw(25)<<book.GetName()<<setw(20)<<book.GetAuthor()<<setw(20)<<book.GetPublisher()<<setw(8)<<book.GetSubject()
		<<setw(20)<<book.GetISBN()<<setw(10)<<book.GetPrice()<<setw(4)<<book.GetYear()<<"年"<<setw(2)<<book.GetMonth()<<"月"<<endl;
	return out;
}
class Manage_Book//管理图书类，保护成员中包括 Book类的对象数组
{
public:
	Manage_Book(){};//默认构造函数
	void In_Book_File();//将图书信息从文件中导入系统
	void Add();//添加图书信息
	void Search();//查询图书
	void Display();//显示系统内所有图书
	void Delete();//删除图书信息
	void All_Clear();//删除系统内所有图书
	int Borrow(string isbn);//以ISBN号为形参借阅书籍
	void Return(string isbn);//以ISBN号为形参归还书籍
	void Show(string isbn);//以ISBN号为形参显示图书信息
	int GetNum();//获取系统内目前的图书数目
protected:
	int Num;
	Book book[M];//Book类的对象数组作为保护成员
};
void Manage_Book::In_Book_File()
{
	ifstream In_Book;
	string name,author,	 publisher,subject,isbn,price;
	int year,month;
	In_Book.open("E:\\book.txt",ios::out);//打开文件 &   E盘内book.txt文件作为默认的图书信息导入路径
	if(In_Book==0)
	{
		cout<<"*****************系统内图书加载失败！请联系工作人员*****************"<<endl;
		exit(0);
	}
	else 
	{
		Num=0;
		while(In_Book&&!In_Book.eof()&&Num<M)
		{
			In_Book>>name>>author>>publisher>>subject>>isbn>>price>>year>>month;//导入图书信息
			book[Num].From_File(name,author,publisher,subject,isbn,price,year,month);//存入对象数组
			Num++;
		}
		In_Book.close();//关闭文件
	}
}
void Manage_Book::Add()//添加图书信息
{
	if(Num==M)
	{		
		cout<<"******对不起，系统存书已满，无额外存储空间！请尝试其他功能******"<<endl;
		exit(0);
	}
	else
	{
		Num=Num+1;
		int i=0 ,year,month;		char command;
		In_Book_File();//导入图书信息
		string name,author,publisher,subject,isbn,price;
		cout<<"***************************         添加图书        *************************"<<endl;
		cout<<"请按照以下步骤添加书目："<<endl;
		cout<<"****请输入书名：";		cin>>name;
		cout<<"****请输入作者：";		cin>>author;
		cout<<"****请输入出版社：";	cin>>publisher;
		cout<<"****请输入学科类别："<<endl<<"【注意】当前分类有：哲学、社会、自然、教育、艺术、技术，请输入相应类别"<<endl;
		cin>>subject;
		cout<<"****请输入ISBN号：";		cin>>isbn;
		cout<<"****请输入价格：";		cin>>price;
		cout<<"****请输入年份：";		cin>>year;
		cout<<"****请输入月份：";		cin>>month;
		book[Num-1].From_File(name,author,publisher,subject,isbn,price,year,month);//新的Book类对象
		cout<<"书目添加成功！"<<endl;
		BF();//输出一行“-”进行美化
		cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
			<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
		BF();//输出一行“-”进行美化
		cout<<book[Num-1];
	    BF();//输出一行“-”进行美化
		cout<<"继续添加图书么？是请输入Y，否请输入N"<<endl;
		cin>>command;
		if(command=='s'||command=='S')
			Add();
		else exit(0);
	}
}
void Manage_Book::Search()//查询/搜索图书
{
	int command,i=0,flag=0;
	char Next;
	string a;
	In_Book_File();//导入图书信息文件
	cout<<"***************************            查找书目       *************************"<<endl;
	cout<<"***************************           1.精确查询      *************************"<<endl;
	cout<<"***************************           2.模糊查询      *************************"<<endl;
	cout<<"****请输入您的查询方式:";
	cin>>command;
	if(command==1)
	{
		cout<<"***************************            精确查询       *************************"<<endl;
		cout<<"****请输入您要查询的书的ISBN号"<<endl;
		cin>>a;
		cout<<"****查询结果："<<endl;
		BF();//美化
		cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
				<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
		BF();//美化
		for(i=0;i<Num;i++)
		{
			if(book[i].GetISBN()==a)
				cout<<book[i];
			flag=1;
			break;
		}
		BF();//美化
		if(flag==0)
			cout<<"未查到此书！"<<endl;
		cout<<"继续查询请输入Y，退出输入N"<<endl;
		cin>>Next;
		if(Next=='Y'||Next=='y')
			Search();
		else exit(0);
	}
	else if(command==2)
	{
		int command2;
		cout<<"***************************	     模糊查询         *************************"<<endl;
		cout<<"***************************      1.根据书名查询       *************************"<<endl;
		cout<<"***************************      2.根据作者查询       *************************"<<endl;
		cout<<"***************************      3.根据出版社查询     *************************"<<endl;
		cout<<"***************************      4.根据学科查询       *************************"<<endl;
		cout<<"***************************      5.根据出版年月查询   *************************"<<endl;
		cout<<"****请输入您的选项：";
		cin>>command2;
		switch(command2)
		{
		case 1://根据书名查询
			flag=0;
			cout<<"****请输入书名："<<endl;	cin>>a;
			cout<<"****查询结果："<<endl;
			for(i=0;i<Num;i++)
			{
				if(book[i].GetName()==a)
				{	
					BF();//美化
					cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
							<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
					cout<<book[i];
					BF();//美化
					flag=1;
				}
				break;
			}
			BF();//美化
			if(flag==0)
				cout<<"未查到相关书目"<<endl;
			cout<<"继续查询请输入Y，退出输入N"<<endl;
			cin>>Next;
			if(Next=='Y'||Next=='y')
				Search();
			else exit(0);
			break;
		case 2://根据作者查询
			flag=0;
			cout<<"****请输入作者名："<<endl;		cin>>a;
			cout<<"****查询结果："<<endl;			
			BF();//美化
			cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
						<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
			BF();//美化
			for(i=0;i<Num;i++)
			{
				if(book[i].GetAuthor()==a)
					cout<<book[i];
				flag=1;
			}
			BF();//美化
			if(flag==0)
				cout<<"未查到相关书目"<<endl;
			cout<<"继续查询请输入Y，退出输入N"<<endl;
			cin>>Next;
			if(Next=='Y'||Next=='y')
				Search();
			else exit(0);
			break;
		case 3://根据出版社查询
			flag=0;
			cout<<"请输入准确的出版社名称："<<endl;		cin>>a;
			cout<<"查询结果："<<endl;
			BF();//美化
			cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
					<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
			BF();//美化
			for(i=0;i<Num;i++)
			{
				if(book[i].GetPublisher()==a)
					cout<<book[i];
				flag=1;
			}
			BF();//美化
			if(flag==0)
				cout<<"未查到相关书目"<<endl;
			cout<<"继续查询请输入Y，退出输入N"<<endl;
			cin>>Next;
			if(Next=='Y'||Next=='y')
				Search();
			else exit(0);
			break;
		case 4://根据学科查询
			flag=0;
			cout<<"【注意】当前分类有：哲学、社会、自然、教育、艺术、技术，请输入要查询的类别:"<<endl;
			cin>>a;
			cout<<"查询结果："<<endl;
			BF();//美化
			cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
					<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
			BF();//美化
			for(i=0;i<Num;i++)
			{
				if(book[i].GetSubject()==a)
					cout<<book[i];
				flag=1;
			}
			BF();//美化
			if(flag==0)
				cout<<"未查到相关书目"<<endl;
			cout<<"继续查询请输入Y，退出输入N"<<endl;
			cin>>Next;
			if(Next=='Y'||Next=='y')
				Search();
			else exit(0);
			break;
		case 5://根据出版年月查询
			flag=0;
			int year,month;
			cout<<"请输入出版年份：";		cin>>year;
			cout<<"请输入出版月份：";		cin>>month;
			cout<<"查询结果："<<endl;
			BF();//美化
			cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
					<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
			BF();//美化
			for(i=0;i<Num;i++)
			{
				if(book[i].GetYear()==year&&book[i].GetMonth()==month)
					cout<<book[i];
				flag=1;
			}
			BF();//美化
			if(flag==0)
				cout<<"未查到相关书目"<<endl;
			cout<<"继续查询请输入Y，退出输入N"<<endl;
			cin>>Next;
			if(Next=='Y'||Next=='y')
				Search();
			else exit(0);
			break;
		default://输入错误处理
			system("cls");
			cout<<"对不起您的输入有误！请重新输入："<<endl;
			Search();
		}
	}
	else
	{
		cout<<"对不起，您的输入有误！请重新输入："<<endl;
		Search();
	}
}
void Manage_Book::Display()//显示全部图书
{
	int i=0;
	In_Book_File();
	cout<<"***************************         全部图书        *************************"<<endl;
	BF();//美化
	cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
		<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
	BF();//美化
	i=0;
	while(i<Num&&book[i].GetStatus()==1)
	{	
		cout<<book[i];
		i++;
	}
	BF();//美化
}
void Manage_Book::Delete()//删除图书信息
{
	string isbn;
	int i=0,flag=0;
	In_Book_File();//导入图书信息
	char command;
	cout<<"请输入您要删除的图书的ISBN号：";
	cin>>isbn;
	for(i=0;i<Num;i++)
	{
		if(book[i].GetISBN()==isbn)
		{
			book[i].Delete();
			cout<<"《"<<book[i].GetName()<<"》"<<"删除完毕！"<<endl;
			flag=1;
		}
		break;
	}
	if(flag==0)
	{
		cout<<"图书管理系统中没有该书！"<<endl;
		cout<<"****继续删除请输入Y，退出请输入N"<<endl;
		cin>>command;
		if(command=='Y')
			Delete();
		else exit(0);
	}
}
void Manage_Book::All_Clear()//清除所有图书信息
{
	In_Book_File();
	cout<<"删除所有图书信息"<<endl;
	for(int i=0;i<Num;i++)
	{
		cout<<"《"<<book[i].GetName()<<"》"<<"删除完毕"<<endl;
		book[i].Delete();
	}
	cout<<"书库已空！"<<endl;
}
int Manage_Book::Borrow(string isbn)//根据ISBN号将书籍借出
{
	int i=0,flag=0;
	In_Book_File();
	cout<<"***************************              借书          *************************"<<endl;
	for(i=0;i<Num;i++)
	{
		if(book[i].GetISBN()==isbn)
		{
			flag=1;return 1;
		}
	}
	if(flag==0)
		return 0;
	else return 0;
}
void Manage_Book::Return(string isbn)//根据ISBN号将数据收回（读者归还 ）
{
	int i=0,flag=0;
	In_Book_File();//导入全部图书信息
	cout<<"***************************             还书          *************************"<<endl;
	for(i=0;i<Num;i++)//循环寻找要还的书
	{	if(book[i].GetISBN()==isbn)
		{
			flag=1;
			cout<<"还书成功！"<<endl;
		}
	}
	if(flag==0)
	{
		cout<<"对不起操作有误！"<<endl;
		exit(0);
	}
}
void Manage_Book::Show(string isbn)//根据ISBN号显示书籍信息
{
	int i=0,flag=0;
	In_Book_File();//导入书籍信息
	for(i=0;i<Num;i++)
	{
		cout<<setiosflags(ios::left)<<setw(25)<<"书名/题目"<<setw(20)<<"作者"<<setw(20)<<"出版社"<<setw(8)<<"学科"
				<<setw(20)<<"ISBN号"<<setw(10)<<"价格"<<setw(4)<<"出版日期"<<endl;
		if(book[i].GetISBN()==isbn)
		{
			cout<<book[i];
			flag=1;	
			break;
		}
	}
	if(flag==0)
		cout<<"对不起，没有找到此书！"<<endl;
}
int Manage_Book::GetNum()
{
	return Num;
}
class Reader:virtual public Base
{
public:
	Reader(string name,string id,string gender,string code);//构造函数
	Reader();//默认构造函数
	void From_File(string name,string id,string gender,string code);//从文件中导入读者信息
	int GetStatus();//获取读者在系统中的状态，1表示在系统内，0表示已从系统中清除
	string GetCode();//获取读者登录密码
	string GetName();//获取读者姓名
	string GetID();//获取读者ID
	string GetGender();//获取读者姓名
	void Search();//读者查询书籍信息
	void Borrow();//读者借书
	void Return();//读者还书
	void Display_Keeping();//显示目前借阅的书籍
	void Delete();//删除读者信息
	friend ostream & operator << (ostream &out, Reader const &r);//友元函数操作符重载，“<<”直接输出读者信息
protected://保护成员
	string Name,ID,Gender,Code,Mybook[N];//图书的全部信息以及已经借阅的图书的ISBN号
	int Status,Num_Keeping;//状态变量和目前借阅的图书数目
};
Reader::Reader(string name,string id,string gender,string code)//构造函数
{
	Name=name;	ID=id;		Gender=gender;
	Code=code;		Status=1;	Num_Keeping=0;
}
Reader::Reader()//默认构造函数
{
	Name=" ";	ID=" ";		Gender=" ";
	Code="0";	Status=0;	Num_Keeping=0;
}
void Reader::From_File(string name,string id,string gender,string code)//从文件中读入读者信息
{
	Name=name;	ID=id;		Gender=gender;
	Code=code;		Status=1;	Num_Keeping=0;
}
int Reader::GetStatus()//获取读者用户状态
{
	return Status;
}
string Reader::GetCode()//获取读者密码
{
	return Code;
}
string Reader::GetName()//获取读者姓名
{
	return Name;
}
string Reader::GetID()//获取读者ID
{
	return ID;
}
string Reader::GetGender()//获取读者性别
{
	return Gender;
}
void Reader::Search()//读者的查询图书功能
{
	Manage_Book MB;
	MB.Search();
}
void Reader::Borrow()//借书功能
{
	if(Num_Keeping==N)
	{
		cout<<"对不起，您的借书书目已经达到最高上限"<<N<<"本"<<"不能继续借书。"<<endl;
		exit(0);
	}
	else
	{
		string isbn;
		cout<<"请输入您要借的书籍的ISBN号：";
		cin>>isbn;
		Manage_Book MB;
		if(MB.Borrow(isbn)==1)
		{
			Num_Keeping++;
			Mybook[Num_Keeping-1]=isbn;//将该书作为读者借阅的下一本书 存到读者借阅书本的string数组里
			cout<<"ISBN号为"<<isbn<<"的图书借阅成功！"<<endl;
			Display_Keeping();
		}
		else cout<<"对不起，该书不在系统内或已被借出，借书未成功！"<<endl;
	}
}
void Reader::Return()//还书功能
{
	if(Num_Keeping==0)
	{
		cout<<"对不起，您当前未借阅任何书籍!"<<endl;
		exit(0);
	}
	else
	{
		string isbn;
		Manage_Book MB;
		cout<<"请输入您要还的图书的ISBN号：";
		cin>>isbn;
		MB.Return(isbn);
	}
}
void Reader::Display_Keeping()//显示目前借阅的书籍
{
	Manage_Book MB;
	cout<<"目前借阅的所有书籍有："<<endl;
	if(Num_Keeping==0)
		cout<<"没有借阅书籍！"<<endl;
	else
	{
		for(int i=0;i<Num_Keeping;i++)
		MB.Show(Mybook[i]);
	}
}
void Reader::Delete()//删除读者信息
{
	Status=0;
}
ostream & operator << (ostream &out, Reader &r)//友元函数操作符重载，“<<”直接输出读者信息
{
	cout<<setiosflags(ios::left)<<setw(15)<<"姓名"<<setw(15)<<"读者证号"<<setw(8)<<"性别"<<endl;
	cout<<setiosflags(ios::left)<<setw(15)<<r.GetName()<<setw(15)<<r.GetID()<<setw(8)<<r.GetGender()<<endl;
	return out;
}
class Manage_Reader//管理读者，类的保护成员中包含Reader类的对象数组
{
public:
	Manage_Reader(){};//构造函数
	void In_Reader_File();//导入读者信息
	void Add();//添加读者信息
	void Search();//查询搜索读者
	void Display();//显示所有读者的信息
	void Delete();//删除读者信息
	void All_Clear();//清除所有读者的信息
	void ShowOneself();//显示某一读者自身的信息
	void Borrow();//借书
	void Return();//还书
	int GetCount();//获取目前系统存储的读者数目
protected:
	Reader reader[Q];//Reader类的对象数组作为保护成员
	int Count;
};
void Manage_Reader::In_Reader_File()//导入读者信息
{
	ifstream In_Reader;
	int i=0;
	string name,id,gender,code;
	In_Reader.open("E:\\reader.txt",ios::out);//读者信息默认存储在文本文件E:\\reader.txt中
	if(In_Reader==0)
	{
		cout<<"系统用户加载失败！"<<endl;
		exit(0);
	}
	else
	{
		Count=0;
		while(In_Reader&&!In_Reader.eof()&&Count<Q)//按照顺序依次读入文件中的读者信息
		{
			In_Reader>>name>>id>>gender>>code;
			reader[i].From_File(name,id,gender,code);
			Count++;
			i++;
		}
		In_Reader.close();//关闭文件
	}
}
void Manage_Reader::Add()//添加读者信息
{
	In_Reader_File();//导入读者信息
	if(Count==Q)
	{
		cout<<"对不起，暂不支持新用户注册"<<endl;
		exit(0);
	}
	else
	{
		Count++;
		string name,id,gender,code;
		char command;
		cout<<"******添加新读者******"<<endl;
		cout<<"请按照以下步骤添加读者"<<endl;//依次输入读者信息
		cout<<"请输入姓名：";		cin>>name;
		cout<<"请输入登录ID：";	cin>>id;
		cout<<"请输入性别：";		cin>>gender;
		cout<<"请设置密码：";		cin>>code;
		reader[Count-1].From_File(name,id,gender,code);
		cout<<"读者信息添加成功！"<<endl;
		cout<<reader[Count-1];
		cout<<"继续添加读者么？是请输入Y，否请输入N"<<endl;
		cin>>command;
		if(command=='S'||command=='s')
			Add();//继续添加读者信息
		else exit(0);
	}
}
void Manage_Reader::Search()
{
	int command,i=0,flag=0;
	string a;
	In_Reader_File();//导入读者信息
	cout<<"******查找用户*******"<<endl;
	cout<<"1.精确查询"<<endl;
	cout<<"2.模糊查询"<<endl;
	cout<<"请输入您的查询方式：";
	cin>>command;
	switch(command)
	{
	case 1://根据ID查找读者用户
		cout<<"请输入您要查询的用户的ID"<<endl;		cin>>a;
		cout<<"查询结果："<<endl;
		for(i=0;i<Count;i++)
			if(reader[i].GetID()==a)
			{
				cout<<reader[i];
				reader[i].Display_Keeping();
				flag=1;
			}
		if(flag==0)
			cout<<"未查到该用户!"<<endl;
		break;
	case 2:
		int command2;
		cout<<"1.根据姓名查询："<<endl;
		cout<<"2.根据性别查询："<<endl;
		cout<<"请输入您的选项：";
		cin>>command2;
		if(command2==1)//根据姓名查找读者用户
		{
			cout<<"请输入您要查询的读者姓名：";
			cin>>a;
			cout<<"查询结果为："<<endl;
			for(i=0;i<Count;i++)
			{
				if(reader[i].GetName()==a)
				{
					cout<<reader[i];
					reader[i].Display_Keeping();
					flag=1;
				}
			}
			if(flag==0)
				cout<<"未查到该用户！"<<endl;
		}
		else if(command2=2)//根据性别查询读者信息
		{
			cout<<"请输入您要查询的性别（男/女）：";
			cin>>a;
			cout<<"查询结果为："<<endl;
			for(i=0;i<Count;i++)
			{
				if(reader[i].GetGender()==a)
				{
					cout<<reader[i];
					reader[i].Display_Keeping();
					flag=1;
				}
			}
			if(flag==0)
				cout<<"未查到相关用户！"<<endl;
		}
		else
		{
			cout<<"对不起，您的输入有误！"<<endl;
			Search();
		};
		break;
	default:
		cout<<"对不起，您的输入有误！"<<endl;
		Search();//重新输入查询
	}
}
void Manage_Reader::Display()//显示所有的读者信息
{
	int i=0,k=0;
	In_Reader_File();//从文件中导入读者的信息
	cout<<"显示所有读者用户及借阅的所有书籍"<<endl;
	while(k<Count&&reader[k].GetStatus()==1)
	{
		BF();
		cout<<reader[k];
		reader[k].Display_Keeping();
		BF();
		k++;
	}
}
void Manage_Reader::Delete()//删除指定的读者信息
{
	string id;	int i=0,flag=0;
	In_Reader_File();//从文件中导入读者信息
	char command;
	cout<<"*******删除用户*******"<<endl;
	cout<<"请输入您要删除的读者用户的ID："<<endl;
	cin>>id;
	for(i=0;i<Count;i++)
	{
		if(reader[i].GetID()==id&&reader[i].GetStatus()==1)
		{
			reader[i].Delete();//删除用户信息
			cout<<"用户"<<reader[i].GetName()<<"所有信息删除完毕！"<<endl;
			flag=1;
		}
		break;
	}
	if(flag==0)
	{
		cout<<"图书管理系统中无该用户!"<<endl;
		cout<<"继续删除请输入“Y”，退出请输入“N”"<<endl;
		cin>>command;
		if(command=='Y')
			Delete();
		else	exit(0);
	}
}
void Manage_Reader::All_Clear()//清除全部用户信息
{
	In_Reader_File();
	cout<<"***删除所有用户信息*****"<<endl;
	for(int i=0;i<Count;i++)
	{
		cout<<"正在删除第"<<i+1<<"位用户的信息"<<endl;
		reader[i].Delete();//逐一删除读者信息
	}
	cout<<"所有用户信息删除完毕！"<<endl;
}
void Manage_Reader::ShowOneself()//显示个人信息
{
	string code;
	int i=0,flag=0;
	In_Reader_File();//导入读者信息
	cout<<"请再次输入您的密码："<<endl;
	cin>>code;
	BF();
	for(i=0;i<Count;i++)
	{
		if(reader[i].GetCode()==code&&reader[i].GetStatus()==1)
		{
			cout<<reader[i];
			reader[i].Display_Keeping();
			flag=1;
		}
		break;
	}
	BF();
	if(flag==0)
	{
		cout<<"对不起您的输入有误！请重新输入！"<<endl;
		ShowOneself();//重新输入密码
	}
}
void Manage_Reader::Borrow()//借书
{
	string code;
	int i=0,flag=0;
	char command;
	In_Reader_File();
	cout<<"请再次输入您的密码[注意借阅每本书之前都会要输入密码]："<<endl;
	cin>>code;
	BF();
	for(i=0;i<Count;i++)
	{
		if(reader[i].GetCode()==code)
		{
			reader[i].Borrow();
			flag=1;
		}
		break;
	}
	BF();
	if(flag==0)
		cout<<"对不起您的输入有误！"<<endl;
	cout<<"继续借阅书籍？是请输入A;还书？是请输入B;退出请输入N"<<endl;
	cin>>command;
	if(command=='A'||command=='a')
		Borrow();
	else if(command=='B'||command=='b')
		Return();
	else exit(0);
}
void Manage_Reader::Return()
{
	string code;
	int i=0,flag=0;
	char command;
	In_Reader_File();
	cout<<"请再次输入您的密码[注意归还每本书之前都会要输入密码]："<<endl;
	cin>>code;
	for(i=0;i<Count;i++)
	{
		if(reader[i].GetCode()==code)
		{
			reader[i].Return();
			flag=1;
		}
		break;
	}
	if(flag=0)
		cout<<"对不起您的输入有误！"<<endl;
	cout<<"继续归还书籍？是请输入Y，否请输入N"<<endl;
	cin>>command;
	if(command=='Y'||command=='y')
		Return();//还书
	else exit(0);
}
int Manage_Reader::GetCount()
{
	return Count;
}
class Manage:public Manage_Book,public Manage_Reader//多重继承，继承两个管理类
{
public:
	Manage(){};//构造函数
	void Login_Reader();//管理读者的登录
	void Login_Manage();//管理管理员的登录
};
void Manage::Login_Reader()//读者登录
{
	int i=0,flag=0;
	string id,code;
	Manage_Reader::In_Reader_File();//从文件导入读者的信息
	cout<<"***********************************读者登录"<<"*********************************"<<endl;
	cout<<"请输入用户ID及密码："<<endl;
	cout<<"****ID:";			cin>>id;
	cout<<"**密码：";	cin>>code;
	for(i=0;i<Count;i++)
	{
		if(Manage_Reader::reader[i].GetCode()==code&&Manage_Reader::reader[i].GetID()==id)
		{
			flag=1;
			cout<<"系统登录成功！"<<endl;
			system("cls");
			cout<<"*******************   "<<Manage_Reader::reader[i].GetName();
			if(Manage_Reader::reader[i].GetGender()=="男")
				cout<<"先生";
			else cout<<"女士";
			cout<<"，您好！欢迎使用图书管理系统！*******************"<<endl;
		}
		break;
	}
	if(flag==0)
	{
		system("cls");
		cout<<"对不起，ID或密码有误!请重新登录："<<endl;
		Login_Reader();//重新登录
	}
}
void Manage::Login_Manage()//管理员登录
{
	string code;
	cout<<"请输入管理员密码："<<endl;
	cin>>code;
	if(code=="LIUQIAN")//默认密码为LIUQIAN
	{
		cout<<"系统登录成功！"<<endl;
		system("cls");
		cout<<"管理员您好！欢迎使用图书管理系统！"<<endl;
	}
	else
	{
		system("cls");
		cout<<"密码不正确！请重新登录！"<<endl;
		Login_Manage();//重新登录
	}
}