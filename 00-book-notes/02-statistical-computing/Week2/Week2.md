# 第二周课程笔记:Java基础(2)

##### Week 2, 2017/09/25

#### 1. 举例

1. Transaction Class
```java
import java.time.LocalDate;

public class Transaction {
	private static int nextId = 0;
	private int id;
	private TransactionType type;
	private double price;
	private double quantity;
	private LocalDate date;
	
	public Transaction(TransactionType type, double price,
			double quantity, LocalDate date) {
		this.id = nextId;
		nextId++;
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	public Transaction(int id, TransactionType type, double price,
			double quantity, LocalDate date) {
		this.id = id;
		if(id >= nextId)
			nextId = id + 1;
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	public int getId() { 
		return this.id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public TransactionType getType() {
		return this.type;
	}
	
	public double getPrice() {
		return this.price;
	}
	
	public double getQuantity() {
		return this.quantity;
	}
	
	public LocalDate getDate() {
		return this.date;
	}
	

}

enum TransactionType {BUY, SELL, BONUS, INC_SHARE}
```

2. Security Class
```java
import java.util.List;
import java.util.LinkedList;
//import java.math.BigDecimal;

public class Security {
	private String name;
	private int id;
	private SecurityType type;
	private double quantity; 
	// private BigDecimal quantity;
	private double currentPrice;
	private boolean isActive;
	private List<Transaction> transactions;
	
	public Security() {
		this.name = null;
		this.id = 0;
		this.type = SecurityType.FUND;
		this.quantity = 0.0;
		// this.quantity = new BigDecimal(quantity);
		this.currentPrice = 0.0;
		this.isActive = false;
		this.transactions = new LinkedList<Transaction>();
	}
	
	public Security(String name, int id, SecurityType type) {
		this.name = name;
		this.id = id;
		this.type = type;
		this.quantity = 0.0;
		// this.quantity = new BigDecimal(quantity);
		this.currentPrice = 0.0;
		this.isActive = true;
		this.transactions = new LinkedList<Transaction>();
	}
	
	public Security(String name, int id, SecurityType type, 
			double quantity, boolean isActive) {
		this(name,id,type);
		this.quantity = quantity;
		// this.quantity = new BigDecimal(quantity);
		this.isActive = isActive;
	}

	public String getName() {
		return this.name;
	}
	
	public int getId() {
		return this.id;
	}
	
	public SecurityType getType() {
		return this.type;
	}
	
	public double getQuantity() {
		return this.quantity;
	}
	
	public double getPrice() {
		return this.currentPrice;
	}
	
	public boolean getState() {
		return this.isActive;
	}
	
//	public BigDecimal getQuantity() {
//		return this.quantity;
//	}
	
	public void addTransaction (Transaction t) {
		this.transactions.add(t);
		switch (t.getType()) {
		case BUY:
			quantity += t.getQuantity();
			currentPrice = t.getPrice();
			break;
		case SELL:
			quantity -= t.getQuantity();
			currentPrice = t.getPrice();
			if(Math.abs(quantity) < 0.001) { // double is not directly comparable
				this.isActive = false;
			}
			break;
		case INC_SHARE:
			quantity += t.getQuantity();
			break;
		default:
			break;
		}
	}
	
	// if we change the type quantity into BigDecimal
//	public void addTransaction(Transaction t) {
//		this.transactions.add(t);
//		switch(t.getType()) {
//		case BUY:
//			quantity = quantity.add(t.getQuantity());
//			currentPrice = t.getPrice();
//			break;
//		case SELL:
//			quantity = quantity.subtract(t.getQuantity());
//			currentPrice = t.getPrice();
//			if (quantity.signum() == 0) {
//				this.isActive = false;
//			}
//			break;
//		case INC_SHARE:
//			quantity = quantity.add(t.getQuantity());
//			break;
//		default:
//			break;
//		}
//	}
//	
	
	// public static void main(String[] args)
	// main() function is intended for testing the function of the class modules
}

enum SecurityType {STOCK, FUND}

```

3. MyInvestment Class
```java
public class MyInvestment {
	public static void main(String[] args) {
		Security s = new Security("Bob",12,SecurityType.FUND);
		System.out.println(s.getId());
		System.out.println(s.getName());
	}
}
```

#### 2. Acess Control
+ public
+ private
+ encapsulation数据封装
