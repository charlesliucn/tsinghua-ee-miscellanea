package cn.edu.tsinghua.stat.investment;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * Security Class is used to record the specific transactions
 * and conduct the relevant analysis about the transactions
 * @author liuqian14-2014011216
 */
public class Security {
	// The date field of Security Class
	/**
	 * The id of the Security
	 */
	private int id;
	
	/**
	 * The name of the Security
	 */
	private String name;
	
	/**
	 * The type of the Security, including STOCK and FUND
	 */
	private SecurityType type;
	
	/**
	 * The current quantity of the Security
	 */
	private BigDecimal quantity;
	
	/**
	 * The current price of the transaction
	 */
	private BigDecimal currentPrice;
	
	/**
	 * Used to distinguish whether the Security is active
	 */
	private boolean isActive;
	
	/**
	 * The transaction records of Security
	 */
	private List<Transaction> transactions;
	
	/**
	 * The constructor of Security Class
	 * @param name The name of Security
	 * @param id The id of Security
	 * @param type The type of Security
	 */
	public Security(String name, int id, SecurityType type) {
		// pass the parameters of the class
		this.name = name;
		this.type = type;
		this.id = id;
		// initialize the rest parameters
		this.quantity = new BigDecimal(0);
		this.currentPrice = new BigDecimal(0);
		this.isActive = false;
		this.transactions = new LinkedList<Transaction>();
	}
	
	/**
	 * get the name of the Security Class
	 * @return the name of the Security Class
	 */
	public String getName() {
		return this.name;
	}
	
	/**
	 * get the id of the Security Class
	 * @return the id of the Security Class
	 */
	public int getId() {
		return this.id;
	}
	
	/**
	 * get the type of the Security Class: STOCK or FUND
	 * @return the type of the Security Class
	 */
	public SecurityType getType() {
		return this.type;
	}
	
	/**
	 * get current quantity 
	 * @return the quantity
	 */
	public BigDecimal getQuantity() {
		return this.quantity;
	}
	
	/**
	 * get current state of the Security
	 * @return a boolean value, indicating whether the Security is active or not
	 */
	public boolean isActive() {
		if (this.quantity.signum() > 0)
			this.isActive = true;
		else this.isActive = false;
		return this.isActive;
	}
	
	/**
	 * get the current price of the transaction
	 * @return the current price
	 */
	public double getCurrentPrice() {
		return this.currentPrice.doubleValue();
	}
	
	/**
	 * set the current transaction price
	 * @param price the price of transaction
	 */
	public void setCurrentPrice(BigDecimal price) {
		if (this.currentPrice.signum() >= 0)
			this.currentPrice = price;
	}
	
	/**
	 * get the transactions of the Security Class
	 * @return the Transaction List
	 */
	public List<Transaction> getTransactions(){
		return this.transactions;
	}
	
	/**
	 * concatenate the Security and transactions information into a string
	 * @return A (multi-line) string with all the properties of the security in 1 line 
	 * and all its transactions line by line, in chronical order.
	 */
	public String toString() {
		StringBuilder strbld = new StringBuilder();
		strbld.append("id: ");		
		strbld.append(this.getId());
		strbld.append(" name: ");
		strbld.append(this.getName());
		strbld.append(" type: ");
		strbld.append(this.getType());
		strbld.append(" quantity: ");
		strbld.append(this.getQuantity());
		strbld.append(" currentPrice: ");
		strbld.append(this.getCurrentPrice());
		strbld.append(" isActive: ");
		strbld.append(this.isActive());
		strbld.append("\n");
		Collections.sort(this.transactions);
		for (int i = 0;i < this.transactions.size();i++) {
			strbld.append(this.transactions.get(i).toString());
			strbld.append("\n");
		}
		return strbld.toString();
	}
	
	/**
	 * get current value after all the transactions
	 * @return the current value
	 */
	public BigDecimal getCurrentValue() {
		return this.currentPrice.multiply(this.quantity);
	}
	
	/**
	 * add a transaction record into Security Class
	 * @param t a formal parameter of a Transaction class
	 * @throws InvalidTransactionException Throw an exception when something invalid happens
	 */
	public void addTransaction (Transaction t) throws InvalidTransactionException{
		this.transactions.add(t);
		switch (t.getType()) {
		case BUY:
			this.quantity = this.quantity.add(t.getQuantity());
			this.currentPrice = t.getPrice();
			break;
		case SELL:
			this.quantity = this.quantity.subtract(t.getQuantity());
			this.currentPrice = t.getPrice();
			if(this.quantity.signum() < 0) {
				this.isActive = false;
				throw new InvalidTransactionException(t.getType(),t.getPrice().toString(), 
						t.getQuantity().toString(), t.getDate(), "the quantity would become negative after selling");
			}
			break;
		case INC_SHARE:
			this.quantity = this.quantity.add(t.getQuantity());
			break;
		default:
			break;
		}
	}
	
