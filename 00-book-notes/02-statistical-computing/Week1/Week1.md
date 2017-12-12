# 第一周课程笔记:Java基础(1)

##### Week 1， 2017/09/18

#### 1. Java的三层含义

+ 编程语言：Java是一种面向对象编程(Object Oriented Programming, OOP)的语言
+ Java虚拟机：Java程序是通过Java虚拟机(Java Virtual Machine, JVM)运行的
+ Java应用程序编程接口(Application Programming Interfaces, APIs)：一系列可以复用的预置的类

#### 2. Java的优势

+ 相对于C++，Java是完全面向对象的
+ 相对简单，没有各种指针
+ 在虚拟机上运行，可以将复杂的细节抽象化
+ 速度很快，比R和Python语言快很多
+ 适用于大型企业的软件工程
+ 用户群体很广，便于求助
+ Hadoop系统的主要语言，为大数据处理做准备

#### 3. Java SE安装及测试

#### 4. 程序举例

```java
public class Welcome{
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Welcome to statistacal computing!");
        } else if (args.length == 1) {
            System.out.println("Welcome to statistacal computing, " + args[0]);
        } else {
            System.out.print("Welcome to statistacal computing");
            for (int i = 0; i < args.length - 1; i++) {
                System.out.print(", " + args[i]);
            }
            System.out.println(" and " + args[args.length - 1]);
        }
    }
```

#### 5. Java常用的IDE
1. [Eclipse](https://www.eclipse.org/downloads/)
2. [IntelliJ IDEA](https://www.jetbrains.com/idea/)