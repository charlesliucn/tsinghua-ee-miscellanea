package cn.edu.tsinghua.stat.investment;

import java.time.LocalDate;

/**
 * The InvalidTransactionException Class is used to deal 
 * with the exceptions that happen to Transaction Class
 * @author liuqian14-2014011216
 */
@SuppressWarnings("serial")
public class InvalidTransactionException extends Exception {
	// The data fields
	/**
	 * The type of the transaction
	 */
	private TransactionType type;
	/**
	 * The name of the security
	 */
	private String securityName;
	/**
	 * The price of the transaction
	 */
	private String price;
	/**
	 * The quantity of the transaction
	 */
	private String quantity;
	/**
	 * The date when the transaction happens
	 */
	private LocalDate date;
	
	/**
	 * The first constructor of this class
	 * @param type The type of the transaction
	 * @param price The price of the transaction
	 * @param quantity The quantity of the transaction
	 * @param date The date when the date happens
	 * @param errorMessage The printed error message 
	 */
	public InvalidTransactionException(TransactionType type, String price,
			String quantity, LocalDate date, String errorMessage) {
		super(errorMessage);
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	/**
	 * The second constructor of this class
	 * @param securityName The name of the transaction
	 * @param type The type of the transaction
	 * @param price The price of the transaction
	 * @param quantity The quantity of the transaction
	 * @param date The date when the date happens
	 * @param errorMessage The printed error message 
	 */
	public InvalidTransactionException(String securityName, TransactionType type, String price,
			String quantity, LocalDate date, String errorMessage) {
		super(errorMessage);
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	/**
	 * Get the security name
	 * @return the name of Security
	 */
	public String getSecurityName() {
		return this.securityName;
	}
	
	/**
	 * Get the type of the Transaction
	 * @return the type of Transaction
	 */
	public TransactionType getType() {
		return this.type;
	}
	
	/**
	 * Get the date of the Transaction
	 * @return the date of Transaction
	 */
	public LocalDate getDate() {
		return this.date;
	}
	
	/**
	 * Get the price of the Transaction
	 * @return the price of Transaction
	 */
	public String getPrice() {
		return this.price;
	}
	
	/**
	 * Get the quantity of the Transaction
	 * @return the quantity of Transaction
	 */
	public String getQuantity() {
		return this.quantity;
	}
	
	// Unit Tests are conducted in Transaction.java and Security.java
}
