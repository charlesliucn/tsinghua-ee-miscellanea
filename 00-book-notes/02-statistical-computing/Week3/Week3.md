# 第三周课程笔记:Java基础(3)-继承与接口

##### Week 3, 2017/09/30

#### 1. 基类Employee
```java
import java.math.BigDecimal;

public class Employee {
	private final String name;
	private BigDecimal salary;
	
	public Employee (String name, String salary) {
		this.name = name;
		this.salary = new BigDecimal(salary);
	}
	
	public String getName() {
		return this.name;
	}
	
	public BigDecimal getSalary() {
		return this.salary;
	}
	
	public void setSalary(BigDecimal salary) {
		this.salary = salary;
	}
}
```

#### 2. Manager类继承Employee
```java
import java.math.BigDecimal;
import java.util.List;
import java.util.LinkedList;

public class Manager extends Employee {
	private BigDecimal bonusRate;
	private List<Employee> supervisees;
	
	public Manager(String name, String salary, String bonusRate) {
		super(name,salary); //调用Employee的构造函数
		this.bonusRate = new BigDecimal(bonusRate);
		this.supervisees = new LinkedList<Employee>();
	}
	
	//@Override
	public BigDecimal getSalary() {
		BigDecimal mySalary = super.getSalary();
		for (Employee supervisees: supervisees) {
			mySalary = mySalary.add(supervisees.getSalary().multiply(bonusRate));
		}
		return mySalary;
	}
	
	public void addSupervisee(Employee e) {
		this.supervisees.add(e);
	}
}
```

#### 3. 最高类Top进行调用
```java
import java.util.LinkedList;

public class Top {
	public static void main(String[] args) {
		Employee tom = new Employee("Tom","50000");
		Employee mary = new Employee("Mary","50000");
		Employee sarah = new Employee("Sarah","50000");
		Manager shawn = new Manager("Shawn","40000","0.3");
		Manager sean = new Manager("Sean","40000","0.3");
		shawn.addSupervisee(tom);
		shawn.addSupervisee(mary);
		shawn.addSupervisee(sarah);
		sean.addSupervisee(sarah);
		Manager boss = new Manager("Bill the Boss","60000","0.4");
		boss.addSupervisee(shawn);
		boss.addSupervisee(sean);
		
		LinkedList<Employee> employees = new LinkedList<Employee>();
		employees.add(tom);
		employees.add(mary);
		employees.add(sarah);
		employees.add(shawn);
		employees.add(sean);
		employees.add(boss);
		for (Employee employee:employees) {
			System.out.println(employee.getName()+" earns "+employee.getSalary()+" per year.");
		}
		Employee bosst = new Manager("BOSS","60000","0.4");
		System.out.println(bosst instanceof Manager);
		//  bosst.addSupervisee(tom); 这句话是不成立的，必须先进行explicit cast
		((Manager) bosst).addSupervisee(tom);
	}
}
```

#### 4. 抽象类Abstract Class
1. Employee可以看作是以Person为基类的类
2. Person类包含一个Method
```java
public String getDescription(){
	return name+" is an employee who earns "+ salary + "dollars per year.";
}
```
3. 抽象类的Methods也必须是抽象的
```java
public abstract class Person{
	public abstract String getDescription();
}
```
4. 抽象类是**不能实例化**的

#### 5. 保护类
1. public：每个类都可以看到
2. private：只有这个类本身能看到
3. default：在同一个package下的类可以看到
4. protected：可以被同一package的类以及所有继承的类看到

#### 6. Interface
1. Interface接口看起来像是一个类，但实际不是
2. Interface是一组要求requirements.

#### 7. 异常处理

#### 8. javadoc