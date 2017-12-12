package cn.edu.tsinghua.stat.investment;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Transaction Class is used to record the transaction information
 * @author liuqian14-2014011216
 */
public class Transaction implements Comparable<Transaction> {
	
	/**
	 * The next id of transaction
	 */
	private static int nextId = 0;
	
	/**
	 * The id of the transaction
	 */
	private int id;
	
	/**
	 * The type of the transaction
	 */
	private TransactionType type;
	
	/**
	 * The price of current transaction
	 */
	private BigDecimal price;
	
	/**
	 * The quantity of current transaction
	 */
	private BigDecimal quantity;
	
	/**
	 * The specific date of the transaction
	 */
	private LocalDate date; 
	
	/**
	 * The first constructor of Transaction class(without id).
	 * @param type The type of the transaction, including BUY, SELL, BONUS and INC_SHARE.
	 * @param price The price of the transaction
	 * @param quantity The quantity of the transaction
	 * @param date The date when the transaction happens
	 * @throws InvalidTransactionException Throw an exception when something invalid happens
	 * @throws NumberFormatException Throw an exception of BigDecimal when something is wrong
	 */
	public Transaction (TransactionType type, String price,
			String quantity, LocalDate date) throws 
	InvalidTransactionException, NumberFormatException {
		// set the parameters of the constructor
		this.id = nextId;
		nextId++;
		this.type = type;
		this.price = new BigDecimal(price);
		this.quantity = new BigDecimal(quantity);
		this.date = date;
		
		// throw an exception when the quantity is less than 0
		if (this.quantity.signum() < 0) {
			throw new InvalidTransactionException(type,
					price, quantity, date, "negative quantity");
		}
		// throw an exception when the price is less than 0
		if (this.price.signum() < 0) {
			throw new InvalidTransactionException(type,
					price, quantity, date, "negative price");
		}
		// throw an exception when the price is not 0 but the the transaction type is INC_SHARE
		if (this.price.signum() > 0 && this.type == TransactionType.INC_SHARE) {
				throw new InvalidTransactionException(type,
						price, quantity, date, "the price is not 0 when the type is INC_SHARE");
		}
	}
	
	/**
	 * The second constructor of Transaction class (with id).
	 * @param id The id of the transaction
	 * @param type The type of the transaction
	 * @param price The price of the transaction
	 * @param quantity The quantity of the transaction
	 * @param date The date when the transaction happens
	 * @throws InvalidTransactionException Throw an exception when something invalid happens
	 * @throws NumberFormatException Throw an exception of BigDecimal when something is wrong
	 */
	public Transaction(int id, TransactionType type, String price, 
			String quantity, LocalDate date) throws 
	InvalidTransactionException, NumberFormatException {
		// the parameters of the constructor
		this.id = id;
		this.type = type;
		this.price = new BigDecimal(price);
		this.quantity = new BigDecimal(quantity);
		this.date = date;
		
		// throw an exception when the quantity is less than 0
		if (this.quantity.signum() < 0) {
			throw new InvalidTransactionException(type,
					price, quantity, date, "negative quantity");
		}
		// throw an exception when the price is less than 0
		if (this.price.signum() < 0) {
			throw new InvalidTransactionException(type,
					price, quantity, date, "negative price");
		}
		// throw an exception when the price is not 0 but the the transaction type is INC_SHARE
		if (this.price.signum() > 0 && this.type == TransactionType.INC_SHARE) {
				throw new InvalidTransactionException(type,
						price, quantity, date, "the price is not 0 when the type is INC_SHARE");
		}
	}
	
	/**
	 * get the id of the transaction
	 * @return The id of the transaction
	 */
	public int getID() {
		return this.id;
	}
	
	/**
	 * get the type of the transaction
	 * @return The type of the transaction
	 */
	public TransactionType getType() {
		return this.type;
	}
	
	/**
	 * get the price of the transaction
	 * @return The price of the transaction
	 */
	public BigDecimal getPrice() {
		return this.price;
	}
	
	/**
	 * get the quantity of the transaction
	 * @return The quantity of the transaction
	 */
	public BigDecimal getQuantity() {
		return this.quantity;
	}
	
	/**
	 * get the total values of the transactions
	 * @return The total values of the transactions
	 */
	public BigDecimal getTotal() {
		return this.price.multiply(this.quantity);
	}
	
	/**
	 * get the date of the transaction
	 * @return The date of the transaction
	 */
	public LocalDate getDate() {
		return this.date;
	}
	
	/**
	 * concatenate the transaction information into a string
	 * @return The string of the transaction information
	 */
	public String toString() {
		StringBuilder strbld = new StringBuilder();
		strbld.append("id: ");		
		strbld.append(this.getID());
		strbld.append(" date: ");		
		strbld.append(this.getDate());
		strbld.append(" type: ");
		strbld.append(this.getType());
		strbld.append(" price: ");
		strbld.append(this.getPrice());
		strbld.append(" quantity: ");
		strbld.append(this.getQuantity());
		strbld.append(" total: ");
		strbld.append(this.getTotal().doubleValue());
		return strbld.toString();
	}
	
	/**
	 * compare(and sort) the transaction information by date
	 * @return return negative value when the date is earlier or positive values when it is later
	 */
	public int compareTo(Transaction t) {
		return date.compareTo(t.date);
	}
	
	/**
	 * the main function to conduct the unit test
	 * @param args the arguments of the main function
	 * @throws InvalidTransactionException Throw an exception when something invalid happens
	 * @throws NumberFormatException Throw an exception of BigDecimal when something is wrong
	 */
	public static void main (String[] args) throws
	InvalidTransactionException, NumberFormatException{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("y-M-d");
		
		// Instance t1 to test the first constructor
		Transaction t1 = new Transaction(5, TransactionType.BUY, "3.5",
				"10000", LocalDate.parse("2017-9-25",formatter));
		System.out.println("-----------Transaction t1------------");
		System.out.println("id: " + t1.getID());
		System.out.println("date: " + t1.getDate());
		System.out.println("price:" + t1.getPrice().doubleValue());
		System.out.println("quantity: " + t1.getQuantity().doubleValue());
		System.out.println("total:" + t1.getTotal());
		System.out.println("type:" + t1.getType());
		
		// Instance t2 to test the second constructor
		Transaction t2 = new Transaction(TransactionType.SELL,"3.8",
				"1000", LocalDate.parse("2017-11-4", formatter));
		System.out.println("\n-----------Transaction t2------------");
		System.out.println("id: " + t2.getID());
		System.out.println("date: " + t2.getDate());
		System.out.println("price:" + t2.getPrice().doubleValue());
		System.out.println("quantity: " + t2.getQuantity().doubleValue());
		System.out.println("total:" + t2.getTotal());
		System.out.println("type:" + t2.getType());
		
		// Test toString() function
		System.out.println("\n---Testing overloading toString()---");
		System.out.println(t1.toString());
		System.out.println(t2.toString());
		
		// Test toCompare() function. The return value should be negative
		System.out.println("\n--------Testing compareTo()---------");
		System.out.println(t1.compareTo(t2));
		
		// Test one of the exception: the price is not 0 when the type is INC_SHARE
//		System.out.println("\n----Testing one of the exceptions----");
//		try {
//			@SuppressWarnings("unused")
//			Transaction t3 = new Transaction(5, TransactionType.INC_SHARE, "2",
//				"1000", LocalDate.parse("2017-10-1",formatter));
//		}catch (InvalidTransactionException e) {
//			System.err.println("Error Message:" + e.getMessage());
//		}
	}
	
}