	/**
	 * compute the floating profit after all transactions
	 * @return the floating profit after all transactions
	 */
	public BigDecimal floatingProfit() {
		Collections.sort(this.transactions);
		BigDecimal totalInvestment = new BigDecimal(0);
		BigDecimal totalGain = new BigDecimal(0);
		BigDecimal currentValue = this.getCurrentValue();
		for (int i = 0; i < this.transactions.size();i++) {
			if (this.transactions.get(i).getType() == TransactionType.BUY) {
				totalInvestment =  totalInvestment.add(this.transactions.get(i).getTotal());
			} else if (this.transactions.get(i).getType() == TransactionType.SELL || 
					this.transactions.get(i).getType() == TransactionType.BONUS){
				totalGain = totalGain.add(this.transactions.get(i).getTotal());
			} 
		}
		BigDecimal profit = currentValue.add(totalGain).subtract(totalInvestment);
		return profit;
	}
	
	/**
	 * compute the cumulative return after all transactions
	 * @return the cumulative return after all transactions
	 */
	public BigDecimal cumulativeReturn() {
		Collections.sort(this.transactions);
		BigDecimal totalInvestment = new BigDecimal(0);
		for (int i = 0; i < this.transactions.size();i++) {
			if (this.transactions.get(i).getType() == TransactionType.BUY) {
				totalInvestment =  totalInvestment.add(this.transactions.get(i).getTotal());
			}
		}
		BigDecimal profit = this.floatingProfit();
		return profit.divide(totalInvestment, BigDecimal.ROUND_HALF_UP);
	}
	
	/**
	 * compute the annualized return after all transactions
	 * @return the annualized return after all transactions
	 */
	public BigDecimal annualizedReturn() {
		Collections.sort(this.transactions);
		double totalInvestment = this.transactions.get(0).getTotal().doubleValue();
		double profit = this.floatingProfit().doubleValue();
		LocalDate startDate = this.transactions.get(0).getDate();
		LocalDate currentDate = this.transactions.get(this.transactions.size()-1).getDate();
		int daynum = Period.between(currentDate, startDate).getDays();
		double anReturn = Math.pow((profit+totalInvestment)/totalInvestment,daynum/365.0) - 1;
		BigDecimal annualizedReturn = new BigDecimal(anReturn);
		return annualizedReturn;
	}
	
	/**
	 * the main function to conduct the unit test
	 * @param args the arguments of the main function
	 * @throws InvalidTransactionException Throw an exception when something invalid happens
	 * @throws NumberFormatException Throw an exception of BigDecimal when something is wrong
	 */
	public static void main(String[] args) throws NumberFormatException, InvalidTransactionException {
		Security s = new Security("Security 01", 1, SecurityType.STOCK);
		System.out.println("----------Initialize Security---------");
		System.out.println(s.toString());
		System.out.println("\n-------Test the basic functions-------");
		System.out.println("name: " + s.getName());
		System.out.println("id: " + s.getId());
		System.out.println("type: " + s.getType());
		System.out.println("quantity: " + s.getQuantity());
		System.out.println("currentPrice: " + s.getCurrentPrice());
		System.out.println("transactions: " + s.getTransactions());
		System.out.println("isActive: " + s.isActive());
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("y-M-d");
		System.out.println("\n------Add the first Transaction------");
		Transaction t1 = new Transaction(1, TransactionType.BUY, "3.5",
				"10000", LocalDate.parse("2017-9-25",formatter));
		s.addTransaction(t1);
		System.out.println(s.toString());
		System.out.println("quantity: " + s.getQuantity());
		System.out.println("currentPrice: " + s.getCurrentPrice());
		System.out.println("currentValue: " + s.getCurrentValue());
		
		System.out.println("\n--------Add more Transactions--------");
		Transaction t2 = new Transaction(2, TransactionType.SELL, "3.8",
				"1000", LocalDate.parse("2017-10-4",formatter));
		Transaction t3 = new Transaction(3, TransactionType.BUY, "4.0",
				"1000", LocalDate.parse("2017-10-11",formatter));
		Transaction t4 = new Transaction(4, TransactionType.SELL, "3.9",
				"1000", LocalDate.parse("2017-10-12",formatter));
		Transaction t5 = new Transaction(5, TransactionType.SELL, "4.2",
				"2000", LocalDate.parse("2017-10-16",formatter));
		s.setCurrentPrice(new BigDecimal(3.8));
		s.addTransaction(t2);
		s.addTransaction(t3);
		s.addTransaction(t4);
		s.addTransaction(t5);
		System.out.println(s.toString());
		System.out.println("currentValue: " + s.getCurrentValue());
		
		System.out.println("\n---Test 3 computational functions---");
		System.out.println("floating profit: " + s.floatingProfit());
		System.out.println("cumulative return: " + s.cumulativeReturn());
		System.out.println("annualized return: " + s.annualizedReturn());
		
//		System.out.println("\n----------Test Exceptions----------");
//		Transaction t6 = new Transaction(6, TransactionType.SELL, "3.6",
//				"10000", LocalDate.parse("2017-10-20",formatter));
//		try {
//			s.addTransaction(t6);
//		} catch (InvalidTransactionException e) {
//			System.err.println("Error Message:" + e.getMessage());
//		}
//		System.out.println(s.toString());
	}
	
}

